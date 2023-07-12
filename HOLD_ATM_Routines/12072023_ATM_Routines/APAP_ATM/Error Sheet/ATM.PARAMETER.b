* Version 8 24/05/00  GLOBUS Release No. G10.2.01 25/02/00



SUBROUTINE ATM.PARAMETER

*MODIFICATIONS
*
******************************************************************
*18/05/00 - GB0001261
*           jBASE CHANGES
*           The key word "ERROR " found in all the commented lines
*           has been changed to V$ERROR


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.PARAMETER
    $INSERT I_F.INTERCO.PARAMETER
*************************************************************************

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    CALL MATRIX.UPDATE

    GOSUB INITIALISE                   ; * Special Initialising

*************************************************************************

* Main Program Loop

    LOOP

        CALL RECORDID.INPUT

    UNTIL (MESSAGE EQ 'RET')

        V$ERROR = ''

        IF MESSAGE EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION         ; * Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

            GOSUB CHECK.ID               ; * Special Editing of ID
*       IF ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ

            IF MESSAGE EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            CALL MATRIX.ALTER

            GOSUB CHECK.RECORD           ; * Special Editing of Record
* >       IF ERROR THEN GOTO MAIN.REPEAT

* >       GOSUB PROCESS.DISPLAY           ;* For Display applications

            LOOP
                GOSUB PROCESS.FIELDS      ; * ) For Input
                GOSUB PROCESS.MESSAGE     ; * ) Applications
            WHILE (MESSAGE EQ 'ERROR') REPEAT

        END

MAIN.REPEAT:
    REPEAT

V$EXIT:
RETURN                             ; * From main program

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
        GOSUB CHECK.FIELDS              ; * Special Field Editing

        IF T.SEQU NE '' THEN
            T.SEQU<-1> = A + 1
        END

    REPEAT

RETURN

*************************************************************************

PROCESS.MESSAGE:

* Processing after exiting from field input (PF5)

    IF MESSAGE EQ 'DEFAULT' THEN
        MESSAGE = 'ERROR'               ; * Force the processing back
        IF V$FUNCTION NE 'D' AND V$FUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
        END
    END

    IF MESSAGE EQ 'PREVIEW' THEN
        MESSAGE = 'ERROR'               ; * Force the processing back
        IF V$FUNCTION NE 'D' AND V$FUNCTION NE 'R' THEN
            GOSUB CROSS.VALIDATION
* >       IF NOT(ERROR) THEN
* >          GOSUB DELIVERY.PREVIEW
* >       END
        END
    END

    IF MESSAGE EQ 'VAL' THEN
        MESSAGE = ''
        BEGIN CASE
            CASE V$FUNCTION EQ 'D'
* >          GOSUB CHECK.DELETE              ;* Special Deletion checks
            CASE V$FUNCTION EQ 'R'
* >          GOSUB CHECK.REVERSAL            ;* Special Reversal checks
            CASE OTHERWISE
                GOSUB CROSS.VALIDATION    ; * Special Cross Validation
                IF NOT(V$ERROR) THEN
                    GOSUB OVERRIDES
                END
        END CASE
* >    IF NOT(ERROR) THEN
* >       GOSUB BEFORE.UNAU.WRITE         ;* Special Processing before write
* >    END
        IF NOT(V$ERROR) THEN
            CALL UNAUTH.RECORD.WRITE
* >       IF MESSAGE NE "ERROR" THEN
* >          GOSUB AFTER.UNAU.WRITE          ;* Special Processing after write
* >       END
        END

    END

    IF MESSAGE EQ 'AUT' THEN
* >    GOSUB AUTH.CROSS.VALIDATION          ;* Special Cross Validation
* >    IF NOT(ERROR) THEN
* >       GOSUB BEFORE.AUTH.WRITE         ;* Special Processing before write
* >    END

        IF NOT(V$ERROR) THEN

            CALL AUTH.RECORD.WRITE

* >       IF MESSAGE NE "ERROR" THEN
* >          GOSUB AFTER.AUTH.WRITE          ;* Special Processing after write
* >       END
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

    IF E THEN
        V$ERROR = 1
    END

RETURN

*************************************************************************

CHECK.RECORD:

