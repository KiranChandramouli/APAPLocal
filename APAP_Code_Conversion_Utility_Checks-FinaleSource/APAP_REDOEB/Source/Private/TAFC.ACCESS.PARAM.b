* @ValidationCode : MjoyMDM4NDQ5NDUzOlVURi04OjE3MDI5OTA2MzI4OTM6SVRTUzE6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:27:12
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
* Version 9 15/11/00  GLOBUS Release No. R06.002 22/08/06
*-----------------------------------------------------------------------------
* <Rating>544</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TAFC.ACCESS.PARAM
******************************************************************
* The parameter file for the TAlert events
*-----------------------------------------------------------------------------
* Modification History:
*   DATE         WHO            REFERENCE                     DESCRIPTION
* 21 AUG 2023   Narmadha V     Manual R22 Conversion        GOTO changed to GOSUB, Call Routine Format Modified.
* 18-12-2023    Narmadha V     Manual R22 Conversion        = to EQ, CALL routine Fomat Modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG
    $INSERT I_F.TAFC.ACCESS.PARAM
    $USING EB.TransactionControl
*************************************************************************

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOSUB V$EXIT
    END

    CALL MATRIX.UPDATE

    GOSUB INITIALISE          ;* Special Initialising

*************************************************************************

* Main Program Loop

    LOOP

*CALL RECORDID.INPUT
        EB.TransactionControl.RecordidInput() ;*Manual R22 Conversion

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
            IF V$ERROR THEN GOSUB MAIN.REPEAT;* GOTO changed to GOSUB

*CALL RECORD.READ
            EB.TransactionControl.RecordRead() ;*Manual R22 Conversion

*            FOR FLD.VAL = 1 TO V-9
*                CHANGE ';' TO @SM IN R.NEW(FLD.VAL)
*                CHANGE ',' TO @VM IN R.NEW(FLD.VAL)
*            NEXT FLD.VAL

            IF MESSAGE EQ 'REPEAT' THEN
                GOSUB MAIN.REPEAT ;* GOTO changed to GOSUB
            END

            GOSUB CHECK.RECORD          ;* Special Editing of Record

            CALL MATRIX.ALTER

            IF V$ERROR THEN GOSUB MAIN.REPEAT ;* GOTO changed to GOSUB

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
* Input or display the record fields.

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

*IF MESSAGE = 'DEFAULT' THEN
    IF MESSAGE EQ 'DEFAULT' THEN ;*Manual R22 Conversion = to EQ
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF BROWSER.PREVIEW.ON THEN          ;* EN_10002679 - s
* Clear BROWSER.PREVIEW.ON once inside the template so that after preview
* it might exit from the template, otherwise there will be looping within the template.
        MESSAGE = 'PREVIEW'
        BROWSER.PREVIEW.ON = 0
    END   ;* EN_10002679 - e


*IF MESSAGE = 'PREVIEW' THEN
    IF MESSAGE EQ 'PREVIEW' THEN ;*Manual R22 Conversion = to EQ
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION <> 'D' AND V$FUNCTION <> 'R' THEN
            GOSUB CROSS.VALIDATION
            IF NOT(V$ERROR) THEN
REM >               GOSUB DELIVERY.PREVIEW   ; * Activate print preview
            END
        END
    END

    IF MESSAGE EQ 'VAL' THEN
        MESSAGE = ''
        BEGIN CASE
            CASE V$FUNCTION EQ 'D'
                GOSUB CHECK.DELETE          ;* Special Deletion checks
            CASE V$FUNCTION EQ 'R'
                GOSUB CHECK.REVERSAL        ;* Special Reversal checks
            CASE OTHERWISE
                GOSUB CROSS.VALIDATION      ;* Special Cross Validation
                IF NOT(V$ERROR) THEN
                    GOSUB OVERRIDES
                END
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE     ;* Special Processing before write
        END
        IF NOT(V$ERROR) THEN
*CALL UNAUTH.RECORD.WRITE
            EB.TransactionControl.UnauthRecordWrite()
            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE  ;* Special Processing after write
            END
        END

    END

    IF MESSAGE EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION     ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE     ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN

*CALL AUTH.RECORD.WRITE
            EB.TransactionControl.AuthRecordWrite()

            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE  ;* Special Processing after write
            END
        END

    END

