*-----------------------------------------------------------------------------
* <Rating>-161</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.TEMP.DISB.FILL
*
* =============================================================================
*
* Developed for : APAP
* Developed by : Joaquin Costa
* Date         : 2011/Jul/08
* Attached to : VERSION.CONTROL - REDO.FT.TT.TRANSACTION,DSB
*
*=======================================================================
*
* Works ONLY in DISBURSEMENT PROCESS. Control point is existence of
* USER VARIABLE CURRENT.Template.ID. If it exists, then this is a
* DISBURSEMENT process, otherwise routine ends
*
* PACS00146445  - Marimuthu S   12-JUN-2012
* PACS00240923 - Marimuthu S    2-2-2013
*=======================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
*
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION
    $INSERT I_F.TELLER
    $INSERT I_F.AA.ARRANGEMENT
*
    $INSERT I_F.REDO.FC.TEMP.DISB
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.AA.OVERDUE
*
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.HOLIDAY
    $INSERT I_F.REDO.EOM.BRANCH
    $INSERT I_F.DEPT.ACCT.OFFICER

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
            WRCA.AA.ID = R.RCA<REDO.FC.ID.ARRANGEMENT>
            GOSUB GET.ARR.INFO

        CASE LOOP.CNT EQ 2
            GOSUB GET.NEXT.DISB
            WVCR.RDC.ID = WRCA.AA.ID : '.001'
            R.NEW(FT.TN.L.INITIAL.ID) = WVCR.RDC.ID

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

    WRCA.TOTAL.TO.DISBURSE          = R.RCA<REDO.FC.DIS.AMT.TOT>
    R.NEW(FT.TN.DEBIT.ACCT.NO)         = WAA.ACCOUNT
    R.NEW(FT.TN.DEBIT.THEIR.REF)       = WRCA.AA.ID
    R.NEW(FT.TN.DEBIT.CURRENCY)        = WACC.CCY
    Y.VERSION.NAME = APPLICATION:PGM.VERSION
    IF Y.VERSION.NAME EQ 'REDO.FT.TT.TRANSACTION,REDO.AA.CHEQUE' THEN
        GOSUB UPDATE.COMPANY.ID
    END
    R.NEW(FT.TN.CREDIT.AMOUNT)          = R.RCA<REDO.FC.DIS.AMT,WACT.DISB>

    R.NEW(FT.TN.L.ACTUAL.VERSIO) = APPLICATION:PGM.VERSION
*   WW = R.RCA<REDO.FC.EFFECT.DATE>
*   Fields add to versions
    R.NEW(FT.TN.DEBIT.VALUE.DATE)      = R.RCA<REDO.FC.EFFECT.DATE>
    R.NEW(FT.TN.CREDIT.VALUE.DATE)     = R.RCA<REDO.FC.EFFECT.DATE>
*
    CALL System.setVariable("CURRENT.WRCA.ACT.DISB",WACT.DISB)
    CALL System.setVariable("CURRENT.WRCA.TOTAL.TO.DISBURSE",WRCA.TOTAL.TO.DISBURSE)
    CALL System.setVariable("CURRENT.WRCA.ALREADY.DISB",WRCA.ALREADY.DISB)

    GOSUB DEFAULT.COND
*
    RETURN

DEFAULT.COND:

    Y.CRD.AC = R.NEW(FT.TN.CREDIT.ACCT.NO)
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
            R.NEW(FT.TN.L.LOAN.COND) = LOAN.COND1
            Y.START.VAL++
        REPEAT
        R.NEW(FT.TN.L.LOAN.STATUS.1) = LOAN.STATUS

        CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARR.ERR)
        Y.CURR = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>

        R.NEW(FT.TN.CREDIT.CURRENCY) = Y.CURR
    END

    IF PGM.VERSION EQ ',REDO.MULTI.AA.ACRP.DISB' THEN
        CALL REDO.V.VAL.PDIS.AMT(Y.CRD.AC)
    END

    RETURN
*
* ===========
GET.ARR.INFO:
* ===========
*
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
    WACC.CCY = LCCY ;* DEFAULT VALUE LOCAL CURRENCY
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
        WNEXT.INST = R.RCA<REDO.FC.DIS.TYPE,WNEXT.DISB>
        WNEXT.ID = R.RCA<REDO.FC.DIS.CODTXN,WNEXT.DISB>
        CALL F.READ(FN.REDO.FC.TEMP.DISB,WNEXT.INST,RW.REDO.FC.TEMP.DISB,F.REDO.FC.TEMP.DISB,ERR.RFD)
        IF ERR.RFD THEN
            PROCESS.GOAHEAD = ""
            Y.ERR.MSG = "EB-DISB.INST.CODE.&.MISSING.RCA.&":FM:WNEXT.INST:VM:WVCR.TEMPLATE.ID
        END ELSE
            WNEXT.VERSION  = RW.REDO.FC.TEMP.DISB<FC.TD.NAME.VRN>
