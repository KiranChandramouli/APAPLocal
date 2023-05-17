*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.IVR.GET.MONTHINT
*-------------------------------------------------------------------------
* DESCRIPTION:
*------------
*   To get the interest of the month.
*-------------------------------------------------------------------------
* HISTORY:
*---------
*   Date               who           Reference            Description

* 08-MAY-2014       RMONDRAGON      ODR-2011-02-0099     Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.SCHEDULES

  GOSUB OPEN.FILES
  GOSUB PROCESS
  RETURN

*-----------------------------------------------------------------------------
OPEN.FILES:
*-----------------------------------------------------------------------------

  FN.AZ.SCHEDULES = 'F.AZ.SCHEDULES'
  F.AZ.SCHEDULES = ''
  CALL OPF(FN.AZ.SCHEDULES,F.AZ.SCHEDULES)

  RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

  R.AZ.SCHEDULES = ''; AZ.ERR = ''
  CALL F.READ(FN.AZ.SCHEDULES,O.DATA,R.AZ.SCHEDULES,F.AZ.SCHEDULES,AZ.ERR)
  IF R.AZ.SCHEDULES THEN
    Y.DATES = R.AZ.SCHEDULES<AZ.SLS.DATE>
    Y.INT.AMTS = R.AZ.SCHEDULES<AZ.SLS.TYPE.I>
  END

  Y.DATE.TO.CHECK = TODAY[1,6]

  Y.TOT.DATES = DCOUNT(Y.DATES,VM)
  Y.CNT.DATE = 1
  LOOP
  WHILE Y.CNT.DATE LE Y.TOT.DATES
    Y.DATE = FIELD(Y.DATES,VM,Y.CNT.DATE)
    Y.DATE = Y.DATE[1,6]
    IF (Y.DATE.TO.CHECK EQ Y.DATE) AND (Y.CNT.DATE NE 1) THEN
      Y.INT.AMT = FIELD(Y.INT.AMTS,VM,Y.CNT.DATE)
      Y.CNT.DATE = Y.TOT.DATES
    END
    Y.CNT.DATE++
  REPEAT

  O.DATA = Y.INT.AMT

  RETURN

*-----------------------------------------------------------------------------
END
