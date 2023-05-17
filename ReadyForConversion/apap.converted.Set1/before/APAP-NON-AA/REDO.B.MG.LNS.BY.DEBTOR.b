*-----------------------------------------------------------------------------
* <Rating>-411</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.B.MG.LNS.BY.DEBTOR(Y.FINAL.ARRANGEMENT)
*-----------------------------------------------------------------------------
* Developed By            : Emmanuel James Natraj Livingston
*
* Developed On            : 03-Sep-2013
*
* Development Reference   : 786790(FS-205-DE15)
*
* Development Description : Main Process routine to fetch the required values from the LENDING Arrangement and store
*                           records in temporary directory specified in the param table REDO.H.REPORTS.PARAM.
*
* Attached To             : BATCH>BNK/REDO.B.MG.LNS.BY.DEBTOR
*
* Attached As             : COB Multithreaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
* ---------------*
* Argument#1 : Y.FINAL.ARRANGEMENT
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#2 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*    INTERNAL       Emmanuel James Natraj Livingston     24/10/2013      Delimiter Changed from "-" to "^"
*                    Krishnaveni G                       06/12/2013      current.class extraction changed
* PACS00355150           Ashokkumar.V.P                  24/02/2015      Optimized the relation between the customer.
* PACS00460184           Ashokkumar.V.P                  27/05/2015      New changes for updated mapping.
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
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
    $INSERT TAM.BP I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT TAM.BP I_REDO.GENERIC.FIELD.POS.COMMON
    $INSERT TAM.BP I_REDO.B.MG.LNS.BY.DEBTOR.COMMON
    $INSERT TAM.BP I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT TAM.BP I_F.REDO.AA.MIG.PAY.START.DTE
    $INSERT TAM.BP I_F.REDO.CAMPAIGN.TYPES
    $INSERT I_F.AA.CUSTOMER

    GOSUB INIT.VAL
    GOSUB MAIN.PROCESS
*
    RETURN
*------------
MAIN.PROCESS:
*------------
    Y.AA.ARR.ID = Y.FINAL.ARRANGEMENT
    ARR.ERR       = ""; R.ARRANGEMENT = ""
    CALL AA.GET.ARRANGEMENT(Y.AA.ARR.ID,R.ARRANGEMENT,ARR.ERR)
    IF NOT(R.ARRANGEMENT) THEN
        GOSUB RAISE.ERR.C.22
    END
    Y.MAIN.PROD.GROUP = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.MAIN.ARR.STATUS = R.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.MAIN.ARR.PRCT = R.ARRANGEMENT<AA.ARR.PRODUCT>
    YORG.CONT.DTE = R.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE>
    YSTART.DTE = R.ARRANGEMENT<AA.ARR.START.DATE>

    IF YSTART.DTE GE Y.TODAY THEN
        RETURN
    END
    IF Y.MAIN.ARR.STATUS NE 'CURRENT' AND Y.MAIN.ARR.STATUS NE 'EXPIRED' THEN
        RETURN
    END

    GOSUB L.LOAN.STATUS.1.CHK
    RETURN
*-------------------
L.LOAN.STATUS.1.CHK:
**------------------
    IF YORG.CONT.DTE THEN
        Y.ORG.CONT.DTE = YORG.CONT.DTE[7,2]:"/":YORG.CONT.DTE[5,2]:"/":YORG.CONT.DTE[1,4]
    END
    ARR.ID = Y.AA.ARR.ID
    effectiveDate = ''
    idPropertyClass = 'OVERDUE'
    idProperty = ''; returnIds = ''; returnConditions = ''; returnError = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.AA.OVERDUE = RAISE(returnConditions)
    Y.L.LOAN.STATUS.1.CHK = R.AA.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>

    IF Y.L.LOAN.STATUS.1.CHK NE "Write-off" THEN
        Y.CUSTOMER.ID = R.ARRANGEMENT<AA.ARR.CUSTOMER>
        Y.CURRENCY    = R.ARRANGEMENT<AA.ARR.CURRENCY>
        AA.ID = Y.AA.ARR.ID
        CALL REDO.B.CON.LNS.BY.DEBTOR.AA.RECS(AA.ID,OUT.RECORD)
        R.AA.TERM.AMOUNT      = FIELD(OUT.RECORD,"*",1)
        R.AA.ACCOUNT.DETAILS  = FIELD(OUT.RECORD,"*",2)
        R.AA.PAYMENT.SCHEDULE = FIELD(OUT.RECORD,"*",3)
        R.INTEREST.ACCRUALS   = FIELD(OUT.RECORD,"*",4)
        R.AA.OVERDUE          = FIELD(OUT.RECORD,"*",5)
        R.AA.LIMIT            = FIELD(OUT.RECORD,"*",6)
        R.AA.INTEREST         = FIELD(OUT.RECORD,"*",7)
        R.AA.ACCOUNT          = FIELD(OUT.RECORD,"*",8)
        R.AA.CUSTOMER         = FIELD(OUT.RECORD,"*",9)
        GOSUB MAIN.SUB.PROCESS
    END
    RETURN
