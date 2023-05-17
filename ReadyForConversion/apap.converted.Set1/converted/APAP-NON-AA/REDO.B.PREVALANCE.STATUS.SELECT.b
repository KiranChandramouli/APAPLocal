SUBROUTINE REDO.B.PREVALANCE.STATUS.SELECT
*-------------------------------------------------------------------------------------------
*DESCRIPTION:
*             This routine selects the ids from ACCOUNT Application
* ------------------------------------------------------------------------------------------
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
*   Date            who           Reference            Description
* 03-MAY-2010   S.Jeyachandran  ODR-2010-08-0490      Initial Creation
*---------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_REDO.B.PREVALANCE.STATUS.COMMON
    $INSERT I_F.REDO.PREVALANCE.STATUS
*----------------------------------------------------------------------------

    GOSUB SELECT.PRGM
    GOSUB PROGRAM.END
RETURN
*-----------------------------------------------------------------------------
SELECT.PRGM:
*-----------------------------------------------------------------------------

    SEL.CMD = "SELECT ":FN.ACCOUNT:" WITH L.AC.STATUS1 NE '' OR L.AC.STATUS2 NE ''"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:
*-----------------------------------------------------------------------------
END
