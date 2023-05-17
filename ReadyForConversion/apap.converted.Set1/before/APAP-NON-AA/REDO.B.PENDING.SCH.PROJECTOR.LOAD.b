*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.PENDING.SCH.PROJECTOR.LOAD
*-------------------------------------------------------------
*Description: This routine is to update the concat table REDO.AA.SCHEDULE with the loan's
*             Full schedule details by projecting the schedule using the API - AA.SCHEDULE.PROJECTOR
*             This is an activation service which will be running in AUTO mode.
*-------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.PENDING.SCH.PROJECTOR.COMMON

  GOSUB PROCESS
  RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------

  FN.REDO.AA.SCHEDULE = 'F.REDO.AA.SCHEDULE'
  F.REDO.AA.SCHEDULE  = ''
  CALL OPF(FN.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE)

  RETURN
END
