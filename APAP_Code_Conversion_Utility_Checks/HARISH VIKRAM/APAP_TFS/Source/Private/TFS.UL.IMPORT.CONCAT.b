* @ValidationCode : MjoxNTMyMzY0ODMxOkNwMTI1MjoxNjk4NzUwNjc0NjQ5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 Oct 2023 16:41:14
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
*-----------------------------------------------------------------------------
* <Rating>137</Rating>
*-----------------------------------------------------------------------------
* Version 5 02/06/00  GLOBUS Release No. G14.0.00 03/07/03

SUBROUTINE TFS.UL.IMPORT.CONCAT

*-----------------------------------------------------------------------------
* Subroutine Type : Template subroutine for a Type TFS.UL.IMPORT.CONCAT Application
* Primary Purpose : To store the imported transaction references
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* 07/25/05 - Ganesh Prasad K
*            Teller/Session developments
*
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*26/10/2023         Ajithkumar             R22 Manual Conversion       GLOBUS.BP File is Removed, = TO EQ
*


    $INCLUDE  I_COMMON ;*R22 Manual Code Conversion - Start
    $INCLUDE  I_EQUATE
    $INCLUDE  I_GTS.COMMON ;*R22 Manual Code Conversion - End

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOTO V$EXIT
    END

    CALL MATRIX.UPDATE

REM > GOSUB INITIALISE                ;* Special Initialising

*-----------------------------------------------------------------------------------

* Main Program Loop

    LOOP

        CALL RECORDID.INPUT

    UNTIL MESSAGE = 'RET' DO

        V$ERROR = ''

        IF MESSAGE EQ 'NEW FUNCTION' THEN

            GOSUB CHECK.FUNCTION        ;* Special Editing of Function

            IF V$FUNCTION EQ 'E' OR V$FUNCTION EQ 'L' THEN
                CALL FUNCTION.DISPLAY
                V$FUNCTION = ''
            END

        END ELSE

REM >       GOSUB CHECK.ID                     ;* Special Editing of ID
REM >       IF V$ERROR THEN GOTO MAIN.REPEAT

            CALL RECORD.READ

            IF MESSAGE EQ 'REPEAT' THEN
                GOTO MAIN.REPEAT
            END

            CALL MATRIX.ALTER

            CALL TABLE.DISPLAY          ;* For Table Files

        END

MAIN.REPEAT:
    REPEAT

V$EXIT:
RETURN          ;* From main program

*-----------------------------------------------------------------------------------
*                      Special Tailored Subroutines                     *
*-----------------------------------------------------------------------------------

CHECK.ID:

* Validation and changes of the ID entered.  Set ERROR to 1 if in error.


RETURN


*-----------------------------------------------------------------------------------

CHECK.FUNCTION:

* Validation of function entered.  Set FUNCTION to null if in error.

    IF INDEX('V',V$FUNCTION,1) THEN
        E ='EB.RTN.FUNT.NOT.ALLOWED.APP.17'
        CALL ERR
        V$FUNCTION = ''
    END

RETURN

*-----------------------------------------------------------------------------------

INITIALISE:


RETURN

*-----------------------------------------------------------------------------------

DEFINE.PARAMETERS:  * SEE 'I_RULES' FOR DESCRIPTIONS *


    MAT F = "" ; MAT N = "" ; MAT T = ""
    MAT CHECKFILE = "" ; MAT CONCATFILE = ""
    ID.CHECKFILE = "" ; ID.CONCATFILE = ""

    ID.F  = "TFS.UL.KEY"; ID.N  = "35"; ID.T  = "A"
REM > ID.CHECKFILE = "Main.File.Name" : FM : Enrichment.Field
    Z = 0;
    Z +=1 ; F(Z)  = "TFS.TRAN.ID";  N(1)  = "35"
    V = Z
RETURN

*-----------------------------------------------------------------------------------

END
