SUBROUTINE REDO.B.LY.PGEN.ACCOP.SELECT
*-------------------------------------------------------------------------------------------------
*DESCRIPTION:
*  This routine selects all accounts with current opening date
*  This routine is the SELECT routine of the batch REDO.B.LY.PGEN.ACCOP which updates
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
* 17-JUN-2013   RMONDRAGON        ODR-2011-06-0243      Initial Creation
*----------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_REDO.B.LY.PGEN.ACCOP.COMMON

    GOSUB PROCESS

RETURN

*-------
PROCESS:
*-------

    SEL.LIST = ''
    IF PRG.RECSEL EQ 'Y' THEN
        SEL.ACC.CMD = 'SSELECT ':FN.ACCOUNT:' WITH ':Y.DATE.TO.SELECT
        SEL.LIST = ''
        CALL EB.READLIST(SEL.ACC.CMD,SEL.LIST,'',ID.CNT,'')
    END
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN

END
