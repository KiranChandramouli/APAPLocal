*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RATE.CHANGE.CHRG
*----------------------------------------------------------------
* DESCRIPTION: This routine is a validation routine to make Interest Field as no - inputtable

*----------------------------------------------------------------
* Modification History :
*
*  DATE             WHO          REFERENCE           DESCRIPTION
* 12-Jul-2011     H GANESH     PACS00055012 - B.16  INITIAL CREATION
*----------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.RATE.CHANGE.CRIT

  GOSUB PROCESS
  RETURN

*----------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------
  IF COMI EQ '' THEN
    R.NEW(RATE.CHG.MARGIN.OPERAND)<1,AV> = ''
    RETURN
  END ELSE
    GOSUB CHECK.COND
  END

  RETURN
*----------------------------------------------------------------
CHECK.COND:
*----------------------------------------------------------------

  IF R.NEW(RATE.CHG.PROP.INT.CHG)<1,AV> NE '' THEN
    ETEXT = 'EB-REDO.MARGIN.NOT.ALLW'
    CALL STORE.END.ERROR
    RETURN
  END
  IF R.NEW(RATE.CHG.MARGIN.OPERAND)<1,AV> EQ '' THEN
    Y.TEMP.AF = AF
    AF = RATE.CHG.MARGIN.OPERAND
    ETEXT = 'AC-MAND.INP'
    CALL STORE.END.ERROR
    AF = Y.TEMP.AF
    ETEXT = ''
  END

  RETURN
END
