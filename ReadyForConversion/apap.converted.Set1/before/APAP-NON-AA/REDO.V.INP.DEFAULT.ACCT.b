*-------------------------------------------------------------------------
* <Rating>-107</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE  REDO.V.INP.DEFAULT.ACCT
*-------------------------------------------------------------------------
*DESCRIPTION:
*~~~~~~~~~~~~
* This routine is attached as INPUT routine in TELLER "CK. MANAGER" VERSIONS
*
*
*-------------------------------------------------------------------------
*DEVELOPMENT DETAILS:
*~~~~~~~~~~~~~~~~~~~~
*
*   Date            who                 Reference         Description
*   ~~~~            ~~~                 ~~~~~~~~~         ~~~~~~~~~~~
*   23-MAR-2012     NAVA V.             PACS00172913      Gets NEXT CK. ID
*                                                         properly, and handling Recurrence for
*                                                         different sessions, based REDO.VCR.CHEQUE.NUMBER.                                                        on REDO.VCR.CHEQUE.NUMBER
*   18-03-2013      Vignesh Kumaar M R  PACS00255121      Error not updating Ordering Customer/Bank
*-------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_System
*
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER
$INSERT I_F.USER
$INSERT I_F.ACCOUNT
*
$INSERT I_F.REDO.MANAGER.CHQ.PARAM
$INSERT I_F.REDO.H.BANK.DRAFTS
*
  GOSUB INIT
  GOSUB CHECK.PRELIM.CONDITIONS
*
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
*
  RETURN
*---------------------------------------------------------------------------
*
* ======
PROCESS:
* ======
*
  CALL F.WRITE(FN.REDO.H.BANK.DRAFTS,Y.NEXT.AVAILABLE.ID,R.REDO.H.BANK.DRAFTS)
*
  RETURN
*
* ==============================
GET.NEXT.AVAILABLE.CHECK.NUMBER:
* ==============================
*
  W.ACCOUNT1 = ""
  W.ACCOUNT2 = ""
*
  BEGIN CASE
  CASE APPLICATION EQ 'TELLER'
*
    IF R.NEW(TT.TE.DR.CR.MARKER) EQ "DEBIT" THEN
      W.ACCOUNT1 = R.NEW(TT.TE.ACCOUNT.2)
      W.ACCOUNT2 = R.NEW(TT.TE.ACCOUNT.1)
    END ELSE
      W.ACCOUNT1 = R.NEW(TT.TE.ACCOUNT.1)
      W.ACCOUNT2 = R.NEW(TT.TE.ACCOUNT.2)
    END
*
    Y.ACCOUNT = W.ACCOUNT1
    Y.CUST    = ""
    IF Y.ACCOUNT THEN
      CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
      IF R.ACCOUNT THEN
        Y.CUST = R.ACCOUNT<AC.CUSTOMER>
      END
    END
*
    IF Y.CUST OR NOT(Y.ACCOUNT) THEN
      Y.ACCOUNT = W.ACCOUNT2
    END
*
    WAPP.CHEQUE.NUMBER.FIELD = TT.TE.AMOUNT.LOCAL.1
    GOSUB GET.CHECK.NUMBER
*
    R.NEW(TT.TE.CHEQUE.NUMBER)   = W.NEXT.AVAILABLE.ID
    R.NEW(TT.TE.THEIR.REFERENCE) = W.NEXT.AVAILABLE.ID
    R.NEW(TT.TE.NARRATIVE.1)     = Y.NEXT.AVAILABLE.ID
    GOSUB UPDATE.STOCK
*
  CASE APPLICATION EQ 'FUNDS.TRANSFER'
    Y.ACCOUNT = R.NEW(FT.CREDIT.ACCT.NO)
    WAPP.CHEQUE.NUMBER.FIELD = FT.CREDIT.ACCT.NO
    GOSUB GET.CHECK.NUMBER
    R.NEW(FT.CREDIT.THEIR.REF)        = W.NEXT.AVAILABLE.ID
    R.NEW(FT.LOCAL.REF)<1,TR.REF.POS> = Y.NEXT.AVAILABLE.ID
    GOSUB UPDATE.STOCK
  END CASE
