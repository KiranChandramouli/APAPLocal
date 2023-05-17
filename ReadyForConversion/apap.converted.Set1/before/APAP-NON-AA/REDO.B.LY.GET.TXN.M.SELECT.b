*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LY.GET.TXN.M.SELECT
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the select routine of the batch job REDO.B.LY.GET.TXN.M which updates F.REDO.LY.TXN.BY.MOD file
* This routine selects the ACCT.ENT.TODAY file ids to be processed in the record routine of the batch job.
* ------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA--
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 03-MAY-2010   N.Satheesh Kumar  ODR-2009-12-0276      Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_REDO.B.LY.GET.TXN.M.COMMON

  SEL.CMD = 'SELECT ':FN.ACCT.ENT.TODAY
  CALL EB.READLIST(SEL.CMD,ACCT.ENT.TODAY.LIST,'',NO.OF.REC,'')
  CALL BATCH.BUILD.LIST('',ACCT.ENT.TODAY.LIST)

  RETURN
END