RETURN

*************************************************************************
*                      Special Tailored Subroutines                     *
*************************************************************************
CHECK.ID:
* Validation and changes of the ID entered.  Sets V$ERROR to 1 if in error.

    V$ERROR = 0
    E = ''

    IF E THEN
        V$ERROR = 1
        CALL ERR
    END

RETURN

*************************************************************************
CHECK.RECORD:
* Validation and changes of the Record.  Set V$ERROR to 1 if in error.
*
* A application runnin in browser will enter CHECK.RECORD multiple
* times during a transaction lifecycle. Any validation that must only
* run when the user first opens the contract must be put in the following
* IF statement
*
    IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN      ;* BG_100007114

    END


RETURN

*************************************************************************
CHECK.FIELDS:

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
* CALL TAFC.ACCESS.PARAM.VALIDATE
    APAP.REDOEB.tafcAccessParamValidate() ;* Manual R22 Conversion
*
* If END.ERROR has been set then a cross validation error has occurred
*
    IF END.ERROR THEN
        A = 1
        LOOP UNTIL T.ETEXT<A> <> "" DO A = A+1 ; REPEAT
        T.SEQU = "D"
        T.SEQU<-1> = A
        V$ERROR = 1
        MESSAGE = 'ERROR'
    END ELSE
*        FOR FLD.VAL = 1 TO V-9
*            CHANGE @SM TO ';' IN R.NEW(FLD.VAL)
*            CHANGE @VM TO ',' IN R.NEW(FLD.VAL)
*        NEXT FLD.VAL
    END

RETURN          ;* Back to field input via UNAUTH.RECORD.WRITE

*************************************************************************
OVERRIDES:
*
*  Overrides should reside here.
*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
REM > CALL XX.OVERRIDE
*

*
* IF TEXT = "NO" THEN       ;* Said NO to override
    IF TEXT EQ "NO" THEN ;*Manual R22 Conversion = to EQ
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
DELIVERY.PREVIEW:

RETURN

*************************************************************************
BEFORE.UNAU.WRITE:
*
*  Contract processing code should reside here.
*
REM > CALL XX.         ;* Accounting, Schedule processing etc etc

*IF TEXT = "NO" THEN       ;* Said No to override
    IF TEXT EQ "NO" THEN ;*Manual R22 Conversion = to EQ
*CALL TRANSACTION.ABORT          ;* Cancel current transaction
        EB.TransactionControl.TransactionAbort()
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input
        RETURN
    END
*
* Additional updates should be performed here
*
REM > CALL XX...

RETURN

*************************************************************************
AFTER.UNAU.WRITE:


RETURN

*************************************************************************
AFTER.AUTH.WRITE:


RETURN

*************************************************************************
BEFORE.AUTH.WRITE:

    BEGIN CASE
        CASE R.NEW(V-8)[1,3] = "INA"        ;* Record status
REM > CALL XX.AUTHORISATION
        CASE R.NEW(V-8)[1,3] = "RNA"        ;* Record status
REM > CALL XX.REVERSAL

    END CASE

    AF = EB.TAP.RESTRICT.CMDS
    REST.CMD.CNT = DCOUNT(R.NEW(AF), @VM)
    REST.CMD = R.NEW(AF)
    FOR AV = 1 TO REST.CMD.CNT
        REST.CMD<1, AV> = UPCASE(REST.CMD<1, AV>)
    NEXT AV
    R.NEW(AF) = REST.CMD


RETURN

*************************************************************************
CHECK.FUNCTION:
* Validation of function entered.  Sets V$FUNCTION to null if in error.

    IF INDEX('V',V$FUNCTION,1) THEN
        E = 'EB.RTN.FUNT.NOT.ALLOWED.APP'
        CALL ERR
        V$FUNCTION = ''
    END

RETURN

*************************************************************************
INITIALISE:

    BROWSER.PREVIEW.ON = (OFS$MESSAGE='PREVIEW')  ;*EN_10002679 - S/E

RETURN

*************************************************************************
DEFINE.PARAMETERS:
* SEE 'I_RULES' FOR DESCRIPTIONS *

*CALL TAFC.ACCESS.PARAM.FIELDS
    APAP.REDOEB.tafcAccessParamFields() ;*Manual R22 Conversion

RETURN

*************************************************************************

END
