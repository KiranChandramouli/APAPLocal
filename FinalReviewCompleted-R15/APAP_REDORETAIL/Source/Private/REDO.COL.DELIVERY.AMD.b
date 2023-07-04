* @ValidationCode : MjoxNDQ1MzcyODU3OkNwMTI1MjoxNjgxODI5MDgxNzM2OklUU1M6LTE6LTE6MTgxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 181
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Version 9 15/11/00  GLOBUS Release No. G11.1.01 11/12/00
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE REDO.COL.DELIVERY.AMD
******************************************************************
* This routine makes the load of F.REDO.COL.QUEUE.ERROR in the
* REDO.COL.DELIVERY.AMD aplications for permit amending the errors
* =============================================================================
*
*    First Release : mgudino@temenos.com
*    Developed for : amending the errors in EXTRACT AND DELIVERY PROCESS
*    Date          : 2010/11/14
*
*=======================================================================
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           = TO EQ, SM TO @SM, VM TO @VM, <> TO NE
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION        GOTO changed to GOSUB
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.OFS.STATUS.FLAG

*************************************************************************

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOSUB V$EXIT ;* R22 Manual conversion - GOTO changed to GOSUB
    END

    CALL MATRIX.UPDATE

    GOSUB INITIALISE  ;* Special Initialising

*************************************************************************

* Main Program Loop

    LOOP

        CALL RECORDID.INPUT

    UNTIL (MESSAGE EQ 'RET')

        V$ERROR = ''

        IF MESSAGE EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION    ;* Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

            GOSUB CHECK.ID          ;* Special Editing of ID
            IF V$ERROR THEN ;* AUTO R22 CODE CONVERSION START
                GOSUB MAIN.REPEAT ;* R22 Manual conversion - GOTO changed to GOSUB
            END ;* AUTO R22 CODE CONVERSION END

            CALL RECORD.READ

            IF MESSAGE EQ 'REPEAT' THEN
                GOSUB MAIN.REPEAT ;* R22 Manual conversion - GOTO changed to GOSUB
            END

            GOSUB CHECK.RECORD      ;* Special Editing of Record

            CALL MATRIX.ALTER

            IF V$ERROR THEN ;* AUTO R22 CODE CONVERSION START
                GOSUB MAIN.REPEAT ;* R22 Manual conversion - GOTO changed to GOSUB
            END ;* AUTO R22 CODE CONVERSION END

            LOOP
                GOSUB PROCESS.FIELDS  ;* ) For Input
                GOSUB PROCESS.MESSAGE ;* ) Applications
            WHILE (MESSAGE EQ 'ERROR') REPEAT

        END

MAIN.REPEAT:
    REPEAT

V$EXIT:
RETURN  ;* From main program

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

        GOSUB CHECK.FIELDS        ;* Special Field Editing

        IF T.SEQU NE '' THEN
            T.SEQU<-1> = A + 1
        END ;* AUTO R22 CODE CONVERSION

    REPEAT

RETURN

*************************************************************************
PROCESS.MESSAGE:
* Processing after exiting from field input (PF5)
*
    IF MESSAGE EQ 'DEFAULT' THEN ;* AUTO R22 CODE CONVERSION
        MESSAGE = 'ERROR'         ;* Force the processing back
        IF V$FUNCTION NE 'D' AND V$FUNCTION NE 'R' THEN ;* AUTO R22 CODE CONVERSION
            GOSUB CROSS.VALIDATION
        END
    END

    IF BROWSER.PREVIEW.ON THEN  ;* EN_10002679 - s
* Clear BROWSER.PREVIEW.ON once inside the template so that after preview
* it might exit from the template, otherwise there will be looping within the template
        MESSAGE = 'PREVIEW'
        BROWSER.PREVIEW.ON = 0
    END     ;* EN_10002679 - e


    IF MESSAGE EQ 'PREVIEW' THEN ;* AUTO R22 CODE CONVERSION START
        MESSAGE = 'ERROR'         ;* Force the processing back
        IF V$FUNCTION NE 'D' AND V$FUNCTION NE 'R' THEN ;* AUTO R22 CODE CONVERSION START
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
                GOSUB CHECK.DELETE      ;* Special Deletion checks
            CASE V$FUNCTION EQ 'R'
                GOSUB CHECK.REVERSAL    ;* Special Reversal checks
            CASE OTHERWISE
                GOSUB CROSS.VALIDATION  ;* Special Cross Validation
                IF NOT(V$ERROR) THEN
                    GOSUB OVERRIDES
                END
        END CASE
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.UNAU.WRITE ;* Special Processing before write
        END
        IF NOT(V$ERROR) THEN
            CALL UNAUTH.RECORD.WRITE
            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.UNAU.WRITE          ;* Special Processing after write
            END
        END

    END

    IF MESSAGE EQ 'AUT' THEN
        GOSUB AUTH.CROSS.VALIDATION         ;* Special Cross Validation
        IF NOT(V$ERROR) THEN
            GOSUB BEFORE.AUTH.WRITE ;* Special Processing before write
        END

        IF NOT(V$ERROR) THEN

            CALL AUTH.RECORD.WRITE

            IF MESSAGE NE "ERROR" THEN
                GOSUB AFTER.AUTH.WRITE          ;* Special Processing after write
            END
        END

    END

