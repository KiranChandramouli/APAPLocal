*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.WOF.LOAN.HIST.UPDATE.SELECT
*-----------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.WOF.LOAN.HIST.UPDATE
*-----------------------------------------------------------------
* Description : This routine is used to update the outstanding and paid interest and principal amt
*               in the local table REDO.ACCT.MRKWOF.HIST
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017   21-Nov-2011          Initial draft
*-----------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.WOF.LOAN.HIST.UPDATE.COMMON


  SEL.CMD = 'SELECT ':FN.REDO.ACCT.MRKWOF.HIST:' WITH STATUS EQ INITIATED'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN

END