*----------------
MAIN.SUB.PROCESS:
**---------------
*
    GOSUB CON.LNS.BY.DEBTOR.1
    GOSUB CON.LNS.BY.DEBTOR.2
    GOSUB CON.LNS.BY.DEBTOR.3
    GOSUB CON.LNS.BY.DEBTOR.4
    GOSUB CON.LNS.BY.DEBTOR.7
    GOSUB CON.LNS.BY.DEBTOR.8
    GOSUB CON.LNS.BY.DEBTOR.9
    GOSUB CON.LNS.TEMP.WRITE
*
    RETURN
*-------------------
CON.LNS.BY.DEBTOR.1:
**---------------------------------------------------------------------------------------------------------------------------------
* Fetching the values Debtor Identification C(15), Person Type C(2), Names / co-signer  name C(60) and Given Name / initials C(30)
*----------------------------------------------------------------------------------------------------------------------------------
    Y.PRODUCT.GROUP = ""; Y.RELATION.CODE = ""; OUT.ARR = ""; Y.REL.CODE = ''
    CALL REDO.S.REP.CUSTOMER.EXTRACT(Y.CUSTOMER.ID,Y.PRODUCT.GROUP,Y.REL.CODE,OUT.ARR)
    Y.CUST.IDEN    = OUT.ARR<1>
    Y.CUST.TYPE    = OUT.ARR<2>
    Y.CUST.NAME    = OUT.ARR<3>
    Y.CUST.GN.NAME = OUT.ARR<4>
    C$SPARE(451) = Y.CUST.IDEN
    C$SPARE(452) = Y.CUST.TYPE
    C$SPARE(453) = Y.CUST.NAME
    C$SPARE(454) = Y.CUST.GN.NAME
    Y.L.LOAN.STATUS.1 = R.AA.OVERDUE<AA.OD.LOCAL.REF,Y.L.LOAN.STATUS.1.POS>
*-----------------------------
* Fetching the Loan Code C(27)
*-----------------------------
    Y.PRODUCT.LINE  = R.ARRANGEMENT<AA.ARR.PRODUCT.LINE>
    Y.PRODUCT.GROUP = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.PROD          = R.ARRANGEMENT<AA.ARR.PRODUCT>
*
    Y.LINKED.APPL    = R.ARRANGEMENT<AA.ARR.LINKED.APPL>
    Y.LINKED.APPL.ID = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    LOCATE "ACCOUNT" IN Y.LINKED.APPL<1,1> SETTING Y.LINKED.POS THEN
        CHANGE VM TO FM IN Y.LINKED.APPL.ID
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
    C$SPARE(455) = Y.PREV.ACCOUNT
    RETURN
*-------------------
CON.LNS.BY.DEBTOR.2:
**-----------------------------------------------------------
* Fetching Disbursed Date C(10) and Disbursed Amount N(15,2):
**-----------------------------------------------------------

    IN.REC.VAL =  Y.AA.ARR.ID:"#":Y.CUSTOMER.ID:"#":Y.CURRENCY:"#":Y.L.LOAN.STATUS.1:"#":R.AA.TERM.AMOUNT:"#":R.AA.ACCOUNT.DETAILS:"#":R.AA.OVERDUE:"#":Y.LOAN.CODE
    CALL REDO.S.CON.CALC.DISB.DATE.AMT(IN.REC.VAL,OUT.REC.VAL)
*
    Y.DISBURSE.DATE.DIS =  FIELD(OUT.REC.VAL,"#",1)
    Y.DISBURSE.AMT  =  FIELD(OUT.REC.VAL,"#",2)
    Y.COMP.CODE =  FIELD(OUT.REC.VAL,"#",3)
    Y.RESTRUCT.DATE.DIS =  FIELD(OUT.REC.VAL,"#",4)
    Y.RENEWAL.DATE.DIS =  FIELD(OUT.REC.VAL,"#",5)
    Y.EARLY.PAY.OFF =  FIELD(OUT.REC.VAL,"#",6)
    Y.MG.TOT.COMMIT = FIELD(OUT.REC.VAL,"#",7)
*
    C$SPARE(456) = Y.DISBURSE.DATE.DIS
    C$SPARE(457) =  Y.DISBURSE.AMT
    C$SPARE(468) = Y.COMP.CODE
    C$SPARE(469) = Y.RESTRUCT.DATE.DIS
    C$SPARE(470) = Y.RENEWAL.DATE.DIS
    C$SPARE(471) = Y.TXNEYPO.VAL.ARR
    RETURN

CON.LNS.BY.DEBTOR.3:
*-------------------
* Fetching Maturity Date C(10), First Payment Date C(10), Bill Amount  N(10,2), Rate N(6,2), Currency Type C(1) and Judicial collection C(1):
    GOSUB GET.MAT.DATE
    GOSUB GET.FST.PAY.DATE
*    GOSUB GET.PAY.CHK
    GOSUB GET.PAY.CHK.1
    GOSUB GET.RATE.CCY
    GOSUB GET.JUD.COLL
    RETURN

GET.MAT.DATE:
*-----------
    Y.AA.MATURITY.DATE.DIS = ''
    Y.AA.MATURITY.DATE = ''
    Y.AA.MATURITY.DATE = R.AA.TERM.AMOUNT<AA.AMT.MATURITY.DATE>
    IF Y.AA.MATURITY.DATE THEN
        Y.AA.MATURITY.DATE.DIS = Y.AA.MATURITY.DATE[7,2]:"/":Y.AA.MATURITY.DATE[5,2]:"/":Y.AA.MATURITY.DATE[1,4]
    END
    C$SPARE(458)       = Y.AA.MATURITY.DATE.DIS
    RETURN
