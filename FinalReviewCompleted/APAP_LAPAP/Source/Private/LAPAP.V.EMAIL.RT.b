* @ValidationCode : MjoxODc3ODc0Nzk2OkNwMTI1MjoxNjg5MzM5NzI2NTAyOklUU1M6LTE6LTE6LTQ6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jul 2023 18:32:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -4
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.V.EMAIL.RT
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*13/07/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION             BP removed
*13/07/2023      SURESH                     MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------------------------
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
