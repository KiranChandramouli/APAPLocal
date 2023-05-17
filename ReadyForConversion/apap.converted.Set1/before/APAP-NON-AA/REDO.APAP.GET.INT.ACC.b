* Version 3 02/06/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-46</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.GET.INT.ACC(ARR.ID,Y.START.DATE,Y.END.DATE,Y.UNPAID.BILL.CNT,RETURN.AMOUNT)
*-----------------------------------------------------------------------------
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.APAP.GET.INT.ACC
* ODR NO      : ODR-2010-03-0176

*----------------------------------------------------------------------
*DESCRIPTION: This routine calculates the charge amount for the arrangement ID passed (Scheduled & Activity charges)


*IN PARAMETER:   ARR.ID, Y.PROD.ID
*OUT PARAMETER:  CHARGE.AMT
*LINKED WITH:    REDO.APAP.OUTSTANDING.LOAN.DETAILS
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.11.2010  H GANESH      ODR-2010-03-0176    INITIAL CREATION
*----------------------------------------------------------------------

*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCT.ACTIVITY
$INSERT I_F.AA.OVERDUE
$INSERT I_F.AA.ACCOUNT.DETAILS
$INSERT I_F.AA.BILL.DETAILS
*-----------------------------------------------------------------------------

  GOSUB INITIALISE
  GOSUB PROCESS
  RETURN.AMOUNT = ABS(RETURN.AMOUNT)
  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*----------
  RETURN.AMOUNT = 0
  Y.UNPAID.BILL.CNT = 0

  FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
  F.AA.ACCOUNT.DETAILS  = ''
  R.AA.ACCOUNT.DETAILS  = ''
  CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

  FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
  F.AA.BILL.DETAILS = ''
  R.AA.BILL.DETAILS = ''
  CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-------

  CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCOUNT.DETAILS.ERR)

  GOSUB GET.BALAN.COUNT

  RETURN
*-----------------------------------------------------------------------------
GET.BALAN.COUNT:
*---------------
  Y.BILL.LIST = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
  Y.BILL.TYPE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>
  CHANGE SM TO FM IN Y.BILL.LIST
  CHANGE VM TO FM IN Y.BILL.LIST
  CHANGE SM TO FM IN Y.BILL.TYPE
  CHANGE VM TO FM IN Y.BILL.TYPE

  Y.BILL.LIST.SIZE=DCOUNT(Y.BILL.LIST,FM)
  Y.BILL.CNT=1
  Y.UNPAID.BILL.CNT = 0
  LOOP
  WHILE Y.BILL.CNT LE Y.BILL.LIST.SIZE
    IF Y.BILL.LIST<Y.BILL.CNT> NE '' AND Y.BILL.TYPE<Y.BILL.CNT> EQ "PAYMENT" THEN
      CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.LIST<Y.BILL.CNT>,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,Y.AA.BILL.DETAILS.ERR)
      Y.SETTLE.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
*Y.BILL.STATUS   = R.AA.BILL.DETAILS<AA.BD.BILL.STATUS,1>
*As per the last issue raised by cristina on 11 Mar 2015, we need to show DUE bills + AGED bills (Excluding ACT.CHARGE Bills) in bill count + amount.
*Following lines are commented as per the issue - PACS00313542 , we need to show only aged bills.
*IF (R.AA.BILL.DETAILS<AA.BD.BILL.TYPE> EQ 'ACT.CHARGE') AND (Y.SETTLE.STATUS EQ "UNPAID") THEN
*Y.UNPAID.BILL.CNT += 1  ;*---------------------------------------------------------------------------------- 36TH FIELD VALUE
*RETURN.AMOUNT += SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
*END ELSE
      GOSUB CHECK.UNPAID
*END
    END
    Y.BILL.CNT++

  REPEAT
  RETURN
*-----------------------------------------------------------------------------
CHECK.UNPAID:
*-----------------------------------------------------------------------------
  IF (Y.SETTLE.STATUS EQ "UNPAID") THEN
    Y.UNPAID.BILL.CNT += 1    ;*------------------------------------------------------------------------ 36TH FIELD VALUE
    RETURN.AMOUNT += SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
  END
  RETURN
*-----------------------------------------------------------------------------
END
