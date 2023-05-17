SUBROUTINE REDO.B.LY.PGEN.TBM.SELECT
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine selects REDO.LY.MODALITY ids
*  This routine is the SELECT routine of the batch REDO.B.LY.PGEN.TBM which updates
*   REDO.LY.POINTS table based on the data defined in the parameter table
*   REDO.LY.MODALITY & REDO.LY.PROGRAM
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
*   Date               who           Reference            Description
* 06-SEP-2013       RMONDRAGON   ODR-2011-06-0243         First Version
*-------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_REDO.B.LY.PGEN.TBM.COMMON

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------
*----------------------------------
* This section selects the txns ids
*----------------------------------

    TBM.CMD = ''
    TBM.CMD = 'SSELECT ':FN.REDO.LY.TXN.BY.MOD:' LIKE ...':TODAY
    TBM.ID.LST = ''
    CALL EB.READLIST(TBM.CMD,TBM.ID.LST,'',TBM.CNT,TBM.ERR)
    CALL BATCH.BUILD.LIST('',TBM.ID.LST)

END
