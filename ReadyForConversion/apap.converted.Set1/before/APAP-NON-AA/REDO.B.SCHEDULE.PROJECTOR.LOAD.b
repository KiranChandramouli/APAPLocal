*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.SCHEDULE.PROJECTOR.LOAD
*-----------------------------------------------------------
*Description: This service routine is to update the concat table about the schedule projector
* for each arrangement. This needs to be runned only once after that activity api routine will
* update the concat table during schedule changes.
*-----------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.SCHEDULE.PROJECTOR.COMMON

  FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
  F.AA.ARRANGEMENT  = ''
  CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

  FN.REDO.AA.SCHEDULE = 'F.REDO.AA.SCHEDULE'
  F.REDO.AA.SCHEDULE  = ''
  CALL OPF(FN.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE)


  RETURN
END
