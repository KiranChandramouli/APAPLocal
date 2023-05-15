* @ValidationCode : MjoxODM5MjY2NDg0OkNwMTI1MjoxNjgyMzE1MTU5MTgwOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 11:15:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.VALID.OCUPATION
*----------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON      ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE       ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.CUSTOMER     ;*R22 AUTO CODE CONVERSION.END


    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""

    OCUPATION = COMI ;*  R.NEW(EB.CUS.LOCAL.REF)<1,CUS.POS>

    CALL LAPAP.REGEXs(OCUPATION,code)

    IF ISDIGIT(OCUPATION) OR code EQ 1 THEN

        ETEXT = "NO INTRODUCIR NUMEROS EN ESTE CAMPO "
        CALL STORE.END.ERROR

    END

RETURN

END
