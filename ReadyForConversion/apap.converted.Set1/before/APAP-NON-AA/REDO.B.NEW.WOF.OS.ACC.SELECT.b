*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.NEW.WOF.OS.ACC.SELECT
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.NEW.WOF.OS.ACC.SELECT
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
* ODR-2011-12-0017      23-OCT-2011          Wof accounting - PACS00202156.
*-----------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.NEW.WOF.OS.ACC.COMMON



*SEL.CMD = 'SELECT ':FN.REDO.NEW.WORK.INT.CAP.OS:' WITH ENTRY NE YES'
  SEL.CMD = 'SELECT ':FN.REDO.ACCT.MRKWOF.HIST:' WITH STATUS EQ INITIATED'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,SEL.ERR)

  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN

END
