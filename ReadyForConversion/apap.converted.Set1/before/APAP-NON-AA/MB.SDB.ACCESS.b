*-----------------------------------------------------------------------------
* <Rating>324</Rating>
*-----------------------------------------------------------------------------
* Version 6 22/05/01  GLOBUS Release No. R05.002 12/05/05

    SUBROUTINE MB.SDB.ACCESS

*********************************************************************

**********************************************************************
* 02/09/02 - GLOBUS_EN_10001055
*          Conversion Of all Error Messages to Error Codes
*********************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT      ;* Other Inserts required for Checkfiles, etc.
    $INSERT I_F.CUSTOMER
    $INSERT I_F.SEC.ACC.MASTER

*************************************************************************

    GOSUB INITIALISE          ;* Special Initialising

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    CALL MATRIX.UPDATE


*************************************************************************

* Main Program Loop

    LOOP

        CALL RECORDID.INPUT

    UNTIL MESSAGE = 'RET' DO

        V$ERROR = ''

        IF MESSAGE = 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

            GOSUB CHECK.ID    ;* Special Editing of ID
            IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ

            IF MESSAGE = 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            CALL MATRIX.ALTER

            GOSUB PROCESS.DISPLAY       ;* For Display applications

        END

MAIN.REPEAT:
    REPEAT

    V$EXIT:
    RETURN          ;* From main program

*************************************************************************
*                      S u b r o u t i n e s                            *
*************************************************************************

PROCESS.DISPLAY:

* Display the record fields.

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

* Validation and changes of the ID entered.  Set ERROR to 1 if in error.


    RETURN


*************************************************************************

CHECK.FUNCTION:

* Validation of function entered.  Set FUNCTION to null if in error.

    IF INDEX('V',V$FUNCTION,1) THEN
        E ='EB.RTN.FUNT.NOT.ALLOWED.APP.17'
        CALL ERR
        V$FUNCTION = ''
    END

    RETURN

*************************************************************************

INITIALISE:
*
* Define often used checkfile variables
*

    RETURN

*************************************************************************

DEFINE.PARAMETERS:  * SEE 'I_RULES' FOR DESCRIPTIONS *


    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""

    ID.F = "MB.SDB.ACCESS" ; ID.N = "36" ; ID.T = "A"
*
    Z=0
*
    Z+=1 ; F(Z) = "XX<TXN.REF" ; N(Z) = "14" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-ACCESS.NAME" ; N(Z) = "55" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-ACCESS.DATE" ; N(Z) = "8" ; T(Z) = "D"
    Z+=1 ; F(Z) = "XX-ACCESS.TIME" ; N(Z) = "5" ; T(Z) = "" ; T(Z)<4> = "R##:##"
    Z+=1 ; F(Z) = "XX>ACCESS.SLIP.NO" ; N(Z) = "15" ; T(Z) = "A"

*
REM > CHECKFILE(Z) = CHK.ACCOUNT
*

*
* Live files DO NOT require V = Z + 9 as there are not audit fields.
* But it does require V to be set to the number of fields
*

    V = Z

    RETURN

*************************************************************************

END

