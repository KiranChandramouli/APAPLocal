*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AA.TRIGGER.ACCRUE.SELECT
*------------------------------------------------------
*Description: This routine selects the records to be processed
* multi thread routine
*------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_REDO.B.AA.TRIGGER.ACCRUE.COMMON

  GOSUB PROCESS
  RETURN
*------------------------------------------------------
PROCESS:
*------------------------------------------------------

  Y.LAST.WORKING.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
  Y.TODAY             = TODAY

  IF Y.LAST.WORKING.DATE[5,2] NE Y.TODAY[5,2] THEN          ;* We need to check if the last working day is previous month and today date is current month
    IF Y.TODAY[7,2] EQ '01' THEN
      CALL OCOMO("Month end COB but today is the first day of the month - ":Y.LAST.WORKING.DATE:' & ':Y.TODAY)
      RETURN
    END  ELSE
      CALL OCOMO("Processing started - ":Y.LAST.WORKING.DATE:' & ':Y.TODAY)
    END
  END ELSE
    CALL OCOMO("Month of last working day and today are same LWM - :":Y.LAST.WORKING.DATE:" & TM - ":Y.TODAY)
    RETURN          ;* No need to process this batch
  END

  SEL.CMD = "SELECT ":FN.AA.ACCOUNT.DETAILS:" WITH ARR.AGE.STATUS NE 'CUR'"     ;* Loans with aging bills

  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST)

  RETURN
END
