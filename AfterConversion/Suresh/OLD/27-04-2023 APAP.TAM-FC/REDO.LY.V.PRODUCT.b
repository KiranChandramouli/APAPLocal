* @ValidationCode : MjotMTQ2MzM0OTAzNDpDcDEyNTI6MTY4MjQ5MjM0NTM0MjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2023 12:29:05
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
$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.V.PRODUCT
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
* PROGRAM NAME : REDO.LY.V.PRODUCT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*04.04.2023    Conversion Tool      R22               Auto Conversion     - No changes
*04.04.2023    Shanmugapriya M      R22               Manual Conversion   - No changes
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        Y.PRODUCT = R.NEW(REDO.PROG.PRODUCT)
    END ELSE
        Y.PRODUCT = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    Y.POINT.USE = R.NEW(REDO.PROG.POINT.USE)

*    IF Y.POINT.USE EQ '1' AND Y.PRODUCT EQ '' THEN
*        AF = REDO.PROG.PRODUCT
*        ETEXT = 'EB-REDO.V.TXN.INT':FM:Y.POINT.USE
*        CALL STORE.END.ERROR
*    END

RETURN

END
