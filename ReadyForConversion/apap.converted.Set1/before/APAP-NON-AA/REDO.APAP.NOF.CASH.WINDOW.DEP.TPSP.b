*-----------------------------------------------------------------------------
* <Rating>-145</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.TPSP(Y.CCY.LIST,Y.TT.IDS,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.FINAL.ARRAY,Y.TT.LIST)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.TPSP
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.TPSP is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR, this routine is used to fetch THIRD PARTY
*                    PAYMENTS details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.IDS       - This variable holds the teller ids
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*                    Y.TT.LIST      - This variable holds the processed TELLER records
*                    Y.COMPANY.LIST - This variable holds the list of companies processed
*Files  Used       : TELLER                           As              I               Mode
*                    ACCOUNT                          As              I               Mode
*                    REDO.H.TELLER.TXN.CODES          As              I               Mode
*                    TELLER.TRANSACTION               As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 25 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.TELLER
$INSERT I_F.REDO.H.TELLER.TXN.CODES
$INSERT I_F.TELLER.TRANSACTION
$INSERT I_F.ACCOUNT
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
  FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
  F.TELLER.TRANSACTION  = ''
  CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  FN.TELLER = 'F.TELLER'
  F.TELLER  = ''
  CALL OPF(FN.TELLER,F.TELLER)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
  R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'$',1)
  R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'$',2)
  R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'$',3)
  R.REDO.H.TELLER.TXN.CODES    = FIELD(Y.TT.PARAM.REC,'$',4)

  LOOP
    REMOVE TELLER.ID FROM Y.TT.IDS SETTING Y.TELLER.POS
  WHILE TELLER.ID : Y.TELLER.POS
    GOSUB READ.TELLER
    GOSUB GET.DETAILS
  REPEAT

  RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************
* In this para of the code, the details of third party payments are processed
  Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>

  IF Y.TT.CCY EQ LCCY THEN
    Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1,1>
  END ELSE
    Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
  END

  GOSUB FIND.MULTI.LOCAL.REF
  Y.CHQ.TXN.CODES = R.REDO.H.TELLER.TXN.CODES<TT.TXN.CHQ.TXN.CODES>
  CHANGE VM TO FM IN Y.CHQ.TXN.CODES

  IF NOT(R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CMPNY.NAME.POS>) THEN
    RETURN
  END

  IF NOT(R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.MET.OF.PAY.POS>) THEN
    RETURN
  END

  Y.START.POS    = 20
  Y.CASH.FLAG    = ''   ; Y.CHQ.FLAG = ''       ; Y.TFR.FLAG = ''

  LOCATE R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CMPNY.NAME.POS> IN Y.COMPANY.LIST<1> SETTING Y.COMP.POS THEN
    Y.VM.POS =  Y.COMP.POS + Y.START.POS
  END ELSE
    Y.COMPANY.LIST<-1> = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CMPNY.NAME.POS>
    Y.VM.POS           = DCOUNT(Y.COMPANY.LIST,FM) + Y.START.POS
  END

  IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.MET.OF.PAY.POS> EQ 'CASH' THEN
    GOSUB GET.CASH.DETAILS
    RETURN
  END

  IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.MET.OF.PAY.POS> EQ 'CHEQUE' THEN
    GOSUB GET.CHEQUE.DETAILS
    RETURN
  END

  GOSUB GET.TRANSFER.DETAILS

  RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.CASH.DETAILS:
*****************
* In this para of the code, the THIRD PARTY PAYMENTS done through CASH are fetched and the details are extracated for display
  Y.CASH.FLAG = 1
  Y.ADD.AMT   = Y.TT.AMT
  GOSUB AMEND.FINAL.ARRAY

  RETURN
*--------------------------------------------------------------------------------------------------------
*******************
GET.CHEQUE.DETAILS:
*******************
* In this para of the code, the THIRD PARTY PAYMENTS done through CHEQUE are fetched and the details are extracated for display

  IF NOT(R.TELLER<TT.TE.CHEQUE.NUMBER>) THEN
    RETURN
  END

  TELLER.TRANSACTION.ID = R.TELLER<TT.TE.TRANSACTION.CODE>
  GOSUB READ.TELLER.TRANSACTION
  IF NOT(R.TELLER.TRANSACTION) THEN
    RETURN
  END

  LOCATE R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1> IN Y.CHQ.TXN.CODES<1> SETTING Y.CHQ.POS ELSE
    LOCATE R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2> IN Y.CHQ.TXN.CODES<1> SETTING Y.CHQ.POS ELSE
      RETURN
    END
  END

  Y.CHQ.FLAG = 1
  Y.ADD.AMT  = Y.TT.AMT
  GOSUB AMEND.FINAL.ARRAY

  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
GET.TRANSFER.DETAILS:
*********************
* In this para of the code, the THIRD PARTY PAYMENTS done through TRANSFER are fetched and the details are extracated for display

  IF R.TELLER<TT.TE.DR.CR.MARKER> EQ 'DEBIT' THEN
    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.1>
  END ELSE
    ACCOUNT.ID = R.TELLER<TT.TE.ACCOUNT.2>
  END

  GOSUB READ.ACCOUNT

  IF NOT(R.ACCOUNT<AC.CUSTOMER>) THEN
    RETURN
  END

  Y.TFR.FLAG = 1
  Y.ADD.AMT  = Y.TT.AMT
  GOSUB AMEND.FINAL.ARRAY

  RETURN
*--------------------------------------------------------------------------------------------------------
******************
AMEND.FINAL.ARRAY:
******************
* In this para of the code, the Y.FINAL.ARRAY is amended with increment in the total number of transactions
** and the amount is added up

  LOCATE Y.TT.CCY IN Y.CCY.LIST<1> SETTING Y.CCY.POS ELSE
    Y.CCY.LIST<-1> = Y.TT.CCY
    Y.CCY.POS = DCOUNT(Y.CCY.LIST,FM)
  END

  Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,2> = R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.CMPNY.NAME.POS>

  IF Y.CASH.FLAG THEN
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.ADD.AMT
  END

  IF Y.CHQ.FLAG THEN
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.ADD.AMT
  END

  IF Y.TFR.FLAG THEN
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.ADD.AMT
  END

  Y.TT.LIST<-1> = TELLER.ID

  RETURN
*--------------------------------------------------------------------------------------------------------
************
READ.TELLER:
************
* In this para of the code, file TELLER is read
  R.TELLER  = ''
  TELLER.ER = ''
  CALL F.READ(FN.TELLER,TELLER.ID,R.TELLER,F.TELLER,TELLER.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
************************
READ.TELLER.TRANSACTION:
************************
* In this para of the code, file TELLER.TRANSACTION is read
  R.TELLER.TRANSACTION  = ''
  TELLER.TRANSACTION.ER = ''
  CALL F.READ(FN.TELLER.TRANSACTION,TELLER.TRANSACTION.ID,R.TELLER.TRANSACTION,F.TELLER.TRANSACTION,TELLER.TRANSACTION.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
  R.ACCOUNT  = ''
  ACCOUNT.ER = ''
  CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
  APPL.ARRAY = 'TELLER'
  FLD.ARRAY  = 'L.TT.CMPNY.NAME':VM:'L.TT.MET.OF.PAY'
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

  LOC.L.TT.CMPNY.NAME.POS = FLD.POS<1,1>
  LOC.L.TT.MET.OF.PAY.POS = FLD.POS<1,2>

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
