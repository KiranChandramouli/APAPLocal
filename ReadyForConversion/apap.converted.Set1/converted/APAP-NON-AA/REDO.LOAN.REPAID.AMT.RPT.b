SUBROUTINE REDO.LOAN.REPAID.AMT.RPT(FIN.ARR)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.TRANSACTION.CHAIN
    $INSERT I_F.AA.ACTIVITY.BALANCES
    $INSERT I_F.AA.REFERENCE.DETAILS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.REDO.MULTITXN.VERSIONS
*   $INSERT I_F.AA.REFERENCE.DETAILS
*   $INSERT I_F.AA.ACTIVITY.BALANCES
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
*   $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.CUSTOMER


    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)

    FN.AA.PR = 'F.AA.PROPERTY'
    F.AA.PR = ''
    CALL OPF(FN.AA.PR,F.AA.PR)

    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    CALL OPF(FN.AA,F.AA)

    FN.BILL = 'F.AA.BILL.DETAILS'
    F.BILL = ''
    CALL OPF(FN.BILL,F.BILL)

    FN.AA.REF = 'F.AA.REFERENCE.DETAILS'
    F.AA.REF = ''
    CALL OPF(FN.AA.REF,F.AA.REF)

    FN.AA.ACT.BAL = 'F.AA.ACTIVITY.BALANCES'
    F.AA.ACT.BAL = ''
    CALL OPF(FN.AA.ACT.BAL,F.AA.ACT.BAL)

    FN.AA.AC = 'F.AA.ACCOUNT.DETAILS'
    F.AA.AC = ''
    CALL OPF(FN.AA.AC,F.AA.AC)

    FN.RTC = 'F.REDO.TRANSACTION.CHAIN'
    F.RTC = ''
    CALL OPF(FN.RTC,F.RTC)

    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    CALL OPF(FN.FT,F.FT)

    FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FT.HIS = ''
    CALL OPF(FN.FT.HIS,F.FT.HIS)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.INT.AC = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INT.AC = ''
    CALL OPF(FN.AA.INT.AC,F.AA.INT.AC)

    FN.MTC = 'F.REDO.MULTITXN.VERSIONS'
    F.MTC = ''
    CALL OPF(FN.MTC,F.MTC)

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'
    F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    Y.APL = 'FUNDS.TRANSFER'
    Y.FLDS = 'L.ACTUAL.VERSIO':@VM:'L.NCF.NUMBER'
    CALL MULTI.GET.LOC.REF(Y.APL,Y.FLDS,POS.LC)
    Y.POS.ACT.V = POS.LC<1,1>
    Y.POS.NCF = POS.LC<1,2>


    GOSUB PROCESS

RETURN


PROCESS:


    LOCATE 'CO.CODE' IN D.FIELDS<1> SETTING POS.SS THEN
        Y.CO.DD = D.RANGE.AND.VALUE<POS.SS>
    END
    LOCATE 'EFFECTIVE.DATE' IN D.FIELDS<1> SETTING POS.ED THEN
        Y.EFF.DD = D.RANGE.AND.VALUE<POS.ED>
    END
    LOCATE 'PRODUCT.GROUP' IN D.FIELDS<1> SETTING POS.PD THEN
        Y.PRD.FR = D.RANGE.AND.VALUE<POS.PD>
    END
    LOCATE 'PRODUCT' IN D.FIELDS<1> SETTING POS.PRD THEN
        Y.PRD.FG = D.RANGE.AND.VALUE<POS.PRD>
    END
    LOCATE 'FORM.OF.PAYMENT' IN D.FIELDS<1> SETTING POS.FD THEN
        Y.FR.PAY = D.RANGE.AND.VALUE<POS.FD>
    END

    SEL.CMD = 'SELECT ':FN.RTC:' WITH @ID LIKE "FT..." AND TRANS.AUTH EQ "A"'

    IF Y.CO.DD THEN
        SEL.CMD := ' AND BRANCH.CODE EQ ':Y.CO.DD
    END
    IF Y.EFF.DD THEN
        SEL.CMD := ' AND TRANS.DATE EQ ':Y.EFF.DD
    END

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ERR)

    FLG = ''
    LOOP
    WHILE NO.OF.REC GT 0 DO
        FLG += 1
        Y.FT.ID = SEL.LIST<FLG>
        CALL F.READ(FN.RTC,Y.FT.ID,R.RTC,F.RTC,RTC.ERR)
        Y.FT.IDS = R.RTC<RTC.TRANS.ID> ; Y.FT.CNT = DCOUNT(Y.FT.IDS,@VM)

        FLC = ''
        LOOP
        WHILE Y.FT.CNT GT 0 DO
            FLC += 1
            IF Y.FT.IDS<1,FLC>[1,2] EQ 'FT' THEN
                Y.TOT.AMD = '' ; Y.PRIN.BL = '' ; Y.OT.BL = '' ; Y.INT.BL = '' ; Y.INS.BL = ''
                GOSUB GET.RTC.DD
                IF Y.SET EQ 'Y' AND Y.PRD.SET EQ 'Y' AND Y.PD.SET EQ 'Y' THEN
                    GOSUB FORM.FIN.ARR
                END
            END
            Y.FT.CNT -= 1
        REPEAT
        NO.OF.REC -= 1
    REPEAT

