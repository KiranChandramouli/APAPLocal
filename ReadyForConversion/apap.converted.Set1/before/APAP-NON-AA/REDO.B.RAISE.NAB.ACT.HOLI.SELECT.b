*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.RAISE.NAB.ACT.HOLI.SELECT

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.RAISE.NAB.ACT.HOLI.COMMON

  SLEEP 60

  SEL.CMD = 'SELECT ':FN.REDO.AA.NAB.HISTORY:' WITH MARK.HOLIDAY EQ "YES" AND ACCT.YES.NO EQ "YES" AND STATUS EQ "STARTED" '
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ERR)

  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN

END
