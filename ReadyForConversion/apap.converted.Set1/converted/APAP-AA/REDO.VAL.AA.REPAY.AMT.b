SUBROUTINE REDO.VAL.AA.REPAY.AMT
*-------------------------------------------------
*Description: This routine is to check the overpayment
*             amount against the loan outstanding amount.
*-------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER


    GOSUB PROCESS

RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------
* Fix for PACS00392651 [Over Payment Cheque TXN not displaying in REDO.TELLER.TODAY]

    CALL MULTI.GET.LOC.REF('TELLER','L.INITIAL.ID',LOC.REF.POS)

    IF PGM.VERSION EQ ',REDO.OVERPYMT.CASH' AND R.NEW(TT.TE.LOCAL.REF)<1,LOC.REF.POS> EQ ID.NEW THEN
        AF = TT.TE.LOCAL.REF
        AV = LOC.REF.POS
        ETEXT = 'TT-REDO.OVERPAY.RSTR.STNDALN'
        CALL STORE.END.ERROR
    END

* End of Fix

    Y.LOAN.ACC  = R.NEW(TT.TE.NARRATIVE.1)<1,1>
    Y.REPAY.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)

    CALL REDO.CONVERT.ACCOUNT(Y.LOAN.ACC,"",ARR.ID,ERR.TEXT)
    GOSUB GET.LOAN.OUTSTANDING.BALANCE
    GOSUB GET.UNC.BALANCES
    Y.PENDING.AMT = Y.PROP.AMT<1> - Y.UNC.BALANCE

    IF Y.REPAY.AMT GT Y.PENDING.AMT THEN
        AF    = TT.TE.AMOUNT.LOCAL.1
        ETEXT = 'EB-REDO.REPAY.AMT.GTFS'
        CALL STORE.END.ERROR
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



END
