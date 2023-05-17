*-----------------------------------------------------------------------------
* <Rating>-64</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.A.REV.PYMNT.VP
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
*                TAM Latin America
* Client       : Asociacion Popular de Ahorro & Prestamo (APAP)
* Date         : 05.04.2013
* Description  : Routine for validating account details
* Type         : Validation Routine (attached to hotfield LR-27)
* Attached to  : VERSION > TELLER Vision Plus Versions
*     VERSION > FUNDS.TRANSFER Vision Plus Versions
* Dependencies :
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date           Who            Reference         Description
* 1.0       04.30.2013     lpazmino       -                 Initial Version
*-----------------------------------------------------------------------------

* <region name="INSERTS"> -  VP.TXN.STATUS

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_GTS.COMMON
$INSERT I_F.TELLER
$INSERT I_F.REDO.CARD.BIN
$INSERT I_F.REDO.VISION.PLUS.TXN
$INSERT I_F.REDO.VISION.PLUS.PARAM

* </region>
  GOSUB INIT
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN
* <region name="GOSUBS" description="Gosub blocks">

***********************
* Initialize variables
INIT:
***********************
  FN.REDO.VISION.PLUS.TXN = 'F.REDO.VISION.PLUS.TXN'
  F.REDO.VISION.PLUS.TXN = ''

  FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
  F.REDO.CARD.BIN = ''
  R.REDO.CARD.BIN = ''

  FN.REDO.VISION.PLUS.PARAM = 'F.REDO.VISION.PLUS.PARAM'
  F.REDO.VISION.PLUS.PARAM = ''
  R.REDO.VISION.PLUS.TXN = ''
  REDO.VISION.PLUS.PARAM.ID = 'SYSTEM'

  VP.TXN.LIST = ''
  VP.TXN.LIST.NAME = ''
  VP.TXN.SELECTED = ''
  SYSTEM.RETURN.CODE = ''

  RETURN

***********************
* Open Files
OPEN.FILES:
***********************
  CALL OPF(FN.REDO.VISION.PLUS.TXN, F.REDO.VISION.PLUS.TXN)
  CALL OPF(FN.REDO.CARD.BIN, F.REDO.CARD.BIN)

  RETURN

***********************
* Main Process / if a issues is raised please check INAU or RNAU status to proceed
PROCESS:
***********************

  Y.RECORD.STATUS = TT.TE.RECORD.STATUS
  Y.STATUS = R.NEW(Y.RECORD.STATUS)

  IF V$FUNCTION EQ 'R' OR Y.STATUS[1,3] EQ 'RNA' THEN
    CALL CACHE.READ(FN.REDO.VISION.PLUS.PARAM, REDO.VISION.PLUS.PARAM.ID, R.REDO.VISION.PLUS.PARAM, Y.ERR)
    GOSUB REVERSE.PAYMENT
  END


  RETURN

***********************
* Reverse Payment
REVERSE.PAYMENT:
***********************
* Reversal for the same day, remove from REDO.VISION.PLUS.TXN with no practical effect
* Reversal for different days is applied manually

  SELECT.STATEMENT  = "SELECT " : FN.REDO.VISION.PLUS.TXN
  SELECT.STATEMENT := " WITH TXN.REF EQ '" : ID.NEW : "'"
  SELECT.STATEMENT := " AND STATUS EQ 'PEND'"

  CALL EB.READLIST(SELECT.STATEMENT, VP.TXN.LIST, VP.TXN.LIST.NAME, VP.TXN.SELECTED, SYSTEM.RETURN.CODE)

  IF VP.TXN.SELECTED GT 0 THEN
    REMOVE VP.TXN.ID FROM VP.TXN.LIST SETTING VP.TXN.POS

    CALL F.READ(FN.REDO.VISION.PLUS.TXN,VP.TXN.ID,R.RVPT,F.REDO.VISION.PLUS.TXN,Y.RVPT.ERR)
    RVPT.CREDIT.CARD = R.RVPT<VP.TXN.CARDHOLDER.NUM>
    RVPT.PAYMENT.AMT = R.RVPT<VP.TXN.TRANS.AMOUNT>
    RVPT.TXN.CURRENCY = R.RVPT<VP.TXN.CURRENCY>
    RVPT.TRANS.AUTH = R.RVPT<VP.TXN.TRANS.AUTH>