RETURN

*************************************************************************
*                      Special Tailored Subroutines                     *
*************************************************************************
CHECK.ID:
* Validation and changes of the ID entered.  Sets V$ERROR to 1 if in error

    V$ERROR = 0
    E = ''

    IF E THEN
        V$ERROR = 1
        CALL ERR
    END

RETURN

*************************************************************************
CHECK.RECORD:
* Validation and changes of the Record.  Set V$ERROR to 1 if in error
*
* A application runnin in browser will enter CHECK.RECORD multiple
* times during a transaction lifecycle. Any validation that must only
* run when the user first opens the contract must be put in the following
* IF statement
*
    IF OFS$STATUS<STAT.FLAG.FIRST.TIME> THEN        ;* BG_100007114
*
        IF V$FUNCTION NE "I" THEN
            RETURN
        END
        SELECT.CMD = 'SELECT ':FN.REDO.COL.QUEUE.ERROR
        LIST.NAME = ''
        SELECTED = ''
        SYSTEM.RETURN.CODE = ''
        CALL EB.READLIST(SELECT.CMD,EXTRACT.ERROR.LIST,LIST.NAME,SELECTED,SYSTEM.RETURN.CODE)

        IF SELECTED GT 0 THEN
            R.NEW(1) = ""
            R.NEW(2) = ""
            R.NEW(3) = ""
            R.NEW(4) = ""
        END

        LOOP
* GET THE ERROR ITEM ONE BY ONE
            REMOVE EXTRACT.ERROR.ID FROM EXTRACT.ERROR.LIST SETTING EXTRACT.ERROR.MARK
        WHILE EXTRACT.ERROR.ID : EXTRACT.ERROR.MARK
            CALL CACHE.READ(FN.REDO.COL.QUEUE.ERROR,EXTRACT.ERROR.ID,R.REDO.COL.QUEUE.ERROR,YERR)

            Y.REDO.COL.DEL.INSERT = R.REDO.COL.QUEUE.ERROR<2>
            Y.REDO.COL.DEL.QUEUE.ID = EXTRACT.ERROR.ID  ;*
            Y.REDO.COL.DEL.TABLE.ID = R.REDO.COL.QUEUE.ERROR<1>
            Y.REDO.COL.DEL.ERROR = R.REDO.COL.QUEUE.ERROR<3>

            LOCATE Y.REDO.COL.DEL.TABLE.ID IN R.NEW(2)<1,1>  SETTING Y.POS THEN

            END ELSE
                R.NEW(2)<1,Y.POS> = Y.REDO.COL.DEL.TABLE.ID
            END

            R.NEW(3)<1,Y.POS,-1> = Y.REDO.COL.DEL.QUEUE.ID

            R.NEW(4)<1,Y.POS,-1> = Y.REDO.COL.DEL.INSERT

            R.NEW(5)<1,Y.POS,-1> = Y.REDO.COL.DEL.ERROR

            R.NEW(6)<1,Y.POS,-1> = "NO"

        REPEAT

    END

RETURN

*************************************************************************
CHECK.FIELDS:

* > CALL XX.CHECK.FIELDS
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

RETURN  ;* Back to field input via UNAUTH.RECORD.WRITE

*************************************************************************
OVERRIDES:
*
*  Overrides should reside here
*
    V$ERROR = ''
    ETEXT = ''
    TEXT = ''
* > CALL XX.OVERRIDE
*

*
    IF TEXT EQ "NO" THEN         ;* Said NO to override ;* AUTO R22 CODE CONVERSION
        V$ERROR = 1
        MESSAGE = "ERROR"         ;* Back to field input

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
*  Contract processing code should reside here
*
* > CALL XX.         ;* Accounting, Schedule processing etc etc

    IF TEXT EQ "NO" THEN         ;* Said No to override ;* AUTO R22 CODE CONVERSION
        CALL TRANSACTION.ABORT    ;* Cancel current transaction
        V$ERROR = 1
        MESSAGE = "ERROR"         ;* Back to field input
        RETURN
    END
