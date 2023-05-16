* @ValidationCode : MjoyNzYxMDk3MjI6VVRGLTg6MTY4NDE0OTE0MDYyODpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 May 2023 16:42:20
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.VALID.OCUPATION
*----------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion      Call method format changed
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON      ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE       ;*R22 AUTO CODE CONVERSION
    $INSERT I_F.CUSTOMER     ;*R22 AUTO CODE CONVERSION.END


    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""

    OCUPATION = COMI ;*  R.NEW(EB.CUS.LOCAL.REF)<1,CUS.POS>

    CALL APAP.LAPAP.LAPAPREGEXs(OCUPATION,code) ;* R22 Manual Code Conversion

    IF ISDIGIT(OCUPATION) OR code EQ 1 THEN

        ETEXT = "NO INTRODUCIR NUMEROS EN ESTE CAMPO "
        CALL STORE.END.ERROR

    END

RETURN

END
