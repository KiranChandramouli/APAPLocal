*-----------------------------------------------------------------------------
* <Rating>-155</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VCR.PART.DISB.FILL
*
* =============================================================================

* Developed for : APAP
* Developed by : TAM
* Date         : 14-11-2012
* Attached to : VERSION.CONTROL - FUNDS.TRANSFER,DSB
*
*=======================================================================
*
* Works ONLY in DISBURSEMENT PROCESS. Control point is existence of
* USER VARIABLE CURRENT.Template.ID. If it exists, then this is a
* DISBURSEMENT process, otherwise routine ends
*
*=======================================================================
* Modification History
*
* 19-Mar-2013  Sivakumar.K   PACS00255148  If selection made by account number get the arrangement ID from account
*
*=======================================================================
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_System
*
$INSERT I_F.ACCOUNT
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.TELLER
$INSERT I_F.AA.ARRANGEMENT
*
$INSERT I_F.REDO.FC.FORM.DISB
$INSERT I_F.REDO.CREATE.ARRANGEMENT
$INSERT I_F.REDO.AA.PART.DISBURSE.FC
$INSERT I_F.AA.OVERDUE

  GOSUB INITIALISE
  GOSUB OPEN.FILES

  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
*
  RETURN
*
*--------
PROCESS:
*--------
*
  LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*


  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1
      WRCA.AA.ID = R.RCA<REDO.PDIS.ID.ARRANGEMENT>
      GOSUB GET.ARR.INFO

    CASE LOOP.CNT EQ 2
      GOSUB GET.NEXT.DISB
      WVCR.RDC.ID = WRCA.AA.ID : '.001'
      R.NEW(LRF.NUMBER)<1,WPOS.LI> = WVCR.RDC.ID

    CASE LOOP.CNT EQ 3
      GOSUB FILL.INSTRUCTION.DATA

    END CASE

*       Message Error
    GOSUB CONTROL.MSG.ERROR

*       Increase
    LOOP.CNT += 1
*
  REPEAT
*
  GOSUB GET.AMOUNT.DISBURSED


  WRCA.TOTAL.TO.DISBURSE          = R.RCA<REDO.PDIS.DIS.AMT.TOT>
  R.NEW(FT.DEBIT.ACCT.NO)         = WAA.ACCOUNT
  R.NEW(FT.DEBIT.THEIR.REF)       = WRCA.AA.ID
  R.NEW(FT.DEBIT.CURRENCY)        = WACC.CCY

  R.NEW(FT.CREDIT.AMOUNT)          = R.RCA<REDO.PDIS.DIS.AMT,WACT.DISB>

  R.NEW(LRF.NUMBER)<1,WPOS.FT.AV> = APPLICATION:PGM.VERSION
*WW = R.RCA<REDO.FC.EFFECT.DATE>
* Fields add to versions

  R.NEW(FT.DEBIT.VALUE.DATE)      = R.RCA<REDO.PDIS.VALUE.DATE>
  R.NEW(FT.CREDIT.VALUE.DATE)     = R.RCA<REDO.PDIS.VALUE.DATE>

*
  CALL System.setVariable("CURRENT.WRCA.ACT.DISB",WACT.DISB)
  CALL System.setVariable("CURRENT.WRCA.TOTAL.TO.DISBURSE",WRCA.TOTAL.TO.DISBURSE)
  CALL System.setVariable("CURRENT.WRCA.ALREADY.DISB",WRCA.ALREADY.DISB)

  GOSUB DEFAULT.COND
*
  RETURN
*

DEFAULT.COND:

  Y.CRD.AC = R.NEW(FT.CREDIT.ACCT.NO)
  CALL REDO.CONVERT.ACCOUNT(Y.CRD.AC,Y.ARR.ID,ARR.ID,ERR.TEXT)

  CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARR,F.AA.ARRANGEMENT,AA.AER)
  IF R.AA.ARR THEN
    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
    CHANGE SM TO VM IN LOAN.STATUS
    CHANGE SM TO FM IN LOAN.COND
    Y.CNT = DCOUNT(LOAN.COND,FM)
    Y.START.VAL =1
    LOOP
    WHILE Y.START.VAL LE Y.CNT
      LOAN.COND1<-1> = LOAN.COND<Y.START.VAL>
      LOAN.COND1 = CHANGE(LOAN.COND1,FM,SM)
      R.NEW(FT.LOCAL.REF)<1,FT.LOAN.COND.POS> = LOAN.COND1
      Y.START.VAL++
    REPEAT
    R.NEW(FT.LOCAL.REF)<1,FT.LOAN.STATUS.POS> = LOAN.STATUS

    CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARR.ERR)
    Y.CURR = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>

    R.NEW(FT.CREDIT.CURRENCY) = Y.CURR
  END

  IF PGM.VERSION EQ ',REDO.MULTI.AA.PART.ACRP.DISB' THEN
    CALL REDO.V.VAL.PDIS.AMT(Y.CRD.AC)
  END

  RETURN
