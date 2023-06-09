SUBROUTINE MULTI.TRANSACTION.SERVICE.VALIDATE
*----------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: JEYACHANDRAN S
* PROGRAM NAME:
* ODR NO      :
*----------------------------------------------------------------------
* DESCRIPTION  :This validation routine is attached in MULTI.TRANSACTION application for getting the details
*               and checking purpose
* IN PARAMETER :NA
* OUT PARAMETER:NA
* LINKED WITH  :
* LINKED FILE  :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                 REFERENCE           DESCRIPTION
* 28.09.2010   Jeyachandran S      ODR-2009-10-0318       INITIAL CREATION
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MULTI.TRANSACTION.SERVICE
    $INSERT I_F.AA.ARRANGEMENT

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN
*---------
INIT:
    Y.TOTAL.AMT = ''
RETURN

*--------------
OPENFILES:

    FN.MULTI.TRANSACTION.SERVICE = 'F.MULTI.TRANSACTION.SERVICE'
    F.MULTI.TRANSACTION.SERVICE = ''
    CALL OPF(FN.MULTI.TRANSACTION.SERVICE,F.MULTI.TRANSACTION.SERVICE)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
RETURN

*---------------
CHEQ.CONDITION:

    IF Y.NO.OF.CHQ EQ 'CHEQUE' THEN

        Y.CHQ.VAL = R.NEW(REDO.MTS.NO.OF.CHEQUES)
        IF Y.CHQ.VAL EQ '' THEN
            ETEXT = 'TT-MTS.CHQ.AMT'
            CALL STORE.END.ERROR
        END

        Y.CHQ.NO = R.NEW(REDO.MTS.CHEQUE.NO)<1,Y.PYME.CNTR>
        IF Y.CHQ.NO EQ '' THEN
            ETEXT = 'TT-CHQ.CHECK'
            CALL STORE.END.ERROR
        END

        Y.CHEQUE.AMT = R.NEW(REDO.MTS.CHEQUE.AMT)
        Y.CHQ.AMOUNT = R.NEW(REDO.MTS.TRANSACTION.AMT)<1,Y.PYME.CNTR>
        Y.TOT.CHQ.AMT += Y.CHQ.AMOUNT
    END

    IF Y.NO.OF.CHQ EQ 'CASH' THEN
        Y.BAL.TOT.AMT = R.NEW(REDO.MTS.CASH.AMT)
        Y.CASH.AMOUNT = R.NEW(REDO.MTS.TRANSACTION.AMT)<1,Y.PYME.CNTR>
        Y.CASH.CHQ.AMT += Y.CASH.AMOUNT
    END

    IF Y.NO.OF.CHQ EQ 'ACCOUNT.TRANSFER' THEN
        Y.TRANSFER.AMOUNT = R.NEW(REDO.MTS.TRANSACTION.AMT)<1,Y.PYME.CNTR>
        Y.TRANSFER.AMT += Y.TRANSFER.AMOUNT
    END

    IF Y.NO.OF.CHQ EQ 'ACCOUNT.TRANSFER' AND Y.OPERATION EQ 'REPAYMENT' THEN
        Y.DR.CR.ACC.NO = R.NEW(REDO.MTS.ACCOUNT.SETTLEMENT)<1,Y.PYME.CNTR>
        IF Y.DR.CR.ACC.NO EQ '' THEN
            ETEXT = 'TT-DEBIT.ACCT.NO'
            CALL STORE.END.ERROR
        END
    END

    Y.TXN.AMOUNT = R.NEW(REDO.MTS.TRANSACTION.AMT)<1,Y.PYME.CNTR>
    IF Y.TXN.AMOUNT EQ '' THEN
        ETEXT = 'TT-TXN.AMT'
        CALL STORE.END.ERROR
    END
RETURN

