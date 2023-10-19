* @ValidationCode : MjotMTA3NDM0NTIzNjpDcDEyNTI6MTY5Mzg5NzcxMDM4OTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Sep 2023 12:38:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.ATM
*-----------------------------------------------------------------------------
* <Rating>212</Rating>
*-----------------------------------------------------------------------------
* Version 8 24/05/00  GLOBUS Release No. G10.2.01 25/02/00



SUBROUTINE ATM.BRANCH

*MODIFICATIONS
*
******************************************************************
*18/05/00 - GB0001261
*           jBASE CHANGES
*           The key word "ERROR " found in all the commented lines
*           has been changed to V$ERROR
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*05/09/2023      Conversion tool            R22 Auto Conversion             Nochange
*05/09/2023      Suresh                     R22 Manual Conversion           REM TO *, CALL routine format modified
*----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT I_F.ATM.PARAMETER ;*R22 Manual Conversion
    $INSERT I_GTS.COMMON
    $INSERT I_F.INTRF.PARAMETER
*************************************************************************

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    CALL MATRIX.UPDATE

    GOSUB INITIALISE          ;* Special Initialising

*************************************************************************

* Main Program Loop

    LOOP

        CALL RECORDID.INPUT

    UNTIL (MESSAGE EQ 'RET')

        V$ERROR = ''

        IF MESSAGE EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ

            IF MESSAGE EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            CALL MATRIX.ALTER

            GOSUB CHECK.RECORD          ;* Special Editing of Record
* >       IF ERROR THEN GOTO MAIN.REPEAT   ;*R22 Manual Conversion

* >       GOSUB PROCESS.DISPLAY           ;* For Display applications   ;*R22 Manual Conversion

            LOOP
                GOSUB PROCESS.FIELDS    ;* ) For Input
                GOSUB PROCESS.MESSAGE   ;* ) Applications
            WHILE (MESSAGE EQ 'ERROR') REPEAT

        END

MAIN.REPEAT:
    REPEAT

V$EXIT:
RETURN          ;* From main program

*************************************************************************
*                      S u b r o u t i n e s                            *
*************************************************************************

PROCESS.FIELDS:

* Input or display the record fields

    LOOP
        IF SCREEN.MODE EQ 'MULTI' THEN
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.MULTI.INPUT
            END ELSE
                CALL FIELD.MULTI.DISPLAY
            END
        END ELSE
            IF FILE.TYPE EQ 'I' THEN
                CALL FIELD.INPUT
            END ELSE
                CALL FIELD.DISPLAY
            END
        END

    WHILE NOT(MESSAGE)
        GOSUB CHECK.FIELDS    ;* Special Field Editing

        IF T.SEQU NE '' THEN T.SEQU<-1> = A + 1

    REPEAT

RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

    IF MESSAGE = 'DEFAULT' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF MESSAGE = 'PREVIEW' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
* >       IF NOT(ERROR) THEN ;*R22 Manual Conversion
* >          GOSUB DELIVERY.PREVIEW ;*R22 Manual Conversion
* >       END ;*R22 Manual Conversion
        END
    END

    IF MESSAGE EQ 'VAL' THEN
        MESSAGE = ''
        BEGIN CASE
            CASE V$FUNCTION EQ 'D'
* >          GOSUB CHECK.DELETE              ;* Special Deletion checks  ;*R22 Manual Conversion
            CASE V$FUNCTION EQ 'R'
* >          GOSUB CHECK.REVERSAL            ;* Special Reversal checks  ;*R22 Manual Conversion
            CASE OTHERWISE
                GOSUB CROSS.VALIDATION      ;* Special Cross Validation
* >          IF NOT(ERROR) THEN ;*R22 Manual Conversion
* >             GOSUB OVERRIDES ;*R22 Manual Conversion
* >          END ;*R22 Manual Conversion
        END CASE
* >    IF NOT(ERROR) THEN ;*R22 Manual Conversion
* >       GOSUB BEFORE.UNAU.WRITE         ;* Special Processing before write ;*R22 Manual Conversion
* >    END ;*R22 Manual Conversion
        IF NOT(V$ERROR) THEN
            CALL UNAUTH.RECORD.WRITE
* >       IF MESSAGE NE "ERROR" THEN ;*R22 Manual Conversion
* >          GOSUB AFTER.UNAU.WRITE          ;* Special Processing after write ;*R22 Manual Conversion
* >       END ;*R22 Manual Conversion
        END

    END

    IF MESSAGE EQ 'AUT' THEN
* >    GOSUB AUTH.CROSS.VALIDATION          ;* Special Cross Validation       ;*R22 Manual Conversion
* >    IF NOT(ERROR) THEN  ;*R22 Manual Conversion
* >       GOSUB BEFORE.AUTH.WRITE         ;* Special Processing before write   ;*R22 Manual Conversion
* >    END ;*R22 Manual Conversion

        IF NOT(V$ERROR) THEN

            CALL AUTH.RECORD.WRITE

* >       IF MESSAGE NE "ERROR" THEN ;*R22 Manual Conversion
* >          GOSUB AFTER.AUTH.WRITE          ;* Special Processing after write ;*R22 Manual Conversion
* >       END ;*R22 Manual Conversion
        END

    END

RETURN

*************************************************************************

PROCESS.DISPLAY:

* Display the record fields

    IF SCREEN.MODE EQ 'MULTI' THEN
        CALL FIELD.MULTI.DISPLAY
    END ELSE
        CALL FIELD.DISPLAY
    END

RETURN

*************************************************************************
*                      Special Tailored Subroutines                     *
*************************************************************************

