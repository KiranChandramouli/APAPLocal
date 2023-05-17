*-----------------------------------------------------------------------------
* <Rating>-112</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.NOF.CASH.WINDOW.DEP.TERM.INST.OPEN.R32(Y.CCY.LIST,Y.TELLER.ID,R.TELLER,Y.FINAL.ARRAY,Y.TT.LIST,SET.CUR,Y.DUP.CUR)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.NOF.CASH.WINDOW.DEP.TERM.INST.OPEN.R32
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.NOF.CASH.WINDOW.DEP.TERM.INST.OPEN.R32 is a routine called from another routine
*                    REDO.APAP.NOF.CASH.WINDOW.DEP, this routine is used to fetch the term instrument openings
*                    details from AZ.ACCOUNT records
*Linked With       : Enquiry - REDO.APAP.ENQ.CASH.WINDOW.DEP
*In  Parameter     : R.REDO.H.TELLER.TXN.CODES - The record of REDO.H.TELLER.TXN.CODES
*                    Y.CCY.LIST - This variable holds the processed currency list
*Out Parameter     : Y.FINAL.ARRAY - THe final Array to be passed out
*                    Y.CCY.LIST - This variable holds the processed currency list
*Files  Used       : AZ.ACCOUNT                       As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------             -------------
* 15 Jun 2011       Marimuthu S                 ODR-2011-04-0007 32         Modification made in REDO.APAP.NOF.CASH.WINDOW.DEP.TERM.INST.OPEN
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.H.TELLER.TXN.CODES
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.TELLER
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
  GOSUB OPEN.PARA
  GOSUB FIND.MULTI.LOCAL.REF
  GOSUB TERM.INST.OPEN.DETAILS
  Y.TELLER.ID = TELLER.ID
  RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened
  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT  = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
  FN.AZ.ACCOUNT.HST = 'F.AZ.ACCOUNT$HIS'
  F.AZ.ACCOUNT.HST  = ''
  CALL OPF(FN.AZ.ACCOUNT.HST,F.AZ.ACCOUNT.HST)
  FN.T24.FUND.SERVICES = 'F.T24.FUND.SERVICES'
  F.T24.FUND.SERVICES  = ''
  CALL OPF(FN.T24.FUND.SERVICES,F.T24.FUND.SERVICES)
  TELLER.ID = ''; YACCT.NO = ''
  TELLER.ID = FIELD(Y.TELLER.ID,'_',1)
  YACCT.FLG = FIELD(Y.TELLER.ID,'_',2)
  Y.CASH.TXN.FLAG = FIELD(Y.TELLER.ID,'_',3)
  Y.CHQ.TXN.FLAG = FIELD(Y.TELLER.ID,'_',4)
  Y.TFR.TXN.FLAG = FIELD(Y.TELLER.ID,'_',5)
  RETURN

***********************
TERM.INST.OPEN.DETAILS:
***********************
* In this para of the code, the TERM INSTRUMENT OPENING details are being extracted
  Y.TT.CCY = ''; Y.TT.AMT = ''; Y.CR.ACC = ''
  YTT.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
  Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.DEBIT.AMOUNT.POS>
  IF YTT.MARKER EQ 'CREDIT' AND R.TELLER<TT.TE.CURRENCY.1> NE LCCY THEN
    Y.TT.AMT = R.TELLER<TT.TE.LOCAL.REF,LOC.L.CREDIT.AMOUNT.POS>
  END
  YNET.AMT = ''
  YNET.AMT = R.TELLER<TT.TE.NET.AMOUNT>

  IF YACCT.FLG EQ 1 THEN
    Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.1>
    Y.CR.ACC = R.TELLER<TT.TE.ACCOUNT.1>
    IF NOT(Y.TT.AMT) THEN
      Y.TT.AMT = YNET.AMT
    END
  END ELSE
    Y.TT.CCY = R.TELLER<TT.TE.CURRENCY.2>
    Y.CR.ACC = R.TELLER<TT.TE.ACCOUNT.2>
    IF NOT(Y.TT.AMT) THEN
      Y.TT.AMT = YNET.AMT
    END
  END
  GOSUB GET.TERM.INST.OPEN.DETAILS
  RETURN
