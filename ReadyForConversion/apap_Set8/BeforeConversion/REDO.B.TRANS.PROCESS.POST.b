*-----------------------------------------------------------------------------
* <Rating>-72</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.TRANS.PROCESS.POST
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Sakthi Sellappillai
* Program Name  : REDO.B.TRANS.PROCESS
* ODR           : ODR-2010-08-0031
*------------------------------------------------------------------------------------------
*DESCRIPTION  : REDO.B.TRANS.PROCESS Multithreading routine responsible for generates
*FUNDS.TRANSFER Record
*------------------------------------------------------------------------------------------
* Linked with:
* In parameter : None
* out parameter : None
*------------------------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------------------------
* DATE             WHO                         REFERENCE            DESCRIPTION
*==============    ==============              =================    =================
* 19.10.2010       Sakthi Sellappillai         ODR-2010-08-0031     INITIAL CREATION
*------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ACCOUNT
$INSERT I_BATCH.FILES
$INSERT I_System
$INSERT I_REDO.B.TRANS.PROCESS.COMMON
$INSERT I_F.REDO.SUPPLIER.PAYMENT
$INSERT I_F.REDO.FILE.DATE.PROCESS
$INSERT I_F.REDO.SUPPLIER.PAY.DATE
  GOSUB PROCESS
  GOSUB GOEND
  RETURN
*------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------
  Y.SUPPLIER.PAY.LIST = R.REDO.SUPPLIER.PAY.DATE
  IF Y.SUPPLIER.PAY.LIST THEN
    Y.SUPPLIER.PAY.CNT = DCOUNT(Y.SUPPLIER.PAY.LIST,FM)
    Y.SUP.PAY.INIT = 1
    IF Y.SUPPLIER.PAY.CNT GT 1 THEN
      LOOP
        REMOVE Y.SUPPLIER.PAY.ID FROM Y.SUPPLIER.PAY.LIST SETTING Y.OFS.MSG.POS
      WHILE Y.SUP.PAY.INIT LE Y.SUPPLIER.PAY.CNT
        GOSUB SUPPLIER.PAY.PROCESS
      REPEAT
    END ELSE
      Y.SUPPLIER.PAY.ID = Y.SUPPLIER.PAY.LIST
      GOSUB SUPPLIER.PAY.PROCESS
    END
  END
  RETURN
*------------------------------------------------------------------------------------------
SUPPLIER.PAY.PROCESS:
*------------------------------------------------------------------------------------------
  CALL F.READ(FN.REDO.SUPPLIER.PAYMENT,Y.SUPPLIER.PAY.ID,R.REDO.SUPPLIER.PAYMENT,F.REDO.SUPPLIER.PAYMENT,Y.REDO.SUPPLIER.PAY.ERR)
  Y.SUP.PAY.FILE.NAME        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.FILE.NAME>
  Y.SUP.PAY.SOURCE.ACCOUNT   =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.SOURCE.ACCOUNT>
  Y.SUP.PAY.PAYMENT.DATE     =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.PAYMENT.DATE>
  Y.SUP.PAY.BANK.CODE        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BANK.CODE>
  Y.SUP.PAY.BANK.NAME        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BANK.NAME>
  Y.SUP.PAY.BEN.ACCOUNT      =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.ACCOUNT>
  Y.SUP.PAY.IDENTIFY.TYPE    =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.IDENTIFY.TYPE>
  Y.SUP.PAY.BEN.ID.NO        =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.ID.NO>
  Y.SUP.PAY.BEN.CUSTOMER     =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.BEN.CUSTOMER>
  Y.SUP.PAY.INVOICE.NO       =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.INVOICE.NO>
  Y.SUP.PAY.NCF.NO           =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.NCF.NO>
  Y.SUP.PAY.CURRENCY         =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.CURRENCY>
  Y.SUP.PAY.AMOUNT           =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.AMOUNT>
  Y.SUP.PAY.RECORD.STATUS    =  R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.RECORD.STATUS>
  Y.SUP.PAY.OFS.MSG.ID       = R.REDO.SUPPLIER.PAYMENT<REDO.SUP.PAY.OFS.MESSAGE.ID>
  IF Y.SUP.PAY.OFS.MSG.ID THEN
    Y.SUP.PAY.OFS.RES.ID = Y.SUP.PAY.OFS.MSG.ID:'.1'
    CALL F.READ(FN.OFS.RESPONSE.QUEUE,Y.SUP.PAY.OFS.RES.ID,R.OFS.RESPONSE.QUEUE,F.OFS.RESPONSE.QUEUE,Y.OFS.RES.ERR)
    IF R.OFS.RESPONSE.QUEUE THEN
      IF R.OFS.RESPONSE.QUEUE<1> EQ  1 THEN
        Y.PAY.SUP.PAY.STRING = 'TRANSACTION SUCCESS'
      END ELSE
        Y.PAY.SUP.PAY.FAILURE.DESC = R.OFS.RESPONSE.QUEUE<2>
        Y.PAY.SUP.PAY.STRING = 'TRANSACTION FAILURE'
      END
    END
  END
  Y.VAR.EXT.CUSTOMER = ''
  Y.VAR.EXT.CUSTOMER = System.getVariable("EXT.SMS.CUSTOMERS")
  Y.TRANS.DATE = TODAY
  Y.TRANS.TIME= OCONV(TIME(), "MT")
  CHANGE ":" TO '' IN Y.TRANS.TIME
  Y.UNIQUE.ID = Y.VAR.EXT.CUSTOMER:"_":Y.TRANS.DATE:"_":Y.TRANS.TIME
  FILENAME = Y.UNIQUE.ID:'.CSV'
  FN.HRMS.FILE = "FT_BULK_TRANS_STATUS"
  F.HRMA.FILE = ""
  CALL OPF(FN.HRMS.FILE,F.HRMA.FILE)
  R.RECORD = ''
  R.RECORD = Y.SUP.PAY.FILE.NAME:",":Y.SUP.PAY.SOURCE.ACCOUNT:",":Y.SUP.PAY.PAYMENT.DATE:",":Y.SUP.PAY.BANK.CODE:",":Y.SUP.PAY.BANK.NAME:",":Y.SUP.PAY.BEN.ACCOUNT:",":
  R.RECORD:=Y.SUP.PAY.IDENTIFY.TYPE:",":Y.SUP.PAY.BEN.ID.NO:",":Y.SUP.PAY.BEN.CUSTOMER:",":Y.SUP.PAY.INVOICE.NO:",":Y.SUP.PAY.NCF.NO:",":
  R.RECORD:=Y.SUP.PAY.CURRENCY:",":Y.SUP.PAY.AMOUNT:",":Y.SUP.PAY.RECORD.STATUS:",":Y.PAY.SUP.PAY.STRING:",":Y.PAY.SUP.PAY.FAILURE.DESC
  WRITE R.RECORD TO F.HRMA.FILE,FILENAME
  RETURN
*------------------------------------------------------------------------------------------
GOEND:
*------------------------------------------------------------------------------------------
END
*--------------------------------*END OF SUBROUTINE*---------------------------------------
