*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TT.PASSBOOK.NEXT.TASK

$INSERT I_COMMON
$INSERT I_EQUATE

  CALL EB.SET.NEXT.TASK('TT.PASSBOOK.PRINT,REDO.PASSB I ':COMI)

  RETURN