*
            R.NEW(FT.TN.L.NEXT.VERSION) = WNEXT.VERSION
            IF WNEXT.VERSION EQ "" THEN
                WNEXT.VERSION = "NO-REGISTRA"
            END
            CALL System.setVariable("CURRENT.WRCA.NEXT.VERSION",WNEXT.VERSION)
            CALL System.setVariable("CURRENT.WRCA.FT.ID",WNEXT.ID)
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
    WRCA.INFO   = RAISE(R.RCA<REDO.FC.VAL.DET.INS,WACT.DISB>)
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
            IF PGM.VERSION EQ ',REDO.MULTI.AA.ACCRAP.DISB' THEN
                GOSUB GET.LOAN.ST
            END
        END
    REPEAT
*
    IF WLOC.FIELDS THEN
        GOSUB FILL.LOCAL.FIELDS.DATA
    END
*
    RETURN
*

GET.LOAN.ST:

    ACC.ID =  WFIELD.DATA
    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    R.Condition = ''
    ERR.MSG = ''
    EFF.DATE = ''
    R.AC = ''
    CALL F.READ(FN.ACCOUNT,ACC.ID,R.AC,F.ACCOUNT,AC.ERR)
    IF R.AC THEN
        Y.CR.CC = R.AC<AC.CURRENCY>
    END
    CALL REDO.CONVERT.ACCOUNT(ACC.ID,Y.ARR.ID,ARR.ID,ERR.TEXT)
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)
    LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    LOAN.COND = R.Condition<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>

    Y.CR.CUR = R.NEW(FT.TN.CREDIT.CURRENCY)
    IF Y.CR.CUR EQ '' THEN
        R.NEW(FT.TN.CREDIT.CURRENCY) = Y.CR.CC
    END
    R.NEW(FT.TN.L.LOAN.STATUS.1) = LOAN.COND
    R.NEW(FT.TN.L.LOAN.STATUS.1) = LOAN.STATUS

    RETURN
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
    WRCA.CODTXN       = R.RCA<REDO.FC.DIS.CODTXN>
    WRCA.DIS.AMT      = R.RCA<REDO.FC.DIS.AMT>
    WRCA.DIS.TYPE     = R.RCA<REDO.FC.DIS.TYPE>
*

    LOOP
        REMOVE WDIS.TYPE FROM WRCA.DIS.TYPE SETTING TXN.POS
    WHILE WDIS.TYPE:TXN.POS DO
        REMOVE WTXN.ID FROM WRCA.CODTXN SETTING TXN.POS
        REMOVE WDIS.AMT FROM WRCA.DIS.AMT SETTING TXN.POS
        IF WTXN.ID NE "" THEN
            CALL F.READ(FN.FT,WTXN.ID,R.FT,F.FT,FT.ERR)
            IF R.FT THEN
                WRCA.ALREADY.DISB += WDIS.AMT
            END ELSE
                CALL EB.READ.HISTORY.REC(F.FT.HIS,WTXN.ID,R.FT,FT.ER)
                IF R.FT THEN
                    WRCA.ALREADY.DISB += WDIS.AMT
                END
            END
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
    WRCA.CODTXN   = R.RCA<REDO.FC.DIS.CODTXN>
    WRCA.DIS.TYPE = R.RCA<REDO.FC.DIS.TYPE>
    WDISB.POS     = 0

    WRCA.CODTXN.D = WRCA.CODTXN ; WRCA.DIS.TYPE.D = WRCA.DIS.TYPE
    Y.DD = DCOUNT(WRCA.DIS.TYPE.D,VM)
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
            CALL F.READ(FN.REDO.FC.TEMP.DISB,WDIS.TYPE,R.REDO.FC.TEMP.DISB,F.REDO.FC.TEMP.DISB,ERR.RFD)
            IF ERR.RFD THEN
                PROCESS.GOAHEAD = ""
                Y.ERR.MSG = "EB-DISB.INST.CODE.&.MISSING.RCA.&":FM:WDIS.TYPE:VM:WVCR.TEMPLATE.ID
            END ELSE
                WFIELD.VERSION = R.REDO.FC.TEMP.DISB<FC.TD.FIELD.VRN>
                WFOUND         = 1
                WACT.DISB      = WDISB.POS
            END
        END
        CALL System.setVariable("CURRENT.R.VAL","ERROR")
    REPEAT
*

