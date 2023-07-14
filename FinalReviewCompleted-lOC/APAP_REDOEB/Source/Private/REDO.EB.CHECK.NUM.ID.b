* @ValidationCode : MjoxNzE0OTk3Njk6Q3AxMjUyOjE2ODE5Nzk1OTc5ODA6SVRTUzotMTotMTotMjc6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -27
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE REDO.EB.CHECK.NUM.ID

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool   R22 Auto conversion      VM to @VM, ++ to +=, = to EQ, X to X.VAR
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ASCII.VALUES
    $INSERT I_F.ASCII.VAL.TABLE
    $INSERT I_F.REDO.ADD.THIRDPARTY


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




    Y.TP.CUSTOMER.ID = R.NEW(ARC.TP.CUSTOMER.ID)

    ERR.MSG = ''
    NO.CHARS = LEN(Y.TP.CUSTOMER.ID)
    NO.RANGES = ''
    NO.SINGLE.VALUES = ''
    ERROR.MESSAGE = ''

RETURN
***********************************************************
READ.ASCII.VAL.TABLE:
***********************************************************
    TABLE.TO.USE = 'APAP.IDENTIFICATION'
    READ.FAILED = ''
    ASCII.VAL.TABLE.REC = ''
    CALL CACHE.READ('F.ASCII.VAL.TABLE',TABLE.TO.USE,ASCII.VAL.TABLE.REC,READ.FAILED)       ;* replaces F.READ
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
    CHAR.TO.CHECK = SEQX(Y.TP.CUSTOMER.ID[CNT,1])

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

        ETEXT = 'EB-BANK.ALREADY.REMOVED'
        AF = ARC.TP.CUSTOMER.ID
        CALL STORE.END.ERROR
    END

RETURN

***
END
