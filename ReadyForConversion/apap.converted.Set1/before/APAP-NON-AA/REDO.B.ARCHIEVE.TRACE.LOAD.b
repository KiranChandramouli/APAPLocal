*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.ARCHIEVE.TRACE.LOAD

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.AUDIT.TRAIL.LOG
$INSERT I_F.REDO.EX.AUDIT.TRAIL.LOG
$INSERT I_REDO.B.ARCHIEVE.TRACE.COMMON

  GOSUB INIT
  GOSUB PROCESS

  RETURN

*----
INIT:
*----
*-------------------------------------------------
* This section initialises the necessary variables
*-------------------------------------------------

  FN.REDO.AUDIT.TRAIL.LOG = 'F.REDO.AUDIT.TRAIL.LOG'
  F.REDO.AUDIT.TRAIL.LOG  = ''
  R.REDO.AUDIT.TRAIL.LOG  = ''
  CALL OPF(FN.REDO.AUDIT.TRAIL.LOG,F.REDO.AUDIT.TRAIL.LOG)

  FN.REDO.EX.AUDIT.TRAIL.LOG = 'F.REDO.EX.AUDIT.TRAIL.LOG'
  F.REDO.EX.AUDIT.TRAIL.LOG  = ''
  R.REDO.EX.AUDIT.TRAIL.LOG  = ''
  CALL OPF(FN.REDO.EX.AUDIT.TRAIL.LOG,F.REDO.EX.AUDIT.TRAIL.LOG)

  RETURN

PROCESS:

  CALL CACHE.READ(FN.REDO.EX.AUDIT.TRAIL.LOG,'SYSTEM',R.REDO.EX.AUDIT.TRAIL.LOG,ERR.AUDIT.LOG.EX)
  Y.PATH = R.REDO.EX.AUDIT.TRAIL.LOG<REDO.EX.TRAIL.INFORMATION>

  RETURN
END
