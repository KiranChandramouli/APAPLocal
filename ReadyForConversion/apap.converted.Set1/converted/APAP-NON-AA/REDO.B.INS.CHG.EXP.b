SUBROUTINE REDO.B.INS.CHG.EXP(Y.ID)
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.INS.CHG.EXP.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY

MAIN:


    CALL F.READ(FN.INSURANCE,Y.ID,R.INSURANCE,F.INSURANCE,INS.ERR)
    Y.AA.ID = R.INSURANCE<INS.DET.ASSOCIATED.LOAN>

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARR,F.AA.ARRANGEMENT,AA.ERR)
    IF R.AA.ARR THEN
        GOSUB PROCESS.AA.INS
    END

RETURN

PROCESS.AA.INS:

    R.INSURANCE<INS.DET.POLICY.STATUS> = 'VENCIDA'
    CALL F.WRITE(FN.INSURANCE,Y.ID,R.INSURANCE)

    Y.CHG = R.INSURANCE<INS.DET.CHARGE>
    Y.ACT = 'LENDING-CHANGE-':Y.CHG

    Y.AAA.REQ<AA.ARR.ACT.ARRANGEMENT> = Y.AA.ID
    Y.AAA.REQ<AA.ARR.ACT.ACTIVITY> = Y.ACT
    Y.AAA.REQ<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY
    Y.AAA.REQ<AA.ARR.ACT.PROPERTY,1> = Y.CHG
    Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'FIXED.AMOUNT'
    Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = '0.00'
    Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'STATUS.POLICY'
    Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = 'VENCIDA'

    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
    IN.FUNCTION = 'I'
    VERSION.NAME = 'AA.ARRANGEMENT.ACTIVITY,ZERO.AUTH'

    CALL OFS.BUILD.RECORD(APP.NAME, IN.FUNCTION, "PROCESS", VERSION.NAME, "", "0", AAA.ID, Y.AAA.REQ, PROCESS.MSG)

    OFS.MSG.ID = ''
    OFS.SOURCE = 'TRIGGER.INSURANCE'
    OFS.ERR = ''

    CALL OFS.POST.MESSAGE(PROCESS.MSG,OFS.MSG.ID,OFS.SOURCE,OFS.ERR)

    CALL OCOMO("INSURANCE PROCESSED - ":Y.ID)

RETURN

END
