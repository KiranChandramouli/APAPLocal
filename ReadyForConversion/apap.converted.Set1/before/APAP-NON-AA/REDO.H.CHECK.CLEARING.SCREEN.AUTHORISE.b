*------------------------------------------------------------------------------------------------------------
* <Rating>-104</Rating>
*------------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.H.CHECK.CLEARING.SCREEN.AUTHORISE
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This routine is used to authorise the REDO.H.CHECK.CLEARING.SCREEN table and creation of
*               records through ofs for FT,TT and ALE records
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.H.CHECK.CLEARING.SCREEN
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 29-Jun-2010      Naveenkumar N    ODR-2010-02-0290              Initial creation
*----------------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.AC.LOCKED.EVENTS
$INSERT I_F.ACCOUNT
$INSERT I_F.TELLER
$INSERT I_F.REDO.H.ROUTING.NUMBER
$INSERT I_F.REDO.H.CLEARING.RULES.PARAM
$INSERT I_F.REDO.H.CHECK.CLEARING.SCREEN
$INSERT I_F.REDO.H.CCY.RULES
*
  GOSUB INIT
  GOSUB PROCESS
  RETURN
*****
INIT:
*****
  FN.FUNDS.TRANSFER = "F.FUNDS.TRANSFER"
  F.FUNDS.TRANSFER = ""
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
*
  FN.ROUTING.NUMBER = "F.REDO.H.ROUTING.NUMBER"
  F.ROUTING.NUMBER = ""
  R.ROUTING.NO = ""
  ROU.ERR = ""
  CALL OPF(FN.ROUTING.NUMBER,F.ROUTING.NUMBER)
*
  FN.CLEARING.RULES.PARAM = "F.REDO.H.CLEARING.RULES.PARAM"
  F.CLEARING.RULES.PARAM = ""
  R.CLEARING.RULES.PARAM = ""
  E.CLEARING.RULES.PARAM = ""
  CALL OPF(FN.CLEARING.RULES.PARAM,F.CLEARING.RULES.PARAM)
*
  FN.AC.LOCKED.EVENTS = "F.AC.LOCKED.EVENTS"
  F.AC.LOCKED.EVENTS = ""
  R.AC.LOCKED.EVENTS = ""
  E.AC.LOCKED.EVENTS = ""
  CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
*
  FN.REDO.H.CCY.RULES = "F.REDO.H.CCY.RULES"
  F.REDO.H.CCY.RULES = ""
  R.REDO.H.CCY.RULES = ""
  E.REDO.H.CCY.RULES = ""
  CALL OPF(FN.REDO.H.CCY.RULES,F.REDO.H.CCY.RULES)
*
  FN.ACCOUNT = "F.ACCOUNT"
  F.ACCOUNT = ""
  R.ACCOUNT = ""
  E.ACCOUNT = ""
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
  FN.TELLER = "F.TELLER"
  F.TELLER = ""
  R.TELLER = ""
  F.TELLER = ""
  E.TELLER = ""
  CALL OPF(FN.TELLER,F.TELLER)
*
  TELLER.CNT = ""
  FLAG.CHQ.CNT = ""
  Y.AMT = ""
  Y.ORDERING.CUST = ""
  RETURN
********
PROCESS:
********
  Y.TT.TRANS = R.NEW(REDO.CHK.INIT.DEP.REF)
  Y.TT.TRANS = CHANGE(Y.TT.TRANS,VM,FM)
  LOOP
    REMOVE Y.TT.DEP FROM Y.TT.TRANS SETTING POS
  WHILE Y.TT.DEP:POS
    TELLER.CNT += 1
    GOSUB FT.CREATION
    GOSUB TT.CREATION
    GOSUB ALE.REVERSAL
    GOSUB ALE.CREATION
    FLAG.CHQ.CNT = ""
    Y.AMT = ""
  REPEAT
  RETURN
