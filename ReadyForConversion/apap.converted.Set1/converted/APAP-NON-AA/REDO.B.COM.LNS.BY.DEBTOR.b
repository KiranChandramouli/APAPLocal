SUBROUTINE REDO.B.COM.LNS.BY.DEBTOR(AA.ARR.ID)
*--------------------------------------------------------------------------------------------------
* Description           : This is the Batch Main Process Routine used to process the all AA ID and get the
*                         and get the Report Related details and Write the details in Temp Bp
* Developed On          : 23-Sep-2013
* Developed By          : Amaravathi Krithika B
* Development Reference : DE11
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)
* PACS00382500           Ashokkumar.V.P                  06/03/2015      Added new fields based on mapping
* PACS00382500           Ashokkumar.V.P                  31/03/2015      Insert file compilation.
*--------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.LIMIT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CURRENCY
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.CCY.HISTORY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PRODUCT.GROUP
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ACTIVITY.CHARGES
    $INSERT I_F.AA.PRODUCT.DESIGNER
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.SCHEDULED.ACTIVITY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT I_REDO.B.COM.LNS.BY.DEBTOR.COMMON
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.COUNTRY
    $INSERT I_F.INDUSTRY
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
*    $INSERT TAM.BP I_REDO.B.CON.LNS.BY.DEBTOR.AA.RECS.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.AA.MIG.PAY.START.DTE
    $INSERT I_F.REDO.CAMPAIGN.TYPES
    $INSERT I_F.AA.CUSTOMER

    GOSUB INIT
RETURN
INIT:
*---
    ARR.ERR = ""; R.ARR.APPL = ""; Y.PAMENT.DATE.EXTRA.BILL = ''; Y.RESTRUCT.DATE.DIS = ''; Y.RESTRUCT.DATE = ''
    Y.LIMIT.REF = ''
    CALL AA.GET.ARRANGEMENT(AA.ARR.ID,R.ARR.APPL,ARR.ERR)
    IF NOT(R.ARR.APPL) THEN
        GOSUB RAISE.ERR.C.22
        RETURN
    END
    Y.MAIN.PROD.GROUP = R.ARR.APPL<AA.ARR.PRODUCT.GROUP>
    Y.MAIN.ARR.STATUS = R.ARR.APPL<AA.ARR.ARR.STATUS>
    Y.MAIN.ARR.PRCT = R.ARR.APPL<AA.ARR.PRODUCT>
    YORG.CONT.DTE = R.ARR.APPL<AA.ARR.ORIG.CONTRACT.DATE>
    YSTART.DTE = R.ARR.APPL<AA.ARR.START.DATE>

    IF YSTART.DTE GE Y.TODAY THEN
        RETURN
    END
    IF Y.MAIN.ARR.STATUS NE 'CURRENT' AND Y.MAIN.ARR.STATUS NE 'EXPIRED' THEN
        RETURN
    END

    IF Y.MAIN.PROD.GROUP EQ 'LINEAS.DE.CREDITO' THEN
        PFM = '';PVM = ''; PSM = ''
        FINDSTR 'COM' IN Y.MAIN.ARR.PRCT SETTING PFM,PVM,PSM THEN
            Y.PRODUCT.GROUP = "COMERCIAL"
            GOSUB CHK.CURRENT.EXP
        END
    END ELSE
        GOSUB CHK.CURRENT.EXP
    END
RETURN
CHK.CURRENT.EXP:
*--------------
    IF YORG.CONT.DTE THEN
        Y.ORG.CONT.DTE = YORG.CONT.DTE[7,2]:"/":YORG.CONT.DTE[5,2]:"/":YORG.CONT.DTE[1,4]
    END
    PROP.NAME  = 'APAP.OVERDUE'
    returnConditions = ''; RET.ERR = ''; PROP.CLASS = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(AA.ARR.ID,PROP.CLASS,PROP.NAME,'','',returnConditions,ERR.COND)
    R.AA.MAIN.OVERDUE     = RAISE(returnConditions)
    Y.L.LN.STATUS = R.AA.MAIN.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>
    IF Y.L.LN.STATUS NE "Write-off" THEN
        Y.CUSTOMER.ID = R.ARR.APPL<AA.ARR.CUSTOMER>
        Y.CURRENCY    = R.ARR.APPL<AA.ARR.CURRENCY>
        AA.ID = AA.ARR.ID
        CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(AA.ID,OUT.RECORD)
        R.AA.TERM.AMOUNT.APP      = FIELD(OUT.RECORD,"*",1)
        R.AA.ACCOUNT.DETAILS.APP  = FIELD(OUT.RECORD,"*",2)
        R.AA.PAYMENT.SCHEDULE.APP = FIELD(OUT.RECORD,"*",3)
        R.INTEREST.ACCRUALS.APP   = FIELD(OUT.RECORD,"*",4)
        R.AA.OVERDUE.APP          = FIELD(OUT.RECORD,"*",5)
        R.AA.LIMIT.APP            = FIELD(OUT.RECORD,"*",6)
        R.AA.INTEREST.APP         = FIELD(OUT.RECORD,"*",7)
        R.AA.ACCOUNT.APP          = FIELD(OUT.RECORD,"*",8)
        R.AA.CUSTOMER             = FIELD(OUT.RECORD,"*",9)
        GOSUB GET.MAPPING.FLDS
    END
