* @ValidationCode : MjotMTE4ODI1MDI2NDpDcDEyNTI6MTcwNTA1MzIxMDQzNDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 15:23:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.CONS.LOAN.DET(Y.AA.ARR.ID)
*-----------------------------------------------------------------------------
*
* Developed By            : Vijayarani G
*
* Developed On            : 17-OCT-2013
*
* Development Reference   : 786834(FS-209-DE23)
*
* Development Description : A report Contains antecedents of each credit that belongs to the "Consumer Loans" indicating both the current amount
*                           and the past due  amount in the range of 31-90 days, and for more than 90 days past due,
*                           of the natural and legal persons indebted to the bank detailing by account credits.
*
* Attached To             : BATCH>BNK/REDO.B.CONS.LOAN.DET
*
* Attached As             : COB Routine
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* NA                     NA                             NA                    NA
*-----------------------------------------------------------------------------------------------------------------
* XXXX                   Vijayarani G                   07-Nov-2013           Code changes done for issue fixing
*                        Vijayarani G                   19-Nov-2013           Code changes done as per the clarifications
*                                                                             received on Balance calculation and AA.BILL.DETAILS
*                        Vijayarani G                   26-Nov-2013           Code changes done for issue fixing
* PACS00340818           Amaravathi Krithika B          26-May-2014           Getting Negative Value for the Date Comparision So changed that as
*                                                                             today date can be set as last day of previous month
* PACS00340818           Ashokkumar.V.P                 31/10/2014            New mapping changes - Rewritten the whole source.
* PACS00464363           Ashokkumar.V.P                 22/06/2015            Changed to avoid ageing problem and mapping changes.
* PACS00466618           Ashokkumar.V.P                 26/06/2015            Fixed the NAB account created on same date for old NAB loans.
* CN008212               Ashokkumar                     25/01/2018            Arrears will shown the actual irrespective of grace period.

*
* Date             Who                   Reference      Description
* 21.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, INSERT file folder name removed T24.BP, TAM.BP, LAPAP.BP, SM TO @SM, ++ TO += 1
* 05.09.2023       VICTORIA S            R22            Manual Conversion   - Add call routine prefix
*
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
* <region name= Inserts>
    $INSERT I_COMMON                            ;** R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
  *  $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.COMPANY
    $INSERT I_F.AA.PRODUCT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
   * $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_REDO.B.CONS.LOAN.DET.COMMON            ;** R22 Auto conversion -END
    $USING APAP.TAM
    $USING APAP.REDOCHNLS
   $USING AA.Framework
* </region>
*-----------------------------------------------------------------------------
*
    GOSUB PROCESS.INIT
    GOSUB CHK.AA.ARR.ID
RETURN
*
CHK.AA.ARR.ID:
*-------------
    ARR.ERR = ""; R.AA.ARRANGEMENT = ""; CNT.GT = 0
    CALL F.READ(FN.AA.ARR,Y.AA.ARR.ID,R.AA.ARRANGEMENT,F.AA.ARR,AA.ARRANGEMENT.ERR)
  *  Y.PROD.LINE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
  *  Y.PROD.GRP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
  *  PRODUCT.ID = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
  *  Y.ARR.STATUS = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
  *  CURRENCY = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
  *  EFFECTIVE.DATE = R.AA.ARRANGEMENT<AA.ARR.PROD.EFF.DATE>
  *  STAR.DATE.VAL = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
    
    Y.PROD.LINE = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProductLine >
    Y.PROD.GRP = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProductGroup>
    PRODUCT.ID = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProduct>
    Y.ARR.STATUS = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrArrStatus>
    CURRENCY = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency>
    EFFECTIVE.DATE = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProdEffDate>
    STAR.DATE.VAL = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrStartDate>

    IF (Y.ARR.STATUS EQ "CURRENT" OR Y.ARR.STATUS EQ "EXPIRED") ELSE
        RETURN
    END
    YLST.TODAY1 = YLST.TODAY
    IF STAR.DATE.VAL GT YLST.TODAY1 THEN
        RETURN
    END
    CONS.POS = ''; YPOST.RESTRICT = ''
    IF Y.PROD.GRP EQ 'LINEAS.DE.CREDITO' THEN
        FINDSTR "CONS" IN PRODUCT.ID SETTING CONS.POS THEN
        END ELSE
            RETURN
        END
    END

    Y.LOAN.STATUS = ''; YDE23.CLOSE.LN.FLG = 0
    GOSUB GET.LOAN.STATUS
    GOSUB GET.CLOSED.LOAN.CHK
    IF Y.LOAN.STATUS EQ "Write-off" THEN
        RETURN
    END