************
FT.CREATION:
************
  Y.CHEQ.NOS = R.NEW(REDO.CHK.CHECK.NO)<1,TELLER.CNT>
  Y.CHEQ.NOS = CHANGE(Y.CHEQ.NOS,SM,VM)
  Y.CHEQ.NOS = CHANGE(Y.CHEQ.NOS,VM,FM)
*
  LOOP
    REMOVE Y.CHEQUE.NO FROM Y.CHEQ.NOS SETTING CHEQ.POS
  WHILE Y.CHEQUE.NO:CHEQ.POS
    FLAG.CHQ.CNT += 1
    Y.AMT += R.NEW(REDO.CHK.AMOUNT)<1,TELLER.CNT,FLAG.CHQ.CNT>
  REPEAT
*
  Y.ROT.NO = R.NEW(REDO.CHK.ROUTING.NO)<1,TELLER.CNT>
  CALL F.READ(FN.ROUTING.NUMBER,Y.ROT.NO,R.ROUTING.NO,F.ROUTING.NUMBER,ROU.ERR)
  Y.APAP = R.ROUTING.NO<REDO.ROUT.APAP>
*
  IF Y.APAP EQ "YES" THEN
    Y.ID = "DOP"
  END ELSE
    Y.ID = "USD"
  END
*
  Y.DEBIT.VALUE.DATE = TODAY
*
  CALL F.READ(FN.CLEARING.RULES.PARAM,Y.ID,R.CLEARING.RULES.PARAM,F.CLEARING.RULES.PARAM,PARAM.ERR)
  Y.FWD.DAYS = R.CLEARING.RULES.PARAM<CLR.RULE.FWD.DAYS,TELLER.CNT>
  Y.PROCESS.DATE = TODAY
  NO.OF.DAYS = '+':Y.FWD.DAYS:'C'
  CALL CDT('',Y.PROCESS.DATE,NO.OF.DAYS)
*
  Y.NET.AMT = R.NEW(REDO.CHK.TT.DEP.AMOUNT)<1,TELLER.CNT>
  IF Y.AMT GT Y.NET.AMT THEN
    Y.DEBIT.ACC = R.CLEARING.RULES.PARAM<CLR.RULE.INTER.DEPT.ACCT>
    Y.CREDIT.ACC = R.NEW(REDO.CHK.ACCOUNT.NO)<1,TELLER.CNT>
    Y.DIFFERENCE.AMT = Y.AMT-Y.NET.AMT
    Y.CREDIT.AMT = Y.DIFFERENCE.AMT
*
    Y.ACC.ID = Y.CREDIT.ACC
    GOSUB READ.ACC
    Y.DEBIT.CCY = Y.DEBIT.ACC[1,3]
    Y.ORDERING.CUST = R.ACCOUNT<AC.CUSTOMER>
    Y.CREDIT.CCY = R.ACCOUNT<AC.CURRENCY>
  END
  IF Y.AMT LT Y.NET.AMT THEN
    Y.DEBIT.ACC = R.NEW(REDO.CHK.ACCOUNT.NO)<1,TELLER.CNT>
    Y.CREDIT.ACC = R.CLEARING.RULES.PARAM<CLR.RULE.INTER.DEPT.ACCT>
    Y.DIFFERENCE.AMT = Y.NET.AMT-Y.AMT
    Y.CREDIT.AMT = Y.DIFFERENCE.AMT
*
    Y.ACC.ID = Y.DEBIT.ACC
    GOSUB READ.ACC
    Y.DEBIT.CCY = R.ACCOUNT<AC.CURRENCY>
    Y.ORDERING.CUST = R.ACCOUNT<AC.CUSTOMER>
    Y.CREDIT.CCY = Y.CREDIT.ACC[1,3]
  END
*
  GOSUB CREATE.FT.MESSAGE
  RETURN
*********
READ.ACC:
*********
  Y.TRANSACTION.TYPE = "AC.1"
  CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,E.ACCOUNT)
  RETURN