*-------------
PROCESS:


    Y.BAL.TOT.AMT = R.NEW(REDO.MTS.TOTAL.AMT)
    Y.OPERATION = R.NEW(REDO.MTS.OPERATION)
    Y.TYPE = R.NEW(REDO.MTS.SETTLEMENT.TYPE)
    Y.TOT.AMT = R.NEW(REDO.MTS.TRANSACTION.AMT)
    Y.OD.AMT = R.NEW(REDO.MTS.OD.AMT)
    Y.PYMT.MODE = R.NEW(REDO.MTS.PAYMENT.MODE)
    Y.PYMT.MODE4 = R.NEW(REDO.MTS.PAYMENT.MODE)<1,AV>
    Y.SETT.MODE = R.NEW(REDO.MTS.SETTLEMENT.MODE)

    Y.PYMT.MODE = CHANGE(Y.PYMT.MODE,@VM,@FM)
    Y.PYMT.CNT = DCOUNT(Y.PYMT.MODE,@FM)
    Y.PYME.CNTR = 1
    LOOP
    WHILE Y.PYME.CNTR LE Y.PYMT.CNT
        Y.NO.OF.CHQ = Y.PYMT.MODE<Y.PYME.CNTR>
        GOSUB CHEQ.CONDITION
        Y.PYME.CNTR += 1
    REPEAT


    IF Y.TOT.CHQ.AMT NE '' AND Y.CHEQUE.AMT NE '' THEN
        IF Y.TOT.CHQ.AMT GT Y.CHEQUE.AMT THEN
            ETEXT = 'TT-CHQ.COMPARE'
            CALL STORE.END.ERROR
        END
    END

    IF Y.BAL.TOT.AMT NE '' AND Y.CASH.CHQ.AMT NE '' THEN
        IF Y.BAL.TOT.AMT LT Y.CASH.CHQ.AMT THEN
            ETEXT = 'TT-CASH.COMPARE'
            CALL STORE.END.ERROR
        END
    END

*-----------------
*Checking Cheque amount


    IF Y.TYPE EQ 'SINGLE' AND Y.PYMT.MODE4 NE '' AND Y.OPERATION EQ 'REPAYMENT' THEN
        OD.BILLS.AMT = R.NEW(REDO.MTS.OD.AMT)
        OD.BILLS.AMT = CHANGE(OD.BILLS.AMT,@VM,@FM)
        Y.BILL.CNT = DCOUNT(OD.BILLS.AMT,@FM)
        R.NEW(REDO.MTS.NET.AMOUNT) = OD.BILLS.AMT<1>
*        Y.START.VAL = 1
*        LOOP
*        WHILE Y.START.VAL LE Y.BILL.CNT
*            Y.NET.VAL = OD.BILLS.AMT<Y.START.VAL>
*            R.NEW(REDO.MTS.NET.AMOUNT) = Y.NET.VAL
*            BREAK
*            Y.START.VAL + =1
*        REPEAT


        Y.TRANSACTION.AMT = R.NEW(REDO.MTS.TRANSACTION.AMT)
        Y.TRANSACTION.AMT = CHANGE(Y.TRANSACTION.AMT,@VM,@FM)
        Y.TRANS.CNT = DCOUNT(Y.TRANSACTION.AMT,@FM)
        Y.TRAN.VAL = 1
        LOOP
        WHILE Y.TRAN.VAL LE Y.TRANS.CNT
            Y.TOT.AMT = Y.TRANSACTION.AMT<Y.TRAN.VAL>
            Y.PYMT.MODE = CHANGE(Y.PYMT.MODE,@VM,@FM)
            Y.PYMT.CNT = DCOUNT(Y.PYMT.MODE,@FM)
            Y.PYMT.MODE3 = Y.PYMT.MODE<Y.TRAN.VAL>
            IF Y.PYMT.MODE3 EQ 'CASH' THEN
                Y.FINAL.AMT += Y.TOT.AMT
            END
            Y.TRAN.VAL +=1
        REPEAT
        R.NEW(REDO.MTS.AMT.TO.BE.PAID) = Y.FINAL.AMT

        Y.BAL.TOT.AMT = R.NEW(REDO.MTS.CASH.AMT)
        IF Y.FINAL.AMT GT Y.BAL.TOT.AMT THEN
            ETEXT = 'TT-ARR.CHECK.AMT'
            CALL STORE.END.ERROR
        END
    END
    GOSUB MULTI.SET.TYPE