* ===========
GET.ARR.INFO:
* ===========
*

*PACS00255148_S
  CALL F.READ(FN.ACCOUNT,WRCA.AA.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  IF R.ACCOUNT THEN
    WRCA.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
  END
*PACS00255148_E

  CALL F.READ(FN.AA.ARRANGEMENT,WRCA.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT, ERR.AA)
  IF ERR.AA THEN
    Y.ERR.MSG = "EB-&.RECORD.NOT.FOUND.&":FM:FN.AA.ARRANGEMENT:VM:WRCA.AA.ID
    PROCESS.GOAHEAD = ""
  END ELSE
    GOSUB GET.AA.ACCOUNT
  END
*
  RETURN
*
* =============
GET.AA.ACCOUNT:
* =============
*
  WAA.ACCOUNT    = ""
  WAA.LINKED.APP = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
*
  LOCATE "ACCOUNT" IN WAA.LINKED.APP<1> SETTING ACCT.POS THEN
    WAA.ACCOUNT = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,ACCT.POS>
    GOSUB GET.ACCOUNT.CURRENCY
  END ELSE
    Y.ERR.MSG       = "EB-ACCOUNT.NOT.DEFINED.FOR.AA.&":FM:WRCA.AA.ID
    PROCESS.GOAHEAD = ""
  END
*
  RETURN
*
* ===================
GET.ACCOUNT.CURRENCY:
* ===================
*
  WACC.CCY = LCCY   ;* DEFAULT VALUE LOCAL CURRENCY
*
  CALL F.READ(FN.ACCOUNT,WAA.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
  IF R.ACCOUNT THEN
    WACC.CCY = R.ACCOUNT<AC.CURRENCY>
  END
*
  RETURN
*
* ============
GET.NEXT.DISB:
* ============
*
  WNEXT.VERSION = ""
*
  IF WFOUND.NV THEN
    WNEXT.INST = R.RCA<REDO.PDIS.DIS.TYPE,WNEXT.DISB>
    CALL F.READ(FN.REDO.FC.FORM.DISB,WNEXT.INST,RW.REDO.FC.FORM.DISB,F.REDO.FC.FORM.DISB,ERR.RFD)
    IF ERR.RFD THEN
      PROCESS.GOAHEAD = ""
      Y.ERR.MSG = "EB-DISB.INST.CODE.&.MISSING.RCA.&":FM:WNEXT.INST:VM:WVCR.TEMPLATE.ID
    END ELSE
      WNEXT.VERSION  = RW.REDO.FC.FORM.DISB<FC.PR.NAME.PART.VRN>
*
      R.NEW(LRF.NUMBER)<1,WPOS.FT.NV> = WNEXT.VERSION
      IF WNEXT.VERSION EQ "" THEN
        WNEXT.VERSION = "NO-REGISTRA"
      END
      CALL System.setVariable("CURRENT.WRCA.NEXT.VERSION",WNEXT.VERSION)
    END
  END
*
  RETURN
*
* ====================
FILL.INSTRUCTION.DATA:
* ====================
*
  WRCA.DATA   = WFIELD.VERSION
  WRCA.INFO   = RAISE(R.RCA<REDO.PDIS.VAL.DET.INS,WACT.DISB>)
  WLOC.FIELDS = ""
  WLOC.DATA   = ""
*
  LOOP
    REMOVE WFIELD FROM WRCA.DATA SETTING FIELD.POS
  WHILE WFIELD:FIELD.POS DO
    WFIELD.NO = WFIELD
    REMOVE WFIELD.DATA FROM WRCA.INFO SETTING FIELD.POS
    Y.APL = APPLICATION
    CALL EB.FIND.FIELD.NO(Y.APL, WFIELD.NO)
    IF NOT(WFIELD.NO) THEN
      WLOC.FIELDS<-1> = WFIELD
      WLOC.DATA<-1>   = WFIELD.DATA
    END ELSE
      R.NEW(WFIELD.NO) = WFIELD.DATA
    END
  REPEAT
*
  IF WLOC.FIELDS THEN
    GOSUB FILL.LOCAL.FIELDS.DATA
  END
*
  RETURN
*
* =====================
FILL.LOCAL.FIELDS.DATA:
* =====================
*
*
  YPOS = ''
  WCAMPO    = CHANGE(WLOC.FIELDS,FM,VM)
  Y.APL = APPLICATION
  CALL MULTI.GET.LOC.REF(Y.APL,WCAMPO,YPOS)
  LOOP
    REMOVE WLFIELD FROM WLOC.FIELDS SETTING LF.POS
  WHILE WLFIELD:LF.POS DO
    REMOVE WLFIELD.DATA FROM WLOC.DATA SETTING LFD.POS
    REMOVE LFN.POS FROM YPOS SETTING LF.POS
    R.NEW(LRF.NUMBER)<1,LFN.POS> = WLFIELD.DATA
  REPEAT
*
  RETURN
*
* ===================
GET.AMOUNT.DISBURSED:
* ===================
*
  WRCA.ALREADY.DISB = 0
  WRCA.CODTXN       = R.RCA<REDO.PDIS.DIS.CODTXN>
  WRCA.DIS.AMT      = R.RCA<REDO.PDIS.DIS.AMT>
  WRCA.DIS.TYPE     = R.RCA<REDO.PDIS.DIS.TYPE>
*
  LOOP
    REMOVE WDIS.TYPE FROM WRCA.DIS.TYPE SETTING TXN.POS
  WHILE WDIS.TYPE:TXN.POS DO
    REMOVE WTXN.ID FROM WRCA.CODTXN SETTING TXN.POS
    REMOVE WDIS.AMT FROM WRCA.DIS.AMT SETTING TXN.POS
    IF WTXN.ID NE "" THEN
      WRCA.ALREADY.DISB += WDIS.AMT
    END
  REPEAT
*
  RETURN
*
* =======================
VALIDATE.RCA.DISB.STATUS:
* =======================
*
  WFOUND        = ""
  WFOUND.NV     = ""
  WNEXT.DISB    = ""
  WRCA.CODTXN   = R.RCA<REDO.PDIS.DIS.CODTXN>
  WRCA.DIS.TYPE = R.RCA<REDO.PDIS.DIS.TYPE>
  WDISB.POS     = 0
*
  LOOP
    REMOVE WDIS.TYPE FROM WRCA.DIS.TYPE SETTING TXN.POS
  WHILE WDIS.TYPE:TXN.POS AND (NOT(WFOUND) OR NOT(WFOUND.NV)) DO
    REMOVE WTXN.ID FROM WRCA.CODTXN SETTING TXN.POS
    WDISB.POS += 1
    IF WTXN.ID EQ "" AND WFOUND AND NOT(WFOUND.NV) THEN
      WFOUND.NV  = 1
      WNEXT.DISB = WDISB.POS
    END
    IF WTXN.ID EQ "" AND NOT(WFOUND) THEN
      CALL F.READ(FN.REDO.FC.FORM.DISB,WDIS.TYPE,R.REDO.FC.FORM.DISB,F.REDO.FC.FORM.DISB,ERR.RFD)
      IF ERR.RFD THEN
        PROCESS.GOAHEAD = ""
        Y.ERR.MSG = "EB-DISB.INST.CODE.&.MISSING.RCA.&":FM:WDIS.TYPE:VM:WVCR.TEMPLATE.ID
      END ELSE
        WFIELD.VERSION = R.REDO.FC.FORM.DISB<FC.PR.FIELD.VRN>
        WFOUND         = 1
        WACT.DISB      = WDISB.POS
      END
    END
  REPEAT
*
  IF NOT(WFOUND) THEN
    Y.ERR.MSG = "EB-NOT.PENDING.DISBURSEMENTS.FOR.&":FM:WVCR.TEMPLATE.ID
    PROCESS.GOAHEAD = ""
  END
*
  RETURN
*
* ================
CONTROL.MSG.ERROR:
* ================
*
  IF Y.ERR.MSG THEN
    E       = Y.ERR.MSG
    V$ERROR = 1
    CALL ERR
    CALL System.setVariable("CURRENT.Template.ID","ERROR")
    CALL System.setVariable("CURRENT.WRCA.NEXT.VERSION","ERROR")
    CALL System.setVariable("CURRENT.WRCA.ACT.DISB","ERROR")
    CALL System.setVariable("CURRENT.WRCA.TOTAL.TO.DISBURSE","ERROR")
    CALL System.setVariable("CURRENT.WRCA.ALREADY.DISB","ERROR")
  END
*
  RETURN
*
* =========
INITIALISE:
* =========
*
  PROCESS.GOAHEAD = 1
  LRF.NUMBER      = 0
  Y.ERR.MSG       = ""
*
  FN.ACCOUNT = "F.ACCOUNT"
  F.ACCOUNT  = ""
  CALL OPF(FN.ACCOUNT,F.ACCOUNT )
*
  FN.REDO.FC.FORM.DISB = "F.REDO.FC.FORM.DISB"
  F.REDO.FC.FORM.DISB  = ""
  CALL OPF(FN.REDO.FC.FORM.DISB,F.REDO.FC.FORM.DISB)
*
  FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
  F.REDO.CREATE.ARRANGEMENT  = ""
  CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)

  FN.REDO.AA.PART.DISBURSE.FC = 'F.REDO.AA.PART.DISBURSE.FC'
  F.REDO.AA.PART.DISBURSE.FC = ''
  CALL OPF(FN.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC)
*
  FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
  F.AA.ARRANGEMENT  = ""
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
*
  W.CRE.VAL.DATE = ""
  W.DEB.VAL.DATE = ""

  BEGIN CASE
  CASE APPLICATION EQ "TELLER"
    LRF.NUMBER = TT.TE.LOCAL.REF
  CASE APPLICATION EQ "FUNDS.TRANSFER"
    LRF.NUMBER = FT.LOCAL.REF
  END CASE
*
  WAPP.LST  = APPLICATION:FM:'AA.PRD.DES.OVERDUE'
  WCAMPO    = "L.INITIAL.ID"
  WCAMPO<2> = "L.TRAN.AUTH"
  WCAMPO<3> = "L.ACTUAL.VERSIO"
  WCAMPO<4> = "L.NEXT.VERSION"
  WCAMPO<5> = "L.LOAN.STATUS.1"
  WCAMPO<6> = "L.LOAN.COND"
  WCAMPO    = CHANGE(WCAMPO,FM,VM)
  WFLD.LST  = WCAMPO

  WCAMPO = "L.LOAN.STATUS.1"
  WCAMPO<2> = "L.LOAN.COND"
  WCAMPO = CHANGE(WCAMPO,FM,VM)
  WFLD.LST<-1> = WCAMPO
  YPOS = ''
  CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)
  WPOS.LI    = YPOS<1,1>
  WPOS.FT.TA = YPOS<1,2>
  WPOS.FT.AV = YPOS<1,3>
  WPOS.FT.NV = YPOS<1,4>
  FT.LOAN.STATUS.POS = YPOS<1,5>
  FT.LOAN.COND.POS = YPOS<1,6>

  OD.LOAN.STATUS.POS = YPOS<2,1>
  OD.LOAN.COND.POS = YPOS<2,2>
