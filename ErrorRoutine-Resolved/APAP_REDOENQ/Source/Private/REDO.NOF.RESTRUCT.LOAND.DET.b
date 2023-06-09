* @ValidationCode : MjotNTY1NjU1MDk6Q3AxMjUyOjE2ODYyMjM5ODYyOTM6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 08 Jun 2023 17:03:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.RESTRUCT.LOAND.DET(Y.FIN.ARR)
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date                 Who                    Reference                  Description
*   ------               -----                 -------------               -------------
* 08-06-2023            Saranya           R22 Manual Conversion            commented line AA.PS.DESCRIPTION, changed AA.CUS.PRIMARY.OWNER to AA.CUS.CUSTOMER, AA.CUS.OWNER to AA.CUS.CUSTOMER
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.INTEREST


    FN.AA.INT.AC = 'F.AA.INTEREST.ACCRUALS'
    F.AA.INT.AC = ''
    CALL OPF(FN.AA.INT.AC,F.AA.INT.AC)

    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    CALL OPF(FN.AA,F.AA)

    FN.AA.AC = 'F.AA.ACCOUNT.DETAILS'
    F.AA.AC = ''
    CALL OPF(FN.AA.AC,F.AA.AC)

    FN.REDO.AA.LOAN.UPD.STATUS = 'F.REDO.AA.LOAN.UPD.STATUS'
    F.REDO.AA.LOAN.UPD.STATUS = ''
    CALL OPF(FN.REDO.AA.LOAN.UPD.STATUS,F.REDO.AA.LOAN.UPD.STATUS)

    FN.AA.ARR.OVR = 'F.AA.ARR.OVERDUE'
    F.AA.ARR.OVR = ''
    CALL OPF(FN.AA.ARR.OVR,F.AA.ARR.OVR)

    FN.AA.ARR.TA = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TA = ''
    CALL OPF(FN.AA.ARR.TA,F.AA.ARR.TA)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.PRD.PS = 'F.AA.PRD.DES.PAYMENT.SCHEDULE'
    F.AA.PRD.PS = ''
    CALL OPF(FN.AA.PRD.PS,F.AA.PRD.PS)

    FN.AA.ARR.DATED = 'F.AA.ARRANGEMENT.DATED.XREF'
    F.AA.ARR.DATED = ''
    CALL OPF(FN.AA.ARR.DATED,F.AA.ARR.DATED)

    Y.APL = 'AA.PRD.DES.OVERDUE':@FM:'AA.PRD.DES.PAYMENT.SCHEDULE'
    Y.FLD = 'L.LOAN.STATUS.1':@VM:'L.STATUS.CHG.DT':@FM:'L.MIGRATED.LN'
    CALL MULTI.GET.LOC.REF(Y.APL,Y.FLD,POS.CL)
    Y.POS.ST = POS.CL<1,1>
    Y.POS.DT.SN = POS.CL<1,2>
    Y.POS.MIG.L = POS.CL<2,1>


    LOCATE 'RESTR.FROM.DATE' IN D.FIELDS SETTING POS.FR THEN
        Y.FROM.RE.DATE = D.RANGE.AND.VALUE<POS.FR>
    END

    LOCATE 'RESTR.TILL.DATE' IN D.FIELDS SETTING POS.TO THEN
        Y.TO.RE.DATE = D.RANGE.AND.VALUE<POS.TO>
    END

    LOCATE 'PORT.FOL.TYPE' IN D.FIELDS SETTING POS.PO THEN
        Y.PORT = D.RANGE.AND.VALUE<POS.PO>
    END

    LOCATE 'PROD.TYPE' IN D.FIELDS SETTING POS.PT THEN
        Y.PRO = D.RANGE.AND.VALUE<POS.PT>
    END

    LOCATE 'Y.USER' IN D.FIELDS SETTING POS.US THEN
        Y.USR = D.RANGE.AND.VALUE<POS.US>
    END

    GOSUB GET.PAY.COND

    IF (Y.FROM.RE.DATE EQ '' AND Y.TO.RE.DATE NE '') OR (Y.FROM.RE.DATE NE '' AND Y.TO.RE.DATE EQ '') THEN
        ENQ.ERROR = 'BOTH DATES SHOULD BE ENTERED'
    END

    SEL.CMD = 'SELECT ':FN.REDO.AA.LOAN.UPD.STATUS
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,REC.ERR)

    FLG = ''
    LOOP
    WHILE NO.OF.REC GT 0 DO
        FLG += 1
        GOSUB PROCESS
        NO.OF.REC -= 1
    REPEAT

