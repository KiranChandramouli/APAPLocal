* @ValidationCode : MjoxODY0MzE4NDQ4OkNwMTI1MjoxNjgwNjAyNDgwODc4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Apr 2023 15:31:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
* Version 1   17/05/05     GLOBUS RELEASE 200508           Update Datee: 17/05/05
$PACKAGE APAP.TAM
SUBROUTINE RE.READ.CONSOLIDATE.COND(COND.ID, COND.REC, ERR.MSG)

**********************************************************************************
*
* This routine will fetch the details of the consolidate cond
* records after converting the field names to numbers.
*
* A cache memory is updated with the record details
* to avoid repeated read from disk
*
**********************************************************************************
*
* Incoming:
*    COND.ID - CONSOLIDATION.COND key
*
* Outgoing:
*    COND.REC - Record of the key passed.
*    ERR.MSG  - Error message if record not found.
*
** 04-04-2023 R22 Auto Conversion – FM TO @FM, VM to @VM, SM to @SM
** 04-04-2023 Skanda R22 Manual Conversion - No changes
**********************************************************************************
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_RE.INIT.COMMON
    $INSERT I_F.CONSOLIDATE.COND
    $INSERT I_F.STANDARD.SELECTION
    $INSERT I_F.LOCAL.REF.TABLE
    $INSERT I_DAS.CONSOLIDATE.COND
    $INSERT I_DAS.COMMON
*
    COM /CONSOL.RECS/COND.IDS,COND.RECS(200),COMPANY.IDS

    GOSUB INITIALISE

    IF ERR.MSG EQ "" THEN ;* R22 Auto conversion
        GOSUB GET.COND.RECORD
    END
*
RETURN
*--------------------------------------------------------------------------------
*
INITIALISE:
*---------
* Initailise variables




    IF NOT(COND.IDS) THEN
        GOSUB LOAD.COND.RECS
    END

    ERR.MSG = ""
    IF COMPANY.IDS EQ "" AND FIELD(COND.ID,".",2) THEN       ;* check to see if there are any company specific records ;* R22 Auto conversion
        COND.REC = ""
        ERR.MSG = "RECORD. NOT FOUND"
    END

RETURN

*--------------------------------------------------------------------------------
*
GET.COND.RECORD:
*--------------

    COND.REC = ""
    LOCATE COND.ID IN COND.IDS<1> SETTING COND.POS THEN
        COND.REC = COND.RECS(COND.POS)
    END

RETURN

**********************************************************************************
LOAD.COND.RECS:
***************


* Open files
*
    FN.LRT = 'F.LOCAL.REF.TABLE'
    F.LRT = ''
    CALL OPF(FN.LRT, F.LRT)
*
    FN.LT = 'F.LOCAL.TABLE'
    F.LT = ''
    CALL OPF(FN.LT, F.LT)

    COND.IDS = ""
    MAT COND.RECS = ""
    COMPANY.IDS = ""
    FN.CONSOLIDATE.COND = "F.CONSOLIDATE.COND"
    LIST     =   dasAllIds
    THE.ARGS = ''
    TABLE.SUFFIX = ''
    CALL DAS ('CONSOLIDATE.COND', LIST, THE.ARGS, TABLE.SUFFIX)
    COND.POS = 0
    LOOP
        REMOVE ID FROM LIST SETTING POS
    WHILE ID:POS
        GOSUB SETUP.READ
        GOSUB READ.COND.RECORD
        IF R.CONSOLIDATE.COND THEN
            COND.POS +=1
            R.CONSOLIDATE.COND<RE.CON.OVERRIDE> = ''        ;* Overrides may eat away the CACHE
            COND.IDS<COND.POS> = ID
            COND.RECS(COND.POS) = R.CONSOLIDATE.COND
        END
    REPEAT

RETURN

*--------------------------------------------------------------------------------------
SETUP.READ:
***********


    IF FIELD(ID,".",2)  THEN
        COMPANY.IDS = 1
    END

    YR.COND = ''
    F.CNT = '' ; LF.CNT = '' ; KEY.APP.CNT = ''

