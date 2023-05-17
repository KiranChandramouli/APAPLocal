*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AA.TRIGGER.ACCRUE.LOAD
*-----------------------------------------------------
*Description: This routine is to load the common variable required for
* batch routine.
*-----------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.AA.TRIGGER.ACCRUE.COMMON

  GOSUB PROCESS
  RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------

  FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
  F.AA.ACCOUNT.DETAILS  = ''
  CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

  FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
  F.AA.BILL.DETAILS  = ''
  CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

  YREGION     = ''
  YDATE       = TODAY
  YDAYS.ORIG  = '-1C'
  CALL CDT(YREGION,YDATE,YDAYS.ORIG)
  Y.ACTIVITY.EFF.DATE = YDATE

  RETURN
END
