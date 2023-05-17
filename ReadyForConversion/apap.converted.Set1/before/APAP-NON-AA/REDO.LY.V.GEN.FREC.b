*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
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
    ETEXT = 'EB-REDO.V.TXN.INT':FM:Y.POINT.USE
    CALL STORE.END.ERROR
  END

  RETURN

END
