*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.SCHEDULE.PROJECTOR(Y.AA.ID)
*----------------------------------------------------------
*------------------------------------------------------------
*Description: This service routine is to update the concat table about the schedule projector
* for each arrangement. This needs to be runned only once after that activity api routine will
* update the concat table during schedule changes.
*------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.SCHEDULE.PROJECTOR.COMMON

  CALL OCOMO("started processing the arrangement:[ ":Y.AA.ID:" ]")
  NO.RESET       = ''
  DATE.RANGE     = ''
  SIMULATION.REF = ''
  CALL AA.SCHEDULE.PROJECTOR(Y.AA.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
  R.REDO.AA.SCHEDULE    = ''
  R.REDO.AA.SCHEDULE<1> = LOWER(TOT.PAYMENT)
  R.REDO.AA.SCHEDULE<2> = LOWER(DUE.DATES)
  R.REDO.AA.SCHEDULE<3> = LOWER(DUE.TYPES)
  R.REDO.AA.SCHEDULE<4> = LOWER(DUE.METHODS)
  R.REDO.AA.SCHEDULE<5> = LOWER(DUE.TYPE.AMTS)
  R.REDO.AA.SCHEDULE<6> = LOWER(DUE.PROPS)
  R.REDO.AA.SCHEDULE<7> = LOWER(DUE.PROP.AMTS)
  R.REDO.AA.SCHEDULE<8> = LOWER(DUE.OUTS)
  R.REDO.AA.SCHEDULE<9> = 'BATCH'
  CALL F.WRITE(FN.REDO.AA.SCHEDULE,Y.AA.ID,R.REDO.AA.SCHEDULE)
  CALL OCOMO("Completed processing the arrangement:[ ":Y.AA.ID:" ]")

  RETURN
END
