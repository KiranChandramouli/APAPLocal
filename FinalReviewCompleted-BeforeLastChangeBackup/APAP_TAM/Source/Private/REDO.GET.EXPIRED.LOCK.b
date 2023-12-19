    $PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.GET.EXPIRED.LOCK
*--------------------------------------------------------------------------------
* select account numbers from ac.locked.events
* save the ids to a concat table REDO.LOCK.EXP.LIST
* RUN this job before FILE.TIDY.UP

** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion - No changes
** 13-12-2023 EdwinC R22 Manual Conversion - COB Issue Fix 
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.AC.LOCKED.EVENTS ;* COB Issue Fix
*************************************************************************

    FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS = ''
    CALL OPF(FN.AC.LOCKED.EVENTS, F.AC.LOCKED.EVENTS)

    FN.REDO.LOCK.EXP.LIST = 'F.REDO.LOCK.EXP.LIST'
    F.REDO.LOCK.EXP.LIST = ''
    CALL OPF(FN.REDO.LOCK.EXP.LIST, F.REDO.LOCK.EXP.LIST)
    REC.IDS =''
    L.WORK.DATE = TODAY

*  SEL.CMD  = 'SELECT ' :FN.AC.LOCKED.EVENTS : ' WITH TO.DATE LE ' : L.WORK.DATE : " AND TO.DATE NE '' SAVING UNIQUE ACCOUNT.NUMBER BY ACCOUNT.NUMBER"
    SEL.CMD  = 'SELECT ' :FN.AC.LOCKED.EVENTS : ' WITH TO.DATE LE ' : L.WORK.DATE : " AND TO.DATE NE ''" ;* COB Issue Fix
    CALL EB.READLIST(SEL.CMD, AC.NOS, '', '', '')
* COB Issue Fix - Start
    LOOP
        REMOVE Y.AC.LOCK.ID FROM AC.NOS SETTING Y.POS
    WHILE Y.AC.LOCK.ID:Y.POS
        CALL F.READ(FN.AC.LOCKED.EVENTS,Y.AC.LOCK.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,AC.ERR)
        IF R.AC.LOCKED.EVENTS THEN
            AC.ID =R.AC.LOCKED.EVENTS<AC.LCK.ACCOUNT.NUMBER>
            LOCATE AC.ID IN REC.IDS SETTING POS THEN
            END ELSE
                REC.IDS<-1> = AC.ID
            END
        END
* COB Issue Fix - End
    REPEAT

    CALL F.WRITE(FN.REDO.LOCK.EXP.LIST, L.WORK.DATE, REC.IDS)

    RETURN

END
