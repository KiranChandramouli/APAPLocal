*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FI.FT.PROCESS.SELECT
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.FI.FT.PROCESS.COMMON

  GOSUB PROCESS
  RETURN
*-------
PROCESS:
*-------
  Y.SEL.CMD='SELECT ':FN.REDO.TEMP.FI.CONTROL:' WITH STATUS EQ ""'
  CALL EB.READLIST(Y.SEL.CMD,Y.REC.LIST,'',NO.OF.REC,Y.ERR)
  CALL BATCH.BUILD.LIST('',Y.REC.LIST)
  RETURN
END
