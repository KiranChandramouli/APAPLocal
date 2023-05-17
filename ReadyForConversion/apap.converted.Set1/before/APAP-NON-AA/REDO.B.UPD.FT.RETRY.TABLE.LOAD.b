*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPD.FT.RETRY.TABLE.LOAD
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
* This routine is the load routine of the batch job REDO.B.UPD.FT.RETRY.TABLE
*  which updates the local table REDO.STO.PENDING.RESUBMISSION and REDO.RESUBMIT.FT.DET
* This routine Opens the necessary files
* ------------------------------------------------------------------------------------------------
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
*   Date               who              Reference                   Description
* 03-JUN-2010   N.Satheesh Kumar    TAM-ODR-2009-10-0331          Initial Creation
*---------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.UPD.FT.RETRY.TABLE.COMMON

  GOSUB OPEN.FILES
  RETURN

*----------
OPEN.FILES:
*----------
*---------------------------------------
* This section opens the necessary files
*---------------------------------------

  FN.REDO.RESUBMIT.FT.DET = 'F.REDO.RESUBMIT.FT.DET'
  F.REDO.RESUBMIT.FT.DET = ''
  CALL OPF(FN.REDO.RESUBMIT.FT.DET,F.REDO.RESUBMIT.FT.DET)

  FN.REDO.STO.PENDING.RESUBMISSION = 'F.REDO.STO.PENDING.RESUBMISSION'
  F.REDO.STO.PENDING.RESUBMISSION = ''
  CALL OPF(FN.REDO.STO.PENDING.RESUBMISSION,F.REDO.STO.PENDING.RESUBMISSION)

  FN.OFS.RESPONSE.QUEUE = 'F.OFS.RESPONSE.QUEUE'
  F.OFS.RESPONSE.QUEUE = ''
  CALL OPF(FN.OFS.RESPONSE.QUEUE,F.OFS.RESPONSE.QUEUE)

  RETURN
END
