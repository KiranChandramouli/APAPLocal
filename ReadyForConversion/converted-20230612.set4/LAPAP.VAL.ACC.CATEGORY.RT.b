SUBROUTINE LAPAP.VAL.ACC.CATEGORY.RT

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
    Y.ACCOUNT                = R.NEW(AC.LCK.ACCOUNT.NUMBER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

RETURN

*=======
PROCESS:
*=======
    R.ACCOUNT =''; ACCOUNT.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
    Y.CATEGORY              = R.ACCOUNT<AC.CATEGORY>

    IF Y.CATEGORY NE "6034" THEN
        TEXT = "La cuenta numero: ":Y.ACCOUNT:" no es de tipo Bolsillo. Categoria 6034"
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

RETURN

END
