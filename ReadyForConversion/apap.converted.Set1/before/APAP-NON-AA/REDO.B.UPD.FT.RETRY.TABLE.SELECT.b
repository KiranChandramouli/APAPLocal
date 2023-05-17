*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.FT.RETRY.TABLE.SELECT
*-------------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the SELECT routine of the batch job REDO.B.UPD.FT.RETRY.TABLE
*   which updates the local table REDO.STO.PENDING.RESUBMISSION and REDO.RESUBMIT.FT.DET
* This routine selects the records from REDO.RESUBMIT.FT.DET
* ------------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference                     Description
* 03-JUN-2010   N.Satheesh Kumar  TAM-ODR-2009-10-0331           Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.UPD.FT.RETRY.TABLE.COMMON

  SEL.CMD = 'SELECT ':FN.REDO.RESUBMIT.FT.DET
  CALL EB.READLIST(SEL.CMD,ARR.SEL.LST,'',NO.REC,SEL.ERR)
  CALL BATCH.BUILD.LIST('',ARR.SEL.LST)
  RETURN
END