GET.FST.PAY.DATE:
*---------------
    ERR.REDO.AA.MIG.PAY.START.DTE = ''; R.REDO.AA.MIG.PAY.START.DTE = ''; YL.FIRST.PAY.DATE = ''
    CALL F.READ(FN.REDO.AA.MIG.PAY.START.DTE,Y.AA.ARR.ID,R.REDO.AA.MIG.PAY.START.DTE,F.REDO.AA.MIG.PAY.START.DTE,ERR.REDO.AA.MIG.PAY.START.DTE)
    IF R.REDO.AA.MIG.PAY.START.DTE THEN
        YL.FIRST.PAY.DATE = R.REDO.AA.MIG.PAY.START.DTE<REDO.AA.MPSD.FIRST.PAY.DATE>
    END
    Y.FIRST.PAY.DATE = ''; Y.FIRST.PAY.DATE.DIS = ''; Y.L.FIRST.PAYMENT = ''; Y.L.MIGRATED.LN = ''
    Y.L.MIGRATED.LN = R.AA.PAYMENT.SCHEDULE<AA.PS.LOCAL.REF,L.MIGRATED.LN.POS>
    IF Y.L.MIGRATED.LN EQ 'YES' THEN
        Y.FIRST.PAY.DATE = YL.FIRST.PAY.DATE
        C$SPARE(456) = Y.ORG.CONT.DTE
        C$SPARE(457) = Y.MG.TOT.COMMIT
    END ELSE
        Y.FIRST.PAY.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.PAYMENT.START.DATE>
    END

    IF LEN(Y.FIRST.PAY.DATE) EQ 8 THEN
        Y.FIRST.PAY.DATE.DIS = Y.FIRST.PAY.DATE[7,2]:"/":Y.FIRST.PAY.DATE[5,2]:"/":Y.FIRST.PAY.DATE[1,4]
    END
    C$SPARE(459)     = Y.FIRST.PAY.DATE.DIS
    Y.PAYMENT.TYPE = '' ;Y.ACTUAL.AMT = '';Y.CALC.AMT = '' ;
    Y.ACTUAL.AMT.1 = '' ;Y.CALC.AMT.1 ='' ; Y.BILL.AMT = ''
    Y.PAYMENT.TYPE = R.AA.PAYMENT.SCHEDULE<AA.PS.PAYMENT.TYPE>
    Y.ACTUAL.AMT   = R.AA.PAYMENT.SCHEDULE<AA.PS.ACTUAL.AMT>
    Y.CALC.AMT     = R.AA.PAYMENT.SCHEDULE<AA.PS.CALC.AMOUNT>
    RETURN

GET.PAY.CHK:
*----------
    LOCATE "CONSTANTE" IN Y.PAYMENT.TYPE<1,1> SETTING PAY.TYPE.POS.1 THEN
        Y.ACTUAL.AMT.1 = Y.ACTUAL.AMT<1,PAY.TYPE.POS.1>
        Y.CALC.AMT.1   = Y.CALC.AMT<1,PAY.TYPE.POS.1>
        IF Y.CALC.AMT.1 THEN
            Y.BILL.AMT = Y.CALC.AMT.1
        END ELSE
            Y.BILL.AMT = Y.ACTUAL.AMT.1
        END
    END
    GOSUB CHK.BILL.AMT.1
    RETURN
CHK.BILL.AMT.1:
*-------------
    IF NOT(Y.BILL.AMT) THEN
        LOCATE "LINEAR" IN Y.PAYMENT.TYPE<1,1> SETTING PAY.TYPE.POS.2 THEN
            Y.ACTUAL.AMT.2 = Y.ACTUAL.AMT<1,PAY.TYPE.POS.2>
            Y.CALC.AMT.2   = Y.CALC.AMT<1,PAY.TYPE.POS.2>
            IF Y.CALC.AMT.2 THEN
                Y.BILL.AMT = Y.CALC.AMT.2
            END ELSE
                Y.BILL.AMT = Y.ACTUAL.AMT.2
            END
        END
    END
    RETURN
GET.PAY.CHK.1:
*-----------
    Y.DCNT.EB.PAY = DCOUNT(Y.AA.PAY.TYPE,VM)
    Y.DCNT.DEB = '1'
    Y.PAY.AMT = ''
    Y.BILL.AMT = ''
    GOSUB BILL.AMT.CHK
    GOSUB BILL.AMT.CHK.1
    C$SPARE(460) = Y.BILL.AMT
    RETURN
