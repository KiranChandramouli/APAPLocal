*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.ARCHIEVE.TRACE(TRACE.ARC.ID)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.AUDIT.TRAIL.LOG
$INSERT I_F.REDO.EX.AUDIT.TRAIL.LOG
$INSERT I_REDO.B.ARCHIEVE.TRACE.COMMON
*-----------------------------------------------------------------------------
* Move the files from REDO.AUDIT.TRAIL.LOG to Y.PATH
*-----------------------------------------------------------------------------

  GOSUB INIT
  GOSUB PROCESS

  RETURN

INIT:
  Y.CMD.CPY = ''

  RETURN

*-------
PROCESS:
*-------

  Y.CMD.CPY = 'COPY FROM ':FN.REDO.AUDIT.TRAIL.LOG:' TO ':Y.PATH: ' ': TRACE.ARC.ID
  EXECUTE Y.CMD.CPY

  RETURN
END
