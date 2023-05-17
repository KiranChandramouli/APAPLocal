*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.NEXT.PAYMENT.AMOUNT(ARR.ID,Y.DATE,Y.AMT)

*---------------------------------------------------------
* Description: This routine calculates the next payment amount using the schedule projector routine.
*
* In Param  : NA
* Out Param : NA

*--------------------------------------------------------------------------------
*Modification History:
*   DATE            WHO           REFERENCE                  DESCRIPTION
* 05-Sep-2011      H Ganesh      PACS00113076 - B.16         Initial Draft
*----------------------------------------------------------------------------------



$INSERT I_COMMON
$INSERT I_EQUATE


  GOSUB PROCESS

  RETURN
*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

  Y.AMT = ''
  CALL REDO.TEMP.STORE.COMMON('STORE')
  NO.RESET='1'
  DATE.RANGE=''
  SIMULATION.REF=''
  CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
  CALL REDO.TEMP.STORE.COMMON('RESTORE')
  GOSUB GET.NEXT.AMOUNT

  RETURN
*----------------------------------------------------------------------------------
GET.NEXT.AMOUNT:
*----------------------------------------------------------------------------------
  Y.DATES.CNT = DCOUNT(PAYMENT.DATES,FM)
  Y.VAR1=1
  LOOP

  WHILE Y.VAR1 LE Y.DATES.CNT
    Y.PAY.DATE = PAYMENT.DATES<Y.VAR1>
    IF Y.PAY.DATE GT Y.DATE THEN
      Y.NEXT.PAY.AMT = TOT.PAYMENT<Y.VAR1>
      Y.VAR1 = Y.DATES.CNT+1
    END
    Y.VAR1++
  REPEAT
  Y.AMT = Y.NEXT.PAY.AMT
  RETURN
END
