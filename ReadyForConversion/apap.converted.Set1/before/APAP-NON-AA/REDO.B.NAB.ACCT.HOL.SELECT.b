*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.NAB.ACCT.HOL.SELECT

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.NAB.ACCT.HOL.COMMON
$INSERT I_F.DATES


  Y.NEX.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
  SEL.CMD = 'SELECT ':FN.REDO.AA.NAB.HISTORY:' WITH NAB.CHANGE.DATE GT ':TODAY:' AND NAB.CHANGE.DATE LT ':Y.NEX.DATE
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN

END
