SUBROUTINE REDO.GET.EXPIRED.LOCK
*--------------------------------------------------------------------------------
* select account numbers from ac.locked.events
* save the ids to a concat table REDO.LOCK.EXP.LIST
* RUN this job before FILE.TIDY.UP
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
*************************************************************************

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS, F.AC.LOCKED.EVENTS)

    FN.REDO.LOCK.EXP.LIST = 'F.REDO.LOCK.EXP.LIST'
    F.REDO.LOCK.EXP.LIST = ''
    CALL OPF(FN.REDO.LOCK.EXP.LIST, F.REDO.LOCK.EXP.LIST)

    L.WORK.DATE = TODAY

    SEL.CMD  = 'SELECT ' :FN.AC.LOCKED.EVENTS : ' WITH TO.DATE LE ' : L.WORK.DATE : " AND TO.DATE NE '' SAVING UNIQUE ACCOUNT.NUMBER BY ACCOUNT.NUMBER"
    CALL EB.READLIST(SEL.CMD, AC.NOS, '', '', '')

    REC.IDS = ''
    LOOP
    UNTIL AC.NOS<1> = ''
        RECID = AC.NOS<1>
        DEL AC.NOS<1>
        IF NOT(NUM(RECID)) THEN
            RECID = FIELD(RECID,'\',1)
        END
        REC.IDS<-1> = RECID
    REPEAT

    CALL F.WRITE(FN.REDO.LOCK.EXP.LIST, L.WORK.DATE, REC.IDS)


RETURN

END
