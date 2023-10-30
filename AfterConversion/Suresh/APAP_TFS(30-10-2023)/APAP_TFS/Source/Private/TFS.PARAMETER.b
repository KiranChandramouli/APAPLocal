* @ValidationCode : MjoyOTE5MDcxMDM6Q3AxMjUyOjE2OTgzMDk5ODE1OTM6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Oct 2023 14:16:21
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
$PACKAGE APAP.TFS
* Version 9 15/11/00  GLOBUS Release No. G14.0.00 03/07/03
*-----------------------------------------------------------------------------
* <Rating>503</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TFS.PARAMETER
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

*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion                USPLATFORM.BP File is Removed
*

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INCLUDE  I_F.TFS.PARAMETER ;* R22 Manual Code conversin
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
            CALL UNAUTH.RECORD.WRITE
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

            CALL AUTH.RECORD.WRITE

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

    SAVE.AF = AF ; SAVE.AV = AV ; SAVE.COMI = COMI
    IF R.NEW(TFS.PAR.DEF.ACCNTG.STYLE) THEN
* ACCOUNTING.STYLE
        AF = TFS.PAR.DEF.ACCNTG.STYLE ; AV = 1 ; COMI = R.NEW(AF)
*CALL TFS.PAR.CHECK.FIELDS
        APAP.TFS.tfsParCheckFields() ;*R22 MANAUAL CODE CONVERSION
        LOCATE AF IN T.FIELDNO<1> SETTING AF.POS THEN
            T.ENRI<AF.POS> = COMI.ENRI
        END
    END
* OFS.VERSION
    IF R.NEW(TFS.PAR.OFS.VERSION) THEN
        AF = TFS.PAR.OFS.VERSION
        NO.OF.MVS = DCOUNT(R.NEW(AF),@VM)
        FOR AV = 1 TO NO.OF.MVS
            COMI = R.NEW(AF)<1,AV>
* CALL TFS.PAR.CHECK.FIELDS
            APAP.TFS.tfsParCheckFields() ;*R22 MANAUAL CODE CONVERSION
            IF COMI.ENRI THEN
                LOCATE AF :'.': AV IN T.FIELDNO<1> SETTING AF.AV.POS THEN
                    T.ENRI<AF.AV.POS> = COMI.ENRI
                END
            END
        NEXT AV
    END
* DC.DEPT.IN.DC.ID
    AF = TFS.PAR.DC.DEPT.IN.DC.ID ; AV = 1 ; COMI = R.NEW(AF)
    IF COMI THEN    ;* If NULL, dont bother
*CALL TFS.PAR.CHECK.FIELDS
        APAP.TFS.tfsParCheckFields() ;*R22 MANAUAL CODE CONVERSION
        LOCATE AF IN T.FIELDNO<1> SETTING AF.POS THEN
            T.ENRI<AF.POS> = COMI.ENRI
        END
    END
* DC.BATCH.IN.DC.ID
    AF = TFS.PAR.DC.BATCH.IN.DC.ID
    COMI = R.NEW(AF)
    IF COMI THEN
* CALL TFS.PAR.CHECK.FIELDS
        APAP.TFS.tfsParCheckFields() ;*R22 MANAUAL CODE CONVERSION
        LOCATE AF IN T.FIELDNO<1> SETTING AF.POS THEN
            T.ENRI<AF.POS> = COMI.ENRI
        END
    END
    AF = SAVE.AF ; AV = SAVE.AV ; COMI = SAVE.COMI

RETURN

*-----------------------------------------------------------------------------

CHECK.FIELDS:

* CALL TFS.PAR.CHECK.FIELDS
    APAP.TFS.tfsParCheckFields() ;*R22 MANAUAL CODE CONVERSION

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

*CALL TFS.PAR.CROSSVAL
    APAP.TFS.tfsParCrossval() ;*R22 MANAUAL CODE CONVERISON
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
        CALL TRANSACTION.ABORT          ;* Cancel current transaction
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

*CALL TFS.PAR.FIELD.DEFINITIONS
    APAP.TFS.tfsParFieldDefinitions() ; *R22 Manual code conversion

RETURN

*-----------------------------------------------------------------------------

END




