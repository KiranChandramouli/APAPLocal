*--------------------------------------------------------------------------------------------------------
* <Rating>-50</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.BILL.AMOUNT(Y.AA.ID,Y.CANCEL.CHARAGE.AMOUNT,Y.CANCEL.CAPITAL.AMOUNT,Y.CANCEL.INT.AMOUNT)

*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.NOF.LOAN.EXP.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : CALL routine attached to REDO.APAP.LOAN.EXP.DATE
*Linked With  : Enquiry REDO.E.NOF.LOAN.EXP.DATE
*In Parameter : N/A
*Out Parameter: LN.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
*  5th OCT 2010    JEEVA T              ODR-2010-03-0173        Initial Creation
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AA.BILL.DETAILS
$INSERT I_F.AA.ACCOUNT.DETAILS
$INSERT I_F.DEPT.ACCT.OFFICER

  GOSUB OPEN.FILE
  GOSUB PROCESS
  RETURN
*-----------------------------------------------------------------------------
OPEN.FILE:
*-----------------------------------------------------------------------------
  FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
  F.AA.BILL.DETAILS=''
  CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

  FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
  F.AA.ACCOUNT.DETAILS=''
  CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

  Y.OS.PR.AMOUNT=''
  Y.OS.PR.AMOUNT1=''
  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
  CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCOUNT.DETAILS.ERR)
  Y.BILL.TYPE=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>
  Y.BILL.ID.LIST=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
  CHANGE SM TO FM IN Y.BILL.ID.LIST
  CHANGE VM TO FM IN Y.BILL.ID.LIST
  CHANGE SM TO FM IN Y.BILL.TYPE
  CHANGE VM TO FM IN Y.BILL.TYPE
  Y.BILL.LIST.SIZE=DCOUNT(Y.BILL.TYPE,FM)
  Y.BILL.CNT=1
  LOOP
  WHILE Y.BILL.CNT LE Y.BILL.LIST.SIZE
    IF Y.BILL.TYPE<Y.BILL.CNT> EQ 'PAYOFF'  THEN
      Y.BILL.ID =Y.BILL.ID.LIST<Y.BILL.CNT>
      GOSUB BILL.READ
    END
    Y.BILL.CNT++
  REPEAT
  RETURN
*-----------------------------------------------------------------------------
BILL.READ:
*-----------------------------------------------------------------------------
  CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,Y.AA.BILL.DETAILS.ERR)
  Y.PROPERTY=R.AA.BILL.DETAILS<AA.BD.PROPERTY>
  Y.PAYMENT.TYPE=R.AA.BILL.DETAILS<AA.BD.PAYMENT.TYPE>
  CHANGE SM TO FM IN Y.PROPERTY
  CHANGE VM TO FM IN Y.PROPERTY
  CHANGE SM TO FM IN Y.PAYMENT.TYPE
  CHANGE VM TO FM IN Y.PAYMENT.TYPE
  GOSUB CANCEL.AMOUNT
  GOSUB CHARGE.AMOUNT
  RETURN

*-----------------------------------------------------------------------------
CHARGE.AMOUNT:
*-----------------------------------------------------------------------------

  Y.PAYMENT.AMOUNT=R.AA.BILL.DETAILS<AA.BD.PAYMENT.AMOUNT>
  CHANGE VM TO FM IN Y.PAYMENT.AMOUNT
  CHANGE SM TO FM IN Y.PAYMENT.AMOUNT
  Y.PAYMENT.COUNT=DCOUNT(Y.PAYMENT.TYPE,FM)
  Y.PAY.CNT=1
  LOOP
  WHILE Y.PAY.CNT LE Y.PAYMENT.COUNT
    IF Y.PAYMENT.TYPE<Y.PAY.CNT> EQ 'PAYOFF$CHARGE' THEN
      IF Y.PAY.AMT EQ '' THEN
        Y.PAY.AMT = Y.PAYMENT.AMOUNT<Y.PAY.CNT>
      END ELSE
        Y.PAY.AMT = Y.PAY.AMT + Y.PAYMENT.AMOUNT<Y.PAY.CNT>
      END
      Y.CANCEL.CHARAGE.AMOUNT = Y.PAY.AMT
    END
    Y.PAY.CNT++
  REPEAT
  RETURN
*-----------------------------------------------------------------------------
CANCEL.AMOUNT:
*-----------------------------------------------------------------------------
  Y.TOT=R.AA.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT>
  CHANGE VM TO FM IN Y.TOT
  CHANGE SM TO FM IN Y.TOT
  Y.P.CNT1 = DCOUNT(Y.PROPERTY,FM)
  Y.CNT1=1
  LOOP
  WHILE Y.CNT1 LE Y.P.CNT1
    IF Y.PROPERTY<Y.CNT1> EQ 'ACCOUNT' THEN
      IF Y.OR.PR.AMOUNT1 EQ '' THEN
        Y.OR.PR.AMOUNT1 = Y.TOT<Y.CNT1>
      END ELSE
        Y.OR.PR.AMOUNT1 = Y.OR.PR.AMOUNT1 + Y.TOT<Y.CNT1>
      END
      Y.CANCEL.CAPITAL.AMOUNT =Y.OR.PR.AMOUNT1
    END

    IF Y.PROPERTY<Y.CNT1> EQ 'PRINCIPALINT' THEN
      IF Y.OR.PR.AMOUNT EQ '' THEN
        Y.OR.PR.AMOUNT = Y.TOT<Y.CNT1>
      END ELSE
        Y.OR.PR.AMOUNT = Y.OR.PR.AMOUNT + Y.TOT<Y.CNT1>
      END
      Y.CANCEL.INT.AMOUNT =Y.OR.PR.AMOUNT
    END
    Y.CNT1 ++
  REPEAT
  RETURN
*-----------------------------------------------------------------------------
END