BILL.AMT.CHK:
*-----------
    LOOP
    WHILE Y.DCNT.DEB LE Y.DCNT.EB.PAY
        Y.EB.PAY.VAL = Y.AA.PAY.TYPE<1,Y.DCNT.DEB>
        Y.PAY.AMT = ''
        LOCATE Y.EB.PAY.VAL IN Y.PAYMENT.TYPE<1,1> SETTING Y.POS.CN THEN
            Y.BILL.AMT = R.AA.PAYMENT.SCHEDULE<AA.PS.ACTUAL.AMT,Y.POS.CN>
            IF NOT(Y.BILL.AMT) THEN
                Y.BILL.AMT = R.AA.PAYMENT.SCHEDULE<AA.PS.CALC.AMOUNT,Y.POS.CN>
            END
        END
        IF Y.BILL.AMT THEN
            Y.DCNT.DEB = Y.DCNT.EB.PAY
        END
        Y.DCNT.DEB += '1'
    REPEAT
    RETURN
BILL.AMT.CHK.1:
*--------------
    IF NOT(Y.BILL.AMT) THEN
        Y.ACC.PAY.TYPE.DCNT = DCOUNT(Y.AA.PAY.TYPE.I,VM)
        Y.ACC.PAY.TYPE.STA = '1'
        LOOP
        WHILE Y.ACC.PAY.TYPE.STA LE Y.ACC.PAY.TYPE.DCNT
            Y.ACC.PAY.TYPE.I.VAL = Y.AA.PAY.TYPE.I<1,Y.ACC.PAY.TYPE.STA>
            GOSUB CHK.PAY.TYPE.BILL
            Y.ACC.PAY.TYPE.STA += '1'
        REPEAT
    END
    RETURN
CHK.PAY.TYPE.BILL:
*----------------
    LOCATE Y.ACC.PAY.TYPE.I.VAL IN Y.PAYMENT.TYPE<1,1> SETTING Y.POS.LN THEN
        Y.BILL.AMT = R.AA.PAYMENT.SCHEDULE<AA.PS.CALC.AMOUNT,Y.POS.LN>
        IF NOT(Y.BILL.AMT) THEN
            Y.BILL.AMT = R.AA.PAYMENT.SCHEDULE<AA.PS.ACTUAL.AMT,Y.POS.LN>
        END
    END
    IF Y.BILL.AMT THEN
        Y.ACC.PAY.TYPE.STA = Y.ACC.PAY.TYPE.DCNT
    END
    RETURN

GET.RATE.CCY:
*-----------
    Y.CURR.TYPE = '' ;Y.AA.RATE = ''
    Y.AA.RATE    = R.INTEREST.ACCRUALS<AA.INT.ACC.RATE,1,1>
    C$SPARE(461) = Y.AA.RATE
    IF Y.CURRENCY EQ LCCY THEN
        Y.CURR.TYPE = "N"
    END ELSE
        Y.CURR.TYPE = "E"
    END
    C$SPARE(462) = Y.CURR.TYPE
    RETURN
GET.JUD.COLL:
*-----------
    Y.JUD.COLL = ''
    IF Y.L.LOAN.STATUS.1 EQ "JudicialCollection" THEN
        Y.JUD.COLL = "S"
    END ELSE
        Y.JUD.COLL = "N"
    END
    C$SPARE(463) = Y.JUD.COLL
    RETURN
*-------------------
CON.LNS.BY.DEBTOR.4:

**------------------------------------------------------------------------------------------------------------------------------------
* Fetching Debtor Risk Clasification C(2), Principal Provision Required N(15,2), Vinculation Type C(2), Location C(6) and Branch N(5):
**------------------------------------------------------------------------------------------------------------------------------------
    REDO.H.CUSTOMER.PROVISIONING.ERR = ""
    R.REDO.H.CUSTOMER.PROVISIONING   = ""
    CALL F.READ(FN.REDO.H.CUSTOMER.PROVISIONING,Y.CUSTOMER.ID,R.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING,REDO.H.CUSTOMER.PROVISIONING.ERR)
    IF R.REDO.H.CUSTOMER.PROVISIONING THEN
        Y.LOAN.TYPE          = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE>
        Y.NEW.ARRANGEMENT.ID = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.ARRANGEMENT.ID>
        Y.CURR.CLASS         = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURRENT.CLASS>
        Y.PROV.PRINC         = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.PRINC>
        Y.PROV.INTR = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.INTEREST>

* (S) 20131206
        LOCATE "MORTGAGE" IN Y.LOAN.TYPE<1,1> SETTING LOAN.POS THEN
            Y.DEBT.RISK.CLASS = Y.CURR.CLASS<1,LOAN.POS>
        END
* (E) 20131206
        LOCATE Y.AA.ARR.ID IN Y.NEW.ARRANGEMENT.ID<1,1> SETTING ARR.POS THEN
            Y.PRINCI.PROV = Y.PROV.PRINC<1,ARR.POS>
            Y.INT.PROV.REQ    = Y.PROV.INTR<1,ARR.POS>
        END
    END
    C$SPARE(464) = Y.DEBT.RISK.CLASS
    C$SPARE(465) = Y.PRINCI.PROV
    C$SPARE(473) = Y.PRINCI.PROV
    C$SPARE(474) = Y.INT.PROV.REQ
    GOSUB GET.RLN.CODE
    RETURN