RETURN
GET.MAPPING.FLDS:
*---------------
    GOSUB CUS.GIVEN.DTLS.4
    GOSUB GET.LN.CODE.5
    GOSUB GET.CALL.RTN.FLDS
    GOSUB GET.MAT.DATE.11.12.13
    GOSUB GET.PRIC.PAY.MTHD.14.INIT15
    GOSUB GET.GRCE.PRD.16.17
    GOSUB GET.CCY.TYPE.18.JUD.19
    GOSUB GET.DEBT.RISK.20
    GOSUB GET.UNSEC.SEC.AMT.21
    GOSUB GET.VINC.TYPE.25
    GOSUB GET.COLL.AMT.26
    GOSUB GET.LOC.CATEG.CRISK.29.30.33
    GOSUB GET.PENALTY.PAYOFF.35.1
    GOSUB GET.REVIEW.INT.RATE.40
    GOSUB GET.CUS.TYPE.43.45
    GOSUB FORM.ARRAY
RETURN
*
CUS.GIVEN.DTLS.4:
*--------------
    Y.PRDT.GROUP = ""; Y.RLN.CODE = ""; OUT.ARR  = ""; Y.L.CU.PRO.RATING = ''
    Y.L.AA.MMD.PYME = ''; Y.L.AA.CAL.ISSUER = ''
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
    Y.CUST.IDEN    = OUT.ARR<1>
    Y.CUST.TYPE    = OUT.ARR<2>
    Y.CUST.NAME    = OUT.ARR<3>
    Y.CUST.GN.NAME = OUT.ARR<4>
    C$SPARE(351) = Y.CUST.IDEN
    C$SPARE(352) = Y.CUST.TYPE
    C$SPARE(353) = Y.CUST.NAME
    C$SPARE(354) = Y.CUST.GN.NAME

    Y.L.CU.PRO.RATING = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.PRO.RATING.POS>
    Y.L.AA.CAL.ISSUER = R.CUSTOMER<EB.CUS.LOCAL.REF,L.AA.CAL.ISSUER.POS>
    Y.L.AA.MMD.PYME = R.CUSTOMER<EB.CUS.LOCAL.REF,L.AA.MMD.PYME.POS>
