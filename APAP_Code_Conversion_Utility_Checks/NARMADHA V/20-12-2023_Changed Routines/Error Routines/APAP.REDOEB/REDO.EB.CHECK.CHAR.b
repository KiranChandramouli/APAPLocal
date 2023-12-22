* @ValidationCode : MjoxOTUxODUwOTAwOlVURi04OjE3MDI4ODE0MjczOTQ6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Dec 2023 12:07:07
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE REDO.EB.CHECK.CHAR

*--------------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, ++ to +=, = to EQ, X to X.VAR
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 18-12-2023      Narmadha V        Manual R22 Conversion   Change Hardcoded Value to FN variabe
*-------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ASCII.VALUES
    $INSERT I_F.ASCII.VAL.TABLE
    $INSERT I_F.EB.SECURE.MESSAGE

    GOSUB INITIALISE
    GOSUB READ.ASCII.VAL.TABLE
    IF ERR.MSG THEN
        RETURN
    END
    CNT = 1
    LOOP
    WHILE CNT LE NO.CHARS
        GOSUB PROCESS.INPUT
        IF ERR.MSG THEN
            RETURN
        END
        CNT += 1
    REPEAT

RETURN
***********************************************************
INITIALISE:
***********************************************************



    APP.BEN = 'EB.SECURE.MESSAGE'
    APP.FLD = 'L.ESM.MSG.REP'
    BEN.APP.POS = ''
    CALL MULTI.GET.LOC.REF(APP.BEN,APP.FLD,BEN.APP.POS)
    POS.L.ESM.MSG.REP = BEN.APP.POS<1,1>

    Y.POS.L.ESM.MSG.REP = R.NEW(EB.SM.LOCAL.REF)<1,POS.L.ESM.MSG.REP>

    ERR.MSG = ''
    NO.CHARS = LEN(Y.POS.L.ESM.MSG.REP)
    NO.RANGES = ''
    NO.SINGLE.VALUES = ''
    ERROR.MESSAGE = ''

RETURN
***********************************************************
READ.ASCII.VAL.TABLE:
***********************************************************
    TABLE.TO.USE = 'APAP.CLAIMS'
    READ.FAILED = ''
    ASCII.VAL.TABLE.REC = ''
    FN.ASCII.VAL.TABLE = "F.ASCII.VAL.TABLE"
*CALL CACHE.READ(FN.ASCII.VAL.TABLE,TABLE.TO.USE,ASCII.VAL.TABLE.REC,READ.FAILED)       ;* replaces F.READ
    CALL CACHE.READ(FN.ASCII.VAL.TABLE,TABLE.TO.USE,ASCII.VAL.TABLE.REC,READ.FAILED)  ;*Manual R22 Conversion - Change Hardcoded Value to FN variabe
    IF READ.FAILED THEN
        ERR.MSG = 'ASCII.VAL.TABLE NOT SET UP FOR ':TABLE.TO.USE
    END ELSE
        IF ASCII.VAL.TABLE.REC<ASVT.START.RANGE> NE '' THEN
            NO.RANGES = DCOUNT(ASCII.VAL.TABLE.REC<ASVT.START.RANGE>,@VM)
        END
        IF ASCII.VAL.TABLE.REC<ASVT.SINGLE.VALUE> NE '' THEN
            NO.SINGLE.VALUES = DCOUNT(ASCII.VAL.TABLE.REC<ASVT.SINGLE.VALUE>,@VM)
        END
        ERROR.MESSAGE = ASCII.VAL.TABLE.REC<ASVT.ERR.MESSAGE,LNGG>
        IF ERROR.MESSAGE EQ '' THEN
            ERROR.MESSAGE = ASCII.VAL.TABLE.REC<ASVT.ERR.MESSAGE,1>
        END
    END

RETURN

***********************************************************
PROCESS.INPUT:
***********************************************************

    CHAR.FOUND = ''
    CHAR.TO.CHECK = SEQX(Y.POS.L.ESM.MSG.REP[CNT,1])

    IF NO.RANGES THEN
        X.VAR = 1
        LOOP
        WHILE X.VAR LE NO.RANGES
            START.RANGE.VAL = ASCII.VAL.TABLE.REC<ASVT.START.RANGE,X.VAR>
            END.RANGE.VAL = ASCII.VAL.TABLE.REC<ASVT.END.RANGE,X.VAR>

            IF CHAR.TO.CHECK GE START.RANGE.VAL AND CHAR.TO.CHECK LE END.RANGE.VAL THEN         ;* Match found
                CHAR.FOUND = 1
                RETURN      ;* and check the next character
            END
            X.VAR += 1
        REPEAT
    END

    IF NO.SINGLE.VALUES THEN
        Y.ASVT.SINGLE.VALUE  = ASCII.VAL.TABLE.REC<ASVT.SINGLE.VALUE>
        CHANGE @VM TO @FM IN Y.ASVT.SINGLE.VALUE
        LOCATE CHAR.TO.CHECK IN Y.ASVT.SINGLE.VALUE SETTING LOC.POS THEN
            CHAR.FOUND = 1
            RETURN        ;* and check the next character
        END ELSE
            LOC.POS = ' '
        END
    END

    IF CHAR.FOUND EQ '' THEN     ;* Set error message
        ETEXT ='EB-VERIEFY.TEXT'
        AF= ''
*    AV = POS.L.ESM.MSG.REP
        CALL STORE.END.ERROR
    END

RETURN

***
END
