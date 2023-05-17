*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.INS.CHG.EXP.SELECT
*
$INSERT I_EQUATE
$INSERT I_COMMON
$INSERT I_REDO.B.INS.CHG.EXP.COMMON


  SEL.CMD = 'SELECT ':FN.INSURANCE:' WITH POLICY.STATUS EQ VIGENTE AND POL.EXP.DATE LE ':TODAY
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN

END
