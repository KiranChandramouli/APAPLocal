SUBROUTINE REDO.CANC.CHARGE.PAYOFF.PS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY


    FN.REDO.CPY.PAY.SCH.PO = 'F.REDO.CPY.PAY.SCH.PO'
    F.REDO.CPY.PAY.SCH.PO = ''
    CALL OPF(FN.REDO.CPY.PAY.SCH.PO,F.REDO.CPY.PAY.SCH.PO)

    FN.AA.ARRANGEMENT.DATED.XREF = 'F.AA.ARRANGEMENT.DATED.XREF'
    F.AA.ARRANGEMENT.DATED.XREF = ''
    CALL OPF(FN.AA.ARRANGEMENT.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF)

    FN.AA.ARR.PS = 'F.AA.ARR.PAYMENT.SCHEDULE'
    F.AA.ARR.PS = ''
    CALL OPF(FN.AA.ARR.PS,F.AA.ARR.PS)

    Y.AA.ID = c_aalocArrId
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.AA.ID,'PAYMENT.SCHEDULE','',TODAY,'',RET.COND,RET.CD)
    RET.COND = RAISE(RET.COND)
    Y.PAY.TYPES = RET.COND<AA.PS.PAYMENT.TYPE>
    Y.PAY.PROP = RET.COND<AA.PS.PROPERTY> ; Y.CNT = DCOUNT(Y.PAY.TYPES,@VM)

    IF c_aalocActivityStatus EQ 'AUTH' THEN
        GOSUB PROCESS.REMOVE.SCH
    END

    IF c_aalocActivityStatus EQ 'AUTH-REV' THEN
        GOSUB REV.SCH
    END

RETURN

REV.SCH:

    CALL F.READ(FN.REDO.CPY.PAY.SCH.PO,Y.AA.ID,R.REDO.CPY.PAY.SACH.PO,F.REDO.CPY.PAY.SCH.PO,PO.ERR)
    IF R.REDO.CPY.PAY.SACH.PO THEN
        Y.PAY.TYPES = R.REDO.CPY.PAY.SACH.PO<AA.PS.PAYMENT.TYPE>
*    CALL F.READ(FN.AA.ARRANGEMENT.DATED.XREF,Y.AA.ID,R.AA.DATED.XREF,F.AA.ARRANGEMENT.DATED.XREF,DATED.ERR)
*    Y.TOT.PRS = R.AA.DATED.XREF<1>
*    LOCATE 'REPAYMENT.SCHEDULE' IN Y.TOT.PRS<1,1> SETTING POS.POF THEN
*        Y.LAT.DATED = R.AA.DATED.XREF<2,POS.POF,1>
*    END ELSE
*        RETURN
*  END

*   Y.FIN.ARR.ID = Y.AA.ID:'-':'REPAYMENT.SCHEDULE':'-':Y.LAT.DATED
*   CALL F.READ(FN.AA.ARR.PS,Y.FIN.ARR.ID,R.AA.ARR.PS,F.AA.ARR.PS,PS.ERR)
*   IF R.AA.ARR.PS THEN
*       RET.COND = R.AA.ARR.PS
        Y.OLD.PAY.TYPES = RET.COND<AA.PS.PAYMENT.TYPE>
        Y.OL.CNT = DCOUNT(Y.PAY.TYPES,@VM) ; Y.FS = '' ; A.OL.CNT = DCOUNT(Y.OLD.PAY.TYPES,@VM)
        LOOP
        WHILE Y.OL.CNT GT 0 DO
            Y.FS += 1
            Y.ONE.PAY = Y.PAY.TYPES<1,Y.FS>
            GOSUB REV.LOC
            Y.OL.CNT -= 1
        REPEAT
*   END ELSE
*       RETURN
*   END
    END
    IF Y.SETS EQ 'Y' THEN
        GOSUB POST.OFS
    END

RETURN

REV.LOC:

    LOCATE Y.ONE.PAY IN Y.OLD.PAY.TYPES<1,1> SETTING POS.OO ELSE
        GOSUB SUB.REV.RAT
    END

RETURN