RETURN

GET.PAY.COND:

    SL.D = 'SELECT ':FN.AA.PRD.PS
    CALL EB.READLIST(SL.D,SELCM,'',NO.F,RS.ER)
    KL = '' ; PR.ID.D = '' ; PAY.RT = ''
    LOOP
    WHILE NO.F GT 0 DO
        KL += 1
        Y.PR.ID = SELCM<KL>
        CALL F.READ(FN.AA.PRD.PS,Y.PR.ID,R.PR,F.AA.PRD.PS,PS.ER)
        PAY.RT<-1> = R.PR<AA.PS.PAYMENT.TYPE>
*PR.ID.D<-1> = R.PR<AA.PS.DESCRIPTION>;* R22 Manual conversion - this variable is obsolete in R22
        NO.F -= 1
    REPEAT

RETURN

PROCESS:

    Y.ID = SEL.LIST<FLG>

    CALL F.READ(FN.REDO.AA.LOAN.UPD.STATUS,Y.ID,R.REDO.AA.LOAN.UPD.STATUS,F.REDO.AA.LOAN.UPD.STATUS,UPD.ERR)
    Y.RES.DATE = R.REDO.AA.LOAN.UPD.STATUS ; Y.RES.DD = R.REDO.AA.LOAN.UPD.STATUS
    GOSUB FIND.MIG.LN

    IF Y.MIG.LN.OR EQ 'YES' THEN
        CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ID,'OVERDUE','','',RET.PR,RET.COND.O,RET.ER)
        RET.COND.O = RAISE(RET.COND.O)
        Y.RES.DATE = RET.COND.O<AA.OD.LOCAL.REF,Y.POS.DT.SN>
    END

    IF Y.FROM.RE.DATE NE '' AND Y.TO.RE.DATE NE '' THEN
        IF Y.RES.DATE LT Y.FROM.RE.DATE OR Y.RES.DATE GT Y.TO.RE.DATE THEN
            RETURN
        END
    END

    Y.EF.DATE = TODAY
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ID,'ACCOUNT','',Y.EF.DATE,'',RET.COND,RET.ER)
    RET.COND = RAISE(RET.COND)
    Y.ALT.AC = RET.COND<AA.AC.ALT.ID>

    GOSUB GET.CUS.NAME
    GOSUB GET.PROTFOLIO
    GOSUB GET.PREV.DUE.RATE
    GOSUB GET.INTEREST.RATE

    GOSUB GET.PAY.SCH.AMT
    GOSUB GET.MAT.DATE
    GOSUB GET.INP
    GOSUB FIN.ARR

RETURN

FIND.MIG.LN:

    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ID,'PAYMENT.SCHEDULE','','',RET.PR,RET.COND,COND.ERR)
    RET.COND = RAISE(RET.COND)
    Y.MIG.LN.OR = RET.COND<AA.PS.LOCAL.REF,Y.POS.MIG.L>

RETURN

