* @ValidationCode : MjoxMzMwMDYyNzA4OkNwMTI1MjoxNjgyMDc0MDU1ODQwOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:17:35
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

    VAL.IDENTIFICACION   =  COMI

    CALL APAP.TAM.REDO.S.CALC.CHECK.DIGIT(VAL.IDENTIFICACION)   ;*R22 MANUAL CODE CONVERSION

    IF VAL.IDENTIFICACION EQ "PASS" THEN

        TEXT = "LA CEDULA ES VALIDA"
        CALL DISPLAY.MESSAGE(TEXT, '')      ;*R22 AUTO CODE CONVERSION

    END ELSE

        TEXT = "LA CEDULA NO ES VALIDA, VERIFIQUE SI ES UN PASAPORTE"
        CALL DISPLAY.MESSAGE(TEXT, '')     ;*R22 AUTO CODE CONVERSION

    END
