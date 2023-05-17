*-----------------------------------------------------------------------------
* <Rating>9</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.MESSAGE(VAR.AC.ID)
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This deal slip routine is created FT and TT payment
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : TXN.ARRAY
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRABHU N
* PROGRAM NAME : REDO.GET.MESSAGE
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                REFERENCE         DESCRIPTION
*28.06.2010      PRABHU           ODR-2010-01-0081    INITIAL CREATION
* -----------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.OVERRIDE
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.AA.REFERENCE.DETAILS
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT I_F.REDO.RATE.CHANGE.MESSAGE
*DEBUG
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN
*----------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------


  Y.STR = VAR.AC.ID

  FN.REDO.NOTIFY.RATE.CHANGE = 'F.REDO.NOTIFY.RATE.CHANGE'
  F.REDO.NOTIFY.RATE.CHANGE = ''
  CALL OPF(FN.REDO.NOTIFY.RATE.CHANGE,F.REDO.NOTIFY.RATE.CHANGE)

  FN.REDO.RATE.CHANGE.MESSAGE = 'F.REDO.RATE.CHANGE.MESSAGE'
  F.REDO.RATE.CHANGE.MESSAGE = ''
  CALL OPF(FN.REDO.RATE.CHANGE.MESSAGE,F.REDO.RATE.CHANGE.MESSAGE)

  FN.AA.REFERENCE.DETAILS = 'F.AA.REFERENCE.DETAILS'
  F.AA.REFERENCE.DETAILS = ''
  CALL OPF(FN.AA.REFERENCE.DETAILS,F.AA.REFERENCE.DETAILS)

  FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
  F.AAA  = ''
  CALL OPF(FN.AAA,F.AAA)

  RETURN
*----------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------

  VAR.AC.ID = R.NEW(FT.CREDIT.ACCT.NO)

  R.NOTIFY.DETAIL = ''
  Y.ARR.ID = ''
  Y.ACC.NO = VAR.AC.ID
  CALL REDO.CONVERT.ACCOUNT(VAR.AC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
  VAR.AA.ID = OUT.ID
  CALL F.READ(FN.REDO.NOTIFY.RATE.CHANGE,VAR.AA.ID,R.NOTIFY.DETAIL,F.REDO.NOTIFY.RATE.CHANGE,NOTIFY.ERR)
  IF R.NOTIFY.DETAIL ELSE
    VAR.AC.ID = ''
    RETURN
  END
  GOSUB GET.LAST.PAYMENT.DATE
  IF Y.DATE THEN
    IF Y.DATE LE R.NOTIFY.DETAIL<2> THEN
      GOSUB FORM.MSG
    END ELSE
      VAR.AC.ID = ''
    END
  END ELSE
    GOSUB FORM.MSG
  END

  RETURN
*------------------------------------------------------
GET.LAST.PAYMENT.DATE:
*------------------------------------------------------
  Y.DATE = ''
  CALL F.READ(FN.AA.REFERENCE.DETAILS,VAR.AA.ID,R.AA.TXN.DET,F.AA.REFERENCE.DETAILS,TXN.REF.ERR)
  IF R.AA.TXN.DET THEN
    Y.ACTIVITY.CNT = DCOUNT(R.AA.TXN.DET<AA.REF.TRANS.REF>,VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.ACTIVITY.CNT
      Y.AAA.ID = R.AA.TXN.DET<AA.REF.AAA.ID,Y.VAR1>
      CALL F.READ(FN.AAA,Y.AAA.ID,R.AAA,F.AAA,AAA.ERR)
      Y.ACT.CLASS = R.AAA<AA.ARR.ACT.ACTIVITY.CLASS>
      IF Y.ACT.CLASS NE 'LENDING-DISBURSE-TERM.AMOUNT' AND Y.ACT.CLASS NE '' THEN
        IF R.AAA<AA.ARR.ACT.EFFECTIVE.DATE> LT TODAY THEN
          Y.DATE = R.AAA<AA.ARR.ACT.EFFECTIVE.DATE>
        END
      END
      Y.VAR1++
    REPEAT
  END

  RETURN
*------------------------------------------------------
FORM.MSG:
*------------------------------------------------------
* Here we form the message for deal slip

  CALL F.READ(FN.REDO.RATE.CHANGE.MESSAGE,'TELLER',R.MESSAGE.TELLER,F.REDO.RATE.CHANGE.MESSAGE,MSG.ERR)

  Y.EFFECTIVE.DATE = R.NOTIFY.DETAIL<2>
  Y.OLD.INT.RATE   = R.NOTIFY.DETAIL<3>
  Y.NEW.INT.RATE   = R.NOTIFY.DETAIL<4>

  CALL REDO.GET.NEXT.PAYMENT.AMOUNT(VAR.AA.ID,TODAY,Y.NEXT.PAY.AMT)
  Y.NEXT.PAY.AMT = TRIMB(FMT(Y.NEXT.PAY.AMT,'L2,#19'))
  Y.INTEREST     = TRIMB(FMT(R.NOTIFY.DETAIL<4>,'L2,#10'))


  VAR.AC.ID     = R.MESSAGE.TELLER<REDO.RT.MSG.MESSAGE.BODY>
  Y.ORD.MESSAGE = R.MESSAGE.TELLER<REDO.RT.MSG.DATA.ORDER>
  Y.ADD.VALUE = Y.EFFECTIVE.DATE[7,2]:'/':Y.EFFECTIVE.DATE[5,2]:'/':Y.EFFECTIVE.DATE[3,2]:FM:Y.ACC.NO:FM:Y.OLD.INT.RATE:FM:Y.NEW.INT.RATE:FM:Y.NEXT.PAY.AMT
  Y.FMT.MSG.ARCIB = ''
  CALL REDO.FORMAT.MESSAGE(VAR.AC.ID,Y.ORD.MESSAGE,Y.ADD.VALUE,Y.FMT.MSG.ARCIB)
  VAR.AC.ID = Y.FMT.MSG.ARCIB

  IF Y.STR EQ 'LINE.1' THEN
    VAR.AC.ID = VAR.AC.ID<1,1>
  END

  IF Y.STR EQ 'LINE.2' THEN
    VAR.AC.ID = VAR.AC.ID<1,2>
  END

  IF Y.STR EQ 'LINE.3' THEN
    VAR.AC.ID = VAR.AC.ID<1,3>
  END

  RETURN
END