SUB.REV.RAT:

    Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'PAYMENT.TYPE:':A.OL.CNT+1:':1'
    Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.REDO.CPY.PAY.SACH.PO<AA.PS.PAYMENT.TYPE,Y.FS>

    Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'PAYMENT.METHOD:':A.OL.CNT+1:':1'
    Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.REDO.CPY.PAY.SACH.PO<AA.PS.PAYMENT.METHOD,Y.FS>

    Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'PAYMENT.FREQ:':A.OL.CNT+1:':1'
    Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.REDO.CPY.PAY.SACH.PO<AA.PS.PAYMENT.FREQ,Y.FS>

    Y.PROP.CN = R.REDO.CPY.PAY.SACH.PO<AA.PS.PROPERTY,Y.FS> ; Y.PRS.CNT = DCOUNT(Y.PROP.CN,@SM)
    IF Y.PRS.CNT EQ 1 THEN
        Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'PROPERTY:':A.OL.CNT+1:':1'
        Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.REDO.CPY.PAY.SACH.PO<AA.PS.PROPERTY,Y.FS>

    END ELSE
        GOSUB PROC.PROP
    END
    Y.DATE.CN = R.REDO.CPY.PAY.SACH.PO<AA.PS.START.DATE> ; Y.DT.CNT = DCOUNT(Y.DATE.CN,@SM)
    IF Y.DT.CNT EQ 1 THEN
        Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'START.DATE:':A.OL.CNT+1:':1'
        Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = TODAY

        Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'END.DATE:':A.OL.CNT+1:':1'
        Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.REDO.CPY.PAY.SACH.PO<AA.PS.END.DATE,Y.FS>

        IF R.REDO.CPY.PAY.SACH.PO<AA.PS.ACTUAL.AMT,Y.FS> NE '' THEN
            Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'ACTUAL.AMT:':A.OL.CNT+1:':1'
            Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.REDO.CPY.PAY.SACH.PO<AA.PS.ACTUAL.AMT,Y.FS>
        END
    END ELSE
        GOSUB PROC.DATE
    END
    A.OL.CNT += 1
    Y.SETS = 'Y'

RETURN

PROC.DATE:

    FD = ''
    LOOP
    WHILE Y.DT.CNT GT 0 DO
        FD += 1
        Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'START.DATE:':A.OL.CNT+1:':':FD
        Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = TODAY

        Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'END.DATE:':A.OL.CNT+1:':':FD
        Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.REDO.CPY.PAY.SACH.PO<AA.PS.END.DATE,Y.FS,FD>

        IF R.REDO.CPY.PAY.SACH.PO<AA.PS.ACTUAL.AMT,Y.FS,FD> NE '' THEN
            Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'ACTUAL.AMT:':A.OL.CNT+1:':':FD
            Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.REDO.CPY.PAY.SACH.PO<AA.PS.ACTUAL.AMT,Y.FS,FD>
        END
        Y.DT.CNT -= 1
    REPEAT

RETURN

PROC.PROP:

    FH = ''
    LOOP
    WHILE Y.PRS.CNT GT 0 DO
        FH += 1
        Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'PROPERTY:':A.OL.CNT+1:':':FH
        Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = R.REDO.CPY.PAY.SACH.PO<AA.PS.PROPERTY,Y.FS,FH>
        Y.PRS.CNT -= 1
    REPEAT

RETURN

PROCESS.REMOVE.SCH:

    FLG = Y.CNT
    LOOP
    WHILE FLG GT 0 DO
        Y.PRPS = Y.PAY.PROP<1,FLG>
        LOCATE 'ACCOUNT' IN Y.PRPS<1,1,1> SETTING POS.P ELSE
            LOCATE 'PRINCIPALINT' IN Y.PRPS<1,1,1> SETTING POS.I ELSE
                LOCATE 'PENALTINT' IN Y.PRPS<1,1,1> SETTING POS.PI ELSE
                    Y.AAA.REQ<AA.ARR.ACT.FIELD.NAME,1,-1> = 'PAYMENT.TYPE:':FLG:':1'
                    Y.AAA.REQ<AA.ARR.ACT.FIELD.VALUE,1,-1> = '|-|'
                    Y.SET = 'Y'
                END
            END
        END
        FLG -= 1
    REPEAT

    IF Y.SET EQ 'Y' THEN
        CALL F.WRITE(FN.REDO.CPY.PAY.SCH.PO,Y.AA.ID,RET.COND)
        GOSUB POST.OFS
    END

RETURN

POST.OFS:

    Y.ACT = 'LENDING-CHANGE-REPAYMENT.SCHEDULE'

    Y.AAA.REQ<AA.ARR.ACT.ARRANGEMENT> = Y.AA.ID
    Y.AAA.REQ<AA.ARR.ACT.ACTIVITY> = Y.ACT
    Y.AAA.REQ<AA.ARR.ACT.EFFECTIVE.DATE> = TODAY
    Y.AAA.REQ<AA.ARR.ACT.PROPERTY,1> = 'REPAYMENT.SCHEDULE'

    APP.NAME = 'AA.ARRANGEMENT.ACTIVITY'
    IN.FUNCTION = 'I'
    VERSION.NAME = 'AA.ARRANGEMENT.ACTIVITY,ZERO.AUTH'

    CALL OFS.BUILD.RECORD(APP.NAME, IN.FUNCTION, "PROCESS", VERSION.NAME, "", "0", AAA.ID, Y.AAA.REQ, PROCESS.MSG)

    OFS.MSG.ID = ''
    OFS.SOURCE = 'TRIGGER.INSURANCE'
    OFS.ERR = ''

    CALL OFS.POST.MESSAGE(PROCESS.MSG,OFS.MSG.ID,OFS.SOURCE,OFS.ERR)

RETURN

END
