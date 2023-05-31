* @ValidationCode : MjotMTY3OTM0NDc0NDpDcDEyNTI6MTY4NTUzNDg0OTExMTpoYWk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 17:37:29
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
SUBROUTINE LAPAP.VAL.IDENT.CEDULA
*--------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,= TO EQ, REM TO DISPLAY.MESSAGE(TEXT, '')
*21-04-2023       Samaran T               R22 Manual Code Conversion       CALL ROUTINE FORMAT MODIFIED
*----------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START

    $INSERT I_EQUATE

    $INSERT I_F.DEPT.ACCT.OFFICER    ;*R22 AUTO CODE CONVERSION.END
    
    $USING APAP.REDOSRTN

    VAL.IDENTIFICACION   =  COMI

    APAP.REDOSRTN.redoSCalcCheckDigit(VAL.IDENTIFICACION)   ;*R22 MANUAL CODE CONVERSION

    IF VAL.IDENTIFICACION EQ "PASS" THEN

        TEXT = "LA CEDULA ES VALIDA"
        CALL DISPLAY.MESSAGE(TEXT, '')      ;*R22 AUTO CODE CONVERSION

    END ELSE

        TEXT = "LA CEDULA NO ES VALIDA, VERIFIQUE SI ES UN PASAPORTE"
        CALL DISPLAY.MESSAGE(TEXT, '')     ;*R22 AUTO CODE CONVERSION

    END
