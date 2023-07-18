*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.BOL.CREDIT.RT

    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_System
    $INSERT T24.BP I_F.VERSION
    $INSERT T24.BP I_F.AC.LOCKED.EVENTS
    $INSERT BP I_F.L.APAP.TRANS.BOLSILLO


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


    R.NEW(ST.L.A19.DESCRIPCION2) = Y.DESCRIPCION
    R.NEW(ST.L.A19.BALANCE2)     = Y.BALANCE

END
