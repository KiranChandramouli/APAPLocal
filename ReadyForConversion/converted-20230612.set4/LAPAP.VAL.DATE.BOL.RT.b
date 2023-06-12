SUBROUTINE LAPAP.VAL.DATE.BOL.RT

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

    Y.LOC.REF                  = R.NEW(AC.LCK.LOCAL.REF)
    Y.LOC.REF                  = CHANGE(Y.LOC.REF,@VM,@FM)
    Y.LOC.REF                  = CHANGE(Y.LOC.REF,@SM,@FM)
    Y.DAT.INI                  = Y.LOC.REF<24>
    Y.DAT.END                  = Y.LOC.REF<25>

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
RETURN

*=======
PROCESS:
*=======
    Y.VAL.INI               = Y.DAT.INI * 1
    Y.VAL.FIN               = Y.DAT.END * 1

    IF Y.VAL.FIN LE Y.VAL.INI THEN
        TEXT = "La fecha final de la meta no puede ser menor o igual que la fecha de inicio."
        ETEXT = TEXT
        E = TEXT
        CALL ERR
    END

RETURN

END
