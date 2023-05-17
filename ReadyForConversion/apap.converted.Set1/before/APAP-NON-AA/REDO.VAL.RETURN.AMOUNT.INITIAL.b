*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.RETURN.AMOUNT.INITIAL
*-------------------------------------------------------
*Description: This routine validates the total return amount
*             entered for each cheque.
*-------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LOAN.FT.TT.TXN

  GOSUB PROCESS
  RETURN
*-------------------------------------------------------
PROCESS:
*-------------------------------------------------------

  Y.FLAG = ''
  Y.OLD.ACCOUNT = R.OLD(LN.FT.TT.DRAWDOWN.ACC)
  Y.NEW.ACCOUNT = R.NEW(LN.FT.TT.DRAWDOWN.ACC)
  Y.VAR1 = 1
  Y.NEW.ACCOUNT.COUNT = DCOUNT(Y.NEW.ACCOUNT,VM)
  LOOP
  WHILE Y.VAR1 LE Y.NEW.ACCOUNT.COUNT

    IF Y.OLD.ACCOUNT<1,Y.VAR1> NE Y.NEW.ACCOUNT<1,Y.VAR1> THEN
      Y.FLAG = 'YES'
    END

    Y.VAR1++
  REPEAT
  IF Y.FLAG EQ '' THEN
    AF = LN.FT.TT.DRAWDOWN.ACC
    ETEXT = 'EB-REDO.NO.CHANGE'
    CALL STORE.END.ERROR
  END


  RETURN
END