******************
CREATE.FT.MESSAGE:
******************
  OFS.FT.STR = 'FUNDS.TRANSFER,CHQ.FUNDS/I/PROCESS,/,,REF.NO:1:1=':',TRANSACTION.TYPE:1:1=':Y.TRANSACTION.TYPE:',DEBIT.ACCT.NO:1:1:=':Y.DEBIT.ACC:',DEBIT.CURRENCY:1:1=':Y.DEBIT.CCY:',CREDIT.AMOUNT:1:1:=':Y.CREDIT.AMT:',CREDIT.ACCT.NO:1:1:=':Y.CREDIT.ACC:',CREDIT.CURRENCY:1:1:=':Y.CREDIT.CCY:',DEBIT.VALUE.DATE:1:1:=':Y.DEBIT.VALUE.DATE:',PROCESSING.DATE:1:1:=':Y.PROCESS.DATE:',CREDIT.THEIR.REF:1:1:=':ID.NEW:',ORDERING.CUST:1:1:=':Y.ORDERING.CUST
  OFS.FT.SRC = 'CHQ.OFS'
  OFS.MSG.ID = ""
  OPTIONS = ""
  CALL OFS.POST.MESSAGE(OFS.FT.STR,OFS.MSG.ID,OFS.FT.SRC,OPTIONS)
  RETURN
************
TT.CREATION:
************
  Y.CHEQ.NOS = R.NEW(REDO.CHK.CHECK.NO)<1,TELLER.CNT>
  Y.CHEQ.NOS = CHANGE(Y.CHEQ.NOS,SM,VM)
  Y.CHEQ.NOS = CHANGE(Y.CHEQ.NOS,VM,FM)
  FLAG.CHQ.CNT = ""
  LOOP
    REMOVE Y.CHEQUE.NO FROM Y.CHEQ.NOS SETTING CHEQ.POS
  WHILE Y.CHEQUE.NO:CHEQ.POS
    FLAG.CHQ.CNT += 1
    Y.TRANSACTION.TYPE = R.CLEARING.RULES.PARAM<CLR.RULE.TELLER.CODE>
    Y.TELLER.ID = "0031"
    Y.ACCOUNT.DR = R.NEW(REDO.CHK.DR.ACCOUNT)<1,TELLER.CNT,FLAG.CHQ.CNT>
    Y.ACCOUNT.CR = R.NEW(REDO.CHK.CR.ACCOUNT)<1,TELLER.CNT,FLAG.CHQ.CNT>
    Y.AMT = R.NEW(REDO.CHK.AMOUNT)<1,TELLER.CNT,FLAG.CHQ.CNT>
*
    IF Y.ACCOUNT.DR[1,3] EQ LCCY THEN
      OFS.TT.STR = 'TELLER,CHQ.FUNDS/I/PROCESS,/,,TRANSACTION.NUMBER:1:1=':',TRANSACTION.CODE:1:1=':Y.TRANSACTION.TYPE:',TELLER.ID.1:1:1=':Y.TELLER.ID:',ACCOUNT.1:1:1=':Y.ACCOUNT.DR:',AMOUNT.LOCAL.1:1:1=':Y.AMT:',VALUE.DATE.1:1:1=':TODAY:',TELLER.ID.2:1:1=':Y.TELLER.ID:',ACCOUNT.2:1:1=':Y.ACCOUNT.CR
    END ELSE
      OFS.TT.STR = 'TELLER,CHQ.FUNDS/I/PROCESS,/,,TRANSACTION.NUMBER:1:1=':',TRANSACTION.CODE:1:1=':Y.TRANSACTION.TYPE:',TELLER.ID.1:1:1=':Y.TELLER.ID:',CURRENCY.1:1:1=':Y.ACCOUNT.DR[1,3]:',ACCOUNT.1:1:1=':Y.ACCOUNT.DR:',AMOUNT.FCY.1:1:1=':Y.AMT:',VALUE.DATE.1:1:1=':TODAY:',TELLER.ID.2:1:1=':Y.TELLER.ID:',ACCOUNT.2:1:1=':Y.ACCOUNT.CR
    END
    OFS.TT.SRC = 'CHQ.OFS'
    OFS.MSG.ID.TT = ""
    OPTIONS = ""
    CALL OFS.POST.MESSAGE(OFS.TT.STR,OFS.MSG.ID.TT,OFS.TT.SRC,OPTIONS)
  REPEAT
  RETURN
