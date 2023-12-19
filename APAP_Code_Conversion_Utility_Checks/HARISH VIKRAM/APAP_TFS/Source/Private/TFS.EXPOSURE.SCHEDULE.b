* @ValidationCode : MjotNDg0Mjg5NzYxOkNwMTI1MjoxNjk4NzUwNjczOTQyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TFS
* Version 9 15/11/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>454</Rating>
*-----------------------------------------------------------------------------

*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion       USPLATFORM.BP file be removed ,CALL UNAUTH.RECORD.WRITE;CALL AUTH.RECORD.WRITE;CALL TRANSACTION.ABORT Chnaged, Call Rtn Format can be modified
*15/12/2023         HARISHVIKRAM             R22 Manual Conversion     RECORDID.INPUT Changed

SUBROUTINE TFS.EXPOSURE.SCHEDULE
*-----------------------------------------------------------------------------
*
* Parameter table to define conditions for T24.FUND.SERVICES
*
*-----------------------------------------------------------------------
* Modification history:
*
* 09/07/04 - Sathish PS
*            New Development
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INCLUDE I_F.TFS.PARAMETER ;*R22 Manual code conversion
    $USING EB.TransactionControl
*-----------------------------------------------------------------------------

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    CALL MATRIX.UPDATE

    GOSUB INITIALISE          ;* Special Initialising

*-----------------------------------------------------------------------------

* Main Program Loop

    LOOP

*        CALL RECORDID.INPUT
        EB.TransactionControl.RecordidInput()      ;*R22 Manual code conversion

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

*            CALL RECORD.READ
            EB.TransactionControl.RecordidInput()      ;*R22 Manual code conversion

            IF MESSAGE EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            CALL MATRIX.ALTER

            GOSUB CHECK.RECORD          ;* Special Editing of Record

            IF V$ERROR THEN GOTO MAIN.REPEAT

            LOOP
                GOSUB PROCESS.FIELDS    ;* ) For Input
                GOSUB PROCESS.MESSAGE   ;* ) Applications
            WHILE (MESSAGE EQ 'ERROR') REPEAT

        END

MAIN.REPEAT:
    REPEAT

V$EXIT:
RETURN          ;* From main program

*-----------------------------------------------------------------------------
*                      S u b r o u t i n e s                            *
*-----------------------------------------------------------------------------

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

*-----------------------------------------------------------------------------

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
*            CALL UNAUTH.RECORD.WRITE
            EB.TransactionControl.UnauthRecordWrite()      ;*R22 Manual Conversion
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

*            CALL AUTH.RECORD.WRITE
            EB.TransactionControl.AuthRecordWrite()     ;*R22 Manual Conversion

            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE  ;* Special Processing after write
            END
        END

    END

RETURN

*-----------------------------------------------------------------------------
*                      Special Tailored Subroutines                     *
*-----------------------------------------------------------------------------

CHECK.ID:
* Validation and changes of the ID entered.  Set ERROR to 1 if in error.
    V$ERROR = 0
    E = ''

    IF E THEN
        V$ERROR = 1
        CALL ERR
    END

RETURN

*-----------------------------------------------------------------------------

CHECK.RECORD:

* Validation and changes of the Record.  Set ERROR to 1 if in error.


RETURN

*-----------------------------------------------------------------------------

CHECK.FIELDS:

    IF E THEN
        T.SEQU = "IFLD"
        CALL ERR
    END

RETURN

*-----------------------------------------------------------------------------

CROSS.VALIDATION:

*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''

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
    END
RETURN          ;* Back to field input via UNAUTH.RECORD.WRITE

*-----------------------------------------------------------------------------

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
    IF TEXT = "NO" THEN       ;* Said NO to override
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input

    END
RETURN

*-----------------------------------------------------------------------------

AUTH.CROSS.VALIDATION:


RETURN

*-----------------------------------------------------------------------------

CHECK.DELETE:


RETURN

*-----------------------------------------------------------------------------

CHECK.REVERSAL:


RETURN

*-----------------------------------------------------------------------------
DELIVERY.PREVIEW:

RETURN

*-----------------------------------------------------------------------------

BEFORE.UNAU.WRITE:
*
*  Contract processing code should reside here.
*
REM > CALL XX.         ;* Accounting, Schedule processing etc etc

    IF TEXT = "NO" THEN       ;* Said No to override
*        CALL TRANSACTION.ABORT          ;* Cancel current transaction
        EB.TransactionControl.TransactionAbort()     ;*R22 Manual Conversion
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input
        RETURN
    END

*
* Additional updates should be performed here
*
REM > CALL XX...



RETURN

*-----------------------------------------------------------------------------

AFTER.UNAU.WRITE:


RETURN

*-----------------------------------------------------------------------------

AFTER.AUTH.WRITE:


RETURN

*-----------------------------------------------------------------------------

BEFORE.AUTH.WRITE:

    BEGIN CASE
        CASE R.NEW(V-8)[1,3] = "INA"        ;* Record status
REM > CALL XX.AUTHORISATION
        CASE R.NEW(V-8)[1,3] = "RNA"        ;* Record status
REM > CALL XX.REVERSAL

    END CASE

RETURN

*-----------------------------------------------------------------------------

CHECK.FUNCTION:

* Validation of function entered.  Set FUNCTION to null if in error.

    IF INDEX('V',V$FUNCTION,1) THEN
        E = 'EB.RTN.FUNT.NOT.ALLOWED.APP'
        CALL ERR
        V$FUNCTION = ''
    END

RETURN

*-----------------------------------------------------------------------------

INITIALISE:

RETURN

*-----------------------------------------------------------------------------

DEFINE.PARAMETERS:

*CALL TFS.EXP.SCH.FIELD.DEFINITIONS
    APAP.TFS.tfsExpSchFieldDefinitions() ;*R22 Manual Code conversion

RETURN

*-----------------------------------------------------------------------------

END




