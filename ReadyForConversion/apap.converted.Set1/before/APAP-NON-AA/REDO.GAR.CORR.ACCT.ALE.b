*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.GAR.CORR.ACCT.ALE
*------------------------------------------------------------------------------
*Written by :Prabhu
*This routine is  correction to the table REDO.ACCT.ALE. This table should have
*only valid garnishment records
*-----------------------------------------------------------------------------
    $INCLUDE I_COMMON
    $INCLUDE I_EQUATE

    FN.REDO.ACCT.ALE='F.REDO.ACCT.ALE'
    F.REDO.ACCT.ALE =''
    CALL OPF(FN.REDO.ACCT.ALE,F.REDO.ACCT.ALE)

    FN.AC.LOCKED.EVENTS='F.AC.LOCKED.EVENTS'
    F.AC.LOCKED.EVENTS =''
    CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

    GOSUB PROCESS
    RETURN
*-------
PROCESS:
*-------

    Y.SEL.CMD='SELECT ':FN.REDO.ACCT.ALE
    CALL EB.READLIST(Y.SEL.CMD,Y.SEL.LIST,'',Y.SEL.CNT,Y.ERR)

    LOOP
        REMOVE Y.ACCT.ALE.ID FROM Y.SEL.LIST SETTING Y.ACCT.ALE.POS
    WHILE Y.ACCT.ALE.ID:Y.ACCT.ALE.POS

        R.REDO.ACCT.ALE=''

        CALL F.READ(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.REDO.ACCT.ALE,F.REDO.ACCT.ALE,Y.ERR)
        IF R.REDO.ACCT.ALE THEN
            GOSUB PROCESS.ACCT.ALE
        END
        ELSE
            CALL F.DELETE(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID)
        END
        Y.ACCT.ALE.ID = ''
    REPEAT
    RETURN
*----------------
PROCESS.ACCT.ALE:
*----------------
    Y.ALE.ID.LIST    =R.REDO.ACCT.ALE
    Y.NEW.ALE.ID.LIST=''

    LOOP
        REMOVE Y.ALE.ID FROM Y.ALE.ID.LIST SETTING Y.ALE.POS
    WHILE Y.ALE.ID:Y.ALE.POS
        CALL F.READ(FN.AC.LOCKED.EVENTS,Y.ALE.ID,R.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS,Y.ERR)
        IF R.AC.LOCKED.EVENTS THEN
            Y.NEW.ALE.ID.LIST<-1>=Y.ALE.ID
        END
        Y.ALE.ID=''
    REPEAT
    R.REDO.ACCT.ALE=Y.NEW.ALE.ID.LIST
    CALL F.WRITE(FN.REDO.ACCT.ALE,Y.ACCT.ALE.ID,R.REDO.ACCT.ALE)
    CALL JOURNAL.UPDATE(Y.ACCT.ALE.ID)
    RETURN
END