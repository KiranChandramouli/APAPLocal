*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.REFER.REASON
*--------------------------------------------------------------
*Description: This routine is the validation routine for RCI,APPROVE.
*--------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.CLEARING.INWARD

  GOSUB PROCESS
  RETURN

*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------



  Y.NEW.REFER.REASON = R.NEW(CLEAR.CHQ.REASON)
  Y.OLD.REFER.REASON = R.OLD(CLEAR.CHQ.REASON)

  Y.STATUS = R.NEW(CLEAR.CHQ.STATUS)
  IF Y.STATUS EQ 'PAID' OR Y.STATUS EQ 'REFERRED' THEN
    GOSUB PROCESS.PAID
  END
  IF Y.STATUS EQ 'REJECTED' THEN
    GOSUB PROCESS.REJECTED
  END

  RETURN
*--------------------------------------------------------------
PROCESS.PAID:
*--------------------------------------------------------------
  IF Y.NEW.REFER.REASON NE Y.OLD.REFER.REASON THEN
    R.NEW(CLEAR.CHQ.REASON) = Y.OLD.REFER.REASON
    AF = CLEAR.CHQ.REASON
    ETEXT = 'EB-REDO.NO.CHANGE.REASON'
    CALL STORE.END.ERROR
  END
  RETURN
*--------------------------------------------------------------
PROCESS.REJECTED:
*--------------------------------------------------------------

  IF Y.NEW.REFER.REASON NE Y.OLD.REFER.REASON THEN

    Y.REASON.COUNT = DCOUNT(Y.NEW.REFER.REASON,VM)
    Y.VAR1 = 1

    LOOP
    WHILE Y.VAR1 LE Y.REASON.COUNT
      LOCATE Y.NEW.REFER.REASON<1,Y.VAR1> IN Y.OLD.REFER.REASON<1,1> SETTING POS1 ELSE
        R.NEW(CLEAR.CHQ.REASON) = Y.OLD.REFER.REASON
        AF = CLEAR.CHQ.REASON
        ETEXT = 'EB-REDO.NO.CHANGE.REASON'
        CALL STORE.END.ERROR
        RETURN
      END
      Y.VAR1++
    REPEAT

  END
  RETURN
END
