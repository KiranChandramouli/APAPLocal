SUBROUTINE DR.REG.RIEN9.EXTRACT(REC.ID)
*----------------------------------------------------------------------------
* Company Name   : APAP
* Company Name   : APAP
* Developed By   : gangadhar@temenos.com
* Program Name   : DR.REG.RIEN9.EXTRACT
* Date           : 3-May-2013
*----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the MM and SEC.TRADE in DOP and non DOP.
*----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 28-08-2014   V.P.Ashokkumar       PACS00313072- Fixed all the fields
* 09-12-2014   V.P.Ashokkumar       PACS00313072- Fixed all the fields
* 10-02-2015   V.P.Ashokkumar       PACS00313072- Fixed LOCATE problem
* 27-03-2015   V.P.Ashokkumar       PACS00313072- Updated mapping and performance change
* 10-06-2015   V.P.Ashokkumar       PACS00313072- Changed as per mapping
* 21-10-2016   V.P.Ashokkumar       R15 Upgrade
* 18-01-2018   Bienvenido Romero    CN008184- Sustitución Nombre y No. Cédula por No. cliente APAP
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_TSA.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.INDUSTRY
    $INSERT I_F.COLLATERAL
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.RE.STAT.LINE.CONT
    $INSERT I_F.LIMIT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.LIMIT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.RELATION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.PRODUCT.GROUP
    $INSERT I_F.COUNTRY
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.DATES
*
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_F.REDO.CREATE.ARRANGEMENT
    $INSERT I_F.REDO.AZACC.DESC
    $INSERT I_DR.REG.RIEN9.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN9.PARAM
    $INSERT I_F.REDO.CATEGORY.CIUU
    $INSERT I_F.REDO.AA.MIG.PAY.START.DTE
*
    GOSUB PROCESS
RETURN

PROCESS:
*------*
    GOSUB INIT
    GOSUB PROCESS.AA
RETURN

GET.ACCOUNT.LIMIT:
******************
* Upgrade Start 21/10/2016
    LIM.REF = ''; APPR.DATE = ''; YCONTY.RSK = ''; LIM.SERL = ''
    LIM.REF = R.AA.ARR.LIMIT<AA.LIM.LIMIT.REFERENCE>
    LIM.SERL = R.AA.ARR.LIMIT<AA.LIM.LIMIT.SERIAL>
    IF LIM.REF THEN
        LIM.1 = FMT(LIM.REF,"7'0'R")
        LIM.ID = CUS.ID:'.':LIM.1:'.':LIM.SERL
* Upgrade end 21/10/2016
        R.LIMIT = ''; LIMIT.ERR = ''
        CALL F.READ(FN.LIMIT,LIM.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)
        APPR.DATE = R.LIMIT<LI.APPROVAL.DATE>
        YCONTY.RSK = R.LIMIT<LI.COUNTRY.OF.RISK>
    END ELSE
        APPR.DATE = ''
    END
    ERR.REDO.AA.MIG.PAY.START.DTE = ''; R.REDO.AA.MIG.PAY.START.DTE = ''; YL.FIRST.PAY.DATE = ''
    CALL F.READ(FN.REDO.AA.MIG.PAY.START.DTE,Y.AA.ARR.ID,R.REDO.AA.MIG.PAY.START.DTE,F.REDO.AA.MIG.PAY.START.DTE,ERR.REDO.AA.MIG.PAY.START.DTE)
    IF R.REDO.AA.MIG.PAY.START.DTE THEN
        YL.FIRST.PAY.DATE = R.REDO.AA.MIG.PAY.START.DTE<REDO.AA.MPSD.FIRST.PAY.DATE>
    END
RETURN

