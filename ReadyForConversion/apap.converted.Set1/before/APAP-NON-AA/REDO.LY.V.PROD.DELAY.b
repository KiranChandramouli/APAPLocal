*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
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
