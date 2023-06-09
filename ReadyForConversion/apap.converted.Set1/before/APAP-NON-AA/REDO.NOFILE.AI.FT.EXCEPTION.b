*-----------------------------------------------------------------------------
* <Rating>-84</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.AI.FT.EXCEPTION(LIST.FT.EXCEP)

*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name :
*-----------------------------------------------------------------------------
* Description    :  This Nofile routine will get required details of Customer Accts
* Linked with    :
* In Parameter   :
* Out Parameter  :
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.REDO.APAP.STO.DUPLICATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.FT.TXN.TYPE.CONDITION
$INSERT I_F.STANDING.ORDER
$INSERT I_F.AI.REDO.ARCIB.PARAMETER

*---------*
MAIN.PARA:
*---------*
  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN
*----------*
INITIALISE:
*----------*
  FN.FUNDS.TRANSFER.EXCEP = "F.FUNDS.TRANSFER$NAU"
  F.FUNDS.TRANSFER.EXCEP  = ''
  FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
  F.FT.TXN.TYPE.CONDITION = ''
  FN.STO.DUP.EXCEP = 'F.REDO.APAP.STO.DUPLICATE$NAU'
  F.STO.DUP.EXCEP = ''
  FN.STANDING.ORDER.EXCEP = 'F.STANDING.ORDER$NAU'
  F.STANDING.ORDER.EXCEP = ''

  FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
  F.AI.REDO.ARCIB.PARAMETER  = ''

  RETURN
*----------*
OPEN.FILES:
*----------*
  CALL OPF(FN.FUNDS.TRANSFER.EXCEP,F.FUNDS.TRANSFER.EXCEP)
  CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)
  CALL OPF(FN.STO.DUP.EXCEP,F.STO.DUP.EXCEP)
  CALL OPF(FN.STANDING.ORDER.EXCEP,F.STANDING.ORDER.EXCEP)

  LREF.APP = 'FUNDS.TRANSFER'
  LREF.FIELDS = 'L.ACTUAL.VERSIO'
  LREF.POS=''
  CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)

  Y.FT.VERSION.POS = LREF.POS<1,1>

  CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,AI.REDO.ARCIB.PARAMETER.ERR)

  Y.PAYROLL.TXN.CODE  = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.PAYROLL.TXN.CODE>
  Y.SUPPLIER.TXN.CODE = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.SUPPLIER.TXN.CODE>

  Y.FILE.UPLOAD.CODES  = Y.PAYROLL.TXN.CODE:FM:Y.SUPPLIER.TXN.CODE
  RETURN

*--------*
PROCESS:
*--------*

  GOSUB FT.DET.PARA
  GOSUB STO.DET.PARA

  RETURN
************
FT.DET.PARA:
***********

  CUST.ID = System.getVariable("EXT.SMS.CUSTOMERS")

  SEL.CMD = "SELECT ":FN.FUNDS.TRANSFER.EXCEP:" WITH DEBIT.CUSTOMER EQ ":CUST.ID:" AND RECORD.STATUS EQ INAO"
  CALL EB.READLIST(SEL.CMD,SEL.LIST1,'',SEL.NOR1,SEL.RET1)
  LOOP
    REMOVE FT.ID FROM SEL.LIST1 SETTING CUST.ACC.POS
  WHILE FT.ID:CUST.ACC.POS
    CALL F.READ(FN.FUNDS.TRANSFER.EXCEP,FT.ID,R.FUNDS.TRANSFER.EXCEP,F.FUNDS.TRANSFER.EXCEP,FT.HIS.ERR)
    IF NOT(FT.HIS.ERR) THEN
      Y.INPUTTER =  FIELD(R.FUNDS.TRANSFER.EXCEP<FT.INPUTTER>,'_',6)
      Y.FT.SIGNATORY =R.FUNDS.TRANSFER.EXCEP<FT.SIGNATORY>
      Y.VERSION.NAME  = FIELD(R.FUNDS.TRANSFER.EXCEP<FT.LOCAL.REF,Y.FT.VERSION.POS>,',',2)
      Y.VERSION.PREFIX = Y.VERSION.NAME[1,7]
      GOSUB FT.MAPPING.DETAILS
    END
  REPEAT
  RETURN

