* @ValidationCode : MjoxMzU1OTgyMjg1OkNwMTI1MjoxNjgxMzc2MDk4MDEyOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Apr 2023 14:24:58
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
SUBROUTINE  REDO.LY.V.GEN.FREC
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This routine is used to validate the REDO.LY.PROGRAM table fields
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RMONDRAGON
* PROGRAM NAME : REDO.LY.V.GEN.FREC
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*13.04.2023    Conversion Tool       R22               Auto Conversion     - FM TO @FM
*13.04.2023    Shanmugapriya M       R22               Manual Conversion   - No changes
*
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        Y.GEN.FREC = R.NEW(REDO.PROG.GEN.FREC)
    END ELSE
        Y.GEN.FREC = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    Y.POINT.USE = R.NEW(REDO.PROG.POINT.USE)

    IF Y.POINT.USE EQ '2' AND Y.GEN.FREC EQ '' THEN
        AF = REDO.PROG.GEN.FREC
        ETEXT = 'EB-REDO.V.TXN.INT':@FM:Y.POINT.USE
        CALL STORE.END.ERROR
    END

RETURN

END
