SUBROUTINE  REDO.V.EXP.DATE
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
* PROGRAM NAME : REDO.V.EXP.DATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*19.07.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
*30.11.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        VAR.EXP.DATE = R.NEW(REDO.PROG.EXP.DATE)
    END ELSE
        VAR.EXP.DATE = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    Y.EXP.TYPE = R.NEW(REDO.PROG.EXP.TYPE)

    IF Y.EXP.TYPE EQ 'POR.FECHA' AND VAR.EXP.DATE EQ '' THEN
        AF = REDO.PROG.EXP.DATE
        ETEXT = 'EB-REDO.V.EXP'
        CALL STORE.END.ERROR
    END

    Y.START.DATE = R.NEW(REDO.PROG.START.DATE)

    IF Y.EXP.TYPE EQ 'POR.FECHA' AND VAR.EXP.DATE NE '' THEN
        IF VAR.EXP.DATE LT Y.START.DATE THEN
            AF = REDO.PROG.EXP.DATE
            ETEXT = 'EB-REDO.V.AVAIL.PROGRAM2'
            CALL STORE.END.ERROR
        END
    END

RETURN

*------------------------------------------------------------------------------------
END