*
  RETURN
*
* ===============
GET.CHECK.NUMBER:
* ===============
*
* To get the next available from the received list of @ID'S
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Modification Starts>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>*
*
  Y.BRANCH.LIST = R.USER<EB.USE.LOCAL.REF,Y.BRANCH.POS>
  Y.DEPT.LIST   = R.USER<EB.USE.LOCAL.REF,Y.DEPT.POS>
  LOCATE ID.COMPANY IN Y.BRANCH.LIST<1,1,1> SETTING POS.BR THEN
    Y.CODE.VAL = Y.DEPT.LIST<1,1,POS.BR>
  END ELSE
    Y.CODE.VAL = ''
  END
*
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Modification Ends>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
  SEL.CMD  = 'SSELECT ' : FN.REDO.H.BANK.DRAFTS
  SEL.CMD := ' WITH ITEM.CODE EQ ' : WITEM.CODE
  SEL.CMD := ' AND BRANCH.DEPT EQ ' : ID.COMPANY
*
*>>>>>>>>>>>>>>>>>>>>>>>Department is added in Selection- Starts->>>>>>>>>>>>>>>>>>>>>>
*
  IF Y.CODE.VAL THEN
    SEL.CMD := ' AND CODE EQ ' : Y.CODE.VAL
  END
*
*>>>>>>>>>>>>>>>>>>>Changes done sort DATE.UPDATED is added- Ends ->>>>>>>>>>>>>>>>>>>>
  SEL.CMD := ' AND STATUS EQ AVAILABLE BY SERIAL.NO BY DATE.UPDATED'
*
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
  IF NOT(SEL.LIST) THEN
    AF              = WAPP.CHEQUE.NUMBER.FIELD
    ETEXT           = "TT-MANAG.CHEQUE.NOT.AVAILABLE.FOR.&.ACCOUNT":FM:Y.NOSTRO.AC
    PROCESS.GOAHEAD = ""
    CALL STORE.END.ERROR
  END ELSE
    GOSUB CONTINUE.GETTING.NUMBER
  END
*
  RETURN
*
* ======================
CONTINUE.GETTING.NUMBER:
* ======================
*
  CHEQUE.FOUND = ""
*
  LOOP
    REMOVE X.NEXT.AVAILABLE.ID FROM SEL.LIST SETTING POS
  WHILE X.NEXT.AVAILABLE.ID:POS AND NOT(CHEQUE.FOUND)
*
    Y.NEXT.AVAILABLE.ID =           X.NEXT.AVAILABLE.ID
    CALL F.READU(FN.REDO.H.BANK.DRAFTS,Y.NEXT.AVAILABLE.ID,R.REDO.H.BANK.DRAFTS,F.REDO.H.BANK.DRAFTS,ERR,"I")
    IF ERR NE 'RECORD LOCKED' AND R.REDO.H.BANK.DRAFTS NE "" AND R.REDO.H.BANK.DRAFTS<REDO.BANK.STATUS> EQ "AVAILABLE" THEN
      R.REDO.H.BANK.DRAFTS<REDO.BANK.STATUS> = "ISSUED"
      W.NEXT.AVAILABLE.ID = R.REDO.H.BANK.DRAFTS<REDO.BANK.SERIAL.NO>
      CHEQUE.FOUND = 1        ;* exit the loop else go for next id
    END
*
  REPEAT
*
  IF NOT(CHEQUE.FOUND) THEN
    AF              = WAPP.CHEQUE.NUMBER.FIELD
    ETEXT           = "TT-MANAG.CHEQUE.NOT.AVAILABLE.FOR.&.ACCOUNT":FM:Y.NOSTRO.AC
    PROCESS.GOAHEAD = ""
    CALL STORE.END.ERROR
  END
*
  RETURN
*
*===================
UPDATE.STOCK:
*===================
*
  CALL REDO.UPD.VAL.ITEM.VALUE
*
  RETURN
