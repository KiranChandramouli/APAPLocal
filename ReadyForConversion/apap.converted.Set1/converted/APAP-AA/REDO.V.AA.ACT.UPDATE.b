SUBROUTINE REDO.V.AA.ACT.UPDATE
*-----------------------------------------------------------------------------
*
* Bank name: APAP
* Decription: The arragement history will be checked for AUTH and TRANSACTION activities
* Developed By: Edwin Charles D
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_System
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ACTIVITY
    $INSERT I_F.REDO.AA.ACTIVITY.LOG

    IF MESSAGE EQ 'VAL' THEN
        GOSUB INIT
        GOSUB PROCESS
    END

RETURN

INIT:
*----

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY, F.AA.ARRANGEMENT.ACTIVITY)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY, F.AA.ACTIVITY.HISTORY)

    FN.REDO.AA.ACTIVITY.LOG.NAU = 'F.REDO.AA.ACTIVITY.LOG$NAU'
    F.REDO.AA.ACTIVITY.LOG.NAU = ''
    CALL OPF(FN.REDO.AA.ACTIVITY.LOG.NAU, F.REDO.AA.ACTIVITY.LOG.NAU)

    FN.AA.ARRANGEMENT.STATUS = 'F.AA.ARRANGEMENT.STATUS'
    F.AA.ARRANGEMENT.STATUS = ''
    CALL OPF(FN.AA.ARRANGEMENT.STATUS, F.AA.ARRANGEMENT.STATUS)

RETURN

PROCESS:
*-------


    Y.TIME = TIME()
    Y.DATE = DATE()
    Y.ACTIVITY.REF = ID.NEW
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ACTIVITY.REF,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ARR.ACT.ERR)
    Y.ARR.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ARRANGEMENT>
    R.AA.ARRANGEMENT.STATUS = ''
    CALL F.READ(FN.AA.ARRANGEMENT.STATUS, Y.ARR.ID, R.AA.ARRANGEMENT.STATUS, F.AA.ARRANGEMENT.STATUS, ARR.STAT.ERR)
    IF R.AA.ARRANGEMENT.STATUS<1> THEN
        AF = RE.LOG.ACTIVITY.REF
        ETEXT = 'AA-ARRANGEMENT.LOCKED':@FM:R.AA.ARRANGEMENT.STATUS<1>
        CALL STORE.END.ERROR
        RETURN
    END
    R.NEW(RE.LOG.ARRANGEMENT.ID)    = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ARRANGEMENT>
    R.NEW(RE.LOG.EFFECTIVE.DATE) = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.EFFECTIVE.DATE>
    R.NEW(RE.LOG.ACTIVITY.NAME)  = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ACTIVITY>
    R.NEW(RE.LOG.INIT)           = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.INITIATION.TYPE>
    R.NEW(RE.LOG.IN.TIMESTAMP)   = Y.DATE:Y.TIME
    CALL F.READ(FN.AA.ACTIITY.HISTORY, Y.ARR.ID, R.AA.ACTIVITY.HISTORY, F.AA.ACTIVITY.HISTORY, AA.HIS.ERR)
    Y.ACTIVITY.LIST   = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
    Y.ACTIVITY.REF.LIST    = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF>
    Y.ACT.STATUS.LIST      = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS>
    Y.INIT.LIST            = R.AA.ACTIVITY.HISTORY<AA.AH.INITIATION>

    CHANGE @SM TO @FM IN Y.ACTIVITY.REF.LIST
    CHANGE @SM TO @FM IN Y.ACT.STATUS.LIST
    CHANGE @SM TO @FM IN Y.INIT.LIST

    CHANGE @VM TO @FM IN Y.ACTIVITY.REF.LIST
    CHANGE @VM TO @FM IN Y.ACT.STATUS.LIST
    CHANGE @VM TO @FM IN Y.INIT.LIST

    LOCATE Y.ACTIVITY.REF IN Y.ACTIVITY.REF.LIST<1> SETTING REF.POS THEN

        TOT.CNT = REF.POS
        CNT = 1
        LOOP
        WHILE CNT LE TOT.CNT
            IF Y.ACT.STATUS.LIST<CNT> EQ 'AUTH' AND (Y.INIT.LIST<CNT> EQ 'USER' OR Y.INIT.LIST<CNT> EQ 'TRANSACTION') THEN
                TEMP.ACTIVITY.REF = Y.ACTIVITY.REF.LIST<CNT>
                CALL F.READ(FN.REDO.AA.ACTIVITY.LOG.NAU,TEMP.ACTIVITY.REF,R.REDO.AA.ACTIVITY.LOG.NAU,F.REDO.AA.ACTIVITY.LOG.NAU,ACT.NAU.ERR)
                IF NOT(R.REDO.AA.ACTIVITY.LOG.NAU) AND Y.ACTIVITY.REF NE Y.ACTIVITY.REF.LIST<CNT> THEN
                    AF = RE.LOG.ACTIVITY.REF
                    ETEXT = 'AA-USER.SHOULD.COMMIT.PREVIOUS.ACT'
                    CALL STORE.END.ERROR
                    RETURN
                END
            END
            CNT += 1
        REPEAT
    END

RETURN

PROGRAM.EXT:
*-----------
END