RETURN

GET.RTC.DD:

    Y.FT.ID = Y.FT.IDS<1,FLC>
    CALL F.READ(FN.FT,Y.FT.ID,R.FT,F.FT,FT.ERR)
    IF NOT(R.FT) THEN
        CALL EB.READ.HISTORY.REC(F.FT.HIS,Y.FT.ID,R.FT,FT.ER)
    END
    Y.LOAN.ID = R.FT<FT.CREDIT.ACCT.NO>
    CALL F.READ(FN.AC,Y.LOAN.ID,R.AC,F.AC,AC.ERR)
    Y.ARR.ID = R.AC<AC.ARRANGEMENT.ID>

    CALL F.READ(FN.AA,Y.ARR.ID,R.AA,F.AA,AA.ERR)
    Y.ORIN.COMP = R.AA<AA.ARR.CO.CODE>
    Y.PAY.AGENCY = R.FT<FT.CO.CODE>
    Y.PAY.DATE = R.FT<FT.CREDIT.VALUE.DATE>
    Y.PORT.FOLIO = R.AA<AA.ARR.PRODUCT.GROUP>

    CALL CACHE.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PORT.FOLIO,R.REDO.APAP.PROPERTY.PARAM,PAR.ERR)
    Y.PENALTY.CHARGE.PROP = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PENALTY.ARREAR>

    Y.PRD.SET = '' ; Y.PD.SET = ''
    IF Y.PRD.FR THEN
        IF Y.PRD.FR NE Y.PORT.FOLIO THEN
            RETURN
        END ELSE
            Y.PRD.SET = 'Y'
        END
    END ELSE
        Y.PRD.SET = 'Y'
    END
    Y.PRD = R.AA<AA.ARR.PRODUCT>

    IF Y.PRD.FG THEN
        IF Y.PRD.FG NE Y.PRD THEN
            RETURN
        END ELSE
            Y.PD.SET = 'Y'
        END
    END ELSE
        Y.PD.SET = 'Y'
    END
    Y.CUR = R.AA<AA.ARR.CURRENCY>

    Y.EF.DATE = TODAY
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID,'ACCOUNT','',Y.EF.DATE,'',RET.COND,RET.ER)
    RET.COND = RAISE(RET.COND)
    Y.ALT.AC = RET.COND<AA.AC.ALT.ID>

    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARR.ID,'ACCOUNT','',Y.EF.DATE,'',RET.COND,RET.ER)
    RET.COND = RAISE(RET.COND)
    GOSUB GET.CLIENT.NAME
    GOSUB GET.INT.RATE
    GOSUB PAYMNT.TYPE

    Y.FORM.TYPE = R.RTC<RTC.TRANS.TYPE,FLC> ; Y.DUP.FRM.TYPE = Y.FORM.TYPE ; Y.NB.FROM = ''
    IF Y.FR.PAY THEN
        IF Y.FR.PAY EQ Y.FORM.TYPE THEN
            Y.TELLER.ID = R.RTC<RTC.TELLER.ID>
            Y.TOT.AMT = R.RTC<RTC.TRANS.AMOUNT,FLC>

            GOSUB GET.NV.AMT
            GOSUB DUE.AMT

            Y.NCF = R.FT<FT.LOCAL.REF,Y.POS.NCF>
        END
    END ELSE
        Y.TELLER.ID = R.RTC<RTC.TELLER.ID>
        Y.TOT.AMT = R.RTC<RTC.TRANS.AMOUNT,FLC>

        GOSUB GET.NV.AMT
        GOSUB DUE.AMT

        Y.NCF = R.FT<FT.LOCAL.REF,Y.POS.NCF>
    END

    BEGIN CASE
        CASE Y.DUP.FRM.TYPE EQ 'CASH'
            Y.NB.FROM = 'EFFECTIVO'

        CASE Y.DUP.FRM.TYPE EQ 'CHECK'
            Y.NB.FROM = 'CHEQUES'

    END CASE

