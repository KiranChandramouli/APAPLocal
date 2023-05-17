SUBROUTINE MB.SDB.PARAM

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG
    $INSERT I_F.MB.SDB.PARAM
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
            IF V$ERROR THEN
                GOTO MAIN.REPEAT
            END

            CALL RECORD.READ

            IF MESSAGE EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            GOSUB CHECK.RECORD          ;* Special Editing of Record

            CALL MATRIX.ALTER

            IF V$ERROR THEN
                GOTO MAIN.REPEAT
            END

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

        IF T.SEQU NE '' THEN
            T.SEQU<-1> = A + 1
        END

    REPEAT

RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

    IF MESSAGE EQ 'DEFAULT' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION NE 'D' AND V$FUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF MESSAGE EQ 'PREVIEW' THEN
        MESSAGE = 'ERROR'     ;* Force the processing back
        IF V$FUNCTION NE 'D' AND V$FUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
            IF NOT(V$ERROR) THEN
* >               GOSUB DELIVERY.PREVIEW   ; * Activate print preview
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

*************************************************************************
*                      Special Tailored Subroutines                     *
*************************************************************************

CHECK.ID:

    V$ERROR = 0
    E = ''

    IF E THEN
        V$ERROR = 1
        CALL ERR
    END

RETURN

*************************************************************************

CHECK.RECORD:

    IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN      ;* BG_100007114

    END

RETURN

*************************************************************************

CHECK.FIELDS:

    CALL MB.SDB.PARAM.CHECK.FIELDS

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
* > CALL XX.CROSSVAL
*
* If END.ERROR has been set then a cross validation error has occurred
*
    IF END.ERROR THEN
        A = 1
        LOOP UNTIL T.ETEXT<A> <> "" DO A += 1 ; REPEAT
        T.SEQU = "D"
        T.SEQU<-1> = A
        V$ERROR = 1
        MESSAGE = 'ERROR'
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
* > CALL XX.OVERRIDE
*

*
    IF TEXT EQ "NO" THEN       ;* Said NO to override
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

    IF TEXT EQ "NO" THEN       ;* Said No to override
        CALL TRANSACTION.ABORT          ;* Cancel current transaction
        V$ERROR = 1
        MESSAGE = "ERROR"     ;* Back to field input
        RETURN
    END

*
* Additional updates should be performed here
*
* > CALL XX...



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
        CASE R.NEW(V-8)[1,3] EQ "INA"        ;* Record status
* > CALL XX.AUTHORISATION
        CASE R.NEW(V-8)[1,3] = "RNA"        ;* Record status
* > CALL XX.REVERSAL

    END CASE

RETURN

*************************************************************************

CHECK.FUNCTION:

    IF INDEX('V',V$FUNCTION,1) THEN
        E = 'EB.RTN.FUNT.NOT.ALLOWED.APP'
        CALL ERR
        V$FUNCTION = ''
    END

RETURN

*************************************************************************

INITIALISE:

RETURN

*************************************************************************

DEFINE.PARAMETERS:

    CALL MB.SDB.PARAM.FLD.DEFINITIONS

RETURN

*************************************************************************

END
