*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.LY.V.MINMAX.USED
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
* PROGRAM NAME : REDO.LY.V.MINMAX.USED
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011    RMONDRAGON         ODR-2011-06-0243     FIRST VERSION
* -----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LY.PROGRAM

  IF VAL.TEXT THEN
    Y.MAX.POINT.USED = R.NEW(REDO.PROG.MAX.POINT.USED)
  END ELSE
    Y.MAX.POINT.USED = COMI
  END

  GOSUB PROCESS

  RETURN

*-------
PROCESS:
*-------

  Y.MIN.POINT.USED = R.NEW(REDO.PROG.MIN.POINT.USED)

  VAL.IF.N = Y.MIN.POINT.USED
  AF = REDO.PROG.MIN.POINT.USED
  GOSUB VAL.IF.NUM

  VAL.IF.N = Y.MAX.POINT.USED
  AF = REDO.PROG.MAX.POINT.USED
  GOSUB VAL.IF.NUM

  IF Y.MAX.POINT.USED LT Y.MIN.POINT.USED THEN
    ETEXT = 'EB-REDO.LY.V.MAX.POINT.USED'
    CALL STORE.END.ERROR
  END

  RETURN

*----------
VAL.IF.NUM:
*----------

  IF NOT(NUM(VAL.IF.N)) THEN
    ETEXT = 'EB-REDO.CHECK.FIELDS.F.NONUM'
    CALL STORE.END.ERROR
  END

  RETURN

*------------------------------------------------------------------------------------
END
