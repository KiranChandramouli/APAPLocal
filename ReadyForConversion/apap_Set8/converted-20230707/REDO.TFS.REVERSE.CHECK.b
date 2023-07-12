SUBROUTINE REDO.TFS.REVERSE.CHECK
*------------------------------------------------------------
*Description: This routine is to check whether the Clearing Outfile has been
*               processed for the TFS.
*------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.OUT.CLEAR.FILE
    $INSERT I_F.T24.FUND.SERVICES
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------
    FN.REDO.OUT.CLEAR.FILE = 'F.REDO.OUT.CLEAR.FILE'
    F.REDO.OUT.CLEAR.FILE = ''
    CALL OPF(FN.REDO.OUT.CLEAR.FILE,F.REDO.OUT.CLEAR.FILE)

RETURN
*------------------------------------------------------------
PROCESS:
*------------------------------------------------------------

    Y.ID = ID.NEW
    Y.TODAY  = TODAY

    Y.REV.TOTAL =  DCOUNT(R.NEW(TFS.REVERSAL.MARK),@VM)
    LOOP
    WHILE Y.REV.INT LE Y.REV.TOTAL
        R.NEW(TFS.REVERSAL.MARK)<1,Y.REV.INT> = 'R'
        Y.REV.INT += 1
    REPEAT
    CALL F.READ(FN.REDO.OUT.CLEAR.FILE,Y.TODAY,R.REDO.OUT.CLEAR.FILE,F.REDO.OUT.CLEAR.FILE,OUT.ERR)
    LOCATE Y.ID IN R.REDO.OUT.CLEAR.FILE<REDO.OUT.CLEAR.FILE.TFS.ID,1> SETTING POS THEN
        ETEXT = 'EB-REDO.REV.NOT.ALLOWED'
        CALL STORE.END.ERROR
    END
RETURN
END
