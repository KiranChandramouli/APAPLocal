$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.V.TXN.TYPE.F.INT
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
* PROGRAM NAME : REDO.LY.V.TXN.TYPE.F.INT
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
** 13-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 13-04-2023 Skanda R22 Manual Conversion - No changes
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        Y.TXN.TYPE.F.INT = R.NEW(REDO.PROG.TXN.TYPE.F.INT)
    END ELSE
        Y.TXN.TYPE.F.INT = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    Y.POINT.USE = R.NEW(REDO.PROG.POINT.USE)

    IF Y.POINT.USE EQ '1' AND Y.TXN.TYPE.F.INT EQ '' THEN
        AF = REDO.PROG.TXN.TYPE.F.INT
        ETEXT = 'EB-REDO.V.TXN.INT':@FM:Y.POINT.USE
        CALL STORE.END.ERROR
    END

RETURN

END
