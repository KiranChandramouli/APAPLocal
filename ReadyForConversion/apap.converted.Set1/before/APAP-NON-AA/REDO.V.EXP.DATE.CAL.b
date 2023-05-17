*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.V.EXP.DATE.CAL
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :JEEVA T
*Program   Name    :REDO.V.EXP.DATE.CAL
*---------------------------------------------------------------------------------

*DESCRIPTION       :this routine to cal expiry date

*LINKED WITH       :

* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.CURRENCY
$INSERT I_F.REDO.PAYMENT.STOP.ACCOUNT
$INSERT I_F.CHEQUE.TYPE.ACCOUNT

  GOSUB INIT
  GOSUB EXCHANGE

  RETURN
*----------------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------------
  FN.REDO.PAYMENT.STOP.ACCOUNT = 'F.REDO.PAYMENT.STOP.ACCOUNT'
  F.REDO.PAYMENT.STOP.ACCOUNT = ''
  CALL OPF(FN.REDO.PAYMENT.STOP.ACCOUNT,F.REDO.PAYMENT.STOP.ACCOUNT)

  FN.CHEQUE.TYPE.ACCOUNT = "F.CHEQUE.TYPE.ACCOUNT"
  F.CHEQUE.TYPE.ACCOUNT = ""
  CALL OPF(FN.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT)
  RETURN
*----------------------------------------------------------------------------------
EXCHANGE:
*----------------------------------------------------------------------------------
  ISSUE.DATE = R.NEW(REDO.PS.ACCT.ISSUE.DATE)<1,AV>
  Y.EXPIRY.DATE = R.NEW(REDO.PS.ACCT.EXPIRY.DATE)<1,AV>
  IF COMI EQ 'CONFIRMED' THEN
    IF NOT(ISSUE.DATE) AND NOT(Y.EXPIRY.DATE) THEN
      R.NEW(REDO.PS.ACCT.EXPIRY.DATE)<1,AV> = '20991231'
    END
  END
*    R.NEW(REDO.PS.ACCT.WAIVE.CHARGES)<1,AV> = 'NO'
  Y.VAL = COMI
  IF Y.VAL EQ 'NONE' THEN
    ETEXT = 'ST-INVALID.STATUS.CHANGE'
    CALL STORE.END.ERROR
  END
  IF NOT(R.NEW(REDO.PS.ACCT.CHEQUE.TYPE)<1,AV>) THEN
    Y.FINAL.ID = FIELD(ID.NEW,'.',1)
    R.NEW(REDO.PS.ACCT.ACCOUNT.NUMBER) = Y.FINAL.ID
    CALL F.READ(FN.CHEQUE.TYPE.ACCOUNT,Y.FINAL.ID,R.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT,ACC.ERR)
    Y.CHEQUE.TYPE = R.CHEQUE.TYPE.ACCOUNT<CHQ.TYP.CHEQUE.TYPE>
    R.NEW(REDO.PS.ACCT.CHEQUE.TYPE)<1,AV> = Y.CHEQUE.TYPE
  END

  RETURN
END
