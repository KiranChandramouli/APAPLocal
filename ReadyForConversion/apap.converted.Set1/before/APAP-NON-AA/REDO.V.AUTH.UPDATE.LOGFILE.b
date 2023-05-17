*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUTH.UPDATE.LOGFILE

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT

  FN.REDO.T.AZ.MODIFY.LOG = 'F.REDO.T.AZ.MODIFY.LOG'
  F.REDO.T.AZ.MODIFY.LOG = ''
  CALL OPF(FN.REDO.T.AZ.MODIFY.LOG, F.REDO.T.AZ.MODIFY.LOG)

  Y.ID = TODAY
  Y.VALUE = ID.NEW

  CALL CONCAT.FILE.UPDATE(FN.REDO.T.AZ.MODIFY.LOG, Y.ID, Y.VALUE, 'I', 'AR')

  RETURN
END
