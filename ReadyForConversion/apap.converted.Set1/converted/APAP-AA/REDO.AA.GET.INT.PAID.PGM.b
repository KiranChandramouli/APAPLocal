PROGRAM REDO.AA.GET.INT.PAID.PGM

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
    $INSERT I_AA.LOCAL.COMMON
* DEBUG
    Y.ACCOUNT.ID       =1000009807
    Y.BALANCE.TYPE     ='REPAYINT'
    Y.REQUEST.DATE.LAST='20101107'
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ACCOUNT.ID,Y.BALANCE.TYPE,Y.REQUEST.DATE.LAST,Y.BALANCE.AMOUNT.LAST,Y.RET.ERROR)
    Y.REQUEST.DATE.TODAY=TODAY
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ACCOUNT.ID, Y.BALANCE.TYPE, Y.REQUEST.DATE.TODAY, Y.BALANCE.AMOUNT.NEW,Y.RET.ERROR)

RETURN
END