*
* Additional updates should be performed here
*
* > CALL XX

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
        CASE R.NEW(V-8)[1,3] EQ "INA"          ;* Record status ;* AUTO R22 CODE CONVERSION

**************** MOVE THE AMENDED ELEMENTS TO THE CORRECT QUEUE
            Y.TOTAL = DCOUNT (R.NEW(2), @VM)

            FOR Y.CONT = 1 TO Y.TOTAL
                Y.TOTAL.FIJOS = DCOUNT(R.NEW(6)<1,Y.CONT>, @SM)
                FOR Y.CONT.FIJO = 1 TO Y.TOTAL.FIJOS
                    Y.FIXED = R.NEW(6)<1,Y.CONT,Y.CONT.FIJO>
                    IF Y.FIXED EQ 'SI' THEN

                        R.REDO.COL.QUEUE.ERROR<1> = R.NEW(2)<1,Y.CONT,Y.CONT.FIJO>
                        R.REDO.COL.QUEUE.ERROR<2> = R.NEW(4)<1,Y.CONT,Y.CONT.FIJO>
                        EXTRACT.ERROR.ID = R.NEW(3)<1,Y.CONT,Y.CONT.FIJO>

                        R.REDO.COL.QUEUE.ERROR<3> = ""
*WRITE INTO ERROR QUEUE THE UPDATED REGISTER
*DELETE THE  REGISTER WITH ERROR
                        CALL F.WRITE(FN.EXTRACT.CONTROL.QUEUE,EXTRACT.ERROR.ID,R.REDO.COL.QUEUE.ERROR)
*DELETE THE  REGISTER WITH ERROR

                        CALL F.DELETE(FN.REDO.COL.QUEUE.ERROR,EXTRACT.ERROR.ID)

                    END
                NEXT Y.CONT.FIJO
            NEXT Y.CONT
**************** END

        CASE R.NEW(V-8)[1,3] = "RNA"          ;* Record status
* > CALL XX.REVERSAL

    END CASE

*************************************************************************
CHECK.FUNCTION:
* Validation of function entered.  Sets V$FUNCTION to null if in error

    IF INDEX('V',V$FUNCTION,1) THEN
        E = 'EB.RTN.FUNT.NOT.ALLOWED.APP'
        CALL ERR
        V$FUNCTION = ''
    END

RETURN

*************************************************************************
INITIALISE:

    FN.EXTRACT.CONTROL.QUEUE = 'F.REDO.COL.QUEUE'
    F.EXTRACT.CONTROL.QUEUE = ''
    CALL OPF(FN.EXTRACT.CONTROL.QUEUE,F.EXTRACT.CONTROL.QUEUE)

    FN.REDO.COL.QUEUE.ERROR = 'F.REDO.COL.QUEUE.ERROR'
    F.EXTRACT.CONTROL.QUEUE.ERROR = ''
    CALL OPF(FN.REDO.COL.QUEUE.ERROR,F.EXTRACT.CONTROL.QUEUE.ERROR)


    BROWSER.PREVIEW.ON = (OFS$MESSAGE='PREVIEW')    ;*EN_10002679 - S/E

RETURN

*************************************************************************
DEFINE.PARAMETERS:
* SEE 'I_RULES' FOR DESCRIPTIONS *

    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""

    ID.F = "KEY" ; ID.N = "6.2" ; ID.T = "A"
    Z = 0
    Z += 1 ; F(Z) = "XX.LL.DESCRIPTION" ; N(Z) = "35.3" ; T(Z) = "A"

    Z += 1 ; F(Z) = "XX<TABLE.ID" ; N(Z) = "35" ; T(Z) = "A"
    Z += 1 ; F(Z) = "XX-XX<QUEUE.ID" ; N(Z) = "50" ; T(Z) = "A"
    Z += 1 ; F(Z) = "XX-XX-INSERT" ; N(Z) = "255" ; T(Z) = "A"; T(Z)<7> = "TEXT"

    Z += 1 ; F(Z) = "XX-XX-ERROR" ; N(Z) = "50" ; T(Z) = "A"
    Z += 1 ; F(Z) = "XX-XX-FIXED" ; N(Z) = "2" ; T(Z) = "A" :@FM:"SI_NO"
    Z += 1 ; F(Z) = "XX>XX>RESERVED.1" ; N(Z) = "30" ; T(Z) = "A"
    Z += 1 ; F(Z) = "RESERVED.2" ; N(Z) = "1" ; T(Z)<3> = "NOINPUT"
    Z += 1 ; F(Z) = "RESERVED.3" ; N(Z) = "1" ; T(Z)<3> = "NOINPUT"

    V = Z + 9 ; PREFIX = 'REDO.COL.DEL.'

RETURN

*************************************************************************

END
