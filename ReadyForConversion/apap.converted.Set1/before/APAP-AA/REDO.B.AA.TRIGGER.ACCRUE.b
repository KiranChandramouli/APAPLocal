*-----------------------------------------------------------------------------
* <Rating>-61</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.AA.TRIGGER.ACCRUE(Y.AA.ID)
*------------------------------------------------------
*Description: This routine is to trigger the LENDING-ACCRUE-PENALTINT
* activity locally to resolve the issue of month day accrual of penalty interest
* in bills. This routine will trigger the LENDING-ACCRUE-PENALTINT if the first day
* of the month falls on holiday for all contracts whose bills are in aging liKE DE1, DE3..
*------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.BILL.DETAILS
$INSERT I_F.AA.ACCOUNT.DETAILS
$INSERT I_F.AA.ARRANGEMENT.ACTIVITY
$INSERT I_REDO.B.AA.TRIGGER.ACCRUE.COMMON

  GOSUB INIT
  GOSUB PROCESS

  RETURN
*------------------------------------------------------
INIT:
*------------------------------------------------------

  Y.PAY.BILL.FLAG = ''

  RETURN
*------------------------------------------------------
PROCESS:
*------------------------------------------------------
  CALL OCOMO("Process started - ":Y.AA.ID)

  GOSUB CHECK.PAY.BILL.AGE
  IF Y.PAY.BILL.FLAG EQ 'YES' THEN
    GOSUB POST.OFS
  END ELSE
    CALL OCOMO("No payment bills are aging - ":Y.AA.ID)
  END

  RETURN
*------------------------------------------------------
POST.OFS:
*------------------------------------------------------
*
  IF Y.ACTIVITY.EFF.DATE ELSE
    YREGION     = ''
    YDATE       = TODAY
    YDAYS.ORIG  = '-1C'
    CALL CDT(YREGION,YDATE,YDAYS.ORIG)
    Y.ACTIVITY.EFF.DATE = YDATE
  END

  R.AAA = ''
  R.AAA<AA.ARR.ACT.ARRANGEMENT>     = Y.AA.ID
  R.AAA<AA.ARR.ACT.ACTIVITY>        = 'REDO.ACCRUE.PENALTINT'
  R.AAA<AA.ARR.ACT.EFFECTIVE.DATE>  = Y.ACTIVITY.EFF.DATE

  APP.NAME      = 'AA.ARRANGEMENT.ACTIVITY'
  OFSFUNCT      = 'I'
  PROCESS       = 'PROCESS'
  OFSVERSION    = 'AA.ARRANGEMENT.ACTIVITY,APAP'
  GTSMODE       = ''
  TRANSACTION.ID= ''
  OFSRECORD     = ''
  OFS.MSG.ID    = ''
  OFS.ERR       = ''
  NO.OF.AUTH    = 0

  CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,GTSMODE,NO.OF.AUTH,TRANSACTION.ID,R.AAA,OFSRECORD)
  OFS.MSG.ID = ''
  OFS.SRC    = 'REDO.PEN.ACCRUE'
  OPTIONS    = ''
  CALL OFS.POST.MESSAGE(OFSRECORD,OFS.MSG.ID,OFS.SRC,OPTIONS)
  CALL OCOMO("Accrue has been completed - ":Y.AA.ID)

  RETURN
*------------------------------------------------------
CHECK.PAY.BILL.AGE:
*------------------------------------------------------
* Check whether loans has payment bill with aging status with account property

  CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACC.ERR)

  IF R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS> EQ "" THEN
    CALL OCOMO("Arrangement skipped - ARR.AGE.STATUS is NULL - ":Y.AA.ID)
    GOSUB END1
  END

  GOSUB GET.ACC.PROPERTY

  Y.BILL.REF     = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
  Y.SET.STATUS   = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
  Y.BILL.TYPE    = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>
  Y.AGING.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.AGING.STATUS>

  CHANGE SM TO FM IN Y.BILL.REF
  CHANGE VM TO FM IN Y.BILL.REF
  CHANGE SM TO FM IN Y.SET.STATUS
  CHANGE VM TO FM IN Y.SET.STATUS
  CHANGE SM TO FM IN Y.BILL.TYPE
  CHANGE VM TO FM IN Y.BILL.TYPE
  CHANGE SM TO FM IN Y.AGING.STATUS
  CHANGE VM TO FM IN Y.AGING.STATUS

  Y.BILL.REF.CNT = DCOUNT(Y.BILL.REF,FM)
  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE Y.BILL.REF.CNT
    IF Y.SET.STATUS<Y.VAR1> EQ 'UNPAID' AND Y.BILL.TYPE<Y.VAR1> EQ 'PAYMENT' AND Y.AGING.STATUS<Y.VAR1> NE '' THEN
      Y.BILL.ID = Y.BILL.REF<Y.VAR1>
      CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
      LOCATE Y.ACC.PROPERTY IN R.AA.BILL.DETAILS<AA.BD.PROPERTY,1> SETTING POS1 THEN
        Y.PAY.BILL.FLAG = 'YES'
        Y.VAR1 = Y.BILL.REF.CNT+1
      END
    END
    Y.VAR1++
  REPEAT

  RETURN
*-------------------------------------------------------
GET.ACC.PROPERTY:
*-------------------------------------------------------

  IN.PROPERTY.CLASS = 'ACCOUNT'
  R.OUT.AA.RECORD   = ''
  Y.ACC.PROPERTY    = ''
  CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,Y.ACC.PROPERTY,OUT.ERR)

  IF Y.ACC.PROPERTY EQ '' THEN
    CALL OCOMO("Account Property Missing - ":Y.AA.ID)
  END

  RETURN
*-------------------------------------------------------
END1:
*-------------------------------------------------------

END