RETURN

*----------------
MULTI.SET.TYPE:

    IF Y.OPERATION EQ 'REPAYMENT' AND Y.TYPE EQ 'MULTIPLE' AND Y.PYMT.MODE4 NE '' THEN
        GOSUB REPAY.MUL.MODE.CHK
    END
    GOSUB RESIDUAL.PROCESS
RETURN
*--------------------------------
REPAY.MUL.MODE.CHK:


    OD.BILLS.AMT = R.NEW(REDO.MTS.OD.AMT)
    OD.BILLS.AMT = CHANGE(OD.BILLS.AMT,@VM,@FM)
    Y.BILL.CNT = DCOUNT(OD.BILLS.AMT,@FM)
    Y.START.VAL = 1
    LOOP
    WHILE Y.START.VAL LE Y.BILL.CNT
        Y.NET.VAL = OD.BILLS.AMT<Y.START.VAL>

        Y.PYMT.MODE = CHANGE(Y.PYMT.MODE,@VM,@FM)
        Y.PYMT.CNT = DCOUNT(Y.PYMT.MODE,@FM)
        Y.PYMT.MODE3 = Y.PYMT.MODE<Y.START.VAL>
        IF Y.PYMT.MODE3 EQ 'CASH' THEN
            Y.NET.FINAL.VAL += Y.NET.VAL
        END
        Y.START.VAL + =1
    REPEAT
    R.NEW(REDO.MTS.NET.AMOUNT) = Y.NET.FINAL.VAL


    Y.TRANSACTION.AMT = R.NEW(REDO.MTS.TRANSACTION.AMT)
    Y.TRANSACTION.AMT = CHANGE(Y.TRANSACTION.AMT,@VM,@FM)
    Y.TRANS.CNT = DCOUNT(Y.TRANSACTION.AMT,@FM)
    Y.TRAN.VAL = 1
    LOOP
    WHILE Y.TRAN.VAL LE Y.TRANS.CNT
        Y.TOT.AMT = Y.TRANSACTION.AMT<Y.TRAN.VAL>
        Y.PYMT.MODE = CHANGE(Y.PYMT.MODE,@VM,@FM)
        Y.PYMT.CNT = DCOUNT(Y.PYMT.MODE,@FM)
        Y.PYMT.MODE3 = Y.PYMT.MODE<Y.TRAN.VAL>
        IF Y.PYMT.MODE3 EQ 'CASH' THEN
            Y.FINAL.AMT += Y.TOT.AMT
        END
        Y.TRAN.VAL +=1
    REPEAT
    R.NEW(REDO.MTS.AMT.TO.BE.PAID) = Y.FINAL.AMT
    Y.BAL.TOT.AMT = R.NEW(REDO.MTS.CASH.AMT)
    IF Y.FINAL.AMT GT Y.BAL.TOT.AMT THEN
        ETEXT = 'TT-ARR.CHECK.AMT'
        CALL STORE.END.ERROR
    END
RETURN

