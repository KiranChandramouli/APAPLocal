*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GENERATE.NAB.ACCOUNTING.SELECT

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
$INSERT I_REDO.GENERATE.NAB.ACCOUNTING.COMMON
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

* If NAB Status change has happened during Holiday, then get the list of arrangements during those days

  DATE.DIFF = TIMEDIFF(Y.LAST.WORK.DATE,Y.DATE,'0')

  DATE.DIFF = DATE.DIFF<4>

  IF DATE.DIFF GT 1 THEN

    SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND NAB.CHANGE.DATE GT":Y.LAST.WORK.DATE

  END ELSE

    SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND NAB.CHANGE.DATE EQ ":Y.DATE

  END

  CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

  CALL BATCH.BUILD.LIST('', SEL.LIST)

  RETURN
*------------------------------------------------------------------------------------------------------------------
END