RETURN

FORM.FIN.ARR:

    FIN.ARR<-1> = Y.ORIN.COMP:'*':Y.PAY.AGENCY:'*':Y.PORT.FOLIO:'*':Y.PRD:'*':Y.LOAN.ID:'*':Y.ALT.AC:'*':VAR.CLIENT.NAME:'*'
    FIN.ARR := Y.CUR:'*':Y.RATE:'*':Y.PAY.TYPE:'*':Y.PAY.DATE:'*':Y.NB.FROM:'*':Y.TELLER.ID:'*':Y.NCF:'*':Y.TOT.AMD:'*':Y.PRIN.BL:'*':Y.INT.BL:'*'
    FIN.ARR := Y.OS.AMT:'*':Y.INS.BL:'*':Y.OT.BL:'*':Y.BL.NN.CNT

    Y.TOT.AMD = '' ; Y.PRIN.BL = '' ; Y.OT.BL = '' ; Y.INT.BL = '' ; Y.INS.BL = '' ; Y.SET = '' ; Y.BL.NN.CNT = ''
RETURN

DUE.AMT:

    CALL F.READ(FN.AA.AC,Y.ARR.ID,R.AA.AC,F.AA.AC,AC.AA.ERR)
    Y.BILL.IDS = R.AA.AC<AA.AD.BILL.ID> ; Y.BILL.IDS = CHANGE(Y.BILL.IDS,@SM,@VM)
    Y.SET.STAT = R.AA.AC<AA.AD.SET.STATUS> ; Y.SET.STAT = CHANGE(Y.SET.STAT,@SM,@VM)
    Y.SET.CNT = DCOUNT(Y.SET.STAT,@VM) ; Y.NKJ = '' ; Y.OS.AMT = '' ; Y.BL.NN.CNT = ''
    LOOP
    WHILE Y.SET.CNT GT 0 DO
        Y.NKJ += 1
        IF Y.SET.STAT<1,Y.NKJ> EQ 'UNPAID' THEN
            Y.BL.ID = Y.BILL.IDS<1,Y.NKJ>
            CALL F.READ(FN.BILL,Y.BL.ID,R.BILL,F.BILL,BL.ERR)
            Y.OS.AMT += SUM(R.BILL<AA.BD.OS.PROP.AMOUNT>)
        END ELSE
            Y.BL.NN.CNT += 1
        END
        Y.SET.CNT -= 1
    REPEAT

RETURN

GET.NV.AMT:

    CALL F.READ(FN.AA.REF,Y.ARR.ID,R.AA.REF,F.AA.REF,REF.ERR)
    Y.FT.ID = FIELD(Y.FT.ID,';',1) ; Y.AAA.ID = '' ; Y.SET = ''
    LOCATE Y.FT.ID IN R.AA.REF<AA.REF.TRANS.REF,1> SETTING POS.FT THEN
        Y.AAA.ID = R.AA.REF<AA.REF.AAA.ID,POS.FT>
        Y.SET = 'Y'
    END ELSE
        Y.SET = 'N'
    END

    IF Y.AAA.ID THEN
        GOSUB CAL.AMT
    END

RETURN

