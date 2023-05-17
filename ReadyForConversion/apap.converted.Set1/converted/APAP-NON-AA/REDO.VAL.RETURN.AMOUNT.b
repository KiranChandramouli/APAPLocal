SUBROUTINE REDO.VAL.RETURN.AMOUNT
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

    GOSUB UPDATE.RETURN.AMOUNT

    Y.RETURN.CHQ.AMOUNT = SUM(R.NEW(LN.FT.TT.CHEQUE.AMOUNT))
    Y.RETURN.AMOUNT     = SUM(R.NEW(LN.FT.TT.RETURN.AMOUNT))
    Y.ERROR.FLAG  = ''
    IF Y.RETURN.CHQ.AMOUNT NE Y.RETURN.AMOUNT THEN
        AF = LN.FT.TT.RETURN.AMOUNT
        ETEXT = 'EB-REDO.CHQ.AMT.NOT.EQ'
        Y.ERROR.FLAG = 'YES'
        CALL STORE.END.ERROR
    END

    IF Y.ERROR.FLAG NE 'YES' THEN
        R.NEW(LN.FT.TT.TOTAL.RETURN.AMT) = TRIMB(FMT(Y.RETURN.AMOUNT,'L2#19'))
    END

RETURN
*---------------------------------------------
UPDATE.RETURN.AMOUNT:
*---------------------------------------------
    Y.CHEQUE.COUNT = DCOUNT(R.NEW(LN.FT.TT.CHEQUE.REF),@VM)
    Y.VAR1 = 1
    Y.TXN.IDS = R.NEW(LN.FT.TT.FT.TRANSACTION.ID)
    Y.TXN.CNT = DCOUNT(Y.TXN.IDS,@VM)
    LOOP
    WHILE Y.VAR1 LE Y.CHEQUE.COUNT
        Y.TOT.CHQ.AMT = 0
        Y.CHQ.ID = R.NEW(LN.FT.TT.CHEQUE.REF)<1,Y.VAR1>
        Y.VAR2 = 1
        LOOP
        WHILE Y.VAR2 LE Y.TXN.CNT

            LOCATE Y.CHQ.ID IN R.NEW(LN.FT.TT.RETURNED.CHQ)<1,Y.VAR2,1> SETTING POS1 THEN
                Y.TOT.CHQ.AMT += R.NEW(LN.FT.TT.INDV.RET.AMT)<1,Y.VAR2,POS1>
            END

            R.NEW(LN.FT.TT.RETURN.AMOUNT)<1,Y.VAR2> = TRIMB(FMT(SUM(R.NEW(LN.FT.TT.INDV.RET.AMT)<1,Y.VAR2>),'L2#19'))
            IF R.NEW(LN.FT.TT.AMOUNT)<1,Y.VAR2> LT R.NEW(LN.FT.TT.RETURN.AMOUNT)<1,Y.VAR2> THEN
                AF    = LN.FT.TT.RETURN.AMOUNT
                AV    = Y.VAR2
                ETEXT = 'EB-REDO.RET.AMT.GT'
                Y.ERROR.FLAG = 'YES'
                CALL STORE.END.ERROR
            END
            Y.VAR2 += 1
        REPEAT
        Y.CHQ.CHECK.AMOUNT = R.NEW(LN.FT.TT.CHEQUE.AMOUNT)<1,Y.VAR1>
        IF Y.CHQ.CHECK.AMOUNT ELSE
            Y.CHQ.CHECK.AMOUNT = 0
        END
        IF Y.CHQ.CHECK.AMOUNT NE Y.TOT.CHQ.AMT THEN
            AF    = LN.FT.TT.INDV.RET.AMT
            AV    = Y.VAR1
            ETEXT = 'EB-REDO.AA.CHQ.DIFF'
            Y.ERROR.FLAG = 'YES'
            CALL STORE.END.ERROR
        END

        Y.VAR1 += 1
    REPEAT
RETURN
END
