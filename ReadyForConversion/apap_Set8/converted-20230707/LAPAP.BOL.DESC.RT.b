SUBROUTINE LAPAP.BOL.DESC.RT

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.VERSION
    $INSERT I_F.AC.LOCKED.EVENTS
    $INSERT I_F.L.APAP.TRANS.BOLSILLO


    GOSUB LOAD
    GOSUB PROCESS

*====
LOAD:
*====

    Y.BOL.ID              = COMI

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)
RETURN

*=======
PROCESS:
*=======
    R.AC.LOK = ''; AC.LOK.ERR = ''
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.BOL.ID,R.AC.LOK,F.AC.LOCKED.EVENTS,AC.LOK.ERR)
    Y.DESCRIPCION               = R.AC.LOK<AC.LCK.DESCRIPTION>
    Y.BALANCE                   = R.AC.LOK<AC.LCK.LOCKED.AMOUNT>


    R.NEW(ST.L.A19.DESCRIPCION1) = Y.DESCRIPCION
    R.NEW(ST.L.A19.BALANCE1)     = Y.BALANCE

END