FIN.ARR:

    IF Y.SET NE 'Y' THEN
        Y.FIN.ARR<-1> = Y.ID:'*':Y.ALT.AC:'*':VAR.CLIENT.NAME:'*':Y.PORTFOL:'*':Y.PRD:'*':Y.AGENCY:'*':Y.RES.DATE:'*'
        Y.FIN.ARR := Y.PREV.DU.RTE:'*':Y.CUR.DUE.RTE:'*':Y.PREV.INT.RTE:'*':Y.CUR.INT.RTE:'*':Y.PREV.BILL.AMT:'*'
        Y.FIN.ARR := Y.CUR.BIL.AMT:'*':Y.PRE.MAT.DATE:'*':Y.CUR.MAT.DATE:'*':Y.PREV.PAY.DATE:'*':Y.CUR.PAY.DATE:'*'
        Y.FIN.ARR := Y.PREV.PAY.TYPE.M:'*':Y.CUR.PAY.TYPE.M:'*':Y.INP:'*':Y.AUT:'*':Y.PC.DESC:'*':Y.PC.DESC.C
    END


    Y.PREV.PAY.TYPE = '' ; Y.CUR.PAY.TYPE = '' ; Y.INP = '' ; Y.AUT = '' ; Y.CUR.PAY.DATE = '' ; Y.PREV.PAY.DATE = '';
    Y.CUR.MAT.DATE = '' ; Y.PRE.MAT.DATE = '' ; Y.CUR.BIL.AMT = '' ; Y.PREV.DU.RTE = '' ; Y.CUR.DUE.RTE = '' ; Y.PREV.INT.RTE = '' ;
    Y.CUR.INT.RTE = '' ; Y.PREV.BILL.AMT = '' ; Y.SET = '' ; Y.PREV.PAY.TYPE.M = ''; Y.CUR.PAY.TYPE.M = '' ; Y.PC.DESC = '' ; Y.PC.DESC.C = ''

RETURN

GET.INP:

    FLR = 0
    LOOP
    WHILE FLR GE 0 DO
        FLR += 1
        Y.KK.ID = Y.ID:'-APAP.OVERDUE-':Y.RES.DD:'.':FLR
        CALL F.READ(FN.AA.ARR.OVR,Y.KK.ID,R.AA.ARR.OVR,F.AA.ARR.OVR,OVR.ERR)
        IF R.AA.ARR.OVR THEN
            IF R.AA.ARR.OVR<AA.OD.LOCAL.REF,Y.POS.ST> EQ 'Restructured' THEN
                Y.INP = R.AA.ARR.OVR<AA.OD.INPUTTER>
                Y.AUT = R.AA.ARR.OVR<AA.OD.AUTHORISER>

                Y.INP = FIELD(Y.INP,'_',2)
                Y.AUT = FIELD(Y.AUT,'_',2)
                IF Y.USR AND Y.USR NE Y.INP THEN
                    Y.SET = 'Y'
                END
                FLR = -1
            END
        END ELSE
            FLR = -1
        END
    REPEAT

RETURN

GET.MAT.DATE:


    CALL F.READ(FN.AA.ARR.DATED,Y.ID,R.AA.ARR.DATED,F.AA.ARR.DATED,DATE.ER)
    LOCATE 'COMMITMENT' IN R.AA.ARR.DATED<1,1> SETTING POS.DFD THEN
        Y.DATD.DD = R.AA.ARR.DATED<2,POS.DFD>
        Y.DATD.DD = SORT(Y.DATD.DD)
        LOCATE Y.RES.DATE IN Y.DATD.DD BY 'AR' SETTING POS.ASDL THEN
            Y.COSDS.POS = POS.ASDL - 1
            IF Y.COSDS.POS EQ 0 THEN
                Y.COSDS.POS = 1
            END
        END ELSE
            Y.COSDS.POS = POS.ASDL - 1
            IF Y.COSDS.POS EQ 0 THEN
                Y.COSDS.POS = 1
            END
        END
        Y.COR.PS.D = Y.DATD.DD<Y.COSDS.POS>
        Y.ARR.CO.ID = Y.ID:'-COMMITMENT-':Y.COR.PS.D

        CALL F.READ(FN.AA.ARR.TA,Y.ARR.CO.ID,R.AA.ARR.TA,F.AA.ARR.TA,TA.ERR)
        IF R.AA.ARR.TA THEN
            Y.PRE.MAT.DATE = R.AA.ARR.TA<AA.AMT.MATURITY.DATE>
        END ELSE
            CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ID,'TERM.AMOUNT','','','',RET.COND,RET.ERR)
            RET.COND = RAISE(RET.COND)

            Y.PRE.MAT.DATE = RET.COND<AA.AMT.MATURITY.DATE>
        END
    END

    CALL F.READ(FN.AA.AC,Y.ID,R.AA.AC,F.AA.AC,AA.AC.ERR)
    Y.CUR.MAT.DATE = R.AA.AC<AA.AD.MATURITY.DATE>

