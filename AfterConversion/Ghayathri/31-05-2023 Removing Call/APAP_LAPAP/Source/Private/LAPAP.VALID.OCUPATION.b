* @ValidationCode : MjotMTYzNTk5MjM2NjpDcDEyNTI6MTY4NTUzNDg4MTI0NTpoYWk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:38:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : hai
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
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

    APAP.LAPAP.LAPAPREGEXs(OCUPATION,code) ;* R22 Manual Code Conversion

    IF ISDIGIT(OCUPATION) OR code EQ 1 THEN

        ETEXT = "NO INTRODUCIR NUMEROS EN ESTE CAMPO "
        CALL STORE.END.ERROR

    END

RETURN

END
