SUBROUTINE REDO.INP.CHECK.MORE.AMT
*-------------------------------------------------------------
* Description: This routine is an input routine for AA repayment.
* here we will check the total outstanding of the loan against the payment amount.
* if the repayment amt is greator than loan outstanding, blocking override will be
* thrown.
*-------------------------------------------------------------
* Modification History
*-------------------------
* Date          Who               Reference             Description
* -----         ----              ----------            ----------------
*21-08-2017     Edwin Charles D   PACS00618065          We are validating the unauth record in local codings
*
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.REDO.PART.TT.PROCESS

    IF OFS$SOURCE.ID EQ 'FASTPATH' THEN
        RETURN
    END

    GOSUB OPEN.FILES
    IF APPLICATION EQ 'REDO.PART.TT.PROCESS' THEN
        GOSUB PROCESS.COLLECTION
    END ELSE
        GOSUB PROCESS
    END
RETURN
*-------------------------------------------------------------
OPEN.FILES:
*-------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS  = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ARRANGEMENT.STATUS = 'F.AA.ARRANGEMENT.STATUS'
    F.AA.ARRANGEMENT.STATUS = ''
    CALL OPF(FN.AA.ARRANGEMENT.STATUS, F.AA.ARRANGEMENT.STATUS)

RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------
    R.AA.ARRANGEMENT.STATUS = ''
    Y.LOAN.ACC  = R.NEW(FT.CREDIT.ACCT.NO)
    Y.TXN.TYPE  = R.NEW(FT.TRANSACTION.TYPE)

    GOSUB CHECK.LOAN.ACC

    Y.REPAY.AMT = R.NEW(FT.CREDIT.AMOUNT)
    IF Y.REPAY.AMT ELSE       ;* skip if no repay amt.
        GOSUB END1
    END
    GOSUB CHECK.PAYOFF.BILL
    IF Y.PAYOFF.AMT AND (Y.TXN.TYPE EQ 'ACPO' OR Y.TXN.TYPE EQ 'ACCP' OR Y.TXN.TYPE EQ 'ACCA' OR Y.TXN.TYPE EQ 'ACQP') THEN
        Y.PENDING.AMT = Y.PAYOFF.AMT
    END ELSE
        GOSUB GET.LOAN.OUTSTANDING.BALANCE
        GOSUB GET.UNC.BALANCES
        Y.PENDING.AMT = Y.TOTAL.AMT - Y.UNC.BALANCE
    END
    IF Y.REPAY.AMT GT Y.PENDING.AMT THEN
        AF    = FT.CREDIT.AMOUNT
        ETEXT = 'EB-REDO.REPAY.AMT.GTFS'
        CALL STORE.END.ERROR
    END
RETURN
*-------------------------------------------------------------
CHECK.LOAN.ACC:
*-------------------------------------------------------------
* Check whether it is loan account or not.
    ARR.ID = ''
    CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    IF ARR.ID ELSE  ;* No need to process for other accounts.
        GOSUB END1
    END

RETURN
*-------------------------------------------------------------
GET.LOAN.OUTSTANDING.BALANCE:
*-------------------------------------------------------------
* Here  we get the amount excluding the UNC balances.
    Y.PROP.AMT  = 0
    Y.TOTAL.AMT = 0
    CALL REDO.GET.TOTAL.OUTSTANDING.SIN.UNC.UND(ARR.ID,Y.PROP.AMT,Y.TOTAL.AMT)

RETURN
*-------------------------------------------------------------
GET.UNC.BALANCES:
*-------------------------------------------------------------
* Here we get the UNC balance of the Loan.

    Y.ACCOUNT.PROPERTY = ''
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)

    BALANCE.TO.CHECK = 'UNC':Y.ACCOUNT.PROPERTY
    BALANCE.AMOUNT   = ''
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.LOAN.ACC,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR)
    Y.UNC.BALANCE = ABS(BALANCE.AMOUNT)
RETURN
*-------------------------------------------------------------
PROCESS.COLLECTION:
*-------------------------------------------------------------

    Y.LOAN.ACC  = R.NEW(PAY.PART.TT.ARRANGEMENT.ID)
    GOSUB CHECK.LOAN.ACC
    Y.REPAY.AMT = R.NEW(PAY.PART.TT.AMOUNT)
    IF Y.REPAY.AMT ELSE       ;* skip if no repay amt.
        GOSUB END1
    END
    GOSUB CHECK.PAYOFF.BILL
    IF Y.PAYOFF.AMT THEN
        Y.PENDING.AMT = Y.PAYOFF.AMT
    END ELSE
        GOSUB GET.LOAN.OUTSTANDING.BALANCE
        GOSUB GET.UNC.BALANCES
        Y.PENDING.AMT = Y.TOTAL.AMT - Y.UNC.BALANCE
    END
    IF Y.REPAY.AMT GT Y.PENDING.AMT THEN
        AF = PAY.PART.TT.AMOUNT
        ETEXT = 'EB-REDO.REPAY.AMT.GTFS'
        CALL STORE.END.ERROR
    END
RETURN
*-------------------------------------------------------------
CHECK.PAYOFF.BILL:
*-------------------------------------------------------------
    Y.PAYOFF.AMT = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.ACC.ERR)
    Y.BILL.IDS  = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.BILL.TYPE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>
    CHANGE @SM TO @FM IN Y.BILL.IDS
    CHANGE @VM TO @FM IN Y.BILL.IDS
    CHANGE @SM TO @FM IN Y.BILL.TYPE
    CHANGE @VM TO @FM IN Y.BILL.TYPE


    LOCATE 'PAYOFF' IN Y.BILL.TYPE SETTING POS1 THEN
        Y.PAYOFF.BILL.ID = Y.BILL.IDS<POS1>
        GOSUB GET.PAYOFF.AMOUNT

    END


RETURN
*-------------------------------------------------------------
GET.PAYOFF.AMOUNT:
*-------------------------------------------------------------
    R.BILL.DETAILS = ''
    RET.ERROR      = ''
    CALL AA.GET.BILL.DETAILS(ARR.ID, Y.PAYOFF.BILL.ID, R.BILL.DETAILS, RET.ERROR)
    IF R.BILL.DETAILS THEN
        Y.PAYOFF.AMT = R.BILL.DETAILS<AA.BD.OR.TOTAL.AMOUNT>
    END

RETURN
*-------------------------------------------------------------
END1:
END
