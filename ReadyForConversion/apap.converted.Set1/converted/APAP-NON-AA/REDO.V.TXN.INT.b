SUBROUTINE  REDO.V.TXN.INT
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
*26.07.2011    RMONDRAGON         ODR-2011-06-0243       UPDATE
* -----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LY.PROGRAM
    $INSERT I_GTS.COMMON

    IF VAL.TEXT THEN
        RETURN
    END ELSE
        GOSUB PROCESS
    END

RETURN

*-------
PROCESS:
*-------
    VAR.POINT.USE = COMI

    IF VAR.POINT.USE EQ '2' THEN
        T(REDO.PROG.TXN.TYPE.F.INT)<3> = 'NOINPUT'
        T(REDO.PROG.PRODUCT)<3> = 'NOINPUT'
        T(REDO.PROG.INT.ACCT)<3> = 'NOINPUT'
        R.NEW(REDO.PROG.TXN.TYPE.F.INT) = ''
        R.NEW(REDO.PROG.PRODUCT) = ''
        R.NEW(REDO.PROG.INT.ACCT) = ''
    END

    IF VAR.POINT.USE EQ '1' THEN
        T(REDO.PROG.GEN.FREC)<3> = 'NOINPUT'
        R.NEW(REDO.PROG.GEN.FREC) = ''
    END

    IF VAR.POINT.USE EQ '3' OR VAR.POINT.USE EQ '4' THEN
        T(REDO.PROG.GEN.FREC)<3> = 'NOINPUT'
        T(REDO.PROG.TXN.TYPE.F.INT)<3> = 'NOINPUT'
        T(REDO.PROG.PRODUCT)<3> = 'NOINPUT'
        T(REDO.PROG.INT.ACCT)<3> = 'NOINPUT'
        R.NEW(REDO.PROG.GEN.FREC) = ''
        R.NEW(REDO.PROG.TXN.TYPE.F.INT) = ''
        R.NEW(REDO.PROG.PRODUCT) = ''
        R.NEW(REDO.PROG.INT.ACCT) = ''
    END

RETURN
*------------------------------------------------------------------------------------
END