* Validation and changes of the Record.  Set ERROR to 1 if in error
*
* CHECKS FOR CURRENCY.MARKET EXISTENCE AND PICKS UP THE FIRST
* CURRENCY MARKET
*
    Y.FILE.NAME = 'F.CURRENCY.MARKET'
    CALL OPF(Y.FILE.NAME,Y.F.CURRENCY.MARKET)
    SEL.COMM = 'SSELECT ': Y.FILE.NAME
    CALL EB.READLIST(SEL.COMM,Y.L.CURRENCY.MARKET,Y.SAVE.LIST,Y.NO.OF.REC,Y.ERR)

    IF Y.NO.OF.REC THEN
        R.NEW(ATM.PARA.MARKET) = Y.L.CURRENCY.MARKET<1>
    END ELSE
        V$ERROR = 1
        E='CURRENCY.MARKET IS NOT SETUP'
        CALL ERR
    END
*
* THE FOLLOWING ARE THE ATM SERVICES THAT ARE SUPPORTED BY GLOBUS
*
    R.NEW(ATM.PARA.ATM.SERVICES) = 'ACCOUNT.STATEMENT'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'ATM.REVERSAL'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'BALANCE.ENQUIRY'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'CASH.WITHDRAWAL'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'CHEQUE.BOOK.REQUEST'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'EXCHANGE.RATE'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'FUNDS.TRANSFER'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'LORO.TRANSACTION'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'MINI.STATEMENT'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'NETWORK.BALANCE.ENQUIRY'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'NETWORK.REVERSAL'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'NETWORK.TRANSACTION'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'UTILITY.BILL'
    R.NEW(ATM.PARA.ATM.SERVICES)<1, -1> = 'CASH.DEPOSIT'
    R.NEW(ATM.PARA.ATM.SERVICES)<1,-1> = 'POINT.OF.SALE'
*
*      R.NEW(ATM.PARA.MESS.ACCT.LEN) = ''           ; * CURRENTLY NULL
*
* CHECKS FOR ACCOUNT.NO.LENGTH EXISTENCE AND PICKS UP
* AND ASSIGNS THE VALUE TO ACCT.NO.LEN AND MADE IT TO NOINPUT FIELD
    IF R.NEW(ATM.PARA.ACCT.NO.LEN) EQ '' THEN
        CALL CACHE.READ('F.INTERCO.PARAMETER', 'SYSTEM', R.INTERCO.PARAMETER.2, ERR.FREAD)
        Y.ACCT.NO.LENGTH = R.INTERCO.PARAMETER.2<ST.ICP.ACCOUNT.NO.LENGTH>
        IF ETEXT EQ '' THEN
            R.NEW(ATM.PARA.ACCT.NO.LEN) = Y.ACCT.NO.LENGTH
        END
    END
RETURN

*************************************************************************

CHECK.FIELDS:
    CALL ATM.PARAMETER.CHECK.FIELDS
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
    CALL ATM.PARAMETER.CROSSVAL
*
* If END.ERROR has been set then a cross validation error has occurred
*
    IF END.ERROR THEN
*         ERROR = 1
        MESSAGE = 'ERROR'
    END
RETURN                             ; * Back to field input via UNAUTH.RECORD.WRITE

*************************************************************************

OVERRIDES:
*
*  Overrides should reside here
*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
    CALL ATM.PARAMETER.OVERRIDE
*

*
    IF TEXT EQ "NO" THEN                ; * Said NO to override
        V$ERROR = 1
        MESSAGE = "ERROR"               ; * Back to field input

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
* > CALL XX.         ;* Accounting, Schedule processing etc etc

    IF TEXT EQ "NO" THEN                ; * Said No to override
        CALL TRANSACTION.ABORT          ; * Cancel current transaction
        V$ERROR = 1
        MESSAGE = "ERROR"               ; * Back to field input
        RETURN
    END

*
* Additional updates should be performed here
*
* > CALL XX..



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
        CASE R.NEW(V-8)[1,3] EQ "INA"    ; * Record status
* > CALL XX.AUTHORISATION
        CASE R.NEW(V-8)[1,3] = "RNA"    ; * Record status
* > CALL XX.REVERSAL

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

    APP.CODE = ""                      ; * Set to product code ; e.g FT, FX
    ACCT.OFFICER = ""                  ; * Used in call to EXCEPTION. Should be relevant A/O
    EXCEP.CODE = ""

RETURN

*************************************************************************

DEFINE.PARAMETERS:* SEE 'I_RULES' FOR DESCRIPTIONS *

CALL ATM.PARAMETER.FIELD.DEFINITIONS

RETURN

*************************************************************************

END
