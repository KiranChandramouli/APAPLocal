*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.LY.V.AVAIL.DATE
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
* PROGRAM NAME : REDO.LY.V.AVAIL.DATE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*30.11.2011   RMONDRAGON         ODR-2011-06-0243      INITIAL CREATION
* -----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LY.PROGRAM

  IF VAL.TEXT THEN
    Y.AVAIL.DATE = R.NEW(REDO.PROG.AVAIL.DATE)
  END ELSE
    Y.AVAIL.DATE = COMI
  END

  GOSUB PROCESS

  RETURN

*-------
PROCESS:
*-------

  VAR.AVAILABILITY = R.NEW(REDO.PROG.AVAILABILITY)

  IF VAR.AVAILABILITY EQ '4' AND Y.AVAIL.DATE EQ '' THEN
    AF = REDO.PROG.AVAIL.DATE
    ETEXT = 'EB-REDO.V.AVAIL.PROGRAM':FM:VAR.AVAILABILITY
    CALL STORE.END.ERROR
  END

  Y.START.DATE = R.NEW(REDO.PROG.START.DATE)

  IF VAR.AVAILABILITY EQ '4' AND Y.AVAIL.DATE NE '' THEN
    IF Y.AVAIL.DATE LT Y.START.DATE THEN
      AF = REDO.PROG.AVAIL.DATE
      ETEXT = 'EB-REDO.V.AVAIL.PROGRAM2'
      CALL STORE.END.ERROR
    END
  END

  RETURN

END