*************
ALE.CREATION:
*************
  Y.CHEQ.NOS = R.NEW(REDO.CHK.CHECK.NO)<1,TELLER.CNT>
  Y.CHEQ.NOS = CHANGE(Y.CHEQ.NOS,SM,VM)
  Y.CHEQ.NOS = CHANGE(Y.CHEQ.NOS,VM,FM)
  FLAG.CHQ.CNT = ""
  LOOP
    REMOVE Y.CHEQUE.NO FROM Y.CHEQ.NOS SETTING CHEQ.POS
  WHILE Y.CHEQUE.NO:CHEQ.POS
    FLAG.CHQ.CNT += 1
    Y.AMT = R.NEW(REDO.CHK.AMOUNT)<1,TELLER.CNT,FLAG.CHQ.CNT>
    Y.FROM.DATE = TODAY
    Y.ACCOUNT = R.NEW(REDO.CHK.DR.ACCOUNT)<1,TELLER.CNT,FLAG.CHQ.CNT>
*
    CALL F.READ(FN.REDO.H.CCY.RULES,Y.ID,R.REDO.H.CCY.RULES,F.REDO.H.CCY.RULES,E.REDO.H.CCY.RULES)
    Y.FWD.CCY.RULES = R.REDO.H.CCY.RULES<REDO.CCY.FWD.DAYS>
    Y.NO.OF.DAYS = '+':Y.FWD.CCY.RULES:'C'
    TO.DATE = TODAY
    CALL CDT('',TO.DATE,Y.NO.OF.DAYS)
*
    OFS.ALE.CRE = 'AC.LOCKED.EVENTS,CHQ.FUNDS/I/PROCESS,/,,TRANSACTION.REF:1:1=':',ACCOUNT.NUMBER:1:1=':Y.ACCOUNT:',FROM.DATE:1:1=':Y.FROM.DATE:',TO.DATE:1:1=':TO.DATE:',LOCKED.AMOUNT:1:1=':Y.AMT
    OFS.ALE.SRC = 'CHQ.OFS'
    OFS.MSG.ID.CRE = ""
    OPTIONS = ""
    CALL OFS.POST.MESSAGE(OFS.ALE.CRE,OFS.MSG.ID.CRE,OFS.ALE.SRC,OPTIONS)
  REPEAT
  RETURN
*************
ALE.REVERSAL:
*************
  Y.TT.DEP.AMT = R.NEW(REDO.CHK.TT.DEP.AMOUNT)<1,TELLER.CNT>
  SEL.CMD ='SELECT ':FN.AC.LOCKED.EVENTS:' WITH ACCOUNT.NUMBER EQ ':Y.CREDIT.ACC:' AND LOCKED.AMOUNT EQ ':Y.TT.DEP.AMT
  SEL.LIST = ""
  NO.OF.REC = ""
  SEL.RET = ""
*
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.RET)
  IF SEL.LIST NE '' THEN
    OFS.ALE.STR = 'AC.LOCKED.EVENTS,CHQ.FUNDS/R/PROCESS,/,':SEL.LIST<1>
    OFS.ALE.SRC = 'CHQ.OFS'
    OFS.MSG.ID.ALE = ""
    OPTIONS = ""
    CALL OFS.POST.MESSAGE(OFS.ALE.STR,OFS.MSG.ID.ALE,OFS.ALE.SRC,OPTIONS)
  END
  RETURN
END
