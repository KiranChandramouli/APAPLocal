*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.VAL.DIF.BOLS.RT

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_System
    $INSERT T24.BP I_F.VERSION
    $INSERT T24.BP I_F.AC.LOCKED.EVENTS
    $INSERT T24.BP I_F.ACCOUNT


    GOSUB LOAD
    GOSUB PROCESS
*====
LOAD:
*====
    Y.BOL.DEBIT                = ID.NEW
    Y.MONTO.BOL                = R.NEW(AC.LCK.LOCKED.AMOUNT)
    Y.ACCOUNT                  = R.NEW(AC.LCK.ACCOUNT.NUMBER)

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

    R.AC.LOCK = ''; AC.LOCK.ERR = ''
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.BOL.DEBIT,R.AC.LOCK,F.AC.LOCKED.EVENTS,AC.LOCK.ERR)

    Y.MON.REAL         = R.AC.LOCK<AC.LCK.LOCKED.AMOUNT>

    R.ACC = ''; ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACC,F.ACCOUNT,ACC.ERR)
    ACC.POS = '';
    CALL GET.LOC.REF("ACCOUNT","L.AC.AV.BAL",ACC.POS)
    Y.ACC.BAL               = R.ACC<AC.LOCAL.REF,ACC.POS>

    Y.DIFERENCIA            = Y.MONTO.BOL - Y.MON.REAL

    IF Y.DIFERENCIA GT Y.ACC.BAL THEN
        TEXT = "La cuenta numero: ":Y.ACCOUNT:" no posee fondos suficientes. Fondos actuales de la cuenta: ":Y.ACC.BAL
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

    RETURN

END
