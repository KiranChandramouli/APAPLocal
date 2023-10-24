$PACKAGE APAP.TAM
SUBROUTINE  REDO.LY.V.PER.IF.DELAY
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
* PROGRAM NAME : REDO.LY.V.PER.IF.DELAY
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes
* -----------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        Y.PER.IF.DELAY = R.NEW(REDO.PROG.PER.IF.DELAY)
    END ELSE
        Y.PER.IF.DELAY = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    Y.AVAIL.IF.DELAY = R.NEW(REDO.PROG.AVAIL.IF.DELAY)

    IF Y.AVAIL.IF.DELAY EQ 'SI' AND Y.PER.IF.DELAY EQ '' THEN
        AF = REDO.PROG.PER.IF.DELAY
        ETEXT = 'EB-REDO.V.DISDELAY'
        CALL STORE.END.ERROR
    END

    IF Y.AVAIL.IF.DELAY EQ 'SI' AND Y.PER.IF.DELAY LT '1' OR Y.PER.IF.DELAY GT '100' THEN
        AF = REDO.PROG.PER.IF.DELAY
        ETEXT = 'EB-REDO.LY.V.PERIFDELAY'
        CALL STORE.END.ERROR
    END

RETURN

END