CAL.AMT:

    CALL F.READ(FN.AA.ACT.BAL,Y.ARR.ID,R.AA.ACT.BAL,F.AA.ACT.BAL,BAL.ERR)
    LOCATE Y.AAA.ID IN R.AA.ACT.BAL<AA.ACT.BAL.ACTIVITY.REF,1> SETTING POS.AAA THEN
        Y.PROPS = R.AA.ACT.BAL<AA.ACT.BAL.PROPERTY,POS.AAA>
        Y.PROPS.AMTS = R.AA.ACT.BAL<AA.ACT.BAL.PROPERTY.AMT,POS.AAA>
        Y.PR.CNT = DCOUNT(Y.PROPS,@SM) ; FLP = ''
        LOOP
        WHILE Y.PR.CNT GT 0 DO
            FLP += 1
            Y.PR.CL = Y.PROPS<1,1,FLP>
            Y.PR.CL = FIELD(Y.PR.CL,'.',1)

            CALL CACHE.READ(FN.AA.PR, Y.PR.CL, R.AA.PR, AA.PR.ERR)
            Y.PRP.CLASS = R.AA.PR<AA.PROP.PROPERTY.CLASS>
            GOSUB CASE.SS
            Y.PR.CNT -= 1
        REPEAT
    END

RETURN

CASE.SS:

    BEGIN CASE
        CASE Y.PR.CL EQ 'ACCOUNT'
            Y.PRIN.BL += Y.PROPS.AMTS<1,1,FLP>
        CASE Y.PR.CL EQ 'PRINCIPALINT' OR Y.PR.CL EQ 'PENALTINT'
            Y.INT.BL += Y.PROPS.AMTS<1,1,FLP>
        CASE Y.PR.CL EQ Y.PENALTY.CHARGE.PROP
            Y.OT.BL += Y.PROPS.AMTS<1,1,FLP>
        CASE Y.PR.CL NE Y.PENALTY.CHARGE.PROP AND Y.PRP.CLASS EQ 'CHARGE'
            Y.INS.BL += Y.PROPS.AMTS<1,1,FLP>
    END CASE

    Y.TOT.AMD = Y.PRIN.BL + Y.INT.BL +Y.OT.BL + Y.INS.BL

RETURN

GET.CLIENT.NAME:

    VAR.CLIENT.NAME = ''
    Y.CUSTOMER.CONDITION=RET.COND
    VAR.PRIM.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.PRIMARY.OWNER>
    VAR.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.OWNER>
    CHANGE @VM TO @FM IN VAR.OWNER
    CNT.VAR.OWNER = DCOUNT(VAR.OWNER,@FM)
    COUNT.OWNER = 1
    LOOP
    WHILE COUNT.OWNER LE CNT.VAR.OWNER
        IF VAR.PRIM.OWNER NE VAR.OWNER<COUNT.OWNER> THEN
            Y.OWNER  =  VAR.OWNER<COUNT.OWNER>
            R.CUSTOMER = ''
            CALL F.READ(FN.CUSTOMER,Y.OWNER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
            VAR.CLIENT.NAME<1,-1> = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
        END
        COUNT.OWNER += 1
    REPEAT

RETURN

GET.INT.RATE:

    Y.INT.AC = Y.ARR.ID:'-PRINCIPALINT'
    CALL F.READ(FN.AA.INT.AC,Y.INT.AC,R.AA.INT.AC,F.AA.INT.AC,AC.ERRR)
    Y.RATE = R.AA.INT.AC<AA.INT.ACC.RATE,1,1>

RETURN

PAYMNT.TYPE:


    Y.ACT.VER = R.FT<FT.LOCAL.REF,Y.POS.ACT.V>
    SEL.CC = 'SELECT ':FN.MTC:' WITH VERSION.NAME EQ ':Y.ACT.VER
    CALL EB.READLIST(SEL.CC,SEL.CCL,'',NO.OF.RECS,ER.ERR)

    CALL F.READ(FN.MTC,SEL.CCL,R.MTC,F.MTC,MTC.ER)
    Y.PAY.TYPE = R.MTC<RMV.DESCRIPTION>

RETURN

END
