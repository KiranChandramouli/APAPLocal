* @ValidationCode : MjotODMwMDMwNTEzOkNwMTI1MjoxNjgxMzc2MDk4MTA5OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
SUBROUTINE  REDO.LY.V.PROD.DELAY
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
* PROGRAM NAME : REDO.LY.V.PROD.DELAY
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
*13.04.2023   Conversion Tool        R22               Auto Conversion     - No changes
*13.04.2023   Shanmugapriya M        R22               Manual Conversion   - No changes
*
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        Y.PROD.DELAY = R.NEW(REDO.PROG.PROD.DELAY)
    END ELSE
        Y.PROD.DELAY = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    Y.AVAIL.IF.DELAY = R.NEW(REDO.PROG.AVAIL.IF.DELAY)

    IF Y.AVAIL.IF.DELAY EQ 'SI' AND Y.PROD.DELAY EQ '' THEN
        AF = REDO.PROG.PROD.DELAY
        ETEXT = 'EB-REDO.V.DISDELAY'
        CALL STORE.END.ERROR
    END

RETURN

END