*     IF NOT(WFOUND) THEN
*         Y.ERR.MSG = "EB-NOT.PENDING.DISBURSEMENTS.FOR.&":FM:WVCR.TEMPLATE.ID
*         PROCESS.GOAHEAD = ""
*     END

    R.VAL = ''
    CALL F.READ(FN.REDO.FC.PR.DIS.COB,WVCR.TEMPLATE.ID,R.VAL,F.REDO.FC.PR.DIS.COB,PR.ERR)

    IF R.RCA<REDO.FC.STATUS.DISB> EQ 'U' OR R.VAL<1,1> EQ 'COB' THEN
        IF NOT(R.VAL) THEN
            R.VAL = 'COB'
        END
        WDISB.POS = 0
        GOSUB PROCES.DISB.U
*        R.NEW(FT.PROCESSING.DATE) = TODAY
    END

*
    RETURN
*

PROCES.DISB.U:

    LOOP
        REMOVE W.DIS.TYPE FROM WRCA.DIS.TYPE.D SETTING TX.POS
    WHILE W.DIS.TYPE:TX.POS AND (NOT(WFOUND) OR NOT(WFOUND.NV)) DO
        REMOVE WTXN.ID FROM WRCA.CODTXN.D SETTING TX.POS
        WDISB.POS += 1

        IF R.VAL<1,WDISB.POS+1> EQ "" AND WFOUND AND NOT(WFOUND.NV) THEN
            WFOUND.NV  = 1
            WNEXT.DISB = WDISB.POS
        END
        IF R.VAL<1,WDISB.POS+1> EQ "" AND NOT(WFOUND) THEN
            CALL F.READ(FN.REDO.FC.TEMP.DISB,W.DIS.TYPE,R.REDO.FC.TEMP.DISB,F.REDO.FC.TEMP.DISB,ERR.RFD)
            R.VAL<1,WDISB.POS+1> = WTXN.ID
            CALL System.setVariable("CURRENT.R.VAL",R.VAL)
            IF ERR.RFD THEN
                PROCESS.GOAHEAD = ""
                Y.ERR.MSG = "EB-DISB.INST.CODE.&.MISSING.RCA.&":FM:WDIS.TYPE:VM:WVCR.TEMPLATE.ID
            END ELSE
                WFIELD.VERSION = R.REDO.FC.TEMP.DISB<FC.TD.FIELD.VRN>
                WFOUND         = 1
                WACT.DISB      = WDISB.POS
            END
        END
    REPEAT

    RETURN
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
    FN.REDO.FC.TEMP.DISB = "F.REDO.FC.TEMP.DISB"
    F.REDO.FC.TEMP.DISB  = ""
    CALL OPF(FN.REDO.FC.TEMP.DISB,F.REDO.FC.TEMP.DISB)
*
    FN.REDO.CREATE.ARRANGEMENT = "F.REDO.CREATE.ARRANGEMENT"
    F.REDO.CREATE.ARRANGEMENT  = ""
    CALL OPF(FN.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT)
*
    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT  = ""
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''
    CALL OPF(FN.FT.HIS,F.FT.HIS)

    FN.REDO.FC.PR.DIS.COB = 'F.REDO.FC.PR.DIS.COB'
    F.REDO.FC.PR.DIS.COB = ''
    CALL OPF(FN.REDO.FC.PR.DIS.COB,F.REDO.FC.PR.DIS.COB)

*
    W.CRE.VAL.DATE = ""
    W.DEB.VAL.DATE = ""