CHECK.ID:

* Validation and changes of the ID entered.  Set ERROR to 1 if in error
    ID.NEW = COMI



ERRORS:
    IF E THEN
        V$ERROR = 1
        CALL ERR
    END
RETURN


*************************************************************************

CHECK.RECORD:

* Validation and changes of the Record.  Set ERROR to 1 if in error


RETURN

*************************************************************************

CHECK.FIELDS:
* CALL ATM.BRANCH.CHECK.FIELDS ;*R22 Manual Conversion
    APAP.ATM.atmBranchCheckFields()
    IF E THEN
        T.SEQU = "IFLD"
        CALL ERR
    END

RETURN

*************************************************************************

CROSS.VALIDATION:

*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
*
* CALL ATM.BRANCH.CROSSVAL ;*R22 Manual Conversion
    APAP.ATM.atmBranchCrossval()
*
* If END.ERROR has been set then a cross validation error has occurred
*
    IF END.ERROR THEN
*         ERROR = 1
        MESSAGE = 'ERROR'
    END
RETURN          ;* Back to field input via UNAUTH.RECORD.WRITE

*************************************************************************

OVERRIDES:
*
*  Overrides should reside here
*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
* > CALL XX.OVERRIDE ;*R22 Manual Conversion
*

*
    IF TEXT = "NO" THEN       ;* Said NO to override
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input

    END
RETURN

*************************************************************************

AUTH.CROSS.VALIDATION:


RETURN

*************************************************************************

CHECK.DELETE:


RETURN

*************************************************************************

CHECK.REVERSAL:


RETURN

*************************************************************************

BEFORE.UNAU.WRITE:
*
*  Contract processing code should reside here
*
* > CALL XX.         ;* Accounting, Schedule processing etc etc ;*R22 Manual Conversion

    IF TEXT = "NO" THEN       ;* Said No to override
        CALL TRANSACTION.ABORT          ;* Cancel current transaction
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input
        RETURN
    END

*
* Additional updates should be performed here
*
* > CALL XX.. ;*R22 Manual Conversion



RETURN

*************************************************************************

AFTER.UNAU.WRITE:


RETURN

*************************************************************************

AFTER.AUTH.WRITE:

    FV.INTRF.PARAM = 'F.INTRF.PARAMETER'
    FP.INTRF.PARAM = ''
    CALL OPF(FV.INTRF.PARAM,FP.INTRF.PARAM)

*    CALL F.READ(FV.INTRF.PARAM,'SYSTEM',INTRF.ARR,FP.INTRF.PARAM,INTRF.ERR)        ;*/ TUS S/E
    CALL CACHE.READ(FV.INTRF.PARAM,'SYSTEM',INTRF.ARR,INTRF.ERR)

    Y.FILE.PATH = INTRF.ARR<INTRF.FILE.PATH>
    Y.FILE.NAME = APPLICATION:'.':ID.NEW
    Y.FILE.PATH = Y.FILE.PATH:'/':Y.FILE.NAME

    Y.OFS.STRING = APPLICATION:',/S/VALIDATE,,':ID.NEW
    Y.TXN = 'INTRF.PAR'
    CALL OFS.GLOBUS.MANAGER(Y.TXN,Y.OFS.STRING)

    Y.FILE.VAR = ''
    OPENSEQ Y.FILE.PATH TO Y.FILE.VAR ELSE
        CREATE Y.FILE.VAR ELSE
            CRT 'UNABLE TO OPEN':Y.FILE.VAR
        END
    END

    CLOSESEQ Y.FILE.VAR

RETURN

*************************************************************************

BEFORE.AUTH.WRITE:

    BEGIN CASE
        CASE R.NEW(V-8)[1,3] = "INA"        ;* Record status
* > CALL XX.AUTHORISATION ;*R22 Manual Conversion
        CASE R.NEW(V-8)[1,3] = "RNA"        ;* Record status
* > CALL XX.REVERSAL ;*R22 Manual Conversion

    END CASE
*
* If there are any OVERRIDES a call to EXCEPTION.LOG should be made
*
* IF R.NEW(V-9) THEN
*    EXCEP.CODE = "110" ; EXCEP.MESSAGE = "OVERRIDE CONDITION"
*    GOSUB EXCEPTION.MESSAGE
* END
*

RETURN

*************************************************************************

CHECK.FUNCTION:

* Validation of function entered.  Set FUNCTION to null if in error

    IF INDEX('V',V$FUNCTION,1) THEN
        E = 'FUNCTION NOT ALLOWED FOR THIS APPLICATION'
        CALL ERR
        V$FUNCTION = ''
    END

RETURN

*************************************************************************
*
EXCEPTION.MESSAGE:
*
    CALL EXCEPTION.LOG("U",
    APP.CODE,
    APPLICATION,
    APPLICATION,
    EXCEP.CODE,
    "",
    FULL.FNAME,
    ID.NEW,
    R.NEW(V-7),
    EXCEP.MESSAGE,
    ACCT.OFFICER)
*
RETURN

*************************************************************************

INITIALISE:

    APP.CODE = ""   ;* Set to product code ; e.g FT, FX
    ACCT.OFFICER = ""         ;* Used in call to EXCEPTION. Should be relevant A/O
    EXCEP.CODE = ""

RETURN

*************************************************************************

DEFINE.PARAMETERS:  * SEE 'I_RULES' FOR DESCRIPTIONS *

*   CALL ATM.BRANCH.FIELD.DEFINITIONS ;*R22 Manual Conversion
    APAP.ATM.atmBranchFieldDefinitions()

RETURN

*************************************************************************

END
