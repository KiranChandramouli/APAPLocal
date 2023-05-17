*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.NEXT.IMMEDIATE.PAYMENT.AMT

*---------------------------------------------------------
* Description: This conversion routine calculates the next payment amount using the schedule projector routine
*
* In Param  : NA
* Out Param : NA

*--------------------------------------------------------------------------------
*Modification History:
*   DATE            WHO           REFERENCE                  DESCRIPTION
* 23-Nov-2012      H Ganesh      AA Overview Screen         Initial Draft
*----------------------------------------------------------------------------------



$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.ACCOUNT.DETAILS

  GOSUB PROCESS

  RETURN
*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

  FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
  F.AA.ACCOUNT.DETAILS = ''
  CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)



  Y.ID = O.DATA
  ARR.ID = FIELD(Y.ID,'-',1)

  IF ARR.ID ELSE
    O.DATA = ''
  END
  CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACC.DET,F.AA.ACCOUNT.DETAILS,ACT.ERR)
  Y.PAY.START.DATE = R.AA.ACC.DET<AA.AD.PAYMENT.START.DATE>
  IF Y.PAY.START.DATE ELSE
    Y.PAY.START.DATE = TODAY
  END
  Y.AMT = ''
  SIMULATION.REF = ''
  NO.RESET = '1'
  YREGION = ''
  YDATE = TODAY
  Y.YEAR = YDATE[1,4] + 1
  YDAYS.ORIG = Y.YEAR:TODAY[5,4]
  DATE.RANGE = Y.PAY.START.DATE:FM:YDAYS.ORIG     ;* Date range is passed for 1 years to avoid building schedule for whole loan term

  CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)

  GOSUB GET.NEXT.AMOUNT
  IF Y.AMT THEN
    O.DATA = 'Total Cuota: ':FMT(Y.AMT,'R2,#15')
  END ELSE
    O.DATA = ''
  END

  RETURN
*----------------------------------------------------------------------------------
GET.NEXT.AMOUNT:
*----------------------------------------------------------------------------------
  Y.DATES.CNT = DCOUNT(PAYMENT.DATES,FM)
  Y.VAR1=1
  LOOP

  WHILE Y.VAR1 LE Y.DATES.CNT
    Y.PAY.DATE = PAYMENT.DATES<Y.VAR1>
    IF Y.PAY.DATE GT TODAY THEN
      Y.NEXT.PAY.AMT = TOT.PAYMENT<Y.VAR1>
      Y.VAR1 = Y.DATES.CNT+1
    END
    Y.VAR1++
  REPEAT
  Y.AMT = Y.NEXT.PAY.AMT
  RETURN
END
