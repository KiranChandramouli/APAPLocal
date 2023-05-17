*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.LOAN.FT.TT.TXN
*------------------------------------------------------
* Description: This validation routine checks whether the returned
* cheques are not altered as fraud cheque.
*------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LOAN.FT.TT.TXN

  GOSUB PROCESS
  RETURN

*------------------------------------------------------
PROCESS:
*------------------------------------------------------
  Y.DRAW.ACCOUNT = R.NEW(LN.FT.TT.DRAWDOWN.ACC)<1,AV>
  Y.NEW.CHQ.NO = COMI
  Y.OLD.CHQ.NO = R.OLD(LN.FT.TT.CHEQUE.REF)<1,AV>
  IF Y.DRAW.ACCOUNT THEN
    GOSUB CHECK.ALTERED
  END ELSE
    IF Y.NEW.CHQ.NO NE Y.OLD.CHQ.NO THEN
      GOSUB UPDATE.CHQ.NO
    END
  END

  RETURN
*------------------------------------------------------
CHECK.ALTERED:
*------------------------------------------------------
  IF Y.NEW.CHQ.NO NE Y.OLD.CHQ.NO THEN
    COMI = R.OLD(LN.FT.TT.CHEQUE.REF)<1,AV>
    ETEXT = 'EB-REDO.CANNOT.ALTER'
    CALL STORE.END.ERROR
  END

  RETURN
*------------------------------------------------------
UPDATE.CHQ.NO:
*------------------------------------------------------

  Y.NEW.CHEQUES.NOS = R.NEW(AF)
  Y.NEW.CHEQUES.NOS<1,AV> = COMI
  CHANGE VM TO SM IN Y.NEW.CHEQUES.NOS
  Y.LOAN.NOS = R.NEW(LN.FT.TT.LOAN.ID)
  Y.LOAN.CNT = DCOUNT(Y.LOAN.NOS,VM)
  Y.VAR1 = 1
  LOOP
  WHILE Y.VAR1 LE Y.LOAN.CNT
    R.NEW(LN.FT.TT.RETURNED.CHQ)<1,Y.VAR1> = Y.NEW.CHEQUES.NOS
    Y.VAR1++
  REPEAT

  RETURN
END
