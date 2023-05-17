*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.WOF.GROUP.ACCOUNT.SELECT
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.WOF.GROUP.ACCOUNT.SELECT
*-----------------------------------------------------------------
* Description : This routine used to raise the entry for group of aa loans
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      21-Nov-2011          Initial draft
*-----------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.WOF.GROUP.ACCOUNT.COMMON


  SEL.CMD = 'SELECT ':FN.REDO.WORK.INT.CAP.AMT:' WITH ENTRY NE YES'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,SEL.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN

END