RETURN

*--------------------------------------------------------------------------------
READ.COND.RECORD:
*---------------
*
    CALL CACHE.READ(FN.CONSOLIDATE.COND, ID, R.CONSOLIDATE.COND, ERR.MSG) ;* R22 Auto conversion
*
    IF R.CONSOLIDATE.COND THEN          ;* Convert field names to numbers
        GOSUB SETUP.CONSOL.RECORD
    END
*
RETURN
*---------------------------------------------------------------------------------
SETUP.CONSOL.RECORD:
*-------------------

    FILE.COUNT = COUNT(R.CONSOLIDATE.COND<RE.CON.FILE.NAME>, @VM) + (R.CONSOLIDATE.COND<RE.CON.FILE.NAME> # "")
    LOOP F.CNT += 1 WHILE F.CNT <= FILE.COUNT
        Y.FILE.NAME = R.CONSOLIDATE.COND<RE.CON.FILE.NAME,F.CNT>
        Y.FIELD.NAME = R.CONSOLIDATE.COND<RE.CON.FIELD.NAME,F.CNT>
        IF Y.FILE.NAME NE "LOCAL" AND Y.FILE.NAME NE "NO LOOKUP" THEN ;* R22 Auto conversion
            GOSUB GET.AL.FIELD.NUMBER
            R.CONSOLIDATE.COND<RE.CON.FIELD.NAME,F.CNT> = Y.FIELD.NUMBER
        END
    REPEAT
*
    LOC.FILE.COUNT = COUNT(R.CONSOLIDATE.COND<RE.CON.LOCAL.FILE.NAME>, @VM) + (R.CONSOLIDATE.COND<RE.CON.LOCAL.FILE.NAME> # "")
    LOOP LF.CNT += 1 WHILE LF.CNT <= LOC.FILE.COUNT
        Y.FILE.NAME = R.CONSOLIDATE.COND<RE.CON.LOCAL.FILE.NAME, LF.CNT>
        Y.FIELD.NAME = R.CONSOLIDATE.COND<RE.CON.LOCAL.FIELD.NAM, LF.CNT>
        IF Y.FILE.NAME NE "AL" THEN ;* R22 Auto conversion
            GOSUB GET.AL.FIELD.NUMBER
        END ELSE
            GOSUB GET.PL.FIELD.NUMBER
        END
        R.CONSOLIDATE.COND<RE.CON.LOCAL.FIELD.NAM,LF.CNT> = Y.FIELD.NUMBER
*
        Y.FILE.NAME = R.CONSOLIDATE.COND<RE.CON.CON.ON.FILE, LF.CNT>
        Y.FIELD.NAME = R.CONSOLIDATE.COND<RE.CON.CON.ON.FIELD, LF.CNT>
        IF Y.FILE.NAME THEN
            IF Y.FILE.NAME NE "AL" THEN ;* R22 Auto conversion
                GOSUB GET.AL.FIELD.NUMBER
            END ELSE
                GOSUB GET.PL.FIELD.NUMBER
            END
            R.CONSOLIDATE.COND<RE.CON.CON.ON.FIELD,LF.CNT> = Y.FIELD.NUMBER
        END
    REPEAT
*
    KEY.APPS = COUNT(R.CONSOLIDATE.COND<RE.CON.KEY.APPLICATION>, @VM) + (R.CONSOLIDATE.COND<RE.CON.KEY.APPLICATION> # "")
    LOOP KEY.APP.CNT += 1 WHILE KEY.APP.CNT <= KEY.APPS
        Y.FILE.NAME = R.CONSOLIDATE.COND<RE.CON.KEY.LOCAL.FILE, KEY.APP.CNT>
        Y.FIELD.NAME = R.CONSOLIDATE.COND<RE.CON.KEY.LOCAL.FIELD, KEY.APP.CNT>
        GOSUB GET.AL.FIELD.NUMBER
        R.CONSOLIDATE.COND<RE.CON.KEY.LOCAL.FIELD, KEY.APP.CNT> = Y.FIELD.NUMBER
    REPEAT
*
RETURN

*-------------------------------------------------------------------------------------
GET.AL.FIELD.NUMBER:
*------------------
    Y.FIELD.NAME.1 = '';  Y.FIELD.NUMBER.SAVE = '' ; Y.FIELD.NUMBER = ''
    IF INDEX(Y.FIELD.NAME, "/", 1) THEN
        Y.FIELD.NAME.1 = FIELD(Y.FIELD.NAME,"/",2)
        Y.FIELD.NAME = FIELD(Y.FIELD.NAME,"/",1)
    END
SECOND.LOOP:
    YAF = '' ; YAV = '' ;YAS = ''; DATA.TYPE = ''; ERR.MSG = ''
    R.STANDARD.SELECTION = ''
    CALL GET.STANDARD.SELECTION.DETS(Y.FILE.NAME, R.STANDARD.SELECTION)
    CALL FIELD.NAMES.TO.NUMBERS(Y.FIELD.NAME,R.STANDARD.SELECTION,Y.FIELD.NUMBER,YAF,YAV,YAS,DATA.TYPE,ERR.MSG)
*
    IF ERR.MSG THEN
        READ.ERR = ''
        CALL CACHE.READ(FN.LRT, Y.FILE.NAME, R.LRT, READ.ERR) ;* R22 Auto conversion
        IF NOT(READ.ERR) THEN
            GOSUB GET.FIELD.NUMBER
        END
        IF NOT(Y.FIELD.NUMBER) THEN
            E = 'FIELD NAME ':Y.FIELD.NAME:' NOT FOUND IN FILE ':Y.FILE.NAME:' OR CHANGED'
            GOSUB FATAL.ERROR
        END
    END

    IF Y.FIELD.NAME.1 THEN
        Y.FIELD.NUMBER.SAVE = Y.FIELD.NUMBER
        Y.FIELD.NAME = Y.FIELD.NAME.1
        Y.FIELD.NAME.1 = '' ; Y.FIELD.NUMBER = ''
        GOTO SECOND.LOOP
    END
    IF Y.FIELD.NUMBER.SAVE THEN
        Y.FIELD.NUMBER = Y.FIELD.NUMBER.SAVE:"/":Y.FIELD.NUMBER
    END
RETURN

*
*-------------------------------------------------------------------------------------
GET.FIELD.NUMBER:
*----------------

    LF.COUNT = COUNT(R.LRT<EB.LRT.LOCAL.TABLE.NO>, @VM) + (R.LRT<EB.LRT.LOCAL.TABLE.NO> <> "")
    FOR Y.LF = 1 TO LF.COUNT
        LT.KEY = R.LRT<EB.LRT.LOCAL.TABLE.NO,Y.LF>
        CALL CACHE.READ(FN.LT, LT.KEY, R.LT, READ.ERR) ;* R22 Auto conversion
        IF R.LT<2,1> EQ Y.FIELD.NAME THEN ;* R22 Auto conversion
            LOCATE 'LOCAL.REF' IN R.STANDARD.SELECTION<SSL.SYS.FIELD.NAME,1> SETTING SS.POS THEN
                Y.FIELD.NUMBER =  R.STANDARD.SELECTION<SSL.SYS.FIELD.NO,SS.POS>:'.':Y.LF
                EXIT
            END
        END
    NEXT Y.LF

RETURN

*
*-------------------------------------------------------------------------------------
GET.PL.FIELD.NUMBER:
*------------------
*
    IF NOT(YR.COND) THEN
        CALL CACHE.READ(FN.CONSOLIDATE.COND, "ASSET&LIAB", YR.COND, READ.ERR) ;* R22 Auto conversion
    END
    LOCATE Y.FIELD.NAME IN YR.COND<RE.CON.NAME,1> SETTING Y.FIELD.NUMBER ELSE
        Y.FIELD.NUMBER = ''
    END
RETURN
*
*-------------------------------------------------------------------------------------
FATAL.ERROR:
*----------
    TEXT = E
    CALL FATAL.ERROR("RE.READ.CONSOLIDATE.COND")
*
END