RETURN

GET.PAY.SCH.AMT:

    SIMULATION.REF = ''
    NO.RESET = '1'
    YREGION = ''
    CALL AA.SCHEDULE.PROJECTOR(Y.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)

    LOCATE Y.RES.DATE IN PAYMENT.DATES BY 'AR' SETTING POS.DD THEN
        POS.PREV.DD = POS.DD - 1
        IF POS.PREV.DD EQ 0 THEN
            POS.PREV.DD = 1
        END
        Y.PREV.BILL.AMT = TOT.PAYMENT<POS.PREV.DD>
        Y.PREV.PAY.DATE = PAYMENT.DATES<POS.PREV.DD>
        Y.CUR.PAY.DATE = PAYMENT.DATES<POS.PREV.DD+2>
        Y.PAY.PRP = PAYMENT.PROPERTIES<POS.PREV.DD>
        Y.PREV.PAY.TYPE = PAYMENT.TYPES<POS.PREV.DD>
        GOSUB GET.PAY.TYPE
    END ELSE
        POS.PREV.DD = POS.DD - 1
        IF POS.PREV.DD EQ 0 THEN
            POS.PREV.DD = 1
        END
        Y.PREV.BILL.AMT = TOT.PAYMENT<POS.PREV.DD>
        Y.PREV.PAY.DATE = PAYMENT.DATES<POS.PREV.DD>
        Y.CUR.PAY.DATE = PAYMENT.DATES<POS.PREV.DD+1>
        Y.PAY.PRP = PAYMENT.PROPERTIES<POS.PREV.DD>
        Y.PREV.PAY.TYPE = PAYMENT.TYPES<POS.PREV.DD>
        GOSUB GET.PAY.TYPE
    END

    LOCATE TODAY IN PAYMENT.DATES BY 'AR' SETTING POS.DD THEN
        POS.CUR.DD = POS.DD
        IF POS.CUR.DD EQ 0 THEN
            POS.CUR.DD = 1
        END
        Y.CUR.BIL.AMT = TOT.PAYMENT<POS.CUR.DD>
        Y.PAY.PRP = PAYMENT.PROPERTIES<POS.DD>
        Y.CUR.PAY.TYPE = PAYMENT.TYPES<POS.CUR.DD>
        GOSUB GET.PAY.TYPE.1
    END ELSE
        POS.CUR.DD = POS.DD
        IF POS.CUR.DD EQ 0 THEN
            POS.CUR.DD = 1
        END
        Y.CUR.BIL.AMT = TOT.PAYMENT<POS.CUR.DD>
        Y.PAY.PRP = PAYMENT.PROPERTIES<POS.DD>
        Y.CUR.PAY.TYPE = PAYMENT.TYPES<POS.CUR.DD>
        GOSUB GET.PAY.TYPE.1
    END

RETURN

GET.PAY.TYPE:

    Y.PO.CNT = DCOUNT(Y.PAY.PRP,@VM)
    LFR = ''
    LOOP
    WHILE Y.PO.CNT GT 0 DO
        LFR += 1
        Y.SD.VL = Y.PAY.PRP<1,LFR>
        LOCATE 'ACCOUNT' IN Y.SD.VL<1,1,1> SETTING POLK THEN
            Y.PREV.PAY.TYPE.M<1,-1> = Y.PREV.PAY.TYPE<1,LFR>
        END ELSE
            LOCATE 'PRINCIPALINT' IN Y.SD.VL<1,1,1> SETTING POLK THEN
                Y.PREV.PAY.TYPE.M<1,-1> = Y.PREV.PAY.TYPE<1,LFR>
            END
        END
        Y.PO.CNT -= 1
    REPEAT

    IF Y.PREV.PAY.TYPE.M THEN
        LOCATE Y.PREV.PAY.TYPE.M IN PAY.RT SETTING PR.DK THEN
            Y.PC.DESC = PR.ID.D<PR.DK>
        END
    END