GET.RLN.CODE:
*-----------
    CUSTOMER.ERR = ""
    R.CUSTOMER   = ""
    Y.FIRST.VAL  = "1"
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.RELATION.CODE = R.CUSTOMER<EB.CUS.RELATION.CODE>
    Y.DCNT.RLN = DCOUNT(Y.RELATION.CODE,VM)
    Y.STA.RLN = '1'
    Y.VINC.TYPE = ''
    LOOP
    WHILE Y.STA.RLN LE Y.DCNT.RLN
        Y.REL.CODE      = Y.RELATION.CODE<1,Y.STA.RLN>
        LOCATE Y.REL.CODE IN Y.VINCATION.DATA.NAME<1> SETTING VINC.POS THEN
            Y.VINC.TYPE = Y.VINCATION.DATA.VAL<VINC.POS>
        END
        IF Y.VINC.TYPE THEN
            Y.STA.RLN = Y.DCNT.RLN
        END
        Y.STA.RLN += 1
    REPEAT
    IF NOT(Y.VINC.TYPE) THEN
        Y.VINC.TYPE = 'NI'
    END
    C$SPARE(466) = Y.VINC.TYPE
    Y.L.LOCALIDAD = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.LOCALIDAD.POS>
    Y.LOCATION    = Y.L.LOCALIDAD
    C$SPARE(467)  = Y.LOCATION
    RETURN
READ.SCHU.ACT:
*------------
    AA.SCH.ACT.ERR          = ""
    R.AA.SCHEDULED.ACTIVITY = ""
    CALL F.READ(FN.AA.SCHEDULED.ACTIVITY,Y.AA.ARR.ID,R.AA.SCHEDULED.ACTIVITY,F.AA.SCHEDULED.ACTIVITY,AA.SCH.ACT.ERR)
    Y.INT.ACTIVITY  = R.AA.SCHEDULED.ACTIVITY<AA.SCH.ACTIVITY.NAME>
    Y.INT.LAST.DATE = R.AA.SCHEDULED.ACTIVITY<AA.SCH.LAST.DATE>
    Y.INT.NEXT.DATE = R.AA.SCHEDULED.ACTIVITY<AA.SCH.NEXT.DATE>
    CHANGE VM TO FM IN Y.INT.ACTIVITY
    CHANGE VM TO FM IN Y.INT.LAST.DATE
    CHANGE VM TO FM IN Y.INT.NEXT.DATE
    RETURN
*-------------------
CON.LNS.BY.DEBTOR.7:
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Fetching Penalty Porcentage Early Payoff N(6,2), Constituted Principal Provision N(15,2) and Interest Provision Required N(15,2) and Contingent Provision Required N(15,2):
**---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*    GOSUB PENALTY.PERCENTAGE
*    GOSUB PENALTY.PERCENTAGE.1
    C$SPARE(472) = Y.TXNEYPOP.VAL.ARR
    RETURN

PENALTY.PERCENTAGE.1:
*-------------------
    Y.CHG.RATE = ''
    Y.CHARGE.PROP = 'PRCANCANTIC'
    EFF.DATE = ''
    PROP.CLASS='CHARGE'
    PROPERTY = Y.CHARGE.PROP
    R.CONDITION = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.AA.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    Y.CHG.RATE = R.CONDITION<AA.CHG.LOCAL.REF,Y.L.AA.CHG.RATE.POS>
*    C$SPARE(472) = Y.CHG.RATE
    RETURN
*
PENALTY.PERCENTAGE:
*-----------------
    Y.DCNT.PEN = DCOUNT(Y.ACT.CHG.PRTY,VM)
    Y.STA.DCNT = '1'
    Y.CHG.RATE = ''
    LOOP
    WHILE Y.STA.DCNT LE Y.DCNT.PEN
        Y.PRTY.ACT = Y.ACT.CHG.PRTY<1,Y.STA.DCNT>
        Y.PRD.CAT.CHG = Y.MAIN.ARR.PRCT:"-":Y.PRTY.ACT
        GOSUB CHK.ACT.CHARGES
        Y.STA.DCNT += 1
    REPEAT
*    C$SPARE(472) = Y.CHG.RATE
    RETURN
CHK.ACT.CHARGES:
*-------------
    FINDSTR Y.PRD.CAT.CHG IN Y.AA.PRD.CAT.ACTIVITY.CHARGES SETTING Y.CAT.CHG.POS THEN
        Y.AA.PRD.CAT.CHG.ID = Y.AA.PRD.CAT.ACTIVITY.CHARGES<Y.CAT.CHG.POS>
        IF Y.AA.PRD.CAT.CHG.ID THEN
            CALL F.READ(FN.AA.PRD.CAT.ACTIVITY.CHARGES,Y.AA.PRD.CAT.CHG.ID,R.AA.PRD.CAT.ACTIVITY.CHARGES,F.AA.PRD.CAT.ACTIVITY.CHARGES,AA.PRD.CAT.ERR)
            IF R.AA.PRD.CAT.ACTIVITY.CHARGES THEN
                GOSUB READ.AA.ACT.CG
            END
        END
    END
    RETURN
READ.AA.ACT.CG:
*-------------
    Y.ACTIVITY.CHG = R.AA.PRD.CAT.ACTIVITY.CHARGES<AA.ACT.CHG.ACTIVITY.ID>
    LOCATE "LENDING-APPLYPAYMENT-RP.PAYOFF" IN Y.ACTIVITY.CHG<1,1> SETTING Y.ACT.POS THEN
        Y.PRP.CHARGE = R.AA.PRD.CAT.ACTIVITY.CHARGES<AA.ACT.CHG.CHARGE,Y.ACT.POS>
    END
    Y.DCNT.PRP.CHG = DCOUNT(Y.PRP.CHARGE,SM)
    Y.STA.CHG = '1'
    GOSUB CHK.PROD.CHG
    RETURN
