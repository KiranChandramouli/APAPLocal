*-----------------------------------------------------------------------------
* <Rating>-101</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.BUY(Y.CCY.LIST,TELLER.ID,Y.TT.PARAM.REC,Y.COMPANY.LIST,Y.TT.LIST,Y.FINAL.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.BUY
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.BUY is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP.SAV.CUR, this routine is used to fetch the BUY currency
*                    details
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : Y.CCY.LIST     - This variable holds the processed currency list
*                    TELLER.ID      - Holds the teller ID
*                    Y.TT.PARAM.REC - Holds the teller and parameter records
*                    Y.COMPANY.LIST - The variblle holds the list of third party payment companies
*Out Parameter     : Y.FINAL.ARRAY  - THe final Array to be passed out
*                    Y.CCY.LIST     - This variable holds the processed currency list
*Files  Used       : TELLER                           As              I               Mode
*                    TELLER.TRANSACTION               As              I               Mode
*                    TRANSACTION                      As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 22 Mar 2011       Shiva Prasad Y              ODR-2010-03-0086 35         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.TELLER
$INSERT I_F.TELLER.TRANSACTION
$INSERT I_F.TRANSACTION
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

  FN.TRANSACTION = 'F.TRANSACTION'
  F.TRANSACTION  = ''
  CALL OPF(FN.TRANSACTION,F.TRANSACTION)

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

  LOCATE TELLER.ID IN Y.TT.LIST SETTING POS.CHK THEN
    RETURN
  END

  R.TELLER                     = FIELD(Y.TT.PARAM.REC,'$',1)
  R.REDO.ADMIN.CHQ.PARAM       = FIELD(Y.TT.PARAM.REC,'$',2)
  R.REDO.MANAGER.CHQ.PARAM     = FIELD(Y.TT.PARAM.REC,'$',3)
  R.CERTIFIED.CHEQUE.PARAMETER = FIELD(Y.TT.PARAM.REC,'$',4)

  IF R.TELLER<TT.TE.CURRENCY.1> EQ R.TELLER<TT.TE.CURRENCY.2> THEN
    RETURN
  END

  GOSUB FIND.MULTI.LOCAL.REF

  TELLER.TRANSACTION.ID = R.TELLER<TT.TE.TRANSACTION.CODE>
  GOSUB READ.TELLER.TRANSACTION

  Y.COMP.COUNT = DCOUNT(Y.COMPANY.LIST,FM)

  Y.CCY.1.CASH = '' ; Y.CCY.1.CHQ = '' ; Y.CCY.1.TFR = ''
  Y.CCY.2.CASH = '' ; Y.CCY.2.CHQ = '' ; Y.CCY.2.TFR = ''

  IF R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
    GOSUB UPDATE.CURRENCY.1
  END

  IF R.TELLER<TT.TE.CURRENCY.2> NE LCCY THEN
    GOSUB UPDATE.CURRENCY.2
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
******************
UPDATE.CURRENCY.1:
******************
* In this para of the code, the CURRENCY.1 is checked if its not LOCAL.CURRENCY and processed further
  TRANSACTION.ID = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.1>
  GOSUB READ.TRANSACTION

  IF R.TRANSACTION<AC.TRA.DEBIT.CREDIT.IND> NE 'DEBIT' THEN
    RETURN
  END

  Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.1>
  Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>

  IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS> EQ 'CASH' THEN
    Y.CCY.1.CASH = 1
    Y.VM.POS     = 20 + Y.COMP.COUNT + 8
    Y.ADD.AMT    = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END

  IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS> EQ 'CHECK' THEN
    Y.CCY.1.CHQ = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 8
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END

  IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS> EQ 'BANK.TRANSFER' THEN
    Y.CCY.1.TFR = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 8
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
******************
UPDATE.CURRENCY.2:
******************
* In this para of the code, the CURRENCY.2 is checked if its not LOCAL.CURRENCY and processed further
  TRANSACTION.ID = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
  GOSUB READ.TRANSACTION

  IF R.TRANSACTION<AC.TRA.DEBIT.CREDIT.IND> NE 'DEBIT' THEN
    RETURN
  END

  Y.TT.AMT = R.TELLER<TT.TE.AMOUNT.FCY.2>
  Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>

  IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS> EQ 'CASH' THEN
    Y.CCY.2.CASH = 1
    Y.VM.POS     = 20 + Y.COMP.COUNT + 8
    Y.ADD.AMT    = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END

  IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS> EQ 'CHECK' THEN
    Y.CCY.2.CHQ = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 8
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END

  IF R.TELLER<TT.TE.LOCAL.REF,LOC.L.TT.PAY.METHOD.POS> EQ 'BANK.TRANSFER' THEN
    Y.CCY.2.TFR = 1
    Y.VM.POS    = 20 + Y.COMP.COUNT + 8
    Y.ADD.AMT   = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END

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

  IF Y.CCY.1.CASH OR Y.CCY.2.CASH THEN
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.ADD.AMT
  END
  IF Y.CCY.1.CHQ OR Y.CCY.2.CHQ THEN
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.ADD.AMT
  END

  IF Y.CCY.1.TFR OR Y.CCY.2.TFR THEN
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
    Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.ADD.AMT
  END

  Y.TT.LIST<-1> = TELLER.ID

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
*****************
READ.TRANSACTION:
*****************
* In this para of the code, file TRANSACTION is read
  R.TRANSACTION  = ''
  TRANSACTION.ER = ''
  CALL F.READ(FN.TRANSACTION,TRANSACTION.ID,R.TRANSACTION,F.TRANSACTION,TRANSACTION.ER)

  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
  APPL.ARRAY = 'TELLER'
  FLD.ARRAY  = 'L.TT.PAY.METHOD'
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.TT.PAY.METHOD.POS = FLD.POS<1,1>

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