RETURN

GET.PAY.TYPE.1:

    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ID,'PAYMENT.SCHEDULE','','',RET.PR,RET.COND,RET.ERR)
    RET.COND = RAISE(RET.COND)
    Y.CUR.PAY.TYPE.M = RET.COND<AA.PS.PAYMENT.TYPE>

*  Y.PO.CNT = DCOUNT(Y.PAY.PRP,VM)
*  LFR = ''
*  LOOP
*  WHILE Y.PO.CNT GT 0 DO
*      LFR += 1
*      Y.SD.VL = Y.PAY.PRP<1,LFR>
*      LOCATE 'ACCOUNT' IN Y.SD.VL<1,1,1> SETTING POLK THEN
*          Y.CUR.PAY.TYPE.M<1,-1> = Y.CUR.PAY.TYPE<1,LFR>
*      END ELSE
*          LOCATE 'PRINCIPALINT' IN Y.SD.VL<1,1,1> SETTING POLK THEN
*              Y.CUR.PAY.TYPE.M<1,-1> = Y.CUR.PAY.TYPE<1,LFR>
*          END
*      END
*      Y.PO.CNT -= 1
*  REPEAT

    IF Y.CUR.PAY.TYPE.M THEN
        LOCATE Y.CUR.PAY.TYPE.M IN PAY.RT SETTING PR.DKC THEN
            Y.PC.DESC.C = PR.ID.D<PR.DKC>
        END
    END

RETURN

GET.INTEREST.RATE:

    Y.PR.ID = Y.ID:'-':'PRINCIPALINT'
    CALL F.READ(FN.AA.INT.AC,Y.PR.ID,R.AA.INT.AC,F.AA.INT.AC,AA.INT.ERR)
    Y.FROM.DATE = R.AA.INT.AC<AA.INT.ACC.FROM.DATE>
    Y.TO.DATE = R.AA.INT.AC<AA.INT.ACC.TO.DATE>

    Y.FR.CNT = DCOUNT(Y.FROM.DATE,@VM) ; LK = '' ; POS.PREV.AR = ''

    LOOP
    WHILE Y.FR.CNT GT 0 DO
        LK += 1
        IF Y.RES.DATE GT Y.FROM.DATE<1,LK> AND Y.RES.DATE GT Y.TO.DATE<1,LK> THEN
            Y.FR.CNT = 0
            POS.PREV.AR = LK
        END

        Y.FR.CNT -= 1
    REPEAT

    IF POS.PREV.AR EQ '' THEN
        POS.PREV.AR = 1
    END

    Y.PREV.INT.RTE = R.AA.INT.AC<AA.INT.ACC.RATE,POS.PREV.AR,1>

    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ID,'INTEREST','PRINCIPALINT','',RET.PR,RET.COND,RET.ERR)
    RET.COND = RAISE(RET.COND)
    Y.CUR.INT.RTE = RET.COND<AA.INT.EFFECTIVE.RATE>

*  Y.CUR.INT.RTE = R.AA.INT.AC<AA.INT.ACC.RATE,1,1>

* LOCATE Y.RES.DATE IN Y.FROM.DATE<1,1> BY 'AR' SETTING POS.AR THEN
*     POS.PREV.AR = POS.AR - 1
*     IF POS.PREV.AR EQ 0 THEN
*         POS.PREV.AR = 1
*     END
*     Y.PREV.INT.RTE = R.AA.INT.AC<AA.INT.ACC.RATE,POS.PREV.AR,1>
* END ELSE
*     POS.PREV.AR = POS.AR - 1
*     IF POS.PREV.AR EQ 0 THEN
*         POS.PREV.AR = 1
*     END
*     Y.PREV.INT.RTE = R.AA.INT.AC<AA.INT.ACC.RATE,POS.PREV.AR,1>
* END