*-----------------
RESIDUAL.PROCESS:


    Y.RESIDUAL.VAL = R.NEW(REDO.MTS.RESIDUAL)
    Y.RESIDUAL.MODE = R.NEW(REDO.MTS.RESIDUAL.MODE)
    Y.PAYMENT.MODE = R.NEW(REDO.MTS.PAYMENT.MODE)
    Y.PAYMENT.MODE = CHANGE(Y.PAYMENT.MODE,@VM,@FM)
    Y.MODE.CNT = DCOUNT(Y.PAYMENT.MODE,@FM)

    IF Y.RESIDUAL.VAL EQ 'YES' THEN
        IF Y.RESIDUAL.MODE EQ '' THEN
            ETEXT = 'TT-MULTI.RESIDUAL'
            CALL STORE.END.ERROR
        END
    END

    IF Y.RESIDUAL.VAL EQ 'YES' AND Y.RESIDUAL.MODE EQ 'CASH' THEN
        Y.LAST.VAL = Y.PAYMENT.MODE<Y.MODE.CNT>
        IF Y.RESIDUAL.MODE NE Y.LAST.VAL THEN
            ETEXT = 'TT-CASH.RES.CMPR'
            CALL STORE.END.ERROR
        END
    END

    IF Y.RESIDUAL.VAL EQ 'YES' AND Y.RESIDUAL.MODE EQ 'ACCOUNT.TRANSFER' THEN
        Y.LAST.VAL = Y.PAYMENT.MODE<Y.MODE.CNT>
        IF Y.RESIDUAL.MODE NE Y.LAST.VAL THEN
            ETEXT = 'TT-TRANS.RES.CMPR'
            CALL STORE.END.ERROR
        END
    END

    IF Y.RESIDUAL.VAL EQ 'YES' AND Y.RESIDUAL.MODE EQ 'CHEQUE' THEN
        Y.LAST.VAL = Y.PAYMENT.MODE<Y.MODE.CNT>
        IF Y.RESIDUAL.MODE NE Y.LAST.VAL THEN
            ETEXT = 'TT-CHQ.RES.CMPR'
            CALL STORE.END.ERROR
        END
    END

    Y.SET.MODE = R.NEW(REDO.MTS.SETTLEMENT.MODE)
    Y.RESIDUAL.MODE = R.NEW(REDO.MTS.RESIDUAL.MODE)
    IF Y.SET.MODE EQ 'CHEQUE' AND (Y.RESIDUAL.MODE EQ '' OR Y.RESIDUAL.MODE EQ 'CHEQUE') THEN
        Y.INIT = 1
        LOOP
        WHILE Y.INIT LE Y.MODE.CNT
            Y.FIRST.VAL = Y.PAYMENT.MODE<Y.INIT>
            IF Y.FIRST.VAL NE Y.SET.MODE THEN
                ETEXT = 'TT-ARR.SETTLEMENT'
                CALL STORE.END.ERROR
            END
            Y.INIT + =1
        REPEAT
    END

    IF Y.SET.MODE EQ 'CHEQUE' THEN
        Y.INIT = 1
        LOOP
        WHILE Y.INIT LE Y.MODE.CNT
            Y.FIRST.VAL = Y.PAYMENT.MODE<Y.INIT>
            IF Y.FIRST.VAL NE Y.SET.MODE THEN
                ETEXT = 'TT-ARR.SETTLEMENT'
                CALL STORE.END.ERROR
            END
            Y.INIT + =1
        REPEAT
    END
    GOSUB FINAL.PROCESS
RETURN