*
    WAPP.LST  = 'AA.PRD.DES.OVERDUE'
    WFLD.LST  = "L.LOAN.STATUS.1":VM:"L.LOAN.COND"
    YPOS = ''
    CALL MULTI.GET.LOC.REF(WAPP.LST,WFLD.LST,YPOS)

    OD.LOAN.STATUS.POS = YPOS<1,1>
    OD.LOAN.COND.POS = YPOS<1,2>

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
            IF E<1,1> EQ "EB-UNKNOWN.VARIABLE" THEN         ;*Tus Start
                WVCR.TEMPLATE.ID = ""
            END     ;*Tus End
            IF WVCR.TEMPLATE.ID EQ "" OR WVCR.TEMPLATE.ID EQ "CURRENT.Template.ID" THEN
                E = CHANGE(E,VM,"-")
                PROCESS.GOAHEAD = ""
            END

        CASE LOOP.CNT EQ 2
            CALL F.READ(FN.REDO.CREATE.ARRANGEMENT,WVCR.TEMPLATE.ID,R.REDO.CREATE.ARRANGEMENT,F.REDO.CREATE.ARRANGEMENT,ERR.MSJ)
            IF ERR.MSJ THEN
                Y.ERR.MSG = "EB-RECORD.&.DOES.NOT.EXIST.IN.TABLE.&":FM:FN.REDO.CREATE.ARRANGEMENT:VM:WVCR.TEMPLATE.ID
                PROCESS.GOAHEAD = ""
            END ELSE
                R.RCA = R.REDO.CREATE.ARRANGEMENT
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
UPDATE.COMPANY.ID:
*-----------------
    Y.DEBIT.ACCT.NO = ''

    FN.REDO.EOM.BRANCH = 'F.REDO.EOM.BRANCH'
    F.REDO.EOM.BRANCH = ''

    FN.DEPT.ACCT.OFFICER = 'F.DEPT.ACCT.OFFICER'
    F.DEPT.ACCT.OFFICER = ''

    FN.HOLIDAY = 'F.HOLIDAY'
    F.HOLIDAY = ''

    CALL OPF(FN.REDO.EOM.BRANCH,F.REDO.EOM.BRANCH)
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
    CALL OPF(FN.HOLIDAY, F.HOLIDAY)


    Y.DEBIT.ACCT.NO = WAA.ACCOUNT

    Y.VALUE.DATE  = TODAY

    CENTURY = FMT(Y.VALUE.DATE[1,2],"2'0'R")
    YY = FMT(Y.VALUE.DATE[3,2],"2'0'R")
    MM = FMT(Y.VALUE.DATE[5,2],"2'0'R")
    DD = FMT(Y.VALUE.DATE[7,2],"2'0'R")
    REQUESTED = Y.VALUE.DATE[9,5]

    IF NOT(R.NEW(FT.TN.L.FT.COMPANY)) AND Y.DEBIT.ACCT.NO THEN

        CALL REDO.CONVERT.ACCOUNT(Y.DEBIT.ACCT.NO,'',OUT.ID,ERR.TEXT)
        Y.ARR.ID = OUT.ID
        PROPERTY.CLASS = 'ACCOUNT'
        PROPERTY  = ''
        EFF.DATE  = ''
        ERR.MSG   = ''
        R.ACC.COND = ''
        R.Condition = ''
        R.ACCOUNT = ''
        CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.Condition,ERR.MSG)
        R.ACC.COND = R.Condition

        CALL F.READ(FN.ACCOUNT,Y.DEBIT.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        LREF.POS=''
        LREF.APP    = 'AA.PRD.DES.ACCOUNT'
        LREF.FIELDS = 'L.AA.AGNCY.CODE'
        CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
        POS.L.AA.AGN.CODE  = LREF.POS<1,1>
        AA.AGENCY.CODE     = R.ACC.COND<AA.AC.LOCAL.REF,POS.L.AA.AGN.CODE>
        R.DEPT.ACCT.OFFICER = ''
        CALL F.READ(FN.DEPT.ACCT.OFFICER,AA.AGENCY.CODE,R.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER,DEPT.ACCT.ERR)
        DEF.COMPANY = ''
        IF R.DEPT.ACCT.OFFICER THEN
            GOSUB CHECK.MON.LAST.DAY
            Y.REGION = AA.AGENCY.CODE[7,2]
            DEF.COMPANY = "DO00100":Y.REGION
            IF Y.LAST.W.DAY EQ Y.VALUE.DATE THEN
                GOSUB UPDATE.EOM.BRANCH
            END ELSE
                R.NEW(FT.TN.L.FT.COMPANY) = DEF.COMPANY
            END
        END
    END

    RETURN

CHECK.MON.LAST.DAY:
*------------------
    IF MM GE '12' THEN
        YY = YY + 1 ; MM = '01' ; DD = '01'
        Y.NEXT.DATE = CENTURY:YY:MM:DD
    END ELSE
        MM = MM + 1 ; DD = '01'
        MM = FMT(MM,"2'0'R")
        Y.NEXT.DATE = CENTURY:YY:MM:DD
    END

    CALL CDT('',Y.NEXT.DATE,'-1W')
    Y.LAST.W.DAY = Y.NEXT.DATE

    RETURN

UPDATE.EOM.BRANCH:
*-----------------

    R.REDO.EOM.BRANCH = ''; AA.AGENCY.CODE = ''
    CALL F.READ(FN.REDO.EOM.BRANCH,Y.REGION,R.REDO.EOM.BRANCH,F.REDO.EOM.BRANCH,REDO.EOM.ERR)
    Y.MONTH.LIST  = R.REDO.EOM.BRANCH<EM.BR.MONTH>
    Y.AGENT.LIST = R.REDO.EOM.BRANCH<EM.BR.AGENT.CODE>
    Y.CURR.MONTH = Y.VALUE.DATE[5,2]
    LOCATE Y.CURR.MONTH IN Y.MONTH.LIST<1,1> SETTING MON.POS THEN
        AA.AGENCY.CODE = Y.AGENT.LIST<1,MON.POS>
        Y.REGION = AA.AGENCY.CODE[4,2]
        DEF.COMPANY = "DO00100":Y.REGION
        R.NEW(FT.TN.L.FT.COMPANY) = DEF.COMPANY
    END ELSE
        R.NEW(FT.TN.L.FT.COMPANY) = DEF.COMPANY
    END

    RETURN
END