*******************
FT.MAPPING.DETAILS:
******************



  IF Y.INPUTTER EQ 'ARCIB' OR Y.FT.SIGNATORY OR Y.VERSION.PREFIX EQ 'AI.REDO' THEN
    Y.TRANSACTION.TYPE = R.FUNDS.TRANSFER.EXCEP<FT.TRANSACTION.TYPE>
    LOCATE Y.TRANSACTION.TYPE IN Y.FILE.UPLOAD.CODES SETTING FILE.CODE.POS THEN
    END ELSE
      Y.TRANSACTION.TYPE = R.FUNDS.TRANSFER.EXCEP<FT.TRANSACTION.TYPE>
      CALL F.READ(FN.FT.TXN.TYPE.CONDITION,Y.TRANSACTION.TYPE,R.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION,FTTC.ERR)
      Y.DESCRIPTION = R.FT.TXN.TYPE.CONDITION<FT6.DESCRIPTION,LNGG>
      IF NOT(Y.DESCRIPTION) THEN
        Y.DESCRIPTION  =  R.FT.TXN.TYPE.CONDITION<FT6.DESCRIPTION,1>
      END
      Y.DEBIT.ACCT.NO  = R.FUNDS.TRANSFER.EXCEP<FT.DEBIT.ACCT.NO>
      Y.CREDIT.ACCT.NO = R.FUNDS.TRANSFER.EXCEP<FT.CREDIT.ACCT.NO>
      Y.DEBIT.AMOUNT   = R.FUNDS.TRANSFER.EXCEP<FT.DEBIT.AMOUNT>

* Fix for PACS00309079 [ARC-IB Transaction Position displays as zero]

      IF NOT(Y.DEBIT.AMOUNT) THEN
        Y.DEBIT.AMOUNT = R.FUNDS.TRANSFER.EXCEP<FT.CREDIT.AMOUNT>
      END

* End of Fix

      Y.VERSION        = R.FUNDS.TRANSFER.EXCEP<FT.LOCAL.REF,LREF.POS>
      LIST.FT.EXCEP<-1> = FT.ID:"@":Y.DESCRIPTION:"@":Y.DEBIT.ACCT.NO:"@":Y.CREDIT.ACCT.NO:"@":Y.DEBIT.AMOUNT:"@":Y.VERSION
    END
  END

  RETURN
*************
STO.DET.PARA:
*************
  CUST.ID = System.getVariable("EXT.SMS.CUSTOMERS")

  SEL.STO.CMD = "SELECT ":FN.STANDING.ORDER.EXCEP:" WITH DEBIT.CUSTOMER EQ ":CUST.ID:" AND RECORD.STATUS EQ INAO"
  CALL EB.READLIST(SEL.STO.CMD,STO.LIST1,'',SEL.STO.NOR1,SEL.STO.RET1)
  LOOP
    REMOVE STO.ID FROM STO.LIST1 SETTING STO.ACC.POS
  WHILE STO.ID:CUST.ACC.POS
    CALL F.READ(FN.STANDING.ORDER.EXCEP,STO.ID,R.STANDING.ORDER.EXCEP,F.STANDING.ORDER.EXCEP,STO.HIS.ERR)
    IF NOT(STO.HIS.ERR) THEN
      Y.INPUTTER =  FIELD(R.STANDING.ORDER.EXCEP<STO.INPUTTER>,'_',6)
      Y.STO.SIGNATORY = R.STANDING.ORDER.EXCEP<STO.SIGNATORY>
      GOSUB STO.MAPPING.DETAILS
    END
  REPEAT

  RETURN
******************
STO.MAPPING.DETAILS:
******************
  IF Y.INPUTTER EQ 'ARCIB' OR Y.STO.SIGNATORY THEN
    Y.TRANSACTION.TYPE = R.STANDING.ORDER.EXCEP<STO.PAY.METHOD>
    LOCATE Y.TRANSACTION.TYPE IN Y.FILE.UPLOAD.CODES SETTING FILE.CODE.POS THEN
    END ELSE
      CALL F.READ(FN.FT.TXN.TYPE.CONDITION,Y.TRANSACTION.TYPE,R.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION,FTTC.ERR)
      Y.DESCRIPTION = R.FT.TXN.TYPE.CONDITION<FT6.DESCRIPTION,LNGG>
      IF NOT(Y.DESCRIPTION) THEN
        Y.DESCRIPTION  =  R.FT.TXN.TYPE.CONDITION<FT6.DESCRIPTION,1>
      END
      Y.DEBIT.ACCT.NO  = FIELD(STO.ID,'.',1)
      Y.CREDIT.ACCT.NO =  R.STANDING.ORDER.EXCEP<STO.CPTY.ACCT.NO>
      Y.DEBIT.AMOUNT   =  R.STANDING.ORDER.EXCEP<STO.CURRENT.AMOUNT.BAL>
      Y.VERSION        =  ''
      LIST.FT.EXCEP<-1> =STO.ID:"@":Y.DESCRIPTION:"@":Y.DEBIT.ACCT.NO:"@":Y.CREDIT.ACCT.NO:"@":Y.DEBIT.AMOUNT:"@":Y.VERSION
    END
  END
  RETURN

END
