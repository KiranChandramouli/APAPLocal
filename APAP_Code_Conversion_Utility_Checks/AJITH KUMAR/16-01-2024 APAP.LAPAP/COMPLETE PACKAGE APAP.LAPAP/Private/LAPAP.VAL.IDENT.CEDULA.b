* @ValidationCode : MjozMjU1MTU2MzA6Q3AxMjUyOjE2ODQyMjY0MTQzMjc6SVRTUzotMTotMTotMzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 14:10:14
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.VAL.IDENT.CEDULA
*--------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*21-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,= TO EQ, REM TO DISPLAY.MESSAGE(TEXT, '')
*21-04-2023       Samaran T               R22 Manual Code Conversion       CALL ROUTINE FORMAT MODIFIED
*----------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
   $USING EB.OverrideProcessing

    $INSERT I_EQUATE

    $INSERT I_F.DEPT.ACCT.OFFICER    ;*R22 AUTO CODE CONVERSION.END

    $USING APAP.REDOSRTN

    VAL.IDENTIFICACION   =  COMI

    APAP.REDOSRTN.redoSCalcCheckDigit(VAL.IDENTIFICACION)   ;*R22 MANUAL CODE CONVERSION

    IF VAL.IDENTIFICACION EQ "PASS" THEN

        TEXT = "LA CEDULA ES VALIDA"
*        CALL DISPLAY.MESSAGE(TEXT, '')      ;*R22 AUTO CODE CONVERSION
EB.OverrideProcessing.DisplayMessage(TEXT, '')      ;*R22 AUTO CODE CONVERSION;* R22 UTILITY AUTO CONVERSION

    END ELSE

        TEXT = "LA CEDULA NO ES VALIDA, VERIFIQUE SI ES UN PASAPORTE"
*        CALL DISPLAY.MESSAGE(TEXT, '')     ;*R22 AUTO CODE CONVERSION
EB.OverrideProcessing.DisplayMessage(TEXT, '')     ;*R22 AUTO CODE CONVERSION;* R22 UTILITY AUTO CONVERSION

    END
