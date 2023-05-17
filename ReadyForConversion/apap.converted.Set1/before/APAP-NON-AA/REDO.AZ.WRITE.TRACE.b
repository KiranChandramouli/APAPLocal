*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AZ.WRITE.TRACE(Y.RTN.NAME, Y.AZ.ID)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON

  FN.REDO.AZ.TAM.TRACE = 'F.REDO.AZ.TAM.TRACE'
  F.REDO.AZ.TAM.TRACE = ''
  CALL OPF(FN.REDO.AZ.TAM.TRACE, F.REDO.AZ.TAM.TRACE)

  Y.BROWSER = OFS$BROWSER
  Y.VERSION = APPLICATION:PGM.VERSION
  Y.ROUTINE.NAME = Y.RTN.NAME
  Y.FUNCTION = V$FUNCTION
  Y.OFS.SOURCE = OFS$SOURCE.ID
  CALL ALLOCATE.UNIQUE.TIME(Y.TIME)

  Y.ID = Y.AZ.ID:Y.TIME
  Y.USER = OPERATOR
  Y.DATE.TIME = TIMEDATE()
  CHANGE ' ' TO '' IN Y.DATE.TIME
  CHANGE ':' TO '' IN Y.DATE.TIME
  CHANGE '.' TO '' IN Y.DATE.TIME
  Y.ARRAY = Y.VERSION:'*':Y.FUNCTION:'*':ID.NEW:'*':Y.BROWSER:'*':Y.DATE.TIME:'*':Y.USER:'*':Y.ROUTINE.NAME:'*':APPLICATION:'*':Y.OFS.SOURCE
*               1           2            3             4               5              6                7           8                        9

  CALL F.WRITE(FN.REDO.AZ.TAM.TRACE, Y.ID, Y.ARRAY)
  RETURN
END