CHK.PROD.CHG:
*------------
    LOOP
    WHILE Y.STA.CHG LE Y.DCNT.PRP.CHG
        Y.PRP.CHARGE.VAL = Y.PRP.CHARGE<1,1,Y.STA.CHG>
        Y.PRD.CHG.ID = Y.MAIN.ARR.PRCT:'-':Y.PRP.CHARGE.VAL
        FINDSTR Y.PRD.CHG.ID IN Y.AA.PRD.CAT.CHARGE SETTING Y.POS.CHG THEN
            Y.AA.CHARGE.ID = Y.AA.PRD.CAT.CHARGE<Y.POS.CHG>
            CALL F.READ(FN.AA.PRD.CAT.CHARGE,Y.AA.CHARGE.ID,R.AA.PRD.CAT.CHARGE,F.AA.PRD.CAT.CHARGE,AA.PRD.CAT.ERR)
            GOSUB CALC.CAT.CHG.RATE
            IF Y.CHG.RATE THEN
                Y.STA.CHG = Y.DCNT.PRP.CHG
            END
            Y.STA.CHG += 1
        END
    REPEAT
    RETURN
CALC.CAT.CHG.RATE:
*-----------------
    IF R.AA.PRD.CAT.CHARGE THEN
        Y.CHG.RATE = ''
        Y.CHG.RATE = R.AA.PRD.CAT.CHARGE<AA.CHG.CHARGE.RATE>
        IF NOT(Y.CHG.RATE) THEN
            Y.CHG.RATE = R.AA.PRD.CAT.CHARGE<AA.CHG.LOCAL.REF,Y.L.AA.CHG.RATE.POS>
        END
    END
    RETURN
CON.LNS.BY.DEBTOR.8:
*------------------
    GOSUB GET.REVIEW.INIT.RATE
    GOSUB PAY.DATE.EXTRA.BILL
    RETURN
GET.REVIEW.INIT.RATE:
*-------------------
    Y.L.AA.REV.RT.TY = R.AA.INTEREST<AA.INT.LOCAL.REF,Y.L.AA.REV.RT.TY.POS>
    IF Y.L.AA.REV.RT.TY EQ "PERIODICO" THEN
        Y.L.AA.NXT.REV.DT = R.AA.INTEREST<AA.INT.LOCAL.REF,Y.L.AA.NXT.REV.DT.POS>
        Y.REVIEW.DATE.INT.RATE = Y.L.AA.NXT.REV.DT
    END
    Y.REVIEW.DATE.INT.RATE.DIS = ''
    IF Y.REVIEW.DATE.INT.RATE THEN
        Y.REVIEW.DATE.INT.RATE.DIS =  Y.REVIEW.DATE.INT.RATE[7,2]:"/":Y.REVIEW.DATE.INT.RATE[5,2]:"/":Y.REVIEW.DATE.INT.RATE[1,4]
    END
    C$SPARE(475) = Y.REVIEW.DATE.INT.RATE.DIS
    RETURN

PAY.DATE.EXTRA.BILL:
*-----------------
    Y.PAMENT.DATE.EXTRA.BILL = ''
    Y.PROPERTY.NAME = Y.AA.LINEAS.PAY.SCH
    IF Y.PROPERTY.NAME THEN
*        Y.PAMENT.PROP = Y.ACTIVITY.PROPERTY<PAMENT.DATE.POS>
        Y.PRODUCT = Y.MAIN.ARR.PRCT
        Y.PRODUCT.ID = Y.PRODUCT:'-'
        FINDSTR Y.PRODUCT.ID IN SEL.LIST.3 SETTING Y.POS.PRST THEN
            Y.ID.DESIGN = SEL.LIST.3<Y.POS.PRST>
            CALL F.READ(FN.AA.PRODUCT.DESIGNER,Y.ID.DESIGN,R.AA.PRODUCT.DESIGNER,F.AA.PRODUCT.DESIGNER,AA.PRDT.DESIGN)
            Y.PRD.PROPERTY = R.AA.PRODUCT.DESIGNER<AA.PRD.PRD.PROPERTY>
            CHANGE VM TO FM IN Y.PRD.PROPERTY
            IF NOT(Y.PRD.PROPERTY) THEN
                Y.PAMENT.DATE.EXTRA.BILL = ""
            END ELSE
*                GOSUB PROD.DESIGNER.CHK
                GOSUB PAMENT.EXTRA.BILL.CHK
            END
        END
    END
    Y.PAMENT.DATE.EXTRA.BILL.DIS = ''
    IF Y.PAMENT.DATE.EXTRA.BILL THEN
        Y.PAMENT.DATE.EXTRA.BILL.DIS = Y.PAMENT.DATE.EXTRA.BILL[7,2]:"/":Y.PAMENT.DATE.EXTRA.BILL[5,2]:"/":Y.PAMENT.DATE.EXTRA.BILL[1,4]
    END
    C$SPARE(476) = Y.PAMENT.DATE.EXTRA.BILL.DIS
    RETURN