RETURN
*
GET.LN.CODE.5:
*------------
    Y.LINKED.APPL    = R.ARR.APPL<AA.ARR.LINKED.APPL>
    Y.LINKED.APPL.ID = R.ARR.APPL<AA.ARR.LINKED.APPL.ID>
    LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.LINKED.POS THEN
        CHANGE @VM TO @FM IN Y.LINKED.APPL.ID
        Y.LOAN.CODE  = Y.LINKED.APPL.ID<Y.LINKED.POS>
    END
    ERR.ACCOUNT = ''; R.ACCOUNT = ''; Y.PREV.ACCOUNT = ''; Y.ALT.ACCT.TYPE= '';Y.ALT.ACCT.ID=''
    CALL F.READ(FN.ACCOUNT,Y.LOAN.CODE,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
    END
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = Y.LOAN.CODE
    END
    C$SPARE(355) = Y.PREV.ACCOUNT
RETURN
GET.CALL.RTN.FLDS:
*----------------
    IN.REC.VAL =  AA.ARR.ID:"#":Y.CUSTOMER.ID:"#":Y.CURRENCY:"#":Y.L.LN.STATUS:"#":R.AA.TERM.AMOUNT.APP:"#":R.AA.ACCOUNT.DETAILS.APP:"#":R.AA.OVERDUE.APP:"#":Y.LOAN.CODE
    CALL REDO.S.COM.CALC.DISB.DATE.AMT(IN.REC.VAL,OUT.REC.VAL)
    Y.SYS.DATE = OUT.REC.VAL<1>
    Y.DISBURSE.DATE.DIS = ''
    IF Y.SYS.DATE THEN
        Y.DISBURSE.DATE.DIS = Y.SYS.DATE[7,2]:"/":Y.SYS.DATE[5,2]:"/":Y.SYS.DATE[1,4]
        Y.DISBURSE.DATE =  Y.SYS.DATE
    END
*
    Y.COMP.CODE = OUT.REC.VAL<2>
    Y.LIMIT.REF = OUT.REC.VAL<3>; Y.DISBURSE.AMT = OUT.REC.VAL<4>
    Y.EARLY.PAY.OFF = OUT.REC.VAL<5>; Y.APROVAL.DATE.DIS = OUT.REC.VAL<6>
    Y.RESTRUCT.DATE.DIS = OUT.REC.VAL<7>; Y.RENEWAL.DATE.DIS = OUT.REC.VAL<8>
    Y.AMT.APPROVE = OUT.REC.VAL<9>; Y.COUN.CODE = OUT.REC.VAL<10>
    Y.MULT.LIMIT.REF = OUT.REC.VAL<11>; Y.MG.TOT.COMMIT = OUT.REC.VAL<12>
*
    C$SPARE(382) = Y.COMP.CODE[6,4]
    C$SPARE(356) = Y.MULT.LIMIT.REF
    C$SPARE(388) = Y.TXNEYPO.VAL.ARR
    C$SPARE(377) = Y.RESTRUCT.DATE.DIS
    C$SPARE(378) = Y.RENEWAL.DATE.DIS
    C$SPARE(384) = Y.COUN.CODE
    C$SPARE(386) = ""; C$SPARE(387) = ""; C$SPARE(392) = ""
RETURN
GET.MAT.DATE.11.12.13:
*---------------------
    Y.MAT.DATE = R.AA.TERM.AMOUNT.APP<AA.AMT.MATURITY.DATE>
    Y.MAT.DATE.DIS = ''; Y.START.DATE.DIS = ''
    IF Y.MAT.DATE THEN
        Y.MAT.DATE.DIS = Y.MAT.DATE[7,2]:"/":Y.MAT.DATE[5,2]:"/":Y.MAT.DATE[1,4]
    END
    C$SPARE(361) = Y.MAT.DATE.DIS
    ERR.REDO.AA.MIG.PAY.START.DTE = ''; R.REDO.AA.MIG.PAY.START.DTE = ''; YL.FIRST.PAY.DATE = ''; YACTUAL.DATE = ''
    CALL F.READ(FN.REDO.AA.MIG.PAY.START.DTE,Y.AA.ARR.ID,R.REDO.AA.MIG.PAY.START.DTE,F.REDO.AA.MIG.PAY.START.DTE,ERR.REDO.AA.MIG.PAY.START.DTE)
    IF R.REDO.AA.MIG.PAY.START.DTE THEN
        YL.FIRST.PAY.DATE = R.REDO.AA.MIG.PAY.START.DTE<REDO.AA.MPSD.FIRST.PAY.DATE>
    END
    Y.L.MIGRATED.LN = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.LOCAL.REF,L.MIGRATED.LN.POS>
    Y.PAYMENT.TYPE = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.TYPE>
    Y.ACTUAL.AMT   = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.ACTUAL.AMT>
    Y.CALC.AMT     = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.CALC.AMOUNT>
    IF Y.L.MIGRATED.LN EQ 'YES' THEN
        Y.FIRST.PAY.DATE = YL.FIRST.PAY.DATE
        YACTUAL.DATE = YORG.CONT.DTE
        C$SPARE(357) = Y.ORG.CONT.DTE
        C$SPARE(358) = Y.MG.TOT.COMMIT
        C$SPARE(359) = Y.ORG.CONT.DTE
        C$SPARE(360) = Y.MG.TOT.COMMIT
    END
    GOSUB GET.MAT.DATE.11.12.13.1
RETURN

GET.MAT.DATE.11.12.13.1:
************************
    IF Y.L.MIGRATED.LN NE 'YES' THEN
        Y.FIRST.PAY.DATE = R.AA.ACCOUNT.DETAILS.APP<AA.AD.PAYMENT.START.DATE>
        YACTUAL.DATE = Y.APROVAL.DATE.DIS[7,4]:Y.APROVAL.DATE.DIS[4,2]:Y.APROVAL.DATE.DIS[1,2]
        C$SPARE(357) = Y.APROVAL.DATE.DIS
        C$SPARE(358) = Y.AMT.APPROVE
        C$SPARE(359) = Y.DISBURSE.DATE.DIS
        C$SPARE(360) = Y.DISBURSE.AMT
    END
    IF Y.FIRST.PAY.DATE THEN
        Y.START.DATE.DIS = Y.FIRST.PAY.DATE[7,2]:"/":Y.FIRST.PAY.DATE[5,2]:"/":Y.FIRST.PAY.DATE[1,4]
    END
    C$SPARE(362) =  Y.START.DATE.DIS
    Y.DCNT.EB.PAY = DCOUNT(Y.AA.PAY.TYPE,@VM)
    Y.DCNT.DEB = '1'; Y.PAY.AMT = ''; Y.BILL.AMT = ''
    GOSUB BILL.AMT.CHK
    GOSUB GET.PAYMENT.BILL.41
    GOSUB PAY.AMT.CHK
    C$SPARE(363) =  Y.BILL.AMT
    C$SPARE(395) = Y.PAY.AMT
RETURN

BILL.AMT.CHK:
*-----------
    LOOP
    WHILE Y.DCNT.DEB LE Y.DCNT.EB.PAY
        Y.EB.PAY.VAL = Y.AA.PAY.TYPE<1,Y.DCNT.DEB>
        Y.PAY.AMT = ''
        GOSUB BILL.AMT.CHK.SUB
        Y.DCNT.DEB += '1'
    REPEAT
    IF Y.BILL.AMT THEN
        RETURN
    END
    Y.ACC.PAY.TYPE.DCNT = DCOUNT(Y.AA.PAY.TYPE.I,@VM)
    Y.ACC.PAY.TYPE.STA = '1'
    LOOP
    WHILE Y.ACC.PAY.TYPE.STA LE Y.ACC.PAY.TYPE.DCNT
        Y.ACC.PAY.TYPE.I.VAL = Y.AA.PAY.TYPE.I<1,Y.ACC.PAY.TYPE.STA>
        GOSUB BILL.AMT.CHK.1.SUB
        Y.ACC.PAY.TYPE.STA += '1'
    REPEAT
RETURN
BILL.AMT.CHK.SUB:
*****************
    LOCATE Y.EB.PAY.VAL IN Y.PAYMENT.TYPE<1,1> SETTING Y.POS.CN THEN
        Y.BILL.AMT = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.CALC.AMOUNT,Y.POS.CN>
        IF NOT(Y.BILL.AMT) THEN
            Y.BILL.AMT = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.ACTUAL.AMT,Y.POS.CN>
        END
    END
    IF Y.BILL.AMT THEN
        Y.DCNT.DEB = Y.DCNT.EB.PAY
    END
RETURN
BILL.AMT.CHK.1.SUB:
*******************
    LOCATE Y.ACC.PAY.TYPE.I.VAL IN Y.PAYMENT.TYPE<1,1> SETTING Y.POS.LN THEN
        Y.BILL.AMT = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.CALC.AMOUNT,Y.POS.LN>
        IF NOT(Y.BILL.AMT) THEN
            Y.BILL.AMT = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.ACTUAL.AMT,Y.POS.LN>
        END
    END
    IF Y.BILL.AMT THEN
        Y.ACC.PAY.TYPE.STA = Y.ACC.PAY.TYPE.DCNT
    END
RETURN

PAY.AMT.CHK:
*----------
    IF NOT(Y.PAMENT.DATE.EXTRA.BILL.DIS) THEN
        RETURN
    END
    Y.DCNT.PAY.TYPE = DCOUNT(Y.PAYMENT.TYPE,@VM)
    Y.STA.CNT = '1'; Y.PAY.AMT = ''
    LOOP
    WHILE Y.STA.CNT LE Y.DCNT.PAY.TYPE
        Y.PAY.TYPE.VAL = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PAYMENT.TYPE,Y.STA.CNT>
        IF Y.PAY.AMT THEN
            RETURN
        END
        Y.PAY.AMT = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.ACTUAL.AMT,Y.STA.CNT>
        IF Y.PAY.TYPE.VAL EQ "CAPPROG" OR Y.PAY.TYPE.VAL EQ "SOLO.CAPITAL" THEN
            Y.PAY.AMT = ''
            Y.PAY.AMT = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.CALC.AMOUNT,Y.STA.CNT>
        END
        Y.STA.CNT += '1'
    REPEAT
RETURN
GET.PRIC.PAY.MTHD.14.INIT15:
*---------------------------
    Y.DATA.VAL.FREQ = ''; Y.DUE.FREQ.1 = ''
    Y.PRTY = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.PROPERTY>
    Y.DUE.FREQ.1 = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.DUE.FREQ>
    CHANGE @SM TO @VM IN Y.PRTY
    CHANGE @SM TO @VM IN Y.DUE.FREQ.1
    LOCATE "ACCOUNT" IN Y.PRTY<1,1> SETTING Y.PRTY.POS THEN
        Y.DUE.FREQ = Y.DUE.FREQ.1<1,Y.PRTY.POS>
    END
    GOSUB GET.FREQ.VAL
    C$SPARE(364) =  Y.DATA.VAL.FREQ
    Y.DATA.VAL.FREQ = ''
    LOCATE "PRINCIPALINT" IN Y.PRTY<1,1> SETTING Y.PRINC.PRTY.POS THEN
        Y.DUE.FREQ = Y.DUE.FREQ.1<1,Y.PRINC.PRTY.POS>
    END
    GOSUB GET.FREQ.VAL
    C$SPARE(365) =  Y.DATA.VAL.FREQ
RETURN
GET.FREQ.VAL:
************
    Y.YR.FREQ.VAL = Y.DUE.FREQ[2,1]
    Y.FREQ.VAL = Y.DUE.FREQ[6,1]
    IF Y.YR.FREQ.VAL GT '0' THEN
        Y.DATA.VAL.FREQ = 'A'
    END ELSE
        GOSUB GET.FREQ.VAL.1
    END
RETURN
GET.FREQ.VAL.1:
**************
    LOCATE Y.FREQ.VAL IN Y.CAP.INT.PAY.MTD.DATA.NAME<1> SETTING Y.DATA.POS THEN
        Y.DATA.VAL.FREQ = R.EB.LOOKUP.CAP.INT<EB.LU.DATA.VALUE,Y.DATA.POS>
    END ELSE
        Y.RESIDUAL.AMT = R.AA.PAYMENT.SCHEDULE.APP<AA.PS.RESIDUAL.AMOUNT>
        IF Y.RESIDUAL.AMT EQ Y.AMT.APPROVE THEN
            Y.DATA.VAL.FREQ = 'V'
        END
    END
RETURN
GET.GRCE.PRD.16.17:
*------------------
    NO.OF.MONTHS = ''; Y.MNTH = ''
    Y.EFC.RATE = R.AA.INTEREST.APP<AA.INT.EFFECTIVE.RATE>
    Y.DATE1 = Y.FIRST.PAY.DATE
    Y.DATE2 = YACTUAL.DATE
    IF Y.DATE1 GE Y.DATE2 THEN
        CALL EB.NO.OF.MONTHS(Y.DATE1,Y.DATE2,NO.OF.MONTHS)
    END
    Y.GDAYS = 'C'
    IF LEN(Y.DATE1) EQ 8 AND LEN(Y.DATE2) EQ 8 THEN
        CALL CDD('',Y.DATE1,Y.DATE2,Y.GDAYS)
    END

    IF Y.GDAYS LE '30' THEN
        Y.MNTH = 0
    END ELSE
        Y.MNTH = NO.OF.MONTHS:'M'
    END
    C$SPARE(366)  = Y.MNTH
    GOSUB GET.GRCE.PRD.16.17.1
RETURN

GET.GRCE.PRD.16.17.1:
********************
    Y.RATE = ''
    Y.RATE = R.INTEREST.ACCRUALS.APP<AA.INT.ACC.RATE,1>
    IF Y.RATE THEN
        C$SPARE(367)  = ABS(Y.RATE)
        RETURN
    END
    NPV.VAL = Y.DISBURSE.AMT
    R.REDO.AA.SCHEDULE = ''; SCH.ERR = ''
    CALL F.READ(FN.REDO.AA.SCHEDULE,AA.ARR.ID,R.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE,SCH.ERR)
    Y.NO.OF.BILLS = RAISE(R.REDO.AA.SCHEDULE<2>)
    Y.CNT.BILLS = DCOUNT(Y.NO.OF.BILLS,@FM)
    TERM  = Y.CNT.BILLS
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.CNT.BILLS
        IF CASH.FLOWS THEN
            CASH.FLOWS:= @FM:Y.BILL.AMT
        END ELSE
            CASH.FLOWS = Y.BILL.AMT
        END
        Y.CNT += 1
    REPEAT
    IF NPV.VAL AND CASH.FLOWS AND TERM THEN
        CALL CRR.S.CALC.IRR(NPV.VAL,CASH.FLOWS,TERM,IRR.RATE)
        Y.RATE = IRR.RATE
    END
    C$SPARE(367)  = ABS(Y.RATE)
RETURN
GET.CCY.TYPE.18.JUD.19:
*----------------------
    Y.CCY.TYPE  = "E"
    IF Y.CURRENCY EQ LCCY THEN
        Y.CCY.TYPE  = "N"
    END
    C$SPARE(368)  = Y.CCY.TYPE
    Y.JUDIC.COLL = 'N'
    IF Y.L.LN.STATUS EQ "JudicialCollection" THEN
        Y.JUDIC.COLL = 'S'
    END
    C$SPARE(369)  = Y.JUDIC.COLL
RETURN
GET.DEBT.RISK.20:
*---------------
    R.REDO.H.CUSTOMER.PROVISIONING = ''; CUS.PROV.ERR = ''; Y.LN.TYPE.PROV = ''
    CALL F.READ(FN.REDO.H.CUSTOMER.PROVISIONING,Y.CUSTOMER.ID,R.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING,CUS.PROV.ERR)
    Y.LN.TYPE.PROV= R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE>
    LOCATE "COMMERCIAL" IN Y.LN.TYPE.PROV<1,1> SETTING Y.LN.TYP.POS THEN
        Y.GET.DEBT.RISK = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURRENT.CLASS,Y.LN.TYP.POS>
    END
    IF Y.L.AA.MMD.PYME[1,2] EQ '1B' OR Y.L.AA.MMD.PYME[1,2] EQ '1C' THEN
        C$SPARE(370)  = Y.GET.DEBT.RISK
        C$SPARE(400) = 'M'
    END
    IF Y.L.AA.MMD.PYME[1,2] EQ '1A' THEN
        C$SPARE(370)  = Y.L.AA.CAL.ISSUER
        C$SPARE(400) = 'C'
    END
RETURN
GET.UNSEC.SEC.AMT.21:
*-------------------
    Y.CLS.POS = ''
    Y.CO.CODE = R.ARR.APPL<AA.ARR.CO.CODE>
    CALL F.READ(FN.REDO.H.PROVISION.PARAM,Y.CO.CODE,R.REDO.PROV.PARAM.CO,F.REDO.H.PROVISION.PARAM,REDO.PROV.ERR)
    IF R.REDO.PROV.PARAM.CO THEN
        R.REDO.H.PROVISION.PARAM = R.REDO.PROV.PARAM.CO
    END
    Y.LN.TYPE = R.REDO.H.PROVISION.PARAM<PROV.LOAN.TYPE>
    LOCATE "COMMERCIAL" IN Y.LN.TYPE<1,1> SETTING Y.LN.TYP.POS THEN
        Y.PRDT.GRP =  R.REDO.H.PROVISION.PARAM<PROV.PRODUCT.GROUP,Y.LN.TYP.POS>
        GOSUB GET.UNSEC.SEC.AMT.21.SUB
    END
    C$SPARE(371) = Y.UNSECUR.CLS
    C$SPARE(372) = Y.SECUR.CLS
    GOSUB GET.UNSEC.SEC.AMT.21.1
RETURN
GET.UNSEC.SEC.AMT.21.SUB:
************************
    LOCATE Y.MAIN.PROD.GROUP IN Y.PRDT.GRP<1,1,1> SETTING Y.PRDT.GRP.POS THEN
        Y.CLASSFICATION =  R.REDO.H.PROVISION.PARAM<PROV.CLASSIFICATION,Y.PRDT.GRP.POS>
        LOCATE Y.GET.DEBT.RISK IN Y.CLASSFICATION<1,1,1> SETTING Y.CLS.POS THEN
            Y.UNSECUR.CLS = R.REDO.H.PROVISION.PARAM<PROV.UNSECUR.CLASSI,1,Y.CLS.POS>
            Y.SECUR.CLS = R.REDO.H.PROVISION.PARAM<PROV.SECUR.CLASSI,1,Y.CLS.POS>
        END
    END
RETURN

GET.UNSEC.SEC.AMT.21.1:
***********************
    Y.AA.REDO.PROV.ID = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.ARRANGEMENT.ID>
    LOCATE AA.ARR.ID IN Y.AA.REDO.PROV.ID<1,1> SETTING Y.REDO.PROV.POS THEN
        Y.PROV.PRIC = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.PRINC,Y.REDO.PROV.POS>
        Y.PROV.INTEREST = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.INTEREST,Y.REDO.PROV.POS>
    END
    C$SPARE(373) = Y.PROV.PRIC; C$SPARE(390) = Y.PROV.PRIC; C$SPARE(391) = Y.PROV.INTEREST
    Y.ORIEGN = R.AA.ACCOUNT.APP<AA.AC.LOCAL.REF,Y.ORGN.FUND.POS>
    C$SPARE(374) = R.AA.ACCOUNT.APP<AA.AC.LOCAL.REF,Y.ORGN.FUND.POS>
    C$SPARE(381) = R.AA.ACCOUNT.APP<AA.AC.LOCAL.REF,L.AA.CATEG.POS>
    Y.AA.LOAN = R.AA.ACCOUNT.APP<AA.AC.LOCAL.REF,Y.L.AA.LOAN.DSN.POS>
RETURN
GET.VINC.TYPE.25:
*---------------
    Y.RLN.VAL = ''
    IF NOT(R.CUSTOMER) THEN
        C$SPARE(375) = Y.RLN.VAL
        RETURN
    END
    Y.RLN.CODE.VAL = R.CUSTOMER<EB.CUS.RELATION.CODE>
    Y.RL.DCNT = DCOUNT(Y.RLN.CODE.VAL,@VM)
    Y.RL.CNT = '1'
    LOOP
    WHILE Y.RL.CNT LE Y.RL.DCNT
        Y.RLN.CODE = Y.RLN.CODE.VAL<1,Y.RL.CNT>
        LOCATE Y.RLN.CODE IN Y.VINCATION.DATA.NAME<1> SETTING Y.LNK.TYP.POS THEN
            Y.RLN.VAL = R.EB.LOOKUP<EB.LU.DATA.VALUE,Y.LNK.TYP.POS>
        END
        IF Y.RLN.VAL THEN
            Y.RL.CNT =  Y.RL.DCNT
        END
        Y.RL.CNT += 1
    REPEAT
    IF NOT(Y.RLN.VAL) THEN
        Y.RLN.VAL = 'NI'
    END
    C$SPARE(375) = Y.RLN.VAL
RETURN
GET.COLL.AMT.26:
*--------------
    Y.AA.COL = R.AA.TERM.AMOUNT.APP<AA.AMT.LOCAL.REF,Y.AA.COL.POS>
    Y.DCNT.COLL = DCOUNT(Y.AA.COL,@VM)
    Y.DCNT.STA = '1'; FIN.BNK.VAL = ''
    LOOP
    WHILE Y.DCNT.STA LE Y.DCNT.COLL
        Y.COLL.ID = Y.AA.COL<Y.DCNT.STA>
        CALL F.READ(FN.COLLATERAL,Y.COLL.ID,R.COLLATERAL,F.COLLATERAL,COLL.ERR)
        Y.CENTARL.BNK.VAL = ''
        IF NOT(R.COLLATERAL) THEN
            Y.DCNT.STA += 1
            CONTINUE
        END
        Y.CENTARL.BNK.VAL = R.COLLATERAL<COLL.CENTRAL.BANK.VALUE>
        IF FIN.BNK.VAL THEN
            FIN.BNK.VAL += Y.CENTARL.BNK.VAL
        END ELSE
            FIN.BNK.VAL = Y.CENTARL.BNK.VAL
        END
        Y.DCNT.STA += 1
    REPEAT
    C$SPARE(376) = FIN.BNK.VAL
RETURN
*
GET.LOC.CATEG.CRISK.29.30.33:
*----------------------------
    Y.LOCALIDAD = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.LOCALIDAD.POS>
    C$SPARE(379) = Y.LOCALIDAD
    Y.L.APAP.INDUSTRY = ''; R.COUNTRY = ''; COUN.ERR = ''
    Y.L.APAP.INDUSTRY = R.CUSTOMER<EB.CUS.LOCAL.REF,L.APAP.INDUSTRY.POS>
    C$SPARE(380) = Y.L.APAP.INDUSTRY
    CALL F.READ(FN.COUNTRY,Y.COUN.CODE,R.COUNTRY,F.COUNTRY,COUN.ERR)
    Y.CO.RISL.CLS = R.COUNTRY<EB.COU.LOCAL.REF,Y.RISK.CLS.POS>
    C$SPARE(383) = Y.CO.RISL.CLS
    Y.ADJ.STA.DATE.DIS = ''
    Y.ADJ.STA.DATE = R.AA.OVERDUE.APP<AA.OD.LOCAL.REF,ADJ.STA.DATE.POS>
    IF Y.ADJ.STA.DATE THEN
        Y.ADJ.STA.DATE.DIS = Y.ADJ.STA.DATE[7,2]:"/":Y.ADJ.STA.DATE[5,2]:"/":Y.ADJ.STA.DATE[1,4]
    END
    C$SPARE(385) = Y.ADJ.STA.DATE.DIS
RETURN
GET.PENALTY.PAYOFF.35.1:
*----------------------
    Y.CHARGE.PROP = 'PRCANCANTIC'
    PROP.CLASS='CHARGE'
    PROPERTY = Y.CHARGE.PROP
    R.CONDITION = ''; ERR.MSG = ''; EFF.DATE = ''
    CALL REDO.CRR.GET.CONDITIONS(AA.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    Y.CHG.RATE = R.CONDITION<AA.CHG.LOCAL.REF,Y.L.AA.CHG.RATE.POS>    ;* Payoff charge %
    C$SPARE(389) = Y.TXNEYPOP.VAL.ARR
RETURN
GET.REVIEW.INT.RATE.40:
*----------------------
    Y.L.REV.RT.TYPE = R.AA.INTEREST.APP<AA.INT.LOCAL.REF,Y.L.AA.REV.RT.TY.POS>
    IF Y.L.REV.RT.TYPE EQ "PERIODICO" THEN
        Y.L.AA.NXT.REV.DT = R.AA.INTEREST.APP<AA.INT.LOCAL.REF,Y.L.AA.NXT.REV.DT.POS>
    END
    Y.REVIEW.DATE = ''; Y.REVIEW.DATE.DIS = ''
    IF Y.L.AA.NXT.REV.DT THEN
        Y.REVIEW.DATE = Y.L.AA.NXT.REV.DT
        Y.REVIEW.DATE.DIS = Y.REVIEW.DATE[7,2]:"/":Y.REVIEW.DATE[5,2]:"/":Y.REVIEW.DATE[1,4]
    END
    C$SPARE(393) =  Y.REVIEW.DATE.DIS
RETURN
GET.PAYMENT.BILL.41:
*------------------
    IF Y.MAIN.PROD.GROUP EQ "COMERCIAL" THEN
        Y.PROPERTY.NAME  = Y.AA.COMER.PAY.SCH
    END ELSE
        Y.PROPERTY.NAME = Y.AA.LINEAS.PAY.SCH
    END
    IF Y.PROPERTY.NAME THEN
*        Y.PAMENT.PROP = Y.ACTIVITY.PROPERTY<PAMENT.DATE.POS>
        Y.PRODUCT = Y.MAIN.ARR.PRCT
        Y.PRODUCT.ID = Y.PRODUCT:'-'
        FINDSTR Y.PRODUCT.ID IN SEL.LIST.3 SETTING Y.POS.PRST THEN
            Y.ID.DESIGN = SEL.LIST.3<Y.POS.PRST>
            CALL F.READ(FN.AA.PRODUCT.DESIGNER,Y.ID.DESIGN,R.AA.PRODUCT.DESIGNER,F.AA.PRODUCT.DESIGNER,AA.PRODUCT.DESIGNER.ERR)
            Y.PRD.PROPERTY = R.AA.PRODUCT.DESIGNER<AA.PRD.PRD.PROPERTY>
            CHANGE @VM TO @FM IN Y.PRD.PROPERTY
        END
    END
    Y.PAMENT.DATE.EXTRA.BILL.DIS = ''
    IF Y.PAMENT.DATE.EXTRA.BILL THEN
        Y.PAMENT.DATE.EXTRA.BILL.DIS = Y.PAMENT.DATE.EXTRA.BILL[7,2]:"/":Y.PAMENT.DATE.EXTRA.BILL[5,2]:"/":Y.PAMENT.DATE.EXTRA.BILL[1,4]
    END
    C$SPARE(394) = Y.PAMENT.DATE.EXTRA.BILL.DIS
RETURN
PAMENT.EXTRA.BILL.CHK:
**--------------------
    Y.PAMENT.DATE.EXTRA.BILL = ''
    IF NOT(Y.PRD.PROPERTY) THEN
        RETURN
    END
    AA.SCH.ACT.ERR = ""; R.AA.SCHEDULED.ACTIVITY = ""
    CALL F.READ(FN.AA.SCHEDULED.ACTIVITY,AA.ARR.ID,R.AA.SCHEDULED.ACTIVITY,F.AA.SCHEDULED.ACTIVITY,AA.SCH.ACT.ERR)
    Y.INT.ACTIVITY  = R.AA.SCHEDULED.ACTIVITY<AA.SCH.ACTIVITY.NAME>
    Y.INT.LAST.DATE = R.AA.SCHEDULED.ACTIVITY<AA.SCH.LAST.DATE>
    Y.INT.NEXT.DATE = R.AA.SCHEDULED.ACTIVITY<AA.SCH.NEXT.DATE>
    CHANGE @VM TO @FM IN Y.INT.ACTIVITY
    CHANGE @VM TO @FM IN Y.INT.LAST.DATE
    CHANGE @VM TO @FM IN Y.INT.NEXT.DATE
    Y.NEXT.DATE = ''
    FINDSTR "*SOLO.CAPITAL" IN Y.INT.ACTIVITY SETTING Y.ACT.POS.1 THEN
        Y.NEXT.DATE = Y.INT.NEXT.DATE<Y.ACT.POS.1>
        Y.FD.FLG = "1"
    END
    IF Y.FD.FLG EQ "" THEN
        FINDSTR "*CAPPROG" IN Y.INT.ACTIVITY SETTING Y.ACT.POS.2 THEN
            Y.NEXT.DATE = Y.INT.NEXT.DATE<Y.ACT.POS.2>
        END
    END
    Y.PAMENT.DATE.EXTRA.BILL = Y.NEXT.DATE
RETURN
GET.CUS.TYPE.43.45:
*-----------------
    Y.CU.DEBTOR = '' ; Y.L.TIP.CLI = ''; Y.CR.FACT = ''
    Y.L.TIP.CLI = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.TIP.CLI.POS>
    C$SPARE(396) =  Y.L.TIP.CLI
    Y.CR.FACT  = R.AA.ACCOUNT.APP<AA.AC.LOCAL.REF,Y.L.CR.FACILITY.POS>
    C$SPARE(397) = Y.CR.FACT
    C$SPARE(398) = ''; C$SPARE(399) = ''; C$SPARE(402) = ''; C$SPARE(403) = ''; C$SPARE(404) = ''
*    Y.CU.DEBTOR =  R.CUSTOMER<EB.CUS.LOCAL.REF,Y.CU.DEBTOR.POS>
    LOCATE Y.L.REV.RT.TYPE IN Y.TXNTDT.VAL.ARR<1,1> SETTING TXNTE.POS THEN
        YOPER.TYPE = Y.TXNTDT.DIS.ARR<1,TXNTE.POS>
    END
    C$SPARE(401) = YOPER.TYPE
    GOSUB GET.CUS.TYPE.43.45.1
RETURN

GET.CUS.TYPE.43.45.1:
*********************
    L.LOAN.STATUS.1.VAL = R.AA.OVERDUE.APP<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>
    L.RESTRUCT.TYPE.VAL = R.AA.OVERDUE.APP<AA.OD.LOCAL.REF,Y.L.RESTRUCT.TYPE.POS>
    IF L.LOAN.STATUS.1.VAL EQ "Restructured" THEN
        C$SPARE(405) = L.RESTRUCT.TYPE.VAL
    END ELSE
        C$SPARE(405) = "NR"
    END
    YL.AA.CAMP.TY = R.AA.CUSTOMER<AA.CUS.LOCAL.REF,L.AA.CAMP.TY.POS>
    ERR.REDO.CAMPAIGN.TYPES = ''; R.REDO.CAMPAIGN.TYPES = ''
    CALL F.READ(FN.REDO.CAMPAIGN.TYPES,YL.AA.CAMP.TY,R.REDO.CAMPAIGN.TYPES,F.REDO.CAMPAIGN.TYPES,ERR.REDO.CAMPAIGN.TYPES)
    IF R.REDO.CAMPAIGN.TYPES THEN
        YCAMP.SHRTNME = R.REDO.CAMPAIGN.TYPES<CG.TYP.CAM.SHORT.DESC>
    END
*    Y.L.CR.ORIG = R.AA.ACCOUNT.APP<AA.AC.LOCAL.REF,L.CR.ORIG.POS>
    C$SPARE(406)      = YCAMP.SHRTNME
RETURN
FORM.ARRAY:
*---------
    Y.ARR<-1> = Y.CUST.IDEN:"*":Y.CUST.TYPE:"*":Y.CUST.NAME:"*":Y.CUST.GN.NAME:"*":Y.LOAN.CODE:"*":Y.LIMIT.REF:"*":Y.APROVAL.DATE.DIS:"*":Y.AMT.APPROVE:"*":Y.DISBURSE.DATE.DIS:"*":Y.DISBURSE.AMT:"*":Y.MAT.DATE.DIS:"*":Y.START.DATE.DIS:"*":Y.BILL.AMT:"*":Y.DATA.VAL.FREQ:"*":Y.DATA.VAL.FREQ:"*":NO.OF.MONTHS:"*":Y.RATE:"*":Y.CCY.TYPE:"*":Y.JUDIC.COLL:"*":Y.GET.DEBT.RISK:"*":Y.UNSECUR.CLS:"*":Y.SECUR.CLS:"*":Y.PROV.PRIC:"*":Y.ORIEGN:"*":Y.RLN.VAL:"*":FIN.BNK.VAL:"*":Y.RESTRUCT.DATE.DIS:"*":Y.RENEWAL.DATE.DIS:"*":Y.LOCALIDAD:"*":Y.L.APAP.INDUSTRY:"*":Y.AA.LOAN:"*":Y.COMP.CODE:"*":Y.CO.RISL.CLS:"*":Y.COUN.CODE:"*":Y.ADJ.STA.DATE.DIS:"*":"":"*":"":"*":Y.EARLY.PAY.OFF:"*":Y.CHG.RATE:"*":Y.PROV.PRIC:"*":Y.PROV.INTEREST:"*":"":"*":Y.REVIEW.DATE.DIS:"*":Y.PAMENT.DATE.EXTRA.BILL.DIS:"*":Y.PAY.AMT:"*":Y.L.TIP.CLI:"*":Y.CR.FACT:"*":"":"*":"":"*":Y.CU.DEBTOR
    MAP.FMT = "MAP"
    Y.MAP.ID = "REDO.RCL.DE11"
    Y.RCL.APPL = FN.AA.ARRANGEMENT
    Y.RCL.AA.ID = AA.ARR.ID
    CALL RAD.CONDUIT.LINEAR.TRANSLATION(MAP.FMT,Y.MAP.ID,Y.RCL.APPL,Y.RCL.AA.ID,R.AZ.,R.RETURN.MSG,ERR.MSG)
    IF Y.DISBURSE.AMT EQ "" THEN
        Y.DISBURSE.AMT = "0"
    END
    Y.COMMERCI.REC = FMT(Y.DISBURSE.AMT,'R2#23'):"^":R.RETURN.MSG
    IF Y.COMMERCI.REC THEN
        WRITESEQ Y.COMMERCI.REC APPEND TO Y$.SEQFILE.PTR ELSE
            Y.ERR.MSG = "Unable to Write '":Y.OUT.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
RETURN
*
RAISE.ERR.C.22:
*--------------
    MON.TP    = "13"
    REC.CON   = "DE11-":AA.ARR.ID:Y.ERR.MSG
    DESC      = "DE11-":AA.ARR.ID:Y.ERR.MSG
    INT.CODE  = 'REP001'; INT.TYPE  = 'ONLINE'
    BAT.NO    = ''; BAT.TOT   = ''; INFO.OR   = ''; INFO.DE   = ''; ID.PROC   = ''; EX.USER   = ''; EX.PC     = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
RETURN
END