*    IF YDE23.CLOSE.LN.FLG NE 1 THEN
    GOSUB READ.ACCT.DETAILS
    GOSUB GET.COMMON.FIELDS
    GOSUB GET.ACC.ACCOUNT
    GOSUB ACC.NAB.PROCESS
    GOSUB RUN.PROCESS
*    END
RETURN

GET.COMMON.FIELDS:
*-----------------
    Y.LINKED.APPL    = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedAppl>
    Y.LINKED.APPL.ID = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedApplId>

    LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.LINKED.POS THEN
        Y.FINAL.MSG = ""; Y.FINAL.AMT = ""; Y.FINAL.DAYS = ""
        CHANGE @VM TO @FM IN Y.LINKED.APPL.ID
        Y.NROPRESTAMO  = Y.LINKED.APPL.ID<Y.LINKED.POS>
    END
    Y.ACCT.ID = Y.NROPRESTAMO
    C$SPARE(452) = Y.NROPRESTAMO
    GOSUB READ.ACCOUNT
    IF ERR.ACCOUNT THEN
        RETURN
    END
    YPOST.RESTRICT = R.ACCOUNT<AC.POSTING.RESTRICT>
    Y.ARRAY.VAL = ''; Y.PREV.ACCOUNT = ''
    YACCT.ALTGRP = R.ACCOUNT:"###":R.AA.ARRANGEMENT
*CALL REDO.RPT.ACCT.ALT.LOANS(YACCT.ALTGRP,Y.PREV.ACCOUNT)
    APAP.TAM.redoRptAcctAltLoans(YACCT.ALTGRP,Y.PREV.ACCOUNT);* R22 Manual conversion
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = Y.NROPRESTAMO
    END
    GOSUB GET.LN.CODE.5.1
    C$SPARE(452) = Y.PREV.ACCOUNT
RETURN

*---------------
GET.LN.CODE.5.1:
*---------------
**Verificar si tiene id alteno 4
    IF Y.NROPRESTAMO EQ Y.PREV.ACCOUNT THEN
        ID.ALTENO4 = '' ; Y.ALT.TYPE = ''
        Y.ALT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
        CHANGE @VM TO @FM IN Y.ALT.TYPE
        CHANGE @SM TO @FM IN Y.ALT.TYPE
        LOCATE "ALTERNO2" IN Y.ALT.TYPE<1> SETTING EYPO.POS THEN
            ID.ALTENO4  = R.ACCOUNT<AC.ALT.ACCT.ID,EYPO.POS,1>
            FINDSTR "VI" IN ID.ALTENO4 SETTING Ap, Vp THEN
                Y.PREV.ACCOUNT = ID.ALTENO4[3,LEN(ID.ALTENO4)]
            END
        END
    END
RETURN
GET.ACC.ACCOUNT:
****************
    IF Y.NROPRESTAMO EQ '' THEN
        RETURN
    END
    YPRINCIP.GRP = 0; YACCT.GRP = 0; YNAB.STATUS = ''; DAT.BALANCES = ''; ACCT.SET.STAT =''; ACCT.YINSTALL.CNT = ''
    YNAB.STATUS = R.ACCOUNT<AC.LOCAL.REF,L.OD.STATUS.POS>
    CALL F.READ(FN.EB.CONT.BAL,Y.NROPRESTAMO,R.EB.CONTRACT.BALANCES,F.EB.CONT.BAL,EB.CONTRACT.BALANCES.ERR)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.ASSET.TYPE = R.EB.CONTRACT.BALANCES<ECB.CURR.ASSET.TYPE>
        CTR.BAL.TYPE = 1
        CNT.BAL.TYPE = DCOUNT(Y.ASSET.TYPE,@VM)
        LOOP
            C$SPARE(456) = ''; C$SPARE(455) = ''
            C$SPARE(453) = ''; C$SPARE(454) = ''
        WHILE CTR.BAL.TYPE LE CNT.BAL.TYPE
            ACC.POS = '';  RET.FLG = 0; Y.ASSET.TYPE.TP = ''
            BAL.TYPE1 = Y.ASSET.TYPE<1,CTR.BAL.TYPE>
            Y.ASSET.TYPE.TP = R.EB.CONTRACT.BALANCES<ECB.CURR.ASSET.TYPE,CTR.BAL.TYPE>
            LEN.TYPE = LEN(BAL.TYPE1)
            REQ.LEN = BAL.TYPE1[((LEN.TYPE-AC.LEN)+1),AC.LEN]
            REQ.INT.LEN = BAL.TYPE1[((LEN.TYPE-PRIN.INT.LEN)+1),PRIN.INT.LEN]
            IF (REQ.LEN EQ 'ACCOUNT') OR (REQ.INT.LEN EQ 'PRINCIPALINT') THEN
                Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':BAL.TYPE1         ;*alter the consol key with current balance type in analysis
                Y.VARIABLE = ''; YACC.STAT = ''
                CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
                Y.LINE = Y.RPRTS:'.':Y.LINES
                CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
                GOSUB REG.ACCOUNT.NO
            END
            CTR.BAL.TYPE += 1
        REPEAT
    END
RETURN

REG.ACCOUNT.NO:
***************
    IF R.LINE THEN
        Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>         ;* get accounting account for the current balance type in analysis
        IF Y.REGULATORY.ACC.NO[1,1] EQ '8' THEN
            RETURN
        END
        IF Y.REGULATORY.ACC.NO[1,3] EQ '241' THEN
            RETURN
        END
        GOSUB PROCESS.INIT.1
        LOCATE Y.REGULATORY.ACC.NO IN SAVE.ACC.AC<1> SETTING ACC.POS THEN
            GOSUB CHECK.ASSET.TYPE
            RET.FLG = 1
        END ELSE
            GOSUB SAVE.UNIQUE.AC.ACC
        END
        IF REQ.LEN EQ 'ACCOUNT' THEN
            YACCT.GRP += DAT.BALANCES
        END
        IF REQ.LEN EQ 'PRINCIPALINT' THEN
            YPRINCIP.GRP += DAT.BALANCES
        END
        YACC.STAT = BAL.TYPE1[1,3]
        GOSUB BILL.VALUE.CHK
        RET.FLG = 0
    END
RETURN

PROCESS.INIT.1:
***************
    REQUEST.TYPE = ''
    START.DATE = STAR.DATE.VAL
    END.DATE = YLST.TODAY
    REQUEST.TYPE<4>='ECB'
    STRT.DATE.PRINT = ''
    ERROR.MESSAGE = ''
    BAL.DETAILS = ''
    DAT.BALANCES = 0
RETURN

SAVE.UNIQUE.AC.ACC:
*******************
    YGRP.ACCT.NO<-1> = Y.NROPRESTAMO
    SAVE.ACC.AC<-1> = Y.REGULATORY.ACC.NO
*    CALL AA.GET.PERIOD.BALANCES(Y.NROPRESTAMO, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
AA.Framework.GetPeriodBalances(Y.NROPRESTAMO, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE);* R22 UTILITY AUTO CONVERSION
    ASSET.TYPE.ARRAY<-1> = BAL.TYPE1
    DAT.BALANCES = BAL.DETAILS<4>
    BAL.AMT<-1> = DAT.BALANCES
RETURN

SAVE.EXISTING.AC.ACC:
*********************
*    CALL AA.GET.PERIOD.BALANCES(Y.NROPRESTAMO, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
AA.Framework.GetPeriodBalances(Y.NROPRESTAMO, BAL.TYPE1,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE);* R22 UTILITY AUTO CONVERSION
    DAT.BALANCES = BAL.DETAILS<4>
    NEW.AMT = DAT.BALANCES + BAL.AMT<ACC.POS>
    BAL.AMT<ACC.POS> = NEW.AMT
RETURN

CHECK.ASSET.TYPE:
*****************
    LOCATE BAL.TYPE1 IN ASSET.TYPE.ARRAY<1> SETTING ASSET.POS THEN
        ASSET.POS = ''
    END ELSE
        ASSET.TYPE.ARRAY<-1> = BAL.TYPE1
        GOSUB SAVE.EXISTING.AC.ACC
    END
RETURN

READ.ACCOUNT:
*************
    ERR.ACCOUNT = ''; R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
RETURN

RUN.PROCESS:
*----------*
    IF (YACCT.GRP EQ 0 OR YACCT.GRP EQ '') AND YDE23.CLOSE.LN.FLG EQ 1 THEN
        RETURN
    END
    CTR.LINE = 1
    CNT.LINE = DCOUNT(SAVE.ACC.AC,@FM)
    LOOP
    WHILE CTR.LINE LE CNT.LINE
        ACC.NO.LINE = SAVE.ACC.AC<CTR.LINE>
        BAL.AMT.LINE = BAL.AMT<CTR.LINE>
        NOT.PRINT.INT.ACC = ACC.NO.LINE[1,1]
        IF BAL.AMT.LINE EQ '0' OR BAL.AMT.LINE EQ '' THEN
            CTR.LINE += 1
            CONTINUE
        END
        IF NOT.PRINT.INT.ACC NE '8' THEN
            AC.ACCOUNT.PRINT = ACC.NO.LINE
            AC.BAL.PRINT = ABS(BAL.AMT.LINE)
            C$SPARE(453) = SAVE.ACC.AC<CTR.LINE>
            YDAY = 0; YDAY = Y.ARR.INST.NUM<CTR.LINE>
            IF SET.STAT.NAB AND (YINSTALL.CNT.NAB GE YDAY) THEN
                C$SPARE(455) = SET.STAT.NAB
                C$SPARE(456) = YINSTALL.CNT.NAB
            END ELSE
                C$SPARE(455) = Y.ARR.AGE.DAYS<CTR.LINE>
                C$SPARE(456) = Y.ARR.INST.NUM<CTR.LINE>
            END
            IF ACCT.SET.STAT THEN
                C$SPARE(455) = ACCT.SET.STAT
                C$SPARE(456) = ACCT.YINSTALL.CNT
            END
            C$SPARE(454) = AC.BAL.PRINT
            GOSUB MAP.RCL.VALUES
        END
        CTR.LINE += 1
    REPEAT
RETURN

ACC.NAB.PROCESS:
****************
    R.REDO.CONCAT.ACC.NAB = ''; NAB.ERR = ''; YACC.NABBAL = ''; YNAB.STATUS = ''
    YCR.DTE = ''; YCR.AMT = 0; YACC.NABB = 0; SUSPEND.VAL = ''; SUSPEND.STAT = ''; SUSPEND.DTE = ''
    SET.STAT.NAB = ''; YINSTALL.CNT.NAB = ''
    SUSPEND.VAL = R.AA.ACCT.DET<AA.AD.SUSPENDED>
    SUSPEND.STAT = R.AA.ACCT.DET<AA.AD.SUSP.STATUS,1>
    SUSPEND.DTE = R.AA.ACCT.DET<AA.AD.SUSP.DATE,1>
    IF SUSPEND.STAT EQ 'SUSPEND' AND SUSPEND.DTE GT YLST.TODAY THEN
        RETURN
    END
    CALL F.READ(FN.REDO.CONCAT.ACC.NAB,Y.NROPRESTAMO,R.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB,NAB.ERR)
    IF NOT(R.REDO.CONCAT.ACC.NAB) THEN
        RETURN
    END
    YACCT.ID = ''
    YACCT.ID = R.REDO.CONCAT.ACC.NAB
    YCRF.TYPE = "OFFDB"; REQUEST.TYPE<4> = "ECB"
    START.DATE = YLST.TODAY; END.DATE = YLST.TODAY; BAL.DETAILS = 0; ERROR.MESSAGE = ''
*    CALL AA.GET.PERIOD.BALANCES(YACCT.ID, YCRF.TYPE,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE)
AA.Framework.GetPeriodBalances(YACCT.ID, YCRF.TYPE,REQUEST.TYPE, START.DATE, END.DATE, '',BAL.DETAILS, ERROR.MESSAGE);* R22 UTILITY AUTO CONVERSION
    YCR.AMT = BAL.DETAILS<4>
    YACC.NABBAL = YCR.AMT
    Y.REGULATORY.ACC.NO = ''; R.EB.CONTRACT.BALANCES = ''; Y.IN.CONSOL.KEY = ''
    CALL F.READ(FN.EB.CONT.BAL,R.REDO.CONCAT.ACC.NAB,R.EB.CONTRACT.BALANCES,F.EB.CONT.BAL,EB.CONTRACT.BALANCES.ERR)
    IF R.EB.CONTRACT.BALANCES THEN
        Y.CONSOL.KEY = R.EB.CONTRACT.BALANCES<ECB.CONSOL.KEY>
        Y.CONSOL.PART = FIELD(Y.CONSOL.KEY,'.',1,16)
        Y.IN.CONSOL.KEY = Y.CONSOL.PART:'.':YCRF.TYPE
        Y.VARIABLE = ''; Y.RPRTS = ''; Y.LINES = ''
        CALL RE.CALCUL.REP.AL.LINE(Y.IN.CONSOL.KEY,Y.RPRTS,Y.LINES,Y.VARIABLE)
        Y.LINE = Y.RPRTS:'.':Y.LINES
        CALL F.READ(FN.RE.STAT.REP.LINE,Y.LINE,R.LINE,F.RE.STAT.REP.LINE,REP.ERR)
        Y.REGULATORY.ACC.NO = R.LINE<RE.SRL.DESC,1>
        YGRP.ACCT.NO<-1> = R.REDO.CONCAT.ACC.NAB
        SAVE.ACC.AC<-1> = Y.REGULATORY.ACC.NO
        BAL.AMT<-1> = YACC.NABBAL
        YACC.STAT = 'NAB'
        Y.ARR.YACC.STAT = ''
        GOSUB BILL.VALUE.CHK
        SET.STAT.NAB = SET.STAT
        YINSTALL.CNT.NAB = YCNT.GT
    END
RETURN

BILL.VALUE.CHK:
***************
    YAGING.STAT = ''; YSET.STAT = ''; Y.BIL.DATE = ''; FM.AGS = ''; SM.AGS = ''
    VM.AGS = ''; SET.STAT = 0; YINSTALL.CNT = 0; YBILL.STAT = ''; Y.SET.STAT = ''
    YCURR.ASS.VAL = ''; YFM.POSN = ''; Y.FM.POSN = ''
    LOCATE YACC.STAT IN Y.ARR.YACC.STAT<1> SETTING YFM.POSN THEN
        LOCATE Y.ASSET.TYPE.TP IN Y.ASSET.TYPE.ARR<1> SETTING Y.FM.POSN THEN
            RETURN
        END
    END

*    IF YACC.STAT EQ 'DUE' THEN
*        YTEM.SET.STAT = 0; YTEM.INST.NUM = 0
*        YTEM.SET.STAT = Y.ARR.AGE.DAYS<ACC.POS>
*        YTEM.INST.NUM = Y.ARR.INST.NUM<ACC.POS>
*        Y.ARR.AGE.DAYS<ACC.POS> = YTEM.SET.STAT
*        Y.ARR.INST.NUM<ACC.POS> = YTEM.INST.NUM
*        RETURN
*    END
    YSET.STAT = R.AA.ACCT.DET<AA.AD.SET.STATUS>
    YAGING.STAT = R.AA.ACCT.DET<AA.AD.AGING.STATUS>
    YBILL.STAT = R.AA.ACCT.DET<AA.AD.BILL.STATUS>

    IF YACC.STAT EQ 'DUE' THEN
        FINDSTR YACC.STAT IN YBILL.STAT<1> SETTING FM.AGU,SM.AGU,VM.AGU THEN
            Y.SET.STAT = R.AA.ACCT.DET<AA.AD.SET.STATUS,SM.AGU,VM.AGU>
            Y.BILL.TYPE = R.AA.ACCT.DET<AA.AD.BILL.TYPE,SM.AGU,VM.AGU>
            IF Y.SET.STAT EQ 'UNPAID' AND Y.BILL.TYPE EQ 'PAYMENT' THEN
                Y.BIL.DATE = R.AA.ACCT.DET<AA.AD.BILL.DATE,SM.AGU,VM.AGU>
            END
        END
    END
    FINDSTR YACC.STAT IN YAGING.STAT<1> SETTING FM.AGU,SM.AGU,VM.AGU THEN
        Y.SET.STAT = R.AA.ACCT.DET<AA.AD.SET.STATUS,SM.AGU,VM.AGU>
        Y.BILL.TYPE = R.AA.ACCT.DET<AA.AD.BILL.TYPE,SM.AGU,VM.AGU>
        IF Y.SET.STAT EQ 'UNPAID' AND Y.BILL.TYPE EQ 'PAYMENT' THEN
            Y.BIL.DATE = R.AA.ACCT.DET<AA.AD.BILL.DATE,SM.AGU,VM.AGU>
            GOSUB LOOP.INSTAL.DET
        END
    END

    IF (Y.BIL.DATE LT Y.TODAY) AND (LEN(Y.BIL.DATE) EQ 8 AND LEN(Y.TODAY) EQ 8) THEN
        YDAYS = 'C'
        CALL CDD('',Y.BIL.DATE,YLST.TODAY,YDAYS)
        SET.STAT = YDAYS + 1
    END
    IF YACC.STAT EQ 'DUE' AND SET.STAT GE 1 THEN
        YINSTALL.CNT += 1             ;** R22 Auto conversion - ++ TO += 1
    END

    IF RET.FLG EQ 1 THEN
        YTEM.SET.STAT = ''
        YTEM.SET.STAT = Y.ARR.AGE.DAYS<ACC.POS>
        IF SET.STAT GT YTEM.SET.STAT THEN
            Y.ARR.AGE.DAYS<ACC.POS> = SET.STAT
        END
        Y.ARR.INST.NUM<ACC.POS> += YINSTALL.CNT
        IF Y.ARR.INST.NUM<ACC.POS> GE YCNT.GT THEN
            YCNT.GT = Y.ARR.INST.NUM<ACC.POS>
        END
    END ELSE
        Y.ARR.AGE.DAYS<-1> = SET.STAT
        Y.ARR.INST.NUM<-1> = YINSTALL.CNT
    END
    Y.ARR.YACC.STAT<-1> = YACC.STAT
    Y.ASSET.TYPE.ARR<-1> = Y.ASSET.TYPE.TP
    IF YINSTALL.CNT GE YCNT.GT THEN
        YCNT.GT = YINSTALL.CNT
    END
    IF REQ.LEN EQ 'ACCOUNT' AND YACC.STAT EQ 'CUR' THEN
        ACCT.SET.STAT = SET.STAT
        ACCT.YINSTALL.CNT = YINSTALL.CNT
    END
RETURN

LOOP.INSTAL.DET:
****************
    YAGING.STAT.CNT = ''; YPROCESS.CNT = 0; YGP.AGING.STAT = ''; YGP.SET.STAT = ''
    YAGING.STAT.CNT = DCOUNT(YAGING.STAT,@VM)
    LOOP
    UNTIL YPROCESS.CNT EQ YAGING.STAT.CNT
        YPROCESS.CNT += 1                     ;** R22 Auto conversion - ++ TO += 1
        YGP.AGING.STAT = R.AA.ACCT.DET<AA.AD.AGING.STATUS,YPROCESS.CNT,1>
        YGP.SET.STAT = R.AA.ACCT.DET<AA.AD.SET.STATUS,YPROCESS.CNT,1>
        IF YACC.STAT EQ YGP.AGING.STAT AND YGP.SET.STAT EQ 'UNPAID' THEN
            YINSTALL.CNT += 1                  ;** R22 Auto conversion - ++ TO += 1
        END
    REPEAT
RETURN

PROCESS.INIT:
*************
    STRT.DATE.PRINT = ''
    AC.BAL.PRINT = ''
    AC.ACCOUNT.PRINT = ''
    AC.INTEREST.PRINT = ''
    LINK.POS = ''
    STRT.DATE = ''
    LEN.TERM = ''
    D.PART = ''
    TERM.PRINT = ''
    ASSET.TYPE.ARRAY = ''
    SAVE.ACC.AC = ''
    BAL.AMT = ''
    R.EB.CONTRACT.BALANCES = ''
    EB.CONTRACT.BALANCES.ERR = ''
    AC.LEN = 7      ;* This is length of word 'ACCOUNT'
    PRIN.INT.LEN = 12         ;* This is length of word 'PRINCIPALINT'
RETURN

READ.ACCT.DETAILS:
******************
    R.AA.ACCT.DET = ''; AA.ACCT.DET.ERR = ''
    CALL F.READ(FN.AA.ACCT.DET,Y.AA.ARR.ID,R.AA.ACCT.DET,F.AA.ACCT.DET,AA.ACCT.DET.ERR)
RETURN

MAP.RCL.VALUES:
*------------------------------------------------
* Pass arguments to RCL and get the return message
*-------------------------------------------------
    R.RETURN.MSG = ""
    RCL.ID  = Y.RCL.ID
    MAP.FMT = "MAP"
    APP     = FN.AA.ARR
    R.APP   = R.AA.ARRANGEMENT
*CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,RCL.ID,APP,Y.AA.ARR.ID,R.APP,R.RETURN.MSG,ERR.MSG)
    APAP.LAPAP.redoConduitLinearTranslation(MAP.FMT,RCL.ID,APP,Y.AA.ARR.ID,R.APP,R.RETURN.MSG,ERR.MSG) ;*R22 MANUAL CONVERSION
    IF R.RETURN.MSG THEN
        WRK.FILE.ID = Y.AA.ARR.ID:'.':CTR.LINE
        CALL F.WRITE(FN.DR.REG.DE23.WORKFILE,WRK.FILE.ID,R.RETURN.MSG)
    END
RETURN

GET.LOAN.STATUS:
*--------------*
    ArrangementID = Y.AA.ARR.ID
    idPropertyClass = 'OVERDUE'
    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''; effectiveDate = ''
*    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 UTILITY AUTO CONVERSION
    R.AA.OVERDUE = RAISE(returnConditions)
    Y.LOAN.STATUS = R.AA.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>
RETURN

GET.CLOSED.LOAN.CHK:
********************
    ERR.AA.ACTIVITY.HISTORY = ''; R.AA.ACTIVITY.HISTORY = ''; YACT.IS.STAT = ''; YACT.ID.ARR = ''
  *  CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ARR.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ERR.AA.ACTIVITY.HISTORY)
    R.AA.ACTIVITY.HISTORY=AA.Framework.ActivityHistory.Read(Y.AA.ARR.ID, ERR.AA.ACTIVITY.HISTORY)
    IF R.AA.ACTIVITY.HISTORY THEN
        YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhActivity>
        YACT.IS.STAT = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistory.AhActStatus>
        CHANGE @VM TO @FM IN YACT.ID.ARR
        CHANGE @SM TO @FM IN YACT.ID.ARR
        CHANGE @VM TO @FM IN YACT.IS.STAT
        CHANGE @SM TO @FM IN YACT.IS.STAT
    END
    ERR.REDO.APAP.PROPERTY.PARAM = ''; R.REDO.APAP.PROPERTY.PARAM = ''; YPAYOFF.ACT = ''; YPAY.CNT = 0
*    CALL F.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PROD.GRP,R.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM,ERR.REDO.APAP.PROPERTY.PARAM)
    CALL CACHE.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PROD.GRP,R.REDO.APAP.PROPERTY.PARAM,ERR.REDO.APAP.PROPERTY.PARAM);* R22 UTILITY AUTO CONVERSION
    IF R.REDO.APAP.PROPERTY.PARAM THEN
        YPAYOFF.ACT = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY>
        YPAY.CNT = DCOUNT(YPAYOFF.ACT,@VM)
    END

    YCNT = 1
    LOOP
    WHILE YCNT LE YPAY.CNT
        YPAYOFF.ACT.1 = ''
        YPAYOFF.ACT.1 = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY,YCNT>
        LOCATE YPAYOFF.ACT.1 IN YACT.ID.ARR<1> SETTING CHG.POSN.1 THEN
            YARR.STAT = YACT.IS.STAT<CHG.POSN.1>
            IF YARR.STAT EQ 'AUTH' OR YARR.STAT EQ 'DELETE-REV' THEN
                YDE23.CLOSE.LN.FLG = 1
                YCNT = YPAY.CNT + 1
                CONTINUE
            END
        END
        YCNT += 1                   ;** R22 Auto conversion - ++ TO += 1
    REPEAT
RETURN

RAISE.ERR.C.22:
*-----------------------------------------------------------------------------------------------------------------
*Handling Fatal error to halt the process
*-----------------------------------------------------------------------------------------------------------------
    MON.TP    = "23"
    Y.ERR.MSG = "Record not found"
    REC.CON   = "DE23-":Y.AA.ARR.ID:Y.ERR.MSG
    DESC      = "DE23-":Y.AA.ARR.ID:Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
*CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    APAP.REDOCHNLS.redoInterfaceRecAct(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC);* R22 Manual conversion
*
RETURN
*------------------------------------------------------------------Final End-------------------------------------------
END
