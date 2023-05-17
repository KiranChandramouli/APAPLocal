*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.STO.OVERRIDE.SELECT
*--------------------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine is the select routine of the batch job REDO.B.STO.OVERRIDE
* This routine select the FT records in IHLD condition under the certain condition falls.
* -------------------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : FT.ID
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS     : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date           who           Reference                          Description
* 24-AUG-2011   Sudharsanan   TAM-ODR-2009-10-0331(PACS0054326)   Initial Creation
*---------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_REDO.B.STO.OVERRIDE.COMMON
  GOSUB PROCESS
  RETURN
*-------
PROCESS:
*-------
  SEL.CMD="SSELECT ":FN.FUNDS.TRANSFER:" WITH RECORD.STATUS EQ IHLD AND INWARD.PAY.TYPE LIKE STO... AND DEBIT.VALUE.DATE EQ ":TODAY
  CALL EB.READLIST(SEL.CMD,PROCESS.LIST,'',NOR,ERR)
  CALL BATCH.BUILD.LIST('',PROCESS.LIST)
  RETURN
*---------------------------------------------------------------------------------------------------------
END
