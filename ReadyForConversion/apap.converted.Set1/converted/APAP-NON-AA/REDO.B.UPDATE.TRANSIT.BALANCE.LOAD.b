SUBROUTINE REDO.B.UPDATE.TRANSIT.BALANCE.LOAD
*--------------------------------------------------------------
*Description: This is the batch routine to update the transit balance
*             based on the release of ALE.
*--------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPDATE.TRANSIT.BALANCE.COMMON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------

    FN.REDO.TRANSIT.ALE = 'F.REDO.TRANSIT.ALE'
    F.REDO.TRANSIT.ALE  = ''
    CALL OPF(FN.REDO.TRANSIT.ALE,F.REDO.TRANSIT.ALE)

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS  = ''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    FN.AC.LOCKED.EVENTS.HIS = 'F.AC.LOCKED.EVENTS$HIS'
    F.AC.LOCKED.EVENTS.HIS  = ''
    CALL OPF(FN.AC.LOCKED.EVENTS.HIS,F.AC.LOCKED.EVENTS.HIS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.APPLICATION   = "ACCOUNT"
    LOC.REF.FIELDS        = 'L.AC.TRAN.AVAIL'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AC.TRAN.AVAIL   = LOC.REF.POS<1,1>

RETURN
END
