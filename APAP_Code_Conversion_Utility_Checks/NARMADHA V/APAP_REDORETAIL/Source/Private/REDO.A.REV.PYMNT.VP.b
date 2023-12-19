* @ValidationCode : MjotNTAzNDI1MzY1OkNwMTI1MjoxNjgyNTk4MDExNTc2OnNhbWFyOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
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
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 VM TO @VM
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*20-11-2023          Santosh			     Intrface Change comment added           Vision Plus-Interface Changes done by Santiago
*-----------------------------------------------------------------------------

* <region name="INSERTS"> -  VP.TXN.STATUS

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_F.REDO.VISION.PLUS.TXN
    $INSERT I_F.REDO.VISION.PLUS.PARAM
    $USING APAP.TAM

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
*Interface Changes done by Santiago- Start
    WS.DATA = ''
    WS.DATA<1>  = 'ONLINE_PAYMENT'
    WS.DATA<2>  = R.REDO.VISION.PLUS.PARAM<VP.PARAM.VP.USER>        ;*POSUserData
    WS.DATA<3>  = '0000'                                            ;*MCCType
    WS.DATA<4>  = 'R'                                               ;*RequestType
    WS.DATA<5>  = FMT(RVPT.CREDIT.CARD, 'R%19')                     ;*CardNumber
*    WS.DATA<6>  = ORG.ID
*    WS.DATA<7>  = MERCHANT.NUMBER
    WS.DATA<8>  = '0000'                                            ;*CardExpirationDate
    WS.DATA<9>  = RVPT.PAYMENT.AMT                                  ;*TotalSalesAmount
    WS.DATA<10>  = '0000'                                           ;*Track2Length
    WS.DATA<11> = '                             '                   ;*Track2Data
    WS.DATA<12> = '000'                                             ;*CardValidationValue
*Interface Changes done by Santiago-End
    CREDIT.CARD.BIN = RVPT.CREDIT.CARD[1,6]
    CALL CACHE.READ(FN.REDO.CARD.BIN, CREDIT.CARD.BIN, R.REDO.CARD.BIN, Y.ERR)

    LOCATE RVPT.TXN.CURRENCY IN R.REDO.CARD.BIN<REDO.CARD.BIN.T24.CURRENCY,1> SETTING TXN.CURRENCY.POS THEN
* OrgId
        ORG.ID = FIELD(R.REDO.CARD.BIN<REDO.CARD.BIN.ORG.ID>,@VM,TXN.CURRENCY.POS)
        WS.DATA<6> = ORG.ID ;*Interface Changes done by Santiago
* Mercant Number
        MERCHANT.NUMBER = R.REDO.CARD.BIN<REDO.CARD.BIN.MERCHANT.NUMBER>
        WS.DATA<7> = MERCHANT.NUMBER ;*Interface Changes done by Santiago
* APAP.TAM.REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)
        APAP.TAM.redoVpWsConsumer(ACTIVATION, WS.DATA);* MANUAL R22 CODE CONVERSION
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
                    TXN.RESULT<4> = DCOUNT(R.NEW(TT.TE.OVERRIDE), @VM) + 1
                END ELSE
                    TXN.RESULT<4> = 1
                END
        END CASE
    END

RETURN

* </region>

END