* Y.CUR.INT.RTE = R.AA.INT.AC<AA.INT.ACC.RATE,1,1>

RETURN

GET.PREV.DUE.RATE:

    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ID,'CHARGE','PRMORA','','',RET.COND,RET.ERR)
    RET.COND = RAISE(RET.COND)

    Y.PREV.DU.RTE = RET.COND<AA.CHG.CHARGE.RATE>
    Y.CUR.DUE.RTE = RET.COND<AA.CHG.CHARGE.RATE>

*Y.PEN.ID = Y.ID:'-':'PENALTINT'
*CALL F.READ(FN.AA.INT.AC,Y.PEN.ID,R.AA.INT.AC,F.AA.INT.AC,AA.INT.ERR)
*Y.FROM.DATE = R.AA.INT.AC<AA.INT.ACC.FROM.DATE>
*Y.TO.DATE = R.AA.INT.AC<AA.INT.ACC.TO.DATE>

*LOCATE Y.RES.DATE IN Y.FROM.DATE BY 'AR' SETTING POS.AR THEN
*    POS.PREV.AR = POS.AR - 1
*    IF POS.PREV.AR EQ 0 THEN
*        POS.PREV.AR = 1
*    END
*    Y.PREV.DU.RTE = R.AA.INT.AC<AA.INT.ACC.RATE,POS.PREV.AR,1>
*END ELSE
*    POS.PREV.AR = POS.AR - 1
*    IF POS.PREV.AR EQ 0 THEN
*        POS.PREV.AR = 1
*    END
*    Y.PREV.DU.RTE = R.AA.INT.AC<AA.INT.ACC.RATE,POS.PREV.AR,1>
*END

*Y.CUR.DUE.RTE = R.AA.INT.AC<AA.INT.ACC.RATE,1,1>

RETURN

GET.PROTFOLIO:

    CALL F.READ(FN.AA,Y.ID,R.AA,F.AA,AA.ER)
    Y.PORTFOL = R.AA<AA.ARR.PRODUCT.GROUP>
    Y.PRD = R.AA<AA.ARR.PRODUCT>

    IF Y.PORT THEN
        IF Y.PORT NE Y.PORTFOL THEN
            Y.SET = 'Y'
        END
    END

    IF Y.PRO THEN
        IF Y.PRO NE Y.PRD THEN
            Y.SET = 'Y'
        END
    END

    Y.AGENCY = R.AA<AA.ARR.CO.CODE>

RETURN

GET.CUS.NAME:

    Y.EF.DATE = TODAY
    CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ID,'CUSTOMER','',Y.EF.DATE,'',RET.COND,RET.ER)
    RET.COND = RAISE(RET.COND)

    VAR.CLIENT.NAME = ''
    Y.CUSTOMER.CONDITION=RET.COND
*VAR.PRIM.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.PRIMARY.OWNER>
*VAR.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.OWNER>
    VAR.PRIM.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.CUSTOMER> ;* R22 Manual conversion - PRIMARY.OWNER changed to CUSTOMER
    VAR.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.CUSTOMER> ;* R22 Manual conversion - OWNER changed to CUSTOMER
    CHANGE @VM TO @FM IN VAR.OWNER
    CNT.VAR.OWNER = DCOUNT(VAR.OWNER,@FM)
    COUNT.OWNER = 1
    LOOP
    WHILE COUNT.OWNER LE CNT.VAR.OWNER
        Y.OWNER  =  VAR.OWNER<COUNT.OWNER>
        R.CUSTOMER = ''
        CALL F.READ(FN.CUSTOMER,Y.OWNER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        VAR.CLIENT.NAME<1,-1> = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
        COUNT.OWNER += 1
    REPEAT

RETURN

END