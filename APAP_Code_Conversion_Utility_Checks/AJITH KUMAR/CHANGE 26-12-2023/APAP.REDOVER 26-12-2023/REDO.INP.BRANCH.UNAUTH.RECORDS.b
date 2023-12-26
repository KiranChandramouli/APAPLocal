* @ValidationCode : MjotMTE4NjA1NzA4MTpDcDEyNTI6MTcwMzU3Mzc0OTYzMDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 12:25:49
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.BRANCH.UNAUTH.RECORDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This routine is the template (REDO.BRANCH.STATUS) validation routine to validate OPERATION.STATUS field
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : @ID
* CALLED BY :
*
* Revision History:
*------------------------------------------------------------------------------------------
*   Date               who                Reference                  Description
* 04-Jan-2010        Ganesh R                                        Initial Creation
*05-04-2023          Conversion Tool    R22 Auto Code conversion      FM TO @FM,VM TO @VM, ++ TO +=1, If Condition Added
*05-04-2023           Samaran T         Manual R22 Code Conversion        No Changes
* 21-12-2023      AJITHKUMAR      R22 MANUAL CODE CONVERSION
*------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID
    $INSERT I_F.DATA.CAPTURE
    $INSERT I_F.TSA.SERVICE
    $INSERT I_F.COMPANY
    $INSERT I_GTS.COMMON
    $INSERT I_F.REDO.BRANCH.STATUS
    $INSERT I_F.REDO.EXCEP.REC.PARAM
    $INSERT I_System
*

    GOSUB INIT
    GOSUB OPEN.FILES
    GOSUB PROCESS
*
RETURN
*
*---*
INIT:
*---*
*--------------------------*
*Initialising the Variables
*--------------------------*
*
    REC.ID  = 'COB'
    REC.ID1 = 'COB-ID.COMPANY'
    FLAG    = ''
*
    LREF.APP = 'TELLER.ID'
    LREF.FIELDS = 'L.TT.USER.TYPE'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    LOC.USER.TYPE.POS  = LREF.POS<1,1>


RETURN
*
*---------*
OPEN.FILES:
*---------*
    FN.TSA.SERVICE = 'F.TSA.SERVICE'
    F.TSA.SERVICE  = ''
    CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)

    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID  = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)
*
    FN.DATA.CAPT       = 'F.DATA.CAPTURE$NAU'
    F.DATA.CAPTURE$NAU = ''
    CALL OPF(FN.DATA.CAPT,F.DATA.CAPTURE$NAU)
*
    FN.REDO.EXCEP.REC.PARAM = 'F.REDO.EXCEP.REC.PARAM'
*

    FN.BRANCH.UNAUTH.LIST = 'F.BRANCH.UNAUTH.LIST'
    F.BRANCH.UNAUTH.LIST  = ''
    CALL OPF(FN.BRANCH.UNAUTH.LIST,F.BRANCH.UNAUTH.LIST)
    R.BRANCH.UNAUTH.LIST = ''
*
RETURN
*
*----------------
ID.COMPANY.CHECK:
*----------------

    CURRNT.COMP = System.getVariable("CURRENT.USER.BRANCH")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION
        CURRNT.COMP = ""  ;*R22 AUTO CODE CONVERSION
    END  ;*R22 AUTO CODE CONVERSION
    IF CURRNT.COMP EQ "CURRENT.USER.BRANCH" THEN
        LOCATE 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS THEN
            E = ''
        END
        RETURN
    END ELSE
        IF ID.NEW NE CURRNT.COMP THEN
            ETEXT  ='EB-OTHER.COMPANY.ID.NOT.ALLOWED'
            AF = BR.ST.OPERATION.STATUS
            CALL STORE.END.ERROR
        END
    END
RETURN
*--------*
PROCESS:
*--------*

    WFLAG = ''
    ID.VAR='SYSTEM';*R22 MANUAL CODE CONVERSION
    CALL CACHE.READ(FN.REDO.EXCEP.REC.PARAM,ID.VAR,R.EXCEP.REC,EXCEP.ERR)
    VAR.APPLICATION.NAME = R.EXCEP.REC<EXCEP.APPLICATION.NAME>
    VAR.DEPT.CODES       = R.EXCEP.REC<EXCEP.DEPT.CODES>
*
    VAR.OPR.STATUS = R.NEW(BR.ST.OPERATION.STATUS)
    IF VAR.OPR.STATUS EQ "CLOSED" THEN
        GOSUB PROCESS1
    END ELSE
        GOSUB PROCESS2
        R.NEW(BR.ST.FILE.UNAUTH) = ""
        R.NEW(BR.ST.NO.OF.REC)   = ""
    END

RETURN
*-----------------*
USER.VALIDATE.PARA:
*-----------------*

    NEW.STATUS = R.NEW(BR.ST.OPERATION.STATUS)
    OLD.STATUS = R.OLD(BR.ST.OPERATION.STATUS)

    Y.INPUTTER = R.NEW(BR.ST.INPUTTER)

    Y.INPUTTER.CNT=DCOUNT(Y.INPUTTER,@VM)
    Y.INP.FINAL=''
    Y.VAR3=1
    LOOP
    WHILE Y.VAR3 LE Y.INPUTTER.CNT
        Y.INP=Y.INPUTTER<1,Y.VAR3>
        Y.INP=FIELD(Y.INP,'_',2)
        IF (OLD.STATUS EQ 'CLOSED') AND (NEW.STATUS EQ 'OPEN') AND (OPERATOR EQ Y.INP) THEN
            AF=BR.ST.OPERATION.STATUS
            ETEXT="EB-USER.NO.OPEN"
            CALL STORE.END.ERROR
        END

        IF (OLD.STATUS EQ 'OPEN') AND (NEW.STATUS EQ 'CLOSED') AND (OPERATOR EQ Y.INP) THEN
            AF=BR.ST.OPERATION.STATUS
            ETEXT="EB-USER.NO.OPEN"
            CALL STORE.END.ERROR
        END
        Y.VAR3 += 1  ;*R22 AUTO CODE CONVERSION
    REPEAT

RETURN
*-------*
PROCESS1:
*-------*

    R.NEW(BR.ST.FILE.UNAUTH) = ""
    R.NEW(BR.ST.NO.OF.REC)   = ""
*
    IF PGM.VERSION EQ ',REDO.UPDATE' THEN
        GOSUB ID.COMPANY.CHECK
        GOSUB USER.VALIDATE.PARA
        GOSUB CHECK.BRANCH.RECORD
    END

    IF PGM.VERSION EQ ',REDO.COB.UPDATE' THEN
        GOSUB CHECK.ALL.BRANCH.RECORD
    END
*


    IF WFLAG EQ '1' AND V$FUNCTION EQ 'I' AND OFS$OPERATION EQ 'PROCESS' AND NOT(OFS.VAL.ONLY) THEN
        TEXT    = 'REDO.UNAUTH.RECORD'
        CURR.NO = ''
        CALL STORE.OVERRIDE(CURR.NO)
    END
*
    SEL.DATA.CAP  = "SELECT " : FN.DATA.CAPT
    SEL.DATA.CAP := " WITH CO.CODE EQ '" : ID.COMPANY : "'"
    SEL.DATA.CAP := " SAMPLE 1"
    CALL EB.READLIST(SEL.DATA.CAP,SEL.LIST,'',NO.OF.REC,DATA.ERR)

    IF SEL.LIST AND V$FUNCTION EQ 'I' AND OFS$OPERATION EQ 'PROCESS' AND NOT(OFS.VAL.ONLY) THEN
        TEXT    = "REDO.DC.UNBALNCED":@FM:SEL.LIST
        CURR.NO = DCOUNT(R.NEW(BR.ST.OVERRIDE),@VM)+ 1
        CALL STORE.OVERRIDE(CURR.NO)
    END

    SEL.TELL.ID  = "SELECT " : FN.TELLER.ID : " WITH STATUS EQ OPEN"
    SEL.TELL.ID := " WITH CO.CODE EQ " : ID.COMPANY
    CALL EB.READLIST(SEL.TELL.ID,VAR.SEL.LIST,'',NO.OF.RECS,VAR.ERR)
    IF VAR.SEL.LIST AND V$FUNCTION EQ 'I' AND OFS$OPERATION EQ 'PROCESS' AND NOT(OFS.VAL.ONLY) THEN
        LOOP
            REMOVE TEL.ID FROM VAR.SEL.LIST SETTING TEL.POS
        WHILE TEL.ID:TEL.POS

            CALL F.READ(FN.TELLER.ID,TEL.ID,R.TELLER.ID,F.TELLER.ID,TELLER.ID.ERR)
            Y.TEL.USER.TYPE = R.TELLER.ID<TT.TID.LOCAL.REF,LOC.USER.TYPE.POS>
            IF Y.TEL.USER.TYPE EQ 'TELLER' THEN
                TEXT    = "REDO.TILL.OPEN"
                CURR.NO = ''
                CALL STORE.OVERRIDE(CURR.NO)
                RETURN
            END
        REPEAT
    END
*
RETURN
*
* =======
PROCESS2:
* =======
*
    CALL F.READ(FN.TSA.SERVICE,REC.ID,R.TSA.SERVICE,F.TSA.SERVICE,REC.MSG)
    CALL F.READ(FN.TSA.SERVICE,REC.ID1,R.TSA.SERVICE1,F.TSA.SERVICE,REC.MSG1)
    VAR.COB.CTRL    = R.TSA.SERVICE<TS.TSM.SERVICE.CONTROL>
    VAR.COB.ID.CTRL = R.TSA.SERVICE1<TS.TSM.SERVICE.CONTROL>
    IF VAR.COB.CTRL EQ "START" OR VAR.COB.ID.CTRL EQ "START" THEN
        IF V$FUNCTION EQ 'I' AND OFS$OPERATION EQ 'PROCESS' AND NOT(OFS.VAL.ONLY) THEN

            TEXT    = "REDO.COB.RUNNING"
            CURR.NO = DCOUNT(R.NEW(BR.ST.OVERRIDE),@VM)+ 1
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
*
RETURN

*
* ==================
CHECK.BRANCH.RECORD:
* ==================
*

    Y.CNT.VAR.DEPT.CODES = DCOUNT(VAR.DEPT.CODES,@VM)
    Y.CNT.DEPT = 1
    LOOP
    WHILE Y.CNT.DEPT LE Y.CNT.VAR.DEPT.CODES
        Y.ID.DEPT = CURRNT.COMP:'-':VAR.DEPT.CODES<1,Y.CNT.DEPT>
        SEL.DEPT.CMD =  "SELECT ":FN.BRANCH.UNAUTH.LIST: " WITH @ID LIKE ":Y.ID.DEPT:"..."
        CALL EB.READLIST(SEL.DEPT.CMD,SEL.DEPT.LIST,'',NO.OF.RECS,DEPT.ERR)
        IF SEL.DEPT.LIST THEN
            WFLAG = '1'
            RETURN
        END
        Y.CNT.DEPT += 1  ;*R22 AUTO CODE CONVERSION
    REPEAT
RETURN
* ======================
CHECK.ALL.BRANCH.RECORD:
* ======================

    Y.CURRENT.BRANCH.ID = System.getVariable("CURRENT.BRANCH.ID")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN  ;*R22 AUTO CODE CONVERSION
        Y.CURRENT.BRANCH.ID = ""    ;*R22 AUTO CODE CONVERSION
    END   ;*R22 AUTO CODE CONVERSION
    SEL.DEPT.CMD =  "SELECT ":FN.BRANCH.UNAUTH.LIST: " WITH @ID LIKE ":Y.CURRENT.BRANCH.ID:"..."
    CALL EB.READLIST(SEL.DEPT.CMD,SEL.DEPT.LIST,'',NO.OF.RECS,DEPT.ERR)

    IF SEL.DEPT.LIST THEN
        WFLAG = '1'
        RETURN
    END

RETURN
*
END
