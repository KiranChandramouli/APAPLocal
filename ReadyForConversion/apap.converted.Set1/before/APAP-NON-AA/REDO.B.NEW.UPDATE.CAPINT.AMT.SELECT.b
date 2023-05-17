*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.NEW.UPDATE.CAPINT.AMT.SELECT
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.NEW.UPDATE.CAPINT.AMT.SELECT

*-----------------------------------------------------------------
* Description :
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017   23-Oct-2012            Wof Accounting - PACS00202156
*-----------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.NEW.UPDATE.CAPINT.AMT


  SEL.CMD = 'SELECT ':FN.REDO.ACCT.MRKWOF.HIST:' WITH STATUS EQ INITIATED'
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,SEL.ERR)

  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN

END
