SUBROUTINE REDO.UPDATE.CHEQUE.AMOUNTS
*----------------------------------------------
* Description: This routine is to update the Cheque amounts in
* REDO.LOAN.FT.TT.TXN.
*----------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.REDO.LOAN.FT.TT.TXN

    GOSUB OPENFILES
    GOSUB Y.GET.LOC.REF
    GOSUB PROCESS
RETURN
*----------------------------------------------
OPENFILES:
*----------------------------------------------

    FN.REDO.TRANSACTION.CHAIN = 'F.REDO.TRANSACTION.CHAIN'
    F.REDO.TRANSACTION.CHAIN = ''
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TT$NAU = 'F.TELLER$NAU'
    F.TT$NAU  = ''
    CALL OPF(FN.TT$NAU,F.TT$NAU)

    FN.REDO.CONCAT.CHEQUE.NOS = 'F.REDO.CONCAT.CHEQUE.NOS'
    F.REDO.CONCAT.CHEQUE.NOS = ''
    CALL OPF(FN.REDO.CONCAT.CHEQUE.NOS,F.REDO.CONCAT.CHEQUE.NOS)

    FN.REDO.LOAN.FT.TT.TXN = 'F.REDO.LOAN.FT.TT.TXN'
    F.REDO.LOAN.FT.TT.TXN = ''
    CALL OPF(FN.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN)

RETURN
*----------------------------------------------
Y.GET.LOC.REF:
*----------------------------------------------

    LOC.REF.APPLICATION="FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.INITIAL.ID':@VM:'CERT.CHEQUE.NO'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.INITIAL.ID   = LOC.REF.POS<1,1>
    POS.CERT.CHEQUE.NO = LOC.REF.POS<1,2>

RETURN
*----------------------------------------------
PROCESS:
*----------------------------------------------
    Y.INITIAL.ID = R.NEW(FT.LOCAL.REF)<1,POS.L.INITIAL.ID>
    CALL F.READ(FN.REDO.TRANSACTION.CHAIN,Y.INITIAL.ID,R.RTC,F.REDO.TRANSACTION.CHAIN,RTC.ERR)
    Y.TRANS.IDS  = R.RTC<RTC.TRANS.ID>
    Y.TRANS.TYPE = R.RTC<RTC.TRANS.TYPE>

    Y.TRANS.CNT = DCOUNT(Y.TRANS.IDS,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.TRANS.CNT
        Y.ID   = Y.TRANS.IDS<1,Y.VAR1>
        Y.TYPE = Y.TRANS.TYPE<1,Y.VAR1>
        IF Y.ID[1,2] EQ 'TT' AND  Y.TYPE EQ 'CHECK' THEN
            R.TT = ''
            CALL F.READ(FN.TT$NAU,Y.ID,R.TT,F.TT$NAU,TT.NAU.ERR)
            IF R.TT ELSE
                CALL F.READ(FN.TELLER,Y.ID,R.TT,F.TELLER,TT.ERR)
            END
            Y.CHEQUE.TRANS.ID = ''
            IF R.TT THEN
                IF R.TT<TT.TE.CHEQUE.NUMBER> THEN
                    Y.CHEQUE.TRANS.ID = Y.ID
                    Y.VAR1 = Y.TRANS.CNT+1
                END

            END
        END
        Y.VAR1 += 1
    REPEAT

    IF Y.CHEQUE.TRANS.ID THEN
        GOSUB UPDATE.FILES
    END

RETURN
*--------------------------------------------
UPDATE.FILES:
*--------------------------------------------
    Y.ID.NEW = ID.NEW
    CALL F.READ(FN.REDO.LOAN.FT.TT.TXN,Y.ID.NEW,R.TXN,F.REDO.LOAN.FT.TT.TXN,TXN.ERR)
    Y.CHEQUE.NOS = R.NEW(FT.LOCAL.REF)<1,POS.CERT.CHEQUE.NO>
    CHANGE @SM TO @FM IN Y.CHEQUE.NOS
    CHANGE @VM TO @FM IN Y.CHEQUE.NOS
    Y.CNT  = DCOUNT(Y.CHEQUE.NOS,@FM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.CNT
        Y.UPDATE.ID = Y.CHEQUE.NOS<Y.VAR2>:"*":Y.CHEQUE.TRANS.ID
        R.CHQ.NOS = ''
        CALL F.READ(FN.REDO.CONCAT.CHEQUE.NOS,Y.UPDATE.ID,R.CHQ.NOS,F.REDO.CONCAT.CHEQUE.NOS,CHQ.ERR)
        IF R.CHQ.NOS THEN
            IF R.CHQ.NOS<1> EQ Y.INITIAL.ID ELSE
                R.CHQ.NOS<1> = Y.INITIAL.ID
                CALL F.WRITE(FN.REDO.CONCAT.CHEQUE.NOS,Y.UPDATE.ID,R.CHQ.NOS)
            END

        END ELSE
            R.CHQ.NOS<1> = Y.INITIAL.ID
            CALL F.WRITE(FN.REDO.CONCAT.CHEQUE.NOS,Y.UPDATE.ID,R.CHQ.NOS)
        END
        R.TXN<LN.FT.TT.TRANSACTION.ID,Y.VAR2> = Y.CHEQUE.TRANS.ID
        Y.VAR2 += 1
    REPEAT
    Y.ID.NEW = ID.NEW
    CALL F.WRITE(FN.REDO.LOAN.FT.TT.TXN,Y.ID.NEW,R.TXN)

RETURN
END
