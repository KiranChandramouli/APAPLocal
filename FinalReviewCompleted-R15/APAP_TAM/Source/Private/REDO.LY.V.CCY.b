* @ValidationCode : MjotNTU3ODMyNTM3OkNwMTI1MjoxNjgxMzc2MDk3OTUwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 14:24:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.V.CCY
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the currency in REDO.LY.MODALITY application.
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.CCY
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*16.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*13.04.2023    Conversion Tool       R22               Auto Conversion     - FM TO @FM
*13.04.2023    Shanmugapriya M       R22               Manual Conversion   - No changes
*
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.MODALITY

    IF VAL.TEXT THEN
        GOSUB PROCESS
    END

RETURN

********
PROCESS:
*******

    Y.TYPE = R.NEW(REDO.MOD.TYPE)
    Y.CCY = R.NEW(REDO.MOD.CURRENCY)

    T(REDO.MOD.APP.TXN)<3> = 'NOINPUT'

*    IF Y.CCY EQ '' THEN
    IF Y.CCY EQ '' AND Y.TYPE NE '7' THEN
        AF = REDO.MOD.CURRENCY
        ETEXT = 'EB-REDO.CHECK.FIELDS':@FM:Y.TYPE
        CALL STORE.END.ERROR
    END

RETURN

END