GET.ACCOUNT.DET:
****************
    R.ACCOUNT = ''; ERR.ACCOUNT = ''; YCLOSE.DATE = ''
    CALL F.READ(FN.ACCOUNT,AC.ID,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    IF NOT(R.ACCOUNT) THEN
        ERRR.ACCT = ''; AC.ID.HIS = AC.ID
        CALL EB.READ.HISTORY.REC(F.ACCOUNT.HIST,AC.ID.HIS,R.ACCOUNT,ERRR.ACCT)
    END
    YCLOSE.DATE = R.ACCOUNT<AC.CLOSURE.DATE>
RETURN

PROCESS.AA:
***********
    R.AA.ARRANGEMENT = ''; AA.ARRANGEMENT.ERR = ''; R.AA.PRODUCT.GROUP = ''; ERR.AA.PRODUCT.GROUP = ''
    YAPG.DESC = ''; STAR.DATE.VAL = ''; Y.ALT.ACCT.TYPE = ''; Y.ALT.ACCT.ID = ''; Y.PREV.ACCOUNT = ''
    CALL F.READ(FN.AA.ARRANGEMENT,REC.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
    CCY.VAL = R.AA.ARRANGEMENT<AA.ARR.CURRENCY,1>
    CUS.ID = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER,1>
    STAR.DATE.VAL = R.AA.ARRANGEMENT<AA.ARR.START.DATE,1>
    AA.STATUS = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS,1>
    YPRCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP,1>
    IF STAR.DATE.VAL GT Y.TODAY THEN
        RETURN
    END
    IF AA.STATUS MATCHES 'CURRENT':@VM:'EXPIRED' ELSE
        RETURN
    END

    ArrangementID = REC.ID
    idPropertyClass = 'OVERDUE'
    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''; effectiveDate = '';  YACT.OD.STATUS1 = ''; OD.STATUS.CHK = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.OVERDUE = RAISE(returnConditions)
    YACT.OD.STATUS1 = R.AA.OVERDUE<AA.OD.LOCAL.REF,OD.L.LOAN.STATUS1.POS>
    OD.STATUS.CHK = R.AA.OVERDUE<AA.OD.LOCAL.REF,OD.L.STATUS.CHG.DT.POS>
    IF YACT.OD.STATUS1 EQ "Write-off" THEN
        RETURN
    END

    CALL F.READ(FN.AA.PRODUCT.GROUP,YPRCT.GROUP,R.AA.PRODUCT.GROUP,F.AA.PRODUCT.GROUP,ERR.AA.PRODUCT.GROUP)
    YAPG.DESC = R.AA.PRODUCT.GROUP<AA.PG.DESCRIPTION,1>
    IF YAPG.DESC EQ 'LINEAS.DE.CREDITO' THEN
        YAPG.DESC = 'COMMERCIAL'
    END
    APP.ID = 'ACCOUNT'; AC.ID = ''; OD.STATUS1 = ''; R.CUSTOMER = ''; CUSTOMER.ERR = ''; Y.LINKED.POS = ''
    Y.LINKED.APPL = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL,1>
    Y.LINKED.ID = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID,1>
    LOCATE APP.ID IN Y.LINKED.APPL<1,1> SETTING Y.LINKED.POS THEN
        AC.ID = Y.LINKED.ID<1,Y.LINKED.POS>
    END
    GOSUB GET.ACCOUNT.DET

    CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(REC.ID,OUT.RECORD)
    YR.AA.ARR.TERM = FIELD(OUT.RECORD,"*",1)
    R.AA.ACCOUNT.DETAILS  = FIELD(OUT.RECORD,"*",2)
    R.AA.PAYMENT.SCHEDULE = FIELD(OUT.RECORD,"*",3)
    R.INTEREST.ACCRUALS   = FIELD(OUT.RECORD,"*",4)
    R.AA.OVERDUE          = FIELD(OUT.RECORD,"*",5)
    R.AA.ARR.LIMIT        = FIELD(OUT.RECORD,"*",6)
    R.AA.INTEREST         = FIELD(OUT.RECORD,"*",7)
    R.AA.ACCOUNT          = FIELD(OUT.RECORD,"*",8)

    CALL F.READ(FN.CUSTOMER,CUS.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    R.REDO.H.CUSTOMER.PROVISIONING = ''; REDO.H.CUSTOMER.PROVISIONING.ERR = ''; OUT.RECORD = ''
    CALL F.READ(FN.REDO.H.CUSTOMER.PROVISIONING,CUS.ID,R.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING,REDO.H.CUSTOMER.PROVISIONING.ERR)

    Y.ALT.ACCT.TYPE = R.ACCOUNT<AC.ALT.ACCT.TYPE>
    Y.ALT.ACCT.ID = R.ACCOUNT<AC.ALT.ACCT.ID>
    LOCATE 'ALTERNO1' IN Y.ALT.ACCT.TYPE<1,1> SETTING ALT.TYPE.POS THEN
        Y.PREV.ACCOUNT = Y.ALT.ACCT.ID<1,ALT.TYPE.POS>
    END
    IF NOT(Y.PREV.ACCOUNT) THEN
        Y.PREV.ACCOUNT = AC.ID
    END
    GOSUB PROCESS.GROUP1
    YSKP.FLG = 0
    GOSUB PROCESS.GROUP2
    IF YSKP.FLG EQ 1 THEN
        RETURN
    END
    GOSUB PROCESS.GROUP3
    GOSUB ARRAY.FORM.P
    GOSUB WRITE.PROCESS
RETURN

WRITE.PROCESS:
**************
    IF CCY.VAL EQ LCCY THEN
        CALL F.WRITE(FN.DR.REG.RIEN9.WORKFILE,REC.ID.P,RETURN.MSG.P)
    END ELSE
        CALL F.WRITE(FN.DR.REG.RIEN9.WORKFILE.FCY,REC.ID.P,RETURN.MSG.P)
    END
RETURN

GET.DISBURSE.VAL:
*****************
    Y.COMMITED.AMT = 0; Y.DISBURSE.DATE = ''; R.DISB.DETAILS = ''
    CALL REDO.L.GET.DISBURSEMENT.DETAILS(REC.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)
    Y.DISBURSE.AMT = R.DISB.DETAILS<3>
    Y.DISBURSE.DATE = R.DISB.DETAILS<1>
    CHANGE @VM TO @FM IN Y.DISBURSE.DATE
    Y.DISBURSE.DATE = Y.DISBURSE.DATE<1>
RETURN

PROCESS.GROUP1:
***************
    RETURN.MSG = ''; YFLD1 = ''
    YFLD1 = Y.LAST.DAY[7,2]:Y.LAST.DAY[5,2]:Y.LAST.DAY[1,4] ;* Field 1
    FLD1 = FMT(YFLD1,'L#8')

    CONTR.DATE = ''; STRT.DATE = ''; PAY.STRT.DATE = ''; MAT.DATE = ''; Y.L.MIGRATED.LN = ''
    CONTR.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.CONTRACT.DATE>
    MAT.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE>
    Y.L.MIGRATED.LN = R.AA.PAYMENT.SCHEDULE<AA.PS.LOCAL.REF,L.MIGRATED.LN.POS>
    GOSUB GET.DISBURSE.VAL
    GOSUB GET.ACCOUNT.LIMIT
    IF Y.L.MIGRATED.LN EQ 'YES' THEN
        PAY.STRT.DATE = YL.FIRST.PAY.DATE
    END ELSE
        PAY.STRT.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.PAYMENT.START.DATE>
    END
    GOSUB GET.LOAN.TERM
    IF CONTR.DATE GT APPR.DATE THEN
        APP.DATE = CONTR.DATE
    END ELSE
        APP.DATE = APPR.DATE
    END
    IF NOT(STRT.DATE) THEN
        STRT.DATE = APPR.DATE
    END
    YFLD2 = APP.DATE[7,2]:APP.DATE[5,2]:APP.DATE[1,4]       ;* Field 2
    FLD2 = FMT(YFLD2,'L#8')
    IF NOT(Y.DISBURSE.DATE) THEN
        Y.DISBURSE.DATE = APP.DATE
    END
    YFLD3 = Y.DISBURSE.DATE[7,2]:Y.DISBURSE.DATE[5,2]:Y.DISBURSE.DATE[1,4]      ;* Field 3
    FLD3 = FMT(YFLD3,'L#8')
    YFLD4 = PAY.STRT.DATE[7,2]:PAY.STRT.DATE[5,2]:PAY.STRT.DATE[1,4]  ;* Field 4
    FLD4 = FMT(YFLD4,'L#8')
    YFLD5 = MAT.DATE[7,2]:MAT.DATE[5,2]:MAT.DATE[1,4]       ;* Field 5
    FLD5 = FMT(YFLD5,'L#8')
    STATUS.CHK = ''; YFLD8 = ''
    IF YACT.OD.STATUS1 EQ 'Restructured' THEN
        STATUS.CHK = OD.STATUS.CHK
    END
    YFLD6 = STATUS.CHK[7,2]:STATUS.CHK[5,2]:STATUS.CHK[1,4] ;* Field 6
    FLD6 = FMT(YFLD6,'L#8')

    IF ORG.MAT.DATE NE ID.COM3 THEN
        REN.DATE = ID.COM3
    END
    YFLD7 = REN.DATE[7,2]:REN.DATE[5,2]:REN.DATE[1,4]       ;* Field 7
    FLD7 = FMT(YFLD7,'L#8')
    IF YCLOSE.DATE THEN
        YFLD8 = YCLOSE.DATE[7,2]:YCLOSE.DATE[5,2]:YCLOSE.DATE[1,4]
    END
    FLD8 = FMT(YFLD8,'L#8')
    YFLD9 = TERM    ;* Field 9
    FLD9 = FMT(YFLD9,'R%6')
    YFLD10 = ADJ.TERM         ;* Field 10
    FLD10 = FMT(YFLD10,'R%6')
    CU.TIPO.CL = ''; CUS.INDUST = ''; YT.FLD3 = ''; OUT.ARR = ''
    CU.TIPO.CL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.TIPO.CL.POS>
    CUS.INDUST = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.APAP.INDUS.POS>
    YT.FLD3 = AC.ID ; YR.CUSTOMER = R.CUSTOMER
    CALL DR.REG.GET.CUST.TYPE(YR.CUSTOMER,OUT.ARR)
***FLD11 = FMT(OUT.ARR<2>,'L#30')      ;* Field 11
    FLD11 = FMT(CUS.ID,'L#30')          ;* Field 11

    FLD12 = FMT(OUT.ARR<1>,'L#2')       ;* Field 12
    FLD13 = FMT(Y.PREV.ACCOUNT,'L#30')  ;* Field 13
    CATEG.VAL = R.AA.ACCOUNT<AA.AC.CATEGORY>
    YFLD14 = ''; COLL.VALB = ''; TXNCV.POS = ''; COLL.VALB = ''
    LOCATE CATEG.VAL IN Y.TXNCR.DIS.ARR<1,1> SETTING TXNCV.POS THEN
        YFLD14 = LIM.ID
    END
    FLD14 = FMT(YFLD14,'L#30')
RETURN

PROCESS.GROUP2:
***************
* Upgrade Start 21/10/2016
    YRTN.VALUE = ''; YREC.VAL.ID = ''; INT.TERM = MAT.DATE
    YREC.VAL.ID = REC.ID:"~*":COLL.ID:"~*":R.AA.PAYMENT.SCHEDULE:"~*":YR.AA.ARR.TERM:"~*":R.AA.OVERDUE:"~*":Y.TODAY:"~*":R.AA.ACCOUNT.DETAILS
    CALL DR.REG.RIEN9.EXTRACT.SUB(YREC.VAL.ID,YRTN.VALUE)
    CRT REC.ID
    CRT YRTN.VALUE
    YTOT.BAL = ''; YTOT.BAL = YRTN.VALUE<4> + YRTN.VALUE<6>
    IF YTOT.BAL EQ 0 THEN
        YSKP.FLG = 1
        RETURN
    END

    FLD15.P = FMT(YRTN.VALUE<9>,'L#30') ;* For Principal
    FLD16 = FMT(YRTN.VALUE<3>,'L#2')    ;* Field 16
    GOSUB COLL.AMT.VAL
    FLD17 = FMT(YCOLL.VALB,'R2%15')     ;* Field 17
    GOSUB CUSTOMER.NAME.CHK
*FLD18 = FMT(CUS.NAME,'L#60')        ;* Field 18 before
    Y.CUS.NAME = ""
    FLD18 = FMT(Y.CUS.NAME,'L#60')      ;* Field 18 actually
    CRIT.VAL = ''
    GOSUB GET.CRITERIA.CODE
    FLD19 = FMT(CRIT.VAL,'L#2')         ;* Field 19
    YCURR.CLASS = ''; SET.POS = ''; BILL.POS = ''; TXNCCY.POS = ''; YFLD25 = ''
    GOSUB GET.IBR.AMT
    FLD20 = FMT(YCURR.CLAS,'L#2')       ;* Field 20
    FLD21 = FMT(YRTN.VALUE<10>,'R%5')   ;* Field 21
    LOCATE CCY.VAL IN Y.TXNMA.VAL.ARR<1,1> SETTING TXNCCY.POS THEN
        YFLD22 = Y.TXNMA.DIS.ARR<1,TXNCCY.POS>
    END
    FLD22 = FMT(YFLD22,'R%2') ;* Field 22
    GOSUB GET.RATE
    YFLD23 = EFF.RATE<1,1>    ;* Field 23
    FLD23 = FMT(YFLD23,'R2%7')
    GOSUB GET.PENT.RATE
    FLD24 = FMT(Y.PREV.DU.RTE,'R2%7')
    LOCATE YRV.FREQ IN Y.TXNFDR.VAL.ARR<1,1> SETTING TXNFDR.POS THEN
        YFLD25 = Y.TXNFDR.DIS.ARR<1,TXNFDR.POS>
    END
    FLD25 = FMT(YFLD25,'R%3')
    FLD26 = FMT(YRTN.VALUE<7>,'R2%17')  ;* Field 26
    FLD27 = FMT(R.LIMIT<LI.INTERNAL.AMOUNT>,'R2%17')        ;* Field 27
    FLD28.P = FMT(YRTN.VALUE<4>,'R2%17')          ;* Field 28
    GOSUB GET.AA.PROJ.VALS
    FLD29 = FMT(BILL.AMT,'R2%17')       ;* Use AA.SCHEDULE.PROJECTOR - Field 29
    FLD30 = FMT(YRTN.VALUE<1>,'R%3')    ;* Field 30
RETURN

PROCESS.GROUP3:
***************
    FLD31 = FMT(YRTN.VALUE<2>,'R%3')    ;* Field 31
    FLD32 = FMT(YRTN.VALUE<5>,'R2%17')  ;* Field 32
    FLD33 = FMT(YRTN.VALUE<6>,'R2%17')  ;* Field 33
    FLD34 = FMT(CUS.INDUST,'R%6')       ;* Field 34
    CAT.ID = R.AA.ACCOUNT<AA.AC.LOCAL.REF,L.AA.CATEG.POS1,1>
    R.REDO.CATEGORY.CIUU = ''; ECON.INDUST = ''; REDO.CATEGORY.CIUU.ERR = ''; YFLD37 = ''; YFLD38 = ''
    IF CAT.ID THEN
        CALL F.READ(FN.REDO.CATEGORY.CIUU,CAT.ID,R.REDO.CATEGORY.CIUU,F.REDO.CATEGORY.CIUU,REDO.CATEGORY.CIUU.ERR)
        ECON.INDUST = R.REDO.CATEGORY.CIUU<CAT.CIU.BRANCH,1>
    END
    FLD35 = FMT(ECON.INDUST,'R%6')      ;* Field 35
    GOSUB GET.CR.FAC
    FLD36 = FMT(FAC.VAL,'R%3')          ;* Field 36
    FLD37 = FMT(YCURR.CLAS,'L#5')
    FLD38 = FMT(YCURR.CLAS,'L#5')
    FLD39 = FMT(IBR.NOT.AMT,'L#5')      ;* Field 39
    FLD40 = FMT(IBR.AMT,'L#5')          ;* Field 40
    ERR.COUNTRY = ''; R.COUNTRY = ''; YFLD41 = ''
    IF YCONTY.RSK THEN
        CALL F.READ(FN.COUNTRY,YCONTY.RSK,R.COUNTRY,F.COUNTRY,COUNTRY.ERR)
        YFLD41 = R.COUNTRY<EB.COU.LOCAL.REF,L.CO.RISK.CLASS.POS>
    END
    IF YCONTY.RSK EQ 'DO' THEN
        YFLD41 = ''
    END
    FLD41 = FMT(YFLD41,'L#5')
    FLD42 = FMT(YRTN.VALUE<8>,'R2%17')  ;* Field 42
    GOSUB GET.STATUS.OPER
    FLD43 = FMT(STATUS.OPER,'R%2')      ;* Field 43
    GOSUB GET.PROV.REQ.CAP
    FLD44 = FMT(PROV.REQ.CAP,'R2%17')   ;* Field 44
    YCONTY.CDE = ''; YCONTY.CDE = R.CUSTOMER<EB.CUS.RESIDENCE>
    FLD45 = FMT(YCONTY.CDE,'L#4')       ;* Field 45
    FLD46 = FMT(R.CUSTOMER<EB.CUS.LOCAL.REF,L.LOCALIDAD.POS>,'L#6')   ;* field 46 (to be review - Byron)
    CNT.PRD = DCOUNT(R.AA.ARRANGEMENT<AA.ARR.PRODUCT>,@VM)
    FLD47 = FMT(R.AA.ARRANGEMENT<AA.ARR.PRODUCT,CNT.PRD>,'L#30')      ;* Field 47
    FLD48 = FMT(R.AA.ACCOUNT<AA.AC.LOCAL.REF,ORIGEN.RECURSOS.POS>,'L#30')       ;* Field 48
    FLD49 = FMT(R.AA.ACCOUNT<AA.AC.LOCAL.REF,L.AA.AGNCY.CODE.POS>,'L#30')       ;* Field 49
    YFLD50 = '0'    ;* Blank as per APAP - Field 50
    FLD50 = FMT(YFLD50,'L#30')
    FLD51 = FMT(INS.INST,'R2%15')       ;* Field 51
    FLD52 = FMT(INS.COMM,'R2%15')       ;* Field 52
RETURN
* Upgrade End 21/10/2016
ARRAY.FORM.P:
*************
    RETURN.MSG.P1 = ''; RETURN.MSG.P2 = ''
    RETURN.MSG.P1 = FLD1:',':FLD2:',':FLD3:',':FLD4:',':FLD5:',':FLD6:',':FLD7:',':FLD8:',':FLD9:',':FLD10:',':FLD11:',':FLD12:',':FLD13:',':FLD14:',':FLD15.P:',':FLD16:',':FLD17:',':FLD18:',':FLD19:',':FLD20:',':FLD21:',':FLD22:',':FLD23:',':FLD24:',':FLD25:',':FLD26:',':FLD27:',':FLD28.P
    RETURN.MSG.P2 = FLD29:',':FLD30:',':FLD31:',':FLD32:',':FLD33:',':FLD34:',':FLD35:',':FLD36:',':FLD37:',':FLD38:',':FLD39:',':FLD40:',':FLD41:',':FLD42:',':FLD43:',':FLD44:',':FLD45:',':FLD46:',':FLD47:',':FLD48:',':FLD49:',':FLD50:',':FLD51:',':FLD52
    RETURN.MSG.P = RETURN.MSG.P1:',':RETURN.MSG.P2
    REC.ID.P = REC.ID:'.P'
RETURN

GET.AA.PROJ.VALS:
*****************
    BILL.AMT = ''; INS.INST = ''; INS.COMM = ''; TOT.PAYMENT = ''; DUE.OUTS = ''; SIMULATION.REF = ''; NO.RESET = ''
    DUE.TYPE = ''; DUE.METHODS = ''; DUE.TYPE.AMTS = ''; DUE.PROPS = ''; DUE.PROP.AMTS = '' ; DATE.RANGE = ''
    TYFM = ''; TYSM = ''; TYVM = ''; TYPFM = ''; TYPSM = ''; TYPVM = ''; TYEFM = ''; TYESM = ''; TYEVM = ''
    Y.DUE.TYPE.51 = 'INSURANCE'; Y.DUE.TYPE.52 = 'CARGOS'; Y.DUE.PROP1 = 'ACCOUNT'

    R.REDO.AA.SCHEDULE = ''; REDO.AA.SCHEDULE.ERR = ''; Y.VAR = 0
    CALL F.READ(FN.REDO.AA.SCHEDULE,REC.ID,R.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE,REDO.AA.SCHEDULE.ERR)
    IF R.REDO.AA.SCHEDULE THEN
        TOT.PAY = RAISE(R.REDO.AA.SCHEDULE<1>)
        DUE.DAT = RAISE(R.REDO.AA.SCHEDULE<2>)
        DUE.TYPE = RAISE(R.REDO.AA.SCHEDULE<3>)
        DUE.TYPE.AMTS = RAISE(R.REDO.AA.SCHEDULE<5>)
        DUE.PRO = RAISE(R.REDO.AA.SCHEDULE<6>)
        DUE.PRO.AMT = RAISE(R.REDO.AA.SCHEDULE<7>)
        CNT.DUE.DT = DCOUNT(DUE.DAT,@FM)
        CTR.DUE.DT = 1
        GOSUB SCHDULE.LOOP
    END
RETURN

SCHDULE.LOOP:
*************
    LOOP
    WHILE CTR.DUE.DT LT CNT.DUE.DT
        IF DUE.DAT<CTR.DUE.DT> LE Y.TODAY THEN
            Y.VAR = CTR.DUE.DT
            CTR.DUE.DT += 1
            CONTINUE
        END

        FINDSTR Y.DUE.PROP1 IN DUE.PRO<CTR.DUE.DT> SETTING TYEFM,TYESM,TYEVM THEN
            BILL.AMT = TOT.PAY<CTR.DUE.DT,TYEFM>
        END
        IF BILL.AMT EQ 0 OR NOT(BILL.AMT) THEN
            FMPOS1 = ''; VMPOS1 = ''; SMPOS1 = ''
            FINDSTR 'PRINCIPALINT' IN DUE.PRO<CTR.DUE.DT> SETTING FMPOS1,VMPOS1,SMPOS1 THEN
                BILL.AMT = TOT.PAY<CTR.DUE.DT,FMPOS1>
            END
        END
        FINDSTR Y.DUE.TYPE.51 IN DUE.TYPE<CTR.DUE.DT> SETTING TYFM,TYSM,TYVM THEN
            INS.INST = DUE.TYPE.AMTS<CTR.DUE.DT,TYSM>
        END
        FINDSTR Y.DUE.TYPE.52 IN DUE.TYPE<CTR.DUE.DT> SETTING TYPFM,TYPSM,TYPVM THEN
            INS.COMM = DUE.TYPE.AMTS<CTR.DUE.DT,TYPSM>
        END
        CTR.DUE.DT = CNT.DUE.DT
    REPEAT
    IF BILL.AMT EQ 0 OR NOT(BILL.AMT) THEN
        FMPOS1 = ''; VMPOS1 = ''; SMPOS1 = ''
        FINDSTR 'ACCOUNT' IN DUE.PRO<Y.VAR> SETTING FMPOS1,VMPOS1,SMPOS1 THEN
            BILL.AMT = TOT.PAY<Y.VAR,FMPOS1>
        END
        FMPOS1 = ''; VMPOS1 = ''; SMPOS1 = ''
        FINDSTR 'PRINCIPALINT' IN DUE.PRO<Y.VAR> SETTING FMPOS1,VMPOS1,SMPOS1 THEN
            BILL.AMT = TOT.PAY<Y.VAR,FMPOS1>
        END
    END
RETURN

COLL.AMT.VAL:
*************
    COLL.CNT = ''; YCOLL.VALB = ''; YCNT = 0
    COLL.VALB = YR.AA.ARR.TERM<AA.AMT.LOCAL.REF,L.AA.AV.COL.BAL.POS>
    COLL.CNT = DCOUNT(COLL.VALB,@SM)
    LOOP
    UNTIL COLL.CNT EQ YCNT
        YCNT += 1
        YCOLL.VALB += YR.AA.ARR.TERM<AA.AMT.LOCAL.REF,L.AA.AV.COL.BAL.POS,YCNT>
    REPEAT
RETURN

CUSTOMER.NAME.CHK:
******************
    CUS.NAME = ''
    BEGIN CASE
        CASE CU.TIPO.CL EQ 'PERSONA FISICA'
            CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE CU.TIPO.CL EQ 'CLIENTE MENOR'
            CUS.NAME = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:' ':R.CUSTOMER<EB.CUS.FAMILY.NAME>
        CASE CU.TIPO.CL EQ 'PERSONA JURIDICA'
            CUS.NAME = R.CUSTOMER<EB.CUS.NAME.1,1>:' ':R.CUSTOMER<EB.CUS.NAME.2,1>
    END CASE
RETURN

GET.PROV.REQ.CAP:
*****************
    AA.POS = ''; PROV.REQ.CAP = ''
    LOCATE REC.ID IN R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.ARRANGEMENT.ID,1> SETTING AA.POS THEN
        PROV.REQ.CAP = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.PRINC,AA.POS>
    END
RETURN
*----------------------------------------------------------------------------
GET.STATUS.OPER:
****************
    STATUS.OPER = ''
    BEGIN CASE
        CASE YACT.OD.STATUS1 EQ 'JudicialCollection' AND (AA.STATUS NE 'PENDING.CLOSURE' OR AA.STATUS NE 'CLOSED')
            STATUS.OPER = 0
        CASE YACT.OD.STATUS1 EQ 'Normal' AND (AA.STATUS NE 'PENDING.CLOSURE' OR AA.STATUS NE 'CLOSED')
            STATUS.OPER = 2
        CASE YACT.OD.STATUS1 EQ 'Restructured' AND (AA.STATUS NE 'PENDING.CLOSURE' OR AA.STATUS NE 'CLOSED')
            STATUS.OPER = 3
        CASE YACT.OD.STATUS1 EQ 'Write-off' AND (AA.STATUS NE 'PENDING.CLOSURE' OR AA.STATUS NE 'CLOSED')
            STATUS.OPER = 5
        CASE (AA.STATUS NE 'PENDING.CLOSURE' OR AA.STATUS NE 'CLOSED')
            STATUS.OPER = 6
    END CASE
RETURN

GET.IBR.AMT:
***********
    RHCP.LOAN.TYPE = ''; CURR.CLS = ''; ARR.POS1 = ''; YCURR.CLAS = ''
    RHCP.LOAN.TYPE = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE>
    LOCATE YAPG.DESC IN RHCP.LOAN.TYPE<1,1> SETTING ARR.POS1 THEN
        YCURR.CLAS = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURRENT.CLASS,ARR.POS1>
        GOSUB GET.IBR.SEC.UNSEC
    END
RETURN

GET.IBR.SEC.UNSEC:
******************
    LN.POS = ''; LNC.POS = ''; IBR.NOT.AMT = ''; IBR.AMT = ''
    LOCATE YAPG.DESC IN R.REDO.H.PROVISION.PARAMETER<PROV.LOAN.TYPE,1> SETTING LN.POS THEN
        LOCATE YCURR.CLAS IN R.REDO.H.PROVISION.PARAMETER<PROV.CLASSIFICATION,LN.POS,1> SETTING LNC.POS THEN
            IBR.NOT.AMT = R.REDO.H.PROVISION.PARAMETER<PROV.UNSECUR.CLASSI,LN.POS,LNC.POS>
            IBR.AMT = R.REDO.H.PROVISION.PARAMETER<PROV.SECUR.CLASSI,LN.POS,LNC.POS>
        END
    END
RETURN

GET.CR.FAC:
**********
    FAC.VAL = ''; TXNCF.POS = ''; CR.FAC = ''
    FAC.VAL = R.AA.ACCOUNT<AA.AC.LOCAL.REF,L.CR.FACILITY.POS>
RETURN

GET.CRITERIA.CODE:
******************
    AA.MM.PYME = ''; AC.CAT = ''; CRIT.VAL = ''
    CRIT.VAL = R.CUSTOMER<EB.CUS.LOCAL.REF,L.AA.MMD.PYME.POS>
    AC.CAT = R.AA.ACCOUNT<AA.AC.CATEGORY>
RETURN

GET.RATE:
*********
    EFF.RATE = R.AA.INTEREST<AA.INT.EFFECTIVE.RATE>

    ArrangementID = REC.ID; idPropertyClass = 'INTEREST'; YRV.FREQ = ''; R.AA.INTEREST = ''
    idProperty = ''; effectiveDate = Y.LAST.DAY; returnIds = ''; returnConditions = ''; returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.INTEREST = RAISE(returnConditions)
    YRV.FREQ = R.AA.INTEREST<AA.INT.LOCAL.REF,L.AA.RT.RV.FREQ.POS>
RETURN
*
GET.PENT.RATE:
**************
    RET.COND = ''; RET.ERR = ''; Y.PREV.DU.RTE = ''; effectiveDate = Y.LAST.DAY
    CALL AA.GET.ARRANGEMENT.CONDITIONS(REC.ID,'CHARGE','PRMORA',effectiveDate,'',RET.COND,RET.ERR)
    RET.COND = RAISE(RET.COND)
    Y.PREV.DU.RTE = RET.COND<AA.CHG.CHARGE.RATE>
RETURN
*
GET.LOAN.TERM:
**************
    ORG.MAT.DATE = ''; Y.REGION = ''; Y.DAYS = 'C'; ADJ.TERM = ''; TERM = ''; COLL.ID = ''
    LOCATE 'TERM.AMOUNT' IN R.AA.PRODUCT.GROUP<AA.PG.PROPERTY.CLASS,1> SETTING PROP.POS THEN
        PROPERTY.VAL = R.AA.PRODUCT.GROUP<AA.PG.PROPERTY,PROP.POS>
    END

    REQD.MODE = ''; EFF.DATE = STAR.DATE.VAL; R.AA.ACTIVITY.HISTORY = ''; YACT.DTE.ID = ''; ID.COM3 = ''
    CALL AA.READ.ACTIVITY.HISTORY(REC.ID, REQD.MODE, EFF.DATE, R.AA.ACTIVITY.HISTORY)
    IF R.AA.ACTIVITY.HISTORY THEN
        YACT.ID.ARR = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.ID>
        GOSUB CHANGE.TERM.LOCAT
    END

    YACT.DTE.ID = ''
    LOCATE "LENDING-TAKEOVER-ARRANGEMENT" IN YACT.ID.ARR<1,1> SETTING CHG.POSN.1 THEN
        YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.DATE,CHG.POSN.1,1>
        TERM.AMT.ID = REC.ID:'-':PROPERTY.VAL:'-':YACT.DTE.ID:'.1'
        GOSUB READ.TERM.AMT
    END

    YACT.DTE.ID = ''
    LOCATE "LENDING-NEW-ARRANGEMENT" IN YACT.ID.ARR<1,1> SETTING CHG.POSN.2 THEN
        YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.DATE,CHG.POSN.2,1>
        TERM.AMT.ID = REC.ID:'-':PROPERTY.VAL:'-':YACT.DTE.ID:'.1'
        GOSUB READ.TERM.AMT
    END
    ORG.MAT.DATE = R.AA.TERM.AMOUNT<AA.AMT.MATURITY.DATE>
    COLL.ID = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,L.AA.COL.POS,1>

    IF LEN(ORG.MAT.DATE) EQ 8 AND LEN(CONTR.DATE) EQ 8 THEN
        CALL CDD(Y.REGION,ORG.MAT.DATE,CONTR.DATE,Y.DAYS)
        DIFF.DAYS = ABS(Y.DAYS)
        TERM = DROUND(DIFF.DAYS/30,0)
    END
    YA.DAYS = 'C'
    IF MAT.DATE NE ORG.MAT.DATE THEN
        CALL CDD(Y.REGION,MAT.DATE,CONTR.DATE,YA.DAYS)
        DIFF.DAY = ABS(YA.DAYS)
        ADJ.TERM = DROUND(DIFF.DAY/30,0)
    END ELSE
        ADJ.TERM = TERM
    END
RETURN

CHANGE.TERM.LOCAT:
******************
    LOCATE "LENDING-CHANGE.TERM-COMMITMENT" IN YACT.ID.ARR<1,1> SETTING CHG.POSN THEN
        YACT.DTE.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.DATE,CHG.POSN,1>
        TERM.AMT.ID = REC.ID:'-':PROPERTY.VAL:'-':YACT.DTE.ID:'.1'
        GOSUB READ.TERM.AMT
        IF NOT(R.AA.TERM.AMOUNT) THEN
            TERM.AMT.ID = REC.ID:'-':PROPERTY.VAL:'-':YACT.DTE.ID:'.2'
            GOSUB READ.TERM.AMT
        END
        ID.COM3 = YACT.DTE.ID
    END
RETURN

READ.TERM.AMT:
**************
    AA.ARR.TERM.AMOUNT.ERR = ''; R.AA.TERM.AMOUNT = ''
    CALL F.READ(FN.AA.ARR.TERM.AMOUNT,TERM.AMT.ID,R.AA.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT,AA.ARR.TERM.AMOUNT.ERR)
RETURN

INIT:
*****
    FLD1 = ''; FLD2 = ''; FLD3 = ''; FLD4 = ''; FLD5 = ''; FLD6 = '';FLD7 = '';FLD8 = ''; FLD9 = ''; FLD10 = ''; FLD11 = ''; FLD12 = ''
    FLD13 = ''; FLD14 = ''; FLD15.P = ''; YFLD15 = ''; FLD16 = ''; FLD17 = ''; FLD18 = ''; FLD19 = ''; FLD20 = ''; FLD21 = ''; FLD22 = ''; FLD23 = ''; FLD24 = ''
    FLD25 = ''; FLD26 = ''; FLD27 = '';FLD28 = ''; FLD29 = '';FLD30 = '';FLD31 = ''; FLD32 = ''; FLD33 = ''; FLD34 = ''; FLD35 = ''; FLD36 = ''
    FLD37 = ''; FLD38 = ''; FLD39 = ''; FLD49 = ''; FLD50 = ''; FLD51 = ''; FLD52 = ''; RET = 0; YCAL.TODAY = ''; FLD28.P = ''
    YCAT.TODAY = TODAY
RETURN
END