*
* ===================
DELETE.FUNCTION.CASE:
* ===================
*
  IF APPLICATION EQ "TELLER" THEN
    Y.NEXT.AVAILABLE.ID = R.NEW(TT.TE.NARRATIVE.1)
  END ELSE
    Y.NEXT.AVAILABLE.ID = R.NEW(FT.LOCAL.REF)<1,TR.REF.POS>
  END
*
  CALL F.READU(FN.REDO.H.BANK.DRAFTS,Y.NEXT.AVAILABLE.ID,R.REDO.H.BANK.DRAFTS,F.REDO.H.BANK.DRAFTS,ERR,"I")
  R.REDO.H.BANK.DRAFTS<REDO.BANK.STATUS> = "AVAILABLE"
*
  RETURN
*
*----------------------------------------------------------------------------
*
* ===
INIT:
* ===
*
  FN.REDO.MANAGER.CHQ.PARAM = 'F.REDO.MANAGER.CHQ.PARAM'
  F.REDO.MANAGER.CHQ.PARAM  = ''
  CALL OPF(FN.REDO.MANAGER.CHQ.PARAM,F.REDO.MANAGER.CHQ.PARAM)
*
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT  = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
*HD1052466-s

  FN.REDO.H.BANK.DRAFTS = 'F.REDO.H.BANK.DRAFTS'
  F.REDO.H.BANK.DRAFTS  = ''
  CALL OPF(FN.REDO.H.BANK.DRAFTS,F.REDO.H.BANK.DRAFTS)

*HD1052466-E
*
  PROCESS.GOAHEAD      = 1
  Y.PARAM.ID = 'SYSTEM'
*
  W.NEXT.AVAILABLE.ID = ""
  Y.ITEM.CODE         = ""
  Y.NOSTRO.AC         = ""
*
  WAPPL = "FUNDS.TRANSFER" : FM : "USER" : FM : "TELLER"
  WCAMPO    = "TRANSACTION.REF" : FM : 'L.US.IDC.BR' : VM : 'L.US.IDC.CODE' : FM : "L.FT.NOSTRO.ACC"
  YPOS = ''
  CALL MULTI.GET.LOC.REF(WAPPL,WCAMPO,YPOS)
  TR.REF.POS   = YPOS<1,1>
  Y.BRANCH.POS = YPOS<2,1>
  Y.DEPT.POS   = YPOS<2,2>
  Y.NOSACC.POS = YPOS<3,1>

* Fix for PACS00255121 [Error not updating Ordering Customer/Bank]

  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN

    Y.NOSTRO.AC = R.NEW(FT.CREDIT.ACCT.NO)
  END

  IF APPLICATION EQ 'TELLER' THEN

    Y.NOSTRO.AC  = R.NEW(TT.TE.LOCAL.REF)<1,Y.NOSACC.POS>
  END

* End of Fix

  RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  LOOP.CNT  = 1
  MAX.LOOPS = 3
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1
*
      IF OFS.VAL.ONLY OR V$FUNCTION EQ "R" THEN
        PROCESS.GOAHEAD = ""
        GOSUB UPDATE.STOCK
      END
*
    CASE LOOP.CNT EQ 2
*
      CALL CACHE.READ(FN.REDO.MANAGER.CHQ.PARAM,Y.PARAM.ID,R.REDO.MANAGER.CHQ.PARAM,PARAM.ERR)
      Y.ACCOUNT.ALL = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ACCOUNT>
      Y.ITEM.CODE   = R.REDO.MANAGER.CHQ.PARAM<MAN.CHQ.PRM.ITEM.CODE>
      LOCATE Y.NOSTRO.AC IN Y.ACCOUNT.ALL<1,1> SETTING ACCT.POS THEN
        WITEM.CODE = Y.ITEM.CODE<1,ACCT.POS>
      END
*
    CASE LOOP.CNT EQ 3
*
      IF V$FUNCTION NE "D" THEN
        GOSUB GET.NEXT.AVAILABLE.CHECK.NUMBER
      END ELSE
        GOSUB DELETE.FUNCTION.CASE
        GOSUB UPDATE.STOCK
      END
*
    END CASE
    LOOP.CNT +=1
*
  REPEAT
*
  RETURN
*
END
