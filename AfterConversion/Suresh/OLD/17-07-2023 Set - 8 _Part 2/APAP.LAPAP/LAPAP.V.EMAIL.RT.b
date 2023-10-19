* @ValidationCode : Mjo1ODI2NzQwODpDcDEyNTI6MTY4OTIzNjkxNjAwMTozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Jul 2023 13:58:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*13/07/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION             BP removed
*13/07/2023      SURESH                     MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.V.EMAIL.RT
    $INSERT I_COMMON ;*R22 Auto Conversion
    $INSERT I_EQUATE ;*R22 Auto Conversion
    $INSERT I_F.ST.LAPAP.MOD.DIRECCIONES ;*R22 Auto Conversion

    Y.EMAIL = COMI
*DEBUG
    IF Y.EMAIL EQ '' THEN
*TEXT = "EL CAMPO E-MAIL ESTA BLANCO"
*CALL REM
        RETURN
    END
    Y.REGEX = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$"
    Y.EVALUADO =  REGEXP(Y.EMAIL, Y.REGEX)
*DEBUG
    IF Y.EVALUADO EQ 1 THEN
        RETURN
    END ELSE
        ETEXT = "EL E-MAIL INGRESADO NO ES VALIDO."
        CALL STORE.END.ERROR
        RETURN
    END

END
