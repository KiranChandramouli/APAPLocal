*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHECK.REQ.MASSIVE
*----------------------------------------------------
*Description: This is a Check Req routine for the version REDO.RATE.CHANGE,MASSIVE.INPUT
*----------------------------------------------------
* Modification History :
*
*   Date            Who                   Reference               Description
* 05 Dec 2011   H Ganesh               Massive rate              Initial Draft
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.RATE.CHANGE

  GOSUB OPENFILES
  GOSUB PROCESS
  RETURN
*----------------------------------------------------
OPENFILES:
*----------------------------------------------------
  FN.REDO.RATE.CHANGE = 'F.REDO.RATE.CHANGE'
  F.REDO.RATE.CHANGE = ''
  CALL OPF(FN.REDO.RATE.CHANGE,F.REDO.RATE.CHANGE)

  RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------

  R.REDO.RATE.CHANGE.CRIT = ''

  CALL F.READ(FN.REDO.RATE.CHANGE,ID.NEW,R.REDO.RATE.CHANGE.CRIT,F.REDO.RATE.CHANGE,RATE.ERR)

  IF R.REDO.RATE.CHANGE.CRIT THEN
    IF R.REDO.RATE.CHANGE.CRIT<REDO.RT.FILE.TYPE> NE 'MASSIVE' AND R.REDO.RATE.CHANGE.CRIT<REDO.RT.FILE.TYPE> NE '' THEN
      E = 'EB-REDO.NOT.A.MASSIVE'
      RETURN
    END
  END ELSE
    R.NEW(REDO.RT.FILE.TYPE) = 'MASSIVE'
  END
  RETURN
END