*----------------
FINAL.PROCESS:

    IF Y.RESIDUAL.VAL EQ 'YES'AND Y.RESIDUAL.MODE EQ 'CHEQUE' THEN
        Y.LAST.VAL = Y.PAYMENT.MODE<Y.MODE.CNT>
        IF Y.RESIDUAL.MODE NE Y.LAST.VAL THEN
            ETEXT = 'TT-ARR.CHEQUE.ID'
            CALL STORE.END.ERROR
        END
    END


    IF Y.SET.MODE EQ 'CASH' THEN
        Y.BAL.TOT.AMT = R.NEW(REDO.MTS.CASH.AMT)
        Y.BAL.TOT.AMT1 = Y.BAL.TOT.AMT-Y.FINAL.AMT
        R.NEW(REDO.MTS.REMAINDER.AMT) = Y.BAL.TOT.AMT1
    END


    IF Y.SET.MODE EQ '' THEN
        Y.BAL.TRAN.AMT1 = R.NEW(REDO.MTS.TRANSACTION.AMT)
        Y.BAL.TRAN.AMT = CHANGE(Y.BAL.TRAN.AMT1,@VM,@FM)
        Y.CNT = DCOUNT(Y.BAL.TRAN.AMT,@FM)
        Y.INIT = 1
        LOOP
        WHILE Y.INIT LE Y.CNT
            Y.ANT.AMT1 = Y.BAL.TRAN.AMT<Y.INIT>
            Y.PYMT.CNT = DCOUNT(Y.PYMT.MODE,@FM)
            Y.PYMT.MODE3 = Y.PYMT.MODE<Y.INIT>
            IF Y.PYMT.MODE3 EQ 'CASH' THEN
                Y.TOTAL.AMT1 += Y.ANT.AMT1
            END
            Y.INIT + =1
        REPEAT

        Y.CASH.AMT = R.NEW(REDO.MTS.CASH.AMT)
        Y.BAL.TOT.AMT1 = Y.CASH.AMT-Y.TOTAL.AMT1
        R.NEW(REDO.MTS.REMAINDER.AMT) = Y.BAL.TOT.AMT1
    END


*    IF (Y.SET.MODE EQ 'CASH') AND (Y.BAL.TOT.AMT1 EQ 0.00) AND (Y.PYMT.MODE4 EQ 'CASH') THEN
    IF (Y.BAL.TOT.AMT1 EQ 0.00) AND (Y.PYMT.MODE4 EQ 'CASH') THEN
        R.NEW(REDO.MTS.VERSION.1) = 'TELLER,CASHLESS.1'
        R.NEW(REDO.MTS.VERSION.2) = ''
*        R.NEW(REDO.MTS.VERSION.3) = ''
    END

    IF (Y.SET.MODE EQ 'CASH') AND (Y.BAL.TOT.AMT1 GT 0.00) AND (Y.PYMT.MODE4 EQ 'CASH') THEN
        IF (Y.BAL.TOT.AMT1 GT 0.00) AND (Y.PYMT.MODE4 EQ 'CASH') THEN
            R.NEW(REDO.MTS.VERSION.1) = 'TELLER,CASHBACK.2'
            R.NEW(REDO.MTS.VERSION.2) = 'TELLER,CASHBACK.3'
        END

*--------------------------
*To calculate the total amount

        Y.CASH.AMT = R.NEW(REDO.MTS.CASH.AMT)
        Y.CHEQUE.AMT = R.NEW(REDO.MTS.CHEQUE.AMT)
        Y.TRANSFER.AMT = R.NEW(REDO.MTS.TRANSFER.AMT)
        Y.CASH.CHE.AMT = Y.CASH.AMT+Y.CHEQUE.AMT+Y.TRANSFER.AMT
        Y.TOTAL.AMOUNT = R.NEW(REDO.MTS.TOTAL.AMT)
        IF Y.TOTAL.AMOUNT NE '' AND (Y.CASH.AMT NE '' OR Y.CHEQUE.AMT NE '' OR Y.TRANSFER.AMT NE '') THEN
            IF Y.CASH.CHE.AMT GT Y.TOTAL.AMOUNT THEN
                ETEXT = 'TT-CASH.CHQ.CMPR'
                CALL STORE.END.ERROR
            END
        END
        IF Y.OPERATION EQ 'DISBURSEMENT' THEN
            Y.TANS.AMT = R.NEW(REDO.MTS.TRANSACTION.AMT)
            Y.TOTAL = SUM(Y.TANS.AMT)
            Y.TOT = R.NEW(REDO.MTS.TOTAL.AMT)
            IF Y.TOT AND Y.TOTAL THEN
                IF Y.TOT NE Y.TOTAL THEN
                    ETEXT = 'TT-TOTAL.AMOUNT.IS.NOT.EQ'
                    CALL STORE.END.ERROR
                END
            END
        END
        RETURN
*--------------
    END
