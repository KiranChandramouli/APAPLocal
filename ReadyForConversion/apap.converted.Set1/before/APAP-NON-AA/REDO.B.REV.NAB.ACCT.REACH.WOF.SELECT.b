*-----------------------------------------------------------------------------
* <Rating>-14</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.REV.NAB.ACCT.REACH.WOF.SELECT
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.REV.NAB.ACCT.REACH.WOF.SELECT
*-----------------------------------------------------------------
* Description : This routine is used to reverse contingent cus a/c and internal ac
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      23-OCT-2011          WOF ACCOUTING - PACS00202156
*-----------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.REV.NAB.ACCT.REACH.WOF.COMMON
$INSERT I_F.DATES

MAIN:


  Y.DATE = TODAY
  Y.LAST.WORK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
  Y.LS.DATE = TODAY - 1

* If NAB Status change has happened during Holiday, then get the list of arrangements during those days

  DATE.DIFF = TIMEDIFF(Y.LAST.WORK.DATE,Y.DATE,'0')

  DATE.DIFF = DATE.DIFF<4>

*    IF DATE.DIFF GT 1 THEN

  SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND WOF.DATE EQ ":Y.DATE

*    END ELSE

*        SELECT.CMD = "SELECT ":FN.REDO.AA.NAB.HISTORY:" WITH STATUS EQ 'STARTED' AND WOF.DATE EQ ":Y.LS.DATE

*    END
*    DEBUG

  CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.REC,PGM.ERR)

  CALL BATCH.BUILD.LIST('', SEL.LIST)


  RETURN

END
