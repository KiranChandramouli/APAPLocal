SUBROUTINE REDO.VAL.DRAWDOWN
*-----------------------------------------------
*Description: This routine is to validate the drawdown account.
*-----------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.LOAN.FT.TT.TXN
    $INSERT I_F.REDO.OUTWARD.RETURN

    IF COMI EQ '' THEN
        R.NEW(LN.FT.TT.CHEQUE.AMOUNT)<1,AV> = ''
        RETURN
    END


    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------
OPENFILES:
*-----------------------------------------------
    FN.REDO.OUTWARD.RETURN = 'F.REDO.OUTWARD.RETURN'
    F.REDO.OUTWARD.RETURN  = ''
    CALL OPF(FN.REDO.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN)

RETURN
*-----------------------------------------------
PROCESS:
*-----------------------------------------------
    Y.DRAW.ACC = COMI
    Y.OUTRETURN.ID = Y.DRAW.ACC :"-": R.NEW(LN.FT.TT.CHEQUE.REF)<1,AV>
    CALL F.READ(FN.REDO.OUTWARD.RETURN,Y.OUTRETURN.ID,R.OUTWARD.RETURN,F.REDO.OUTWARD.RETURN,RET.ERR)
    IF R.OUTWARD.RETURN THEN
        R.NEW(LN.FT.TT.CHEQUE.AMOUNT)<1,AV> = TRIMB(FMT(R.OUTWARD.RETURN<CLEAR.RETURN.AMOUNT>,'L2#19'))
    END ELSE
        R.NEW(LN.FT.TT.CHEQUE.AMOUNT)<1,AV> = ''
        ETEXT = 'EB-REDO.CHQ.NOT.RETURNED'
        CALL STORE.END.ERROR
    END

RETURN
END