*--------------------------------------------------------------------------------------------------------
***************************
GET.TERM.INST.OPEN.DETAILS:
***************************
* In this para of the code, the term instrument details are fetced corss checked with conditions and
** processed further
  GOSUB READ.AZ.ACCOUNT
  IF R.AZ.ACCOUNT THEN
    GOSUB CHECK.FIN.CATEG
    Y.VM.POS = 6
    GOSUB AMEND.FINAL.ARRAY
  END ELSE
    GOSUB CHECK.FIN.CATEG.1
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.FIN.CATEG:
****************
* In this para of the code, the transaction with FINANCIAL CATEGORY of the AZ.ACCOUNT are processed
  Y.METHOD.PAY.COUNT = DCOUNT(R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.METHOD.PAY.POS>,SM)
  Y.METHOD.PAY.START = 1
  Y.CASH.AMT = 0 ; Y.CHQ.AMT = 0 ; Y.TFR.AMT = 0; Y.METH.PAY.START = ''
  Y.METH.PAY.START = R.AZ.ACCOUNT<AZ.LOCAL.REF,LOC.L.AZ.METHOD.PAY.POS,Y.METHOD.PAY.START>
  LOOP
  WHILE Y.METHOD.PAY.START LE Y.METHOD.PAY.COUNT
    IF Y.METH.PAY.START EQ 'CASHDEPOSIT' THEN
      Y.CASH.AMT += Y.METH.PAY.START
    END
    IF Y.METH.PAY.START EQ 'CHEQUE.DEPOSIT' THEN
      Y.CHQ.AMT  += Y.METH.PAY.START
    END
    IF Y.METH.PAY.START NE 'CASHDEPOSIT' AND Y.METH.PAY.START NE 'CHEQUE.DEPOSIT' THEN
      Y.TFR.AMT  += Y.METH.PAY.START
    END
    Y.METHOD.PAY.START += 1
  REPEAT
  YCURR = R.AZ.ACCOUNT<AZ.CURRENCY>
  RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.FIN.CATEG.1:
******************
  YCURR = Y.TT.CCY
  Y.VM.POS = 6
  IF Y.CASH.TXN.FLAG THEN
    Y.CASH.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END

  IF Y.CHQ.TXN.FLAG THEN
    Y.CHQ.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END

  IF Y.TFR.TXN.FLAG THEN
    Y.TFR.AMT = Y.TT.AMT
    GOSUB AMEND.FINAL.ARRAY
  END
  RETURN
******************
AMEND.FINAL.ARRAY:
******************
* In this para of the code, the Y.FINAL.ARRAY is amended with increment in the total number of transactions
** and the amount is added up
  LOCATE YCURR IN Y.CCY.LIST<1> SETTING Y.CCY.POS ELSE
    Y.CCY.LIST<-1> = YCURR
    Y.CCY.POS = DCOUNT(Y.CCY.LIST,FM)
  END
  Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,3> += 1
  Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,4> += Y.CASH.AMT
  Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,5> += Y.CHQ.AMT
  Y.FINAL.ARRAY<Y.CCY.POS,Y.VM.POS,6> += Y.TFR.AMT

  Y.TT.LIST<-1> = TELLER.ID
  RETURN
*--------------------------------------------------------------------------------------------------------
****************
READ.AZ.ACCOUNT:
****************
* In this para of the code, file AZ.ACCOUNT is read
  R.AZ.ACCOUNT  = '';    AZ.ACCOUNT.ER = ''
  CALL F.READ(FN.AZ.ACCOUNT,Y.CR.ACC,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACCOUNT.ER)
  IF NOT(R.AZ.ACCOUNT) THEN
    YH.CR.ACC = Y.CR.ACC
    CALL EB.READ.HISTORY.REC(F.AZ.ACCOUNT.HST,YH.CR.ACC,R.AZ.ACCOUNT,AZ.AC.ERR)
  END
  RETURN
*--------------------------------------------------------------------------------------------------------
***********************
READ.T24.FUND.SERVICES:
***********************
* In this para of the code, file T24.FUND.SERVICES is read
  R.T24.FUND.SERVICES  = '';    T24.FUND.SERVICES.ER = ''
  CALL F.READ(FN.T24.FUND.SERVICES,T24.FUND.SERVICES.ID,R.T24.FUND.SERVICES,F.T24.FUND.SERVICES,T24.FUND.SERVICES.ER)
  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
  APPL.ARRAY = 'AZ.ACCOUNT':FM:'TELLER'
  FLD.ARRAY  = 'L.AZ.REF.NO':VM:'L.AZ.DEP.NAME':VM:'L.AZ.METHOD.PAY':VM:'L.AZ.AMOUNT':VM:'L.MG.ACT.NO':FM:'L.DEBIT.AMOUNT':VM:'L.CREDIT.AMOUNT'
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.AZ.REF.NO.POS     = FLD.POS<1,1>
  LOC.L.AZ.DEP.NAME.POS   = FLD.POS<1,2>
  LOC.L.AZ.METHOD.PAY.POS = FLD.POS<1,3>
  LOC.L.AZ.AMOUNT.POS     = FLD.POS<1,4>
  LOC.L.MG.ACT.NO.POS     = FLD.POS<1,5>
  LOC.L.DEBIT.AMOUNT.POS = FLD.POS<2,1>
  LOC.L.CREDIT.AMOUNT.POS = FLD.POS<2,2>
  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