*
  CALL System.setVariable("CURRENT.WRCA.NEXT.VERSION","NO")
  CALL System.setVariable("CURRENT.WRCA.ACT.DISB","")
  CALL System.setVariable("CURRENT.WRCA.TOTAL.TO.DISBURSE","0")
  CALL System.setVariable("CURRENT.WRCA.ALREADY.DISB","0")
*
  RETURN
*
* =========
OPEN.FILES:
* =========
*
*
  RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE

    CASE LOOP.CNT EQ 1
      E = ""
      WVCR.TEMPLATE.ID = System.getVariable("CURRENT.Template.ID")
      IF WVCR.TEMPLATE.ID EQ "" OR WVCR.TEMPLATE.ID EQ "CURRENT.Template.ID" THEN
        E = CHANGE(E,VM,"-")
        PROCESS.GOAHEAD = ""
      END

    CASE LOOP.CNT EQ 2
      CALL F.READ(FN.REDO.AA.PART.DISBURSE.FC,WVCR.TEMPLATE.ID,R.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC,ERR.MSJ)
      IF ERR.MSJ THEN
        Y.ERR.MSG = "EB-RECORD.&.DOES.NOT.EXIST.IN.TABLE.&":FM:FN.REDO.CREATE.ARRANGEMENT:VM:WVCR.TEMPLATE.ID
        PROCESS.GOAHEAD = ""
      END ELSE
        R.RCA = R.REDO.AA.PART.DISBURSE.FC
        GOSUB VALIDATE.RCA.DISB.STATUS
      END

    END CASE
*       Message Error
    GOSUB CONTROL.MSG.ERROR

*       Increase
    LOOP.CNT += 1
*
  REPEAT
*
  RETURN
*
END
