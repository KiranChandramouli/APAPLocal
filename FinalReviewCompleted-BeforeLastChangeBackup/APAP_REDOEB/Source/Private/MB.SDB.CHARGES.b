* @ValidationCode : MjoxNDY3OTIwMTYyOkNwMTI1MjoxNjgxOTc5NTk1NjAzOklUU1M6LTE6LTE6LTczOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -73
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
* Version 6 22/05/01  GLOBUS Release No. R05.002 12/05/05

SUBROUTINE MB.SDB.CHARGES

*********************************************************************

**********************************************************************
* 02/09/02 - GLOBUS_EN_10001055
*          Conversion Of all Error Messages to Error Codes
*
* 13-APR-2023     Conversion tool    R22 Auto conversion       = to EQ
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*********************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
*************************************************************************

    GOSUB INITIALISE          ;* Special Initialising

    GOSUB DEFINE.PARAMETERS

    IF LEN(V$FUNCTION) GT 1 THEN
        GOSUB V$EXIT ;* R22 Manual conversion - GOTO to GOSUB
    END

    CALL MATRIX.UPDATE


*************************************************************************

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

            GOSUB CHECK.ID    ;* Special Editing of ID
            IF V$ERROR THEN
                GOSUB MAIN.REPEAT ;* R22 Manual conversion - GOTO to GOSUB
            END ;*R22 Auto conversion

            CALL RECORD.READ

            IF MESSAGE EQ 'REPEAT' THEN
                GOSUB MAIN.REPEAT ;* R22 Manual conversion - GOTO to GOSUB
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

    ID.F = "MB.SDB.CHARGES" ; ID.N = "36" ; ID.T = "A"
*
    Z=0
*
    Z+=1 ; F(Z) = "XX<TXN.REF" ; N(Z) = "26" ; T(Z) = "A"
    Z+=1 ; F(Z) = "XX-PERIODIC.RENT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-DISCOUNT.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-VAT.AMOUNT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-DEPOSIT.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-INITIAL.OFFER.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-VAT.OFFER.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-TOTAL.CHARGE.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-REFUND.AMT" ; N(Z) = "19" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-PAY.REASON" ; N(Z) = "25" ; T(Z) = ""
    Z+=1 ; F(Z) = "XX-RENT.AMT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"
    Z+=1 ; F(Z) = "XX>RENT.VAT" ; N(Z) = "19" ; T(Z) = ""; T(Z)<1> = "AMT"

*
* > CHECKFILE(Z) = CHK.ACCOUNT ;*R22 Auto conversion REM to *
*

*
* Live files DO NOT require V = Z + 9 as there are not audit fields.
* But it does require V to be set to the number of fields
*

    V = Z

RETURN

*************************************************************************

END
