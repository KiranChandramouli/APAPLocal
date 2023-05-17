SUBROUTINE REDO.GENERATE.WOF.ACCOUNTING.SELECT

*DESCRIPTION:
*------------
* This is the COB routine for CR-43.
*
* This will select the Arrangement IDs from the REDO.UPDATE.NAB.HISTORY file with WOF eq 'TODAY'
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
* 26 Feb 2012    Ravikiran AV              CR.43                 Initial Creation
*
*------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.GENERATE.WOF.ACCOUNTING.COMMON
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
    Y.LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    Y.LS.DATE = TODAY - 1

* If NAB Status change has happened during Holiday, then get the list of arrangements during those days

    DATE.DIFF = TIMEDIFF(Y.LAST.WORK.DATE,Y.DATE,'0')

    DATE.DIFF = DATE.DIFF<4>

    IF DATE.DIFF GT 1 THEN

        SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND WOF.DATE EQ ":Y.LAST.WORK.DATE

    END ELSE

        SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND WOF.DATE EQ ":Y.LS.DATE

    END

    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

    CALL BATCH.BUILD.LIST('', SEL.LIST)

RETURN
*------------------------------------------------------------------------------------------------------------------
END
