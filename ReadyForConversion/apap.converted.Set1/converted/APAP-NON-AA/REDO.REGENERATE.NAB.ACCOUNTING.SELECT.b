SUBROUTINE REDO.REGENERATE.NAB.ACCOUNTING.SELECT

*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will select the Arrangement IDs from the REDO.UPDATE.NAB.HISTORY file with STATUS is STARTED.
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 05 Dec 2011    Ravikiran AV              CR.41                 Initial Creation
*
*------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.REGENERATE.NAB.ACCOUNTING.COMMON
    $INSERT I_F.DATES

*------------------------------------------------------------------------------------------------------------------
*Main Logic of the routine
*
MAIN.LOGIC:

    GOSUB PROCESS

RETURN
*------------------------------------------------------------------------------------------------------------------
* Load the Arrangement ids for Multi-Threaded Processing
*
PROCESS:

    Y.DATE = TODAY

    SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH LAST.PAY.DATE EQ ":Y.DATE

    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

    CALL BATCH.BUILD.LIST('', SEL.LIST)

RETURN
*------------------------------------------------------------------------------------------------------------------
END
