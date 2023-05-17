*-----------------------------------------------------------------------------
* <Rating>-42</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.NOFILE.AA.OVERVIEW.PAYSCH(SCHED.ARR)
*----------------------------------------------------------------
*Description: This is the nofile enquiry routine to display the payment details
*              in the Overview screen.
*----------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.PAYMENT.SCHEDULE

  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------

  LOCATE 'ARRANGEMENT.ID' IN D.FIELDS<1> SETTING POS1 THEN
    Y.ARR.ID = D.RANGE.AND.VALUE<POS1>
  END
  GOSUB GET.DATE
  IF Y.DATE THEN
    GOSUB GET.DETAILS
  END
  RETURN
*---------------------------------------------------------------
GET.DATE:
*---------------------------------------------------------------
  ARR.ID = Y.ARR.ID
  SIMULATION.REF = ''
  NO.RESET       = '1'

  DATE.RANGE     = ''
  CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
  Y.DATE = ''
  Y.DATES.CNT = DCOUNT(PAYMENT.DATES,FM)
  Y.VAR1=1
  LOOP

  WHILE Y.VAR1 LE Y.DATES.CNT

    Y.PAY.DATE = PAYMENT.DATES<Y.VAR1>
    Y.PAY.AMT  = TOT.PAYMENT<Y.VAR1>
    IF Y.PAY.DATE GT TODAY THEN
      Y.DATE = Y.PAY.DATE
      Y.VAR1 = Y.DATES.CNT+1
    END
    IF Y.PAY.AMT THEN
      Y.LAST.DATE.AMT = Y.PAY.DATE
    END

    Y.VAR1++
  REPEAT
  IF Y.DATE ELSE    ;* Last payment date has been assigned
    Y.DATE = Y.PAY.DATE
  END
  IF Y.PAY.AMT ELSE
    Y.DATE = Y.LAST.DATE.AMT  ;* This is for the payoff case where amt is zero for next schedule.
  END

  RETURN
*---------------------------------------------------------------
GET.DETAILS:
*---------------------------------------------------------------

  BACKUP.ENQ.SELECTION = ENQ.SELECTION
  ENQ.SELECTION<2>   = "ARRANGEMENT.ID":VM:"DATE.DUE"
  ENQ.SELECTION<4>   = Y.ARR.ID:VM:Y.DATE

  CALL REDO.E.AA.FULL.SCHEDULE.PROJECTOR(SCHED.ARR)
  ENQ.SELECTION = BACKUP.ENQ.SELECTION

  GOSUB GET.PAYMENT.SCHEDULE
  IF R.CONDITION ELSE
    RETURN
  END
  Y.VAR2 = 1
  Y.ARRAY.CNT = DCOUNT(SCHED.ARR,FM)
  LOOP
  WHILE Y.VAR2 LE Y.ARRAY.CNT
    Y.ARRAY = SCHED.ARR<Y.VAR2>
    Y.PAY.TYPE = FIELD(Y.ARRAY,"*",1)

    IF Y.PAY.TYPE THEN
      LOCATE Y.PAY.TYPE IN R.CONDITION<AA.PS.PAYMENT.TYPE,1> SETTING POS2 THEN
        Y.FREQ = R.CONDITION<AA.PS.PAYMENT.FREQ,POS2>
        SCHED.ARR<Y.VAR2>:='*':Y.FREQ
      END
    END
    Y.VAR2++
  REPEAT
  RETURN
*----------------------------------------------
GET.PAYMENT.SCHEDULE:
*----------------------------------------------

  EFF.DATE   = ''
  PROP.CLASS ='PAYMENT.SCHEDULE'
  PROPERTY   = ''
  R.CONDITION= ''
  ERR.MSG    = ''
  CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)


  RETURN
END
