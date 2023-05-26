SUBROUTINE LAPAP.VAL.BOL.BALANCE.RT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.ACCOUNT


    GOSUB LOAD
    GOSUB PROCESS
*====
LOAD:
*====

    Y.MONTO.BOL                = R.NEW(AC.LCK.LOCKED.AMOUNT)
    Y.ACCOUNT                  = R.NEW(AC.LCK.ACCOUNT.NUMBER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN

*=======
PROCESS:
*=======

    R.ACC = ''; ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACC,F.ACCOUNT,ACC.ERR)
    ACC.POS = '';
    CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",ACC.POS)
    Y.ACC.BAL               = R.ACC<AC.LOCAL.REF,ACC.POS>

    IF Y.MONTO.BOL GE Y.ACC.BAL THEN
        TEXT = "La cuenta numero ":Y.ACCOUNT:" no posee fondos suficientes. Fondos actuales de la cuenta: ":Y.ACC.BAL
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

RETURN

END