PROD.DESIGNER.CHK:
**----------------
    LOCATE "CUOTAS.SOLO.INT.Y.CAP.PROGRAMADO" IN Y.PRD.PROPERTY<1> SETTING Y.PROP.1.POS THEN
        Y.PROP.FLAG.1 = "1"
    END ELSE
        LOCATE "CUOTA.NIVELADA.Y.CAP.PROG" IN Y.PRD.PROPERTY<1> SETTING Y.PROP.2.POS THEN
            Y.PROP.FLAG.2 = "1"
        END
    END
    RETURN
PAMENT.EXTRA.BILL.CHK:
**--------------------
    GOSUB READ.SCHU.ACT
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

CON.LNS.BY.DEBTOR.9:
*------------------
    GOSUB GET.NEXT.PAY.AMT
    GOSUB GET.RESTRUCT.TYPE
    Y.L.TIP.CLI     = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.TIP.CLI.POS>
    Y.CUSTOMER.TYPE = Y.L.TIP.CLI
    C$SPARE(479)    = Y.CUSTOMER.TYPE

    Y.ORIGEN.RECURSOS = ''; Y.CREDIT.FACILITY = ''; YOPER.TYPE = ''
    YL.AA.CAMP.TY = ''; YCAMP.SHRTNME = ''
*    Y.L.CR.FACILITY   = R.AA.TERM.AMOUNT<AA.AMT.LOCAL.REF,Y.L.CR.FACILITY.POS>
    Y.CREDIT.FACILITY   = R.AA.ACCOUNT<AA.AC.LOCAL.REF,L.CR.FACILITY.POS>
    C$SPARE(480)      = Y.CREDIT.FACILITY

    LOCATE Y.L.AA.REV.RT.TY IN Y.TXNTDT.VAL.ARR<1,1> SETTING TXNTE.POS THEN
        YOPER.TYPE = Y.TXNTDT.DIS.ARR<1,TXNTE.POS>
    END
    C$SPARE(481) = YOPER.TYPE

    Y.ORIGEN.RECURSOS = R.AA.ACCOUNT<AA.AC.LOCAL.REF,L.ORIGEN.RECURSOS.POS>
    C$SPARE(482)      = Y.ORIGEN.RECURSOS
    YL.AA.CAMP.TY = R.AA.CUSTOMER<AA.CUS.LOCAL.REF,L.AA.CAMP.TY.POS>
    ERR.REDO.CAMPAIGN.TYPES = ''; R.REDO.CAMPAIGN.TYPES = ''
    CALL F.READ(FN.REDO.CAMPAIGN.TYPES,YL.AA.CAMP.TY,R.REDO.CAMPAIGN.TYPES,F.REDO.CAMPAIGN.TYPES,ERR.REDO.CAMPAIGN.TYPES)
    IF R.REDO.CAMPAIGN.TYPES THEN
        YCAMP.SHRTNME = R.REDO.CAMPAIGN.TYPES<CG.TYP.CAM.SHORT.DESC>
    END
    C$SPARE(483)      = YCAMP.SHRTNME
    RETURN

GET.NEXT.PAY.AMT:
*---------------
    IF Y.NEXT.DATE THEN
        Y.ACTUAL.AMT.1 = Y.ACTUAL.AMT<1,PAY.TYPE.POS.1>
        Y.CALC.AMT.1   = Y.CALC.AMT<1,PAY.TYPE.POS.1>
        LOCATE "SOLO.CAPITAL" IN Y.PAYMENT.TYPE<1,1> SETTING Y.CAP.POS THEN
            Y.ACTUAL.AMT.1 = Y.ACTUAL.AMT<1,Y.CAP.POS>
            Y.CALC.AMT.1   = Y.CALC.AMT<1,Y.CAP.POS>
            Y.CAPPROG.FLAG = "1"
        END ELSE
            LOCATE "CAPPROG" IN Y.PAYMENT.TYPE<1,1> SETTING Y.SOLO.POS THEN
                Y.ACTUAL.AMT.1 = Y.ACTUAL.AMT<1,Y.SOLO.POS>
                Y.CALC.AMT.1   = Y.CALC.AMT<1,Y.SOLO.POS>
                Y.SOLO.CAP.FLAG = "1"
            END
        END
        GOSUB SOLO.CHK.CAP
    END
    C$SPARE(477) = Y.PAMENT.AMT
    RETURN
SOLO.CHK.CAP:
*-----------
    IF Y.CAPPROG.FLAG EQ "1" OR Y.SOLO.CAP.FLAG EQ "1" THEN
        IF Y.CALC.AMT.1 NE "" THEN
            Y.PAMENT.AMT =  Y.CALC.AMT.1
        END ELSE
            Y.PAMENT.AMT = Y.ACTUAL.AMT.1
        END
    END
    RETURN
GET.RESTRUCT.TYPE:
*------------------
    IF Y.L.LOAN.STATUS.1 EQ "Restructured" THEN
        Y.L.RESTRUCT.TYPE = R.AA.OVERDUE<AA.OD.LOCAL.REF,Y.L.RESTRUCT.TYPE.POS>
        Y.RESTRUCT.TYPE   = Y.L.RESTRUCT.TYPE
    END ELSE
        Y.RESTRUCT.TYPE = "NR"
    END
    C$SPARE(478) = Y.RESTRUCT.TYPE
    RETURN
