SUBROUTINE  REDO.V.DISDELAY
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
* PROGRAM NAME : REDO.V.DISDELAY
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*19.07.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
*28.11.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM

    IF VAL.TEXT THEN
        Y.DIS.DELAY = R.NEW(REDO.PROG.AVAIL.IF.DELAY)
    END ELSE
        Y.DIS.DELAY = COMI
    END

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    IF VAL.TEXT EQ '' THEN
        VAL.TEXT = 'VALIDATED'
        CALL REDO.V.AVAIL.PROGRAM
        VAL.TEXT = ''
    END ELSE
        CALL REDO.V.AVAIL.PROGRAM
    END

    IF Y.DIS.DELAY EQ 'NO' THEN
        T(REDO.PROG.PROD.DELAY)<3> = 'NOINPUT'
        T(REDO.PROG.PER.IF.DELAY)<3> = 'NOINPUT'
    END

RETURN

*------------------------------------------------------------------------------------
END