************ write TO CHANGE STATUS ****************************
    R.RVPT<VP.TXN.STATUS> = 'REV'
    CALL F.WRITE(FN.REDO.VISION.PLUS.TXN, VP.TXN.ID, R.RVPT)
    CALL F.RELEASE(FN.REDO.VISION.PLUS.TXN, VP.TXN.ID, F.REDO.VISION.PLUS.TXN)

**************************************************************

* When reversed for the same day also discount amount applied by ONLINE_PAYMENT (MemoCredit) by sending the same but RequestType - R
* Only for non OFFLINE txns
    IF RVPT.TRANS.AUTH NE 'OFFLINE' AND RVPT.TRANS.AUTH NE '000000' THEN
      GOSUB INVOKE.VP.WS.OP
    END

  END

  RETURN

****************************************
* Invoke VP Web Service 'OnlinePayment'
INVOKE.VP.WS.OP:
****************************************
  ACTIVATION = 'VP_ONLINE_TXN_SERVICE'

  WS.DATA = ''
  WS.DATA<1>  = 'ONLINE_PAYMENT'
  WS.DATA<2>  = R.REDO.VISION.PLUS.PARAM<VP.PARAM.VP.USER>
  WS.DATA<3>  = 'R'
  WS.DATA<4>  = FMT(RVPT.CREDIT.CARD, 'R%19')
  WS.DATA<7>  = '0000'
  WS.DATA<8>  = RVPT.PAYMENT.AMT
  WS.DATA<9>  = '0000'
  WS.DATA<10> = '                             '
  WS.DATA<11> = '000'

  CREDIT.CARD.BIN = RVPT.CREDIT.CARD[1,6]
  CALL CACHE.READ(FN.REDO.CARD.BIN, CREDIT.CARD.BIN, R.REDO.CARD.BIN, Y.ERR)

  LOCATE RVPT.TXN.CURRENCY IN R.REDO.CARD.BIN<REDO.CARD.BIN.T24.CURRENCY,1> SETTING TXN.CURRENCY.POS THEN
* OrgId
    ORG.ID = FIELD(R.REDO.CARD.BIN<REDO.CARD.BIN.ORG.ID>,VM,TXN.CURRENCY.POS)
    WS.DATA<5> = ORG.ID
* Mercant Number
    MERCHANT.NUMBER = R.REDO.CARD.BIN<REDO.CARD.BIN.MERCHANT.NUMBER>
    WS.DATA<6> = MERCHANT.NUMBER
    CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
  END ELSE
    WS.DATA = ''
    WS.DATA<1> = 'ERROR'
  END

* Obtiene la autorizacion de pago sin problemas
  IF WS.DATA<1> EQ 'OK' THEN
    TXN.RESULT<1> = WS.DATA<1>
  END ELSE
    TXN.RESULT<1> = WS.DATA<1>
    IF WS.DATA<1> EQ 'ERROR' THEN
      TXN.RESULT<2> = 'ST-VP-ERR.VP.REV.PYMNT'
    END
    IF WS.DATA<1> EQ 'OFFLINE' THEN
      TXN.RESULT<2> = 'ST-VP-NO.ONLINE.PYMNT'
    END
    TXN.RESULT<3> = WS.DATA<2>
    BEGIN CASE
    CASE APPLICATION EQ 'TELLER'
      IF R.NEW(TT.TE.OVERRIDE) THEN
        TXN.RESULT<4> = DCOUNT(R.NEW(TT.TE.OVERRIDE), VM) + 1
      END ELSE
        TXN.RESULT<4> = 1
      END
    END CASE
  END

  RETURN

* </region>

END