CON.LNS.TEMP.WRITE:
*------------------
    RCL.ID  = Y.RCL.ID
    MAP.FMT = "MAP"
    APP     = FN.AA.ARRANGEMENT
    R.APP   = R.ARRANGEMENT
    CALL RAD.CONDUIT.LINEAR.TRANSLATION (MAP.FMT,RCL.ID,APP,Y.AA.ARR.ID,R.APP,R.RETURN.MSG,ERR.MSG)
    IF Y.DISBURSE.AMT EQ "" THEN
        Y.DISBURSE.AMT = "0"
    END


*                 1                 2                3           4                 5                 6                             7               8                       9                       10               11             12               13                14              15               16             17               18                         19                     20                 21            22                 23                 24                       25                      26                           27                   28                  29                 30
*    Y.ARR<-1> = Y.CUST.IDEN:"*":Y.CUST.TYPE:"*":Y.CUST.NAME:"*":Y.CUST.GN.NAME:"*":Y.LOAN.CODE:"*":Y.DISBURSE.DATE.DIS:"*":Y.DISBURSE.AMT:"*":Y.AA.MATURITY.DATE.DIS:"*":Y.FIRST.PAY.DATE.DIS:"*":Y.BILL.AMT:"*":Y.AA.RATE:"*":Y.CURR.TYPE:"*":Y.JUD.COLL:"*":Y.DEBT.RISK.CLASS:"*":Y.PRINCI.PROV:"*":Y.VINC.TYPE:"*":Y.LOCATION:"*":Y.COMP.CODE:"*":Y.RESTRUCT.DATE.DIS:"*":Y.RENEWAL.DATE.DIS:"*":Y.EARLY.PAY.OFF:"*":Y.CHG.RATE:"*":Y.PRINCI.PROV:"*":Y.INT.PROV.REQ:"*":Y.REVIEW.DATE.INT.RATE.DIS:"*":Y.PAMENT.DATE.EXTRA.BILL.DIS:"*":Y.PAMENT.AMT:"*":Y.RESTRUCT.TYPE:"*":Y.CUSTOMER.TYPE:"*":Y.CREDIT.FACILITY

*---------------Delimiter Changed from "-" to "*"-----------------***
    Y.CONSUMO.REC = FMT(Y.DISBURSE.AMT,'R2#23'):"^":R.RETURN.MSG
*---------------Delimiter Changed from "-" to "*"-----------------***
    IF Y.CONSUMO.REC THEN
        WRITESEQ Y.CONSUMO.REC APPEND TO Y$.SEQFILE.PTR ELSE
            Y.ERR.MSG = "Unable to Write '":Y.OUT.FILE.NAME:"'"
            GOSUB RAISE.ERR.C.22
            RETURN
        END
    END
    RETURN
AA.ARR.TERM.AMT.READ:
**-------------------
    AA.TERM.AMT.ERR   = ""
    R.AA.ARR.TERM.AMT = ""
    CALL F.READ(FN.AA.ARR.TERM.AMOUNT,Y.AA.TERM.AMT.REC,R.AA.ARR.TERM.AMT,F.AA.ARR.TERM.AMOUNT,AA.TERM.AMT.ERR)
    RETURN
RAISE.ERR.C.22:
*--------------
*Handling error process
    MON.TP    = "13"
    REC.CON   = "DE13-":Y.AA.ARR.ID:Y.ERR.MSG
    DESC      = "DE13-":Y.AA.ARR.ID:Y.ERR.MSG
    INT.CODE  = 'REP001'
    INT.TYPE  = 'ONLINE'
    BAT.NO    = ''
    BAT.TOT   = ''
    INFO.OR   = ''
    INFO.DE   = ''
    ID.PROC   = ''
    EX.USER   = ''
    EX.PC     = ''
    CALL REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,REC.CON,EX.USER,EX.PC)
    RETURN

INIT.VAL:
*********
    C$SPARE(451) = ''; C$SPARE(452) = ''; C$SPARE(453) = ''; C$SPARE(454) = ''; C$SPARE(455) = ''
    C$SPARE(456) = ''; C$SPARE(457) = ''; C$SPARE(458) = ''; C$SPARE(459) = ''; C$SPARE(460) = ''
    C$SPARE(461) = ''; C$SPARE(462) = ''; C$SPARE(463) = ''; C$SPARE(464) = ''; C$SPARE(465) = ''
    C$SPARE(466) = ''; C$SPARE(467) = ''; C$SPARE(468) = ''; C$SPARE(469) = ''; C$SPARE(470) = ''
    C$SPARE(471) = ''; C$SPARE(472) = ''; C$SPARE(473) = ''; C$SPARE(474) = ''; C$SPARE(475) = ''
    C$SPARE(476) = ''; C$SPARE(477) = ''; C$SPARE(478) = ''; C$SPARE(479) = ''; C$SPARE(480) = ''
    C$SPARE(481) = ''; C$SPARE(482) = ''; C$SPARE(483) = ''
    RETURN
END
