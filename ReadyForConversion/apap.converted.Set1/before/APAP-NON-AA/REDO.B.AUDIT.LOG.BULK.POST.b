*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AUDIT.LOG.BULK.POST

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_BATCH.FILES
$INSERT I_REDO.B.AUDIT.LOG.BULD.COMMON


  Y.FILE.NM = 'AUDITLOG.':TODAY:'.csv'

  SHELL.CMD ='SH -c '
  Y.EXE = "cat ":Y.PATH:"/*SEP":" >> ":Y.PATH:"/":Y.FILE.NM

  DAEMON.CMD = SHELL.CMD:Y.EXE
  EXECUTE DAEMON.CMD RETURNING RETURN.VALUE CAPTURING CAPTURE.CAT.VALUE

  Y.RM.EXE = "rm ":Y.PATH:"/*SEP"
  DAEMON.REM.CMD  = SHELL.CMD:Y.RM.EXE
  EXECUTE DAEMON.REM.CMD RETURNING RET.VAL CAPTURING CAP.REM.VAL

END