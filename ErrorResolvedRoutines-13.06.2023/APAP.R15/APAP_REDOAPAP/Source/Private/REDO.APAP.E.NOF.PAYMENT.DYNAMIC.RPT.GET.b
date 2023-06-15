* @ValidationCode : MjoxNTY4MzY3NTg4OkNwMTI1MjoxNjg2Njc1MDU3ODk2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 13 Jun 2023 22:20:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.NOF.PAYMENT.DYNAMIC.RPT.GET(Y.PROCESSED.IDS, Y.OUT.ARRAY)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : T.Jeeva, Temenos Application Management
*Program   Name    : REDO.APAP.E.NOF.PAYMENT.DYNAMIC.RPT.GET
*ODR Reference     : ODR-2010-03-0183
*--------------------------------------------------------------------------------------------------------
*Description  :REDO.APAP.E.NOF.PAYMENT.DYNAMIC.RPT.GET is a mainline routine called within the routine
*              REDO.APAP.E.NOF.PAYMENT.DYNAMIC.RPT, the routine fetches the record details required to
*              display in the enquiry
*In Parameter : Y.PROCESSED.IDS
*Out Parameter: Y.OUT.ARRAY
*--------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* Modification History:
*
* Date             Who                   Reference      Description
* 18.05.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, VM TO @VM, SM TO @SM, = TO EQ, ++ TO += 1, -- TO -= 1
* 18.05.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.OFFICERS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.EB.LOOKUP
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.HISTORY
    
    $USING APAP.AA
    $USING APAP.TAM


    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------
OPEN.FILES:
*---------------------------------------------------------------------------
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS  = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.EB.LOOKUP = 'F.EB.LOOKUP'
    F.EB.LOOKUP  = ''
    CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY  = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AAA  = ''
    CALL OPF(FN.AAA,F.AAA)

    FN.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS = 'F.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS'
    F.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS  = ''
    CALL OPF(FN.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,F.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS)


    LOC.REF.APPLICATION   = "AA.PRD.DES.CUSTOMER":@FM:"ACCOUNT":@FM:"AA.PRD.DES.OVERDUE":@FM:"AA.PRD.DES.PAYMENT.SCHEDULE":@FM:"CUSTOMER"
    LOC.REF.FIELDS        = 'L.AA.AFF.COM':@VM:'L.AA.CAMP.TY':@FM:'L.OD.STATUS':@VM:'L.AC.STATUS1':@VM:'L.AC.STATUS2':@FM:'L.LOAN.STATUS.1':@FM:'L.AA.DEBT.AC':@FM:'L.CU.TEL.AREA':@VM:'L.CU.TEL.NO'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.AFF.COM      = LOC.REF.POS<1,1>
    POS.L.AA.CAMP.TY      = LOC.REF.POS<1,2>
    POS.L.OD.STATUS       = LOC.REF.POS<2,1>
    POS.L.AC.STATUS1      = LOC.REF.POS<2,2>
    POS.L.AC.STATUS2      = LOC.REF.POS<2,3>
    POS.L.LOAN.STATUS.1   = LOC.REF.POS<3,1>
    POS.L.AA.DEBT.AC      = LOC.REF.POS<4,1>
    POS.L.CU.TEL.AREA     = LOC.REF.POS<5,1>
    POS.L.CU.TEL.NO       = LOC.REF.POS<5,2>

RETURN
*---------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------


    GOSUB GET.DELAY.BILL.SELECTION
    Y.AA.IDS.CNT =  DCOUNT(Y.PROCESSED.IDS,@FM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.AA.IDS.CNT
        Y.FLAG = 0
        Y.AA.ID = Y.PROCESSED.IDS<Y.VAR2>
        IF MOD(Y.VAR2,25) EQ 0 THEN                        ;** R22 Auto conversion - = TO EQ
            CALL OCOMO("Processed the ids - ":Y.VAR2:"/":Y.AA.IDS.CNT)
        END
        IF Y.DELAY.BILL.FIELD THEN
            GOSUB DO.DELAYED.BILL.SELECTION
        END ELSE
            CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACT.ERR)
            Y.FLAG = 1
        END
        IF Y.FLAG EQ 1 THEN
            GOSUB GET.FORM.ARRAY
        END

        Y.VAR2 += 1          ;** R22 Auto conversion - ++ TO += 1
    REPEAT


RETURN
*---------------------------------------------------------------------------
GET.DELAY.BILL.SELECTION:
*---------------------------------------------------------------------------
    Y.DELAY.BILL.FIELD = ''
    LOCATE 'DELAYED.BILLS.CNT' IN D.FIELDS<1> SETTING POS1 THEN
        Y.DELAY.BILL.FIELD    = D.FIELDS<POS1>
        Y.DELAY.BILL.VALUE    = D.RANGE.AND.VALUE<POS1>
        Y.DELAY.BILL.OPERATOR = D.LOGICAL.OPERANDS<POS1>
    END

RETURN
*---------------------------------------------------------------------------
DO.DELAYED.BILL.SELECTION:
*---------------------------------------------------------------------------
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACT.ERR)
    Y.SETTLE.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    CHANGE @SM TO @FM IN Y.SETTLE.STATUS
    CHANGE @VM TO @FM IN Y.SETTLE.STATUS
    Y.UNPAID.BILL.CNT = COUNT(Y.SETTLE.STATUS,"UNPAID")
    BEGIN CASE
        CASE Y.DELAY.BILL.OPERATOR EQ '3'
            IF Y.UNPAID.BILL.CNT LT Y.DELAY.BILL.VALUE THEN
                Y.FLAG = 1
            END
        CASE Y.DELAY.BILL.OPERATOR EQ '8'
            IF Y.UNPAID.BILL.CNT LE Y.DELAY.BILL.VALUE THEN
                Y.FLAG = 1
            END
        CASE Y.DELAY.BILL.OPERATOR EQ '1'
            IF Y.UNPAID.BILL.CNT EQ Y.DELAY.BILL.VALUE THEN
                Y.FLAG = 1
            END
        CASE Y.DELAY.BILL.OPERATOR EQ '4'
            IF Y.UNPAID.BILL.CNT GT Y.DELAY.BILL.VALUE THEN
                Y.FLAG = 1
            END
        CASE Y.DELAY.BILL.OPERATOR EQ '9'
            IF Y.UNPAID.BILL.CNT GE Y.DELAY.BILL.VALUE THEN
                Y.FLAG = 1
            END
    END CASE

RETURN
*------------------------------------------------------------------
GET.FORM.ARRAY:
*------------------------------------------------------------------
    GOSUB GET.ARRANGEMENT.DETAILS
    GOSUB GET.CUSTOMER.DETAILS
    GOSUB GET.REPAYMENT.DETAILS
    GOSUB GET.OVERDUE.DETAILS
    GOSUB GET.OUTSTANDING.BALANCE
*Y.OUT.ARRAY<-1> := Y.PORT.TYPE:'*':Y.PROD.TYPE:'*':Y.REGION:'*':Y.CAMP.TYPE:'*':Y.AFF.COMP:'*':Y.LOAN.ORG.AGE:'*':Y.LOAN.NO:'*':Y.PREV.LOAN.NO:'*':Y.CLIENT.NAMES:'*':Y.LOAN.OPEN.DATE:'*':Y.DOM.DATE:'*':Y.USER.DOM:'*':Y.Q.DUE.DATE:'*':Y.LOAN.Q.VALUE:'*':Y.STO.ACC:'*':Y.PREV.ACCT.NO:'*':Y.LOAN.STATUS:'*':Y.LOAN.O.STATUS:'*':Y.ACC.STATUS:'*':Y.OPEN.BALACNE:'*':Y.ORG.LOAN.AMT:'*':Y.CLIENT.PHONE:'*':Y.TOTAL.UNPAID.BILLS.FOR.ARR
    Y.OUT.ARRAY<-1> := Y.PRODUCT.GROUP:'*':Y.PRODUCT:'*':Y.REGION:'*':Y.CAMP.TYPE:'*':Y.AFF.COMP:'*':Y.CO.CODE:'*':Y.LOAN.ACC:'*':Y.PREVIOUS.LOAN.NO:'*':Y.OWNER.NAMES:'*':Y.START.DATE:'*':Y.DOM.DATE:'*':Y.DOM.USER:'*':Y.DUE.DATE:'*':Y.NEXT.PAY.AMT:'*':Y.DIRECT.DB.ACC:'*':Y.DD.ACC.PREVIOUS.NO:'*':Y.LOAN.STATUS:'*':Y.ARR.STATUS:'*':Y.ACC.STATUS.FIN:'*':Y.TOTAL.AMT:'*':Y.DISB.AMOUNT:'*':Y.CLIENT.PHONE:'*':Y.UNPAID.BILLS.CNT:'*':Y.AGING.STATUS

RETURN
*------------------------------------------------------------------
GET.ARRANGEMENT.DETAILS:
*------------------------------------------------------------------

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    Y.PRODUCT.GROUP = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    Y.PRODUCT       = R.AA.ARRANGEMENT<AA.ARR.PRODUCT,1>
    Y.CO.CODE       = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
    IF R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE> THEN       ;* Incase of migrated loan.
        Y.START.DATE    = R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE>
    END ELSE
        Y.START.DATE    = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
    END
    Y.ARR.STATUS    = "AA.ARR.STATUS#":R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>

    GOSUB GET.DOM.DETAILS

*Y.DUE.DATE      = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.DATE>
*CHANGE SM TO VM IN Y.DUE.DATE

    Y.LOAN.ACC      = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    CALL F.READ(FN.ACCOUNT,Y.LOAN.ACC,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.ACC.OFFICER      = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    Y.PREVIOUS.LOAN.NO = R.ACCOUNT<AC.ALT.ACCT.ID,1>
    Y.LEN = LEN(Y.ACC.OFFICER)
    IF Y.LEN GE 8 THEN
        Y.REGION = Y.ACC.OFFICER[Y.LEN-7,2]
    END ELSE
        Y.REGION = ''
    END
    CUSTOMER.ID = R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,CUSTOMER.ID,R.CUSTOMER,F.CUSTOMER,Y.CUS.ERR)
    Y.CLIENT.PHONE = CATS(R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.AREA>,R.CUSTOMER<EB.CUS.LOCAL.REF,POS.L.CU.TEL.NO>)
RETURN
*------------------------------------------------------------------
GET.CUSTOMER.DETAILS:
*------------------------------------------------------------------

    EFF.DATE        = ''
    PROP.CLASS      = 'CUSTOMER'
    PROPERTY        = ''
    R.CONDITION.CUS = ''
    ERR.MSG         = ''
*CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CUS,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CUS,ERR.MSG)   ;** R22 Manual conversion
    Y.CAMP.TYPE = R.CONDITION.CUS<AA.CUS.LOCAL.REF,POS.L.AA.CAMP.TY>
    Y.AFF.COMP  = R.CONDITION.CUS<AA.CUS.LOCAL.REF,POS.L.AA.AFF.COM>
    Y.PRIM.OWNERS   = R.CONDITION.CUS<AA.CUS.CUSTOMER>:@VM:R.CONDITION.CUS<AA.CUS.OTHER.PARTY>
    Y.OWNER.NAMES   = ''
    Y.OWNER.CNT     = DCOUNT(Y.PRIM.OWNERS,@VM)
    Y.PROCESSED.CUS = ''
    Y.OWN.CNT       = 1
    LOOP
    WHILE Y.OWN.CNT LE Y.OWNER.CNT
        Y.CUS.ID = Y.PRIM.OWNERS<1,Y.OWN.CNT>
        IF Y.CUS.ID THEN

            LOCATE Y.CUS.ID IN Y.PROCESSED.CUS<1> SETTING POS.CUS ELSE
                Y.PROCESSED.CUS<-1> = Y.CUS.ID
                CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
                IF R.CUSTOMER<EB.CUS.SHORT.NAME,1> THEN
                    Y.OWNER.NAMES<1,-1> = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
                END
            END
        END
        Y.OWN.CNT += 1             ;** R22 Auto conversion - ++ TO += 1
    REPEAT
RETURN
*------------------------------------------------------------------------------
GET.REPAYMENT.DETAILS:
*------------------------------------------------------------------------------
    Y.ACC.STATUS.FIN     = ''
    Y.DD.ACC.PREVIOUS.NO = ''
    Y.NEXT.PAY.AMT       = ''
*CALL REDO.GET.NEXT.PAYMENT.AMOUNT.OLD(Y.AA.ID,"",Y.NEXT.PAY.AMT)
    APAP.TAM.redoGetNextPaymentAmountOld(Y.AA.ID,"",Y.NEXT.PAY.AMT) ;** R22 Manual conversion

    EFF.DATE        = ''
    PROP.CLASS      = 'PAYMENT.SCHEDULE'
    PROPERTY        = ''
    R.CONDITION.PAYSCH = ''
    ERR.MSG = ''
*CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.PAYSCH,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.PAYSCH,ERR.MSG)   ;** R22 Manual conversion
    Y.DIRECT.DB.ACC = R.CONDITION.PAYSCH<AA.PS.LOCAL.REF,POS.L.AA.DEBT.AC>
    IF Y.DIRECT.DB.ACC THEN
        CALL F.READ(FN.ACCOUNT,Y.DIRECT.DB.ACC,R.DD.ACC,F.ACCOUNT,ACC.ERR)
        Y.DD.ACC.PREVIOUS.NO = R.DD.ACC<AC.ALT.ACCT.ID,1>

        Y.ACC.STATUS1 = R.DD.ACC<AC.LOCAL.REF,POS.L.AC.STATUS1>
        Y.ACC.STATUS2 = R.DD.ACC<AC.LOCAL.REF,POS.L.AC.STATUS2>
        CHANGE @SM TO @VM IN Y.ACC.STATUS2
        Y.LOOKUP.ID   = 'L.AC.STATUS1*'
        Y.ACC.STATUS  = Y.ACC.STATUS1
        GOSUB GET.ACC.STATUS.DESB
        Y.ACC.STATUS.FIN  = Y.ACC.STATUS.DESB
        Y.LOOKUP.ID   = 'L.AC.STATUS2*'
        Y.ACC.STATUS  = Y.ACC.STATUS2
        GOSUB GET.ACC.STATUS.DESB
        Y.ACC.STATUS.FIN<1,-1>  = Y.ACC.STATUS.DESB


    END
RETURN
*------------------------------------------------------------
GET.ACC.STATUS.DESB:
*------------------------------------------------------------
    Y.ACC.STATUS.DESB = ''
    Y.ACC.STATUS.CNT = DCOUNT(Y.ACC.STATUS,@VM)
    Y.ACC.ST = 1
    LOOP
    WHILE Y.ACC.ST LE Y.ACC.STATUS.CNT
        Y.LOOKID = Y.LOOKUP.ID:Y.ACC.STATUS<1,Y.ACC.ST>
        CALL F.READ(FN.EB.LOOKUP,Y.LOOKID,R.EB.LOOKUP,F.EB.LOOKUP,LOOK.ERR)
        IF R.EB.LOOKUP THEN
            IF R.EB.LOOKUP<EB.LU.DESCRIPTION,LNGG> THEN
                Y.ACC.STATUS.DESB<1,-1> = R.EB.LOOKUP<EB.LU.DESCRIPTION,LNGG>
            END ELSE
                Y.ACC.STATUS.DESB<1,-1> =  R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
            END
        END

        Y.ACC.ST += 1               ;** R22 Auto conversion - ++ TO += 1
    REPEAT

RETURN
*------------------------------------------------------------
GET.OVERDUE.DETAILS:
*------------------------------------------------------------
    Y.LOAN.STATUS  = ''
    Y.AGING.STATUS = ''
    EFF.DATE    = ''
    PROP.CLASS  = 'OVERDUE'
    PROPERTY    = ''
    R.CONDITION.OVERDUE = ''
    ERR.MSG     = ''
*CALL REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)    ;** R22 Manual conversion
    Y.LOAN.STATUS.AA = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1>

    Y.LN.STATUS.ID = 'L.LOAN.STATUS.1*':Y.LOAN.STATUS.AA
    R.EB.LOOKUP = ''
    CALL F.READ(FN.EB.LOOKUP,Y.LN.STATUS.ID,R.EB.LOOKUP,F.EB.LOOKUP,LOOK.ERR)
    IF R.EB.LOOKUP THEN
        IF R.EB.LOOKUP<EB.LU.DESCRIPTION,LNGG> THEN
            Y.LOAN.STATUS = R.EB.LOOKUP<EB.LU.DESCRIPTION,LNGG>
        END ELSE
            Y.LOAN.STATUS =  R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
        END
    END
    Y.LOAN.AGING.STATUS = R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS>
    Y.LN.AGING.ID       = 'AA.OVERDUE.STATUS*':Y.LOAN.AGING.STATUS
    R.EB.LOOKUP = ''
    CALL F.READ(FN.EB.LOOKUP,Y.LN.AGING.ID,R.EB.LOOKUP,F.EB.LOOKUP,LOOK.ERR)
    IF R.EB.LOOKUP THEN
        IF R.EB.LOOKUP<EB.LU.DESCRIPTION,LNGG> THEN
            Y.AGING.STATUS = R.EB.LOOKUP<EB.LU.DESCRIPTION,LNGG>
        END ELSE
            Y.AGING.STATUS = R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
        END
    END

RETURN
*------------------------------------------------------
GET.OUTSTANDING.BALANCE:
*------------------------------------------------------
    RET.ERROR          = ''
    Y.DISB.AMOUNT      = ''
    Y.TOTAL.AMT        = ''
    Y.UNPAID.BILLS.CNT = ''
    Y.DUE.DATE         = ''
    Y.BILLS.REFERENCES = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.SET.STATUS       = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    Y.BILL.TYPE        = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>
    CHANGE @SM TO @FM IN Y.BILLS.REFERENCES
    CHANGE @VM TO @FM IN Y.BILLS.REFERENCES
    CHANGE @SM TO @FM IN Y.SET.STATUS
    CHANGE @VM TO @FM IN Y.SET.STATUS
    CHANGE @SM TO @FM IN Y.BILL.TYPE
    CHANGE @VM TO @FM IN Y.BILL.TYPE

    Y.BILLS.CNT = DCOUNT(Y.BILLS.REFERENCES,@FM)
    Y.BILL.VAR = 1
    LOOP
    WHILE Y.BILL.VAR LE Y.BILLS.CNT
        IF Y.SET.STATUS<Y.BILL.VAR> EQ 'UNPAID' THEN
            Y.BILL.ID = Y.BILLS.REFERENCES<Y.BILL.VAR>
            BILL.DETAILS = ''
            CALL AA.GET.BILL.DETAILS(Y.AA.ID, Y.BILL.ID, BILL.DETAILS, RET.ERROR)
            IF Y.BILL.TYPE<Y.BILL.VAR> EQ 'PAYMENT' AND Y.DUE.DATE EQ '' THEN         ;* Oldest unpaid payment bill date.
                Y.DUE.DATE = BILL.DETAILS<AA.BD.PAYMENT.DATE>
            END
            Y.TOTAL.AMT += SUM(BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
            Y.UNPAID.BILLS.CNT += 1
        END
        Y.BILL.VAR += 1                   ;** R22 Auto conversion - ++ TO += 1
    REPEAT

*CALL REDO.GET.DISBURSEMENT.DETAILS(Y.AA.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)
    APAP.TAM.redoGetDisbursementDetails(Y.AA.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)      ;** R22 Manual conversion
    Y.DISB.AMOUNT = Y.COMMITED.AMT
RETURN
*------------------------------------------------------
GET.DOM.DETAILS:
*------------------------------------------------------
* Here we will get Domiliciation details.

    CALL F.READ(FN.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,Y.AA.ID,R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,F.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS,CNCT.ERR)
    IF R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS THEN
        GOSUB GET.DOM.USER.CNCT
    END ELSE
        GOSUB GET.DOM.USER
    END

RETURN
*------------------------------------------------------
GET.DOM.USER.CNCT:
*------------------------------------------------------
    Y.DOM.DATE      =  ""
    Y.DOM.USER      =  ""

    Y.DOM.CNT = DCOUNT(R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<1>,@VM)

    LOOP
    WHILE Y.DOM.CNT GE 1
        Y.AAAA.ID = R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<1,Y.DOM.CNT>
        CALL F.READ(FN.AAA,Y.AAAA.ID,R.AAAA,F.AAA,AAA.ERR)
        IF R.AAAA THEN
            Y.DOM.DATE      = R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<2,Y.DOM.CNT>
            Y.DOM.USER      = R.REDO.DIRECT.DEBIT.ACCOUNTS.DETAILS<3,Y.DOM.CNT>
            Y.DOM.CNT = 0 ;* Break
        END
        Y.DOM.CNT -= 1                 ;** R22 Auto conversion - -- TO -= 1
    REPEAT

    IF Y.DOM.DATE ELSE
        GOSUB GET.DOM.USER
    END

RETURN
*------------------------------------------------------
GET.DOM.USER:
*------------------------------------------------------
    Y.DOM.DATE      = R.AA.ACCOUNT.DETAILS<AA.AD.VALUE.DATE>
    Y.DOM.USER      = ''
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ACT.ERR)
    FINDSTR 'LENDING-NEW-ARRANGEMENT' IN R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY> SETTING POS.AF,POS.AV,POS.AS THEN
        Y.AAA.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,POS.AV,POS.AS>
        CALL F.READ(FN.AAA,Y.AAA.ID,R.AAA,F.AAA,AAA.ERR)
        Y.DOM.USER = FIELD(R.AAA<AA.ARR.ACT.INPUTTER>,'_',2)
    END ELSE
        FINDSTR 'LENDING-TAKEOVER-ARRANGEMENT' IN R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY> SETTING POS.AF,POS.AV,POS.AS THEN
            Y.AAA.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,POS.AV,POS.AS>
            CALL F.READ(FN.AAA,Y.AAA.ID,R.AAA,F.AAA,AAA.ERR)
            Y.DOM.USER = FIELD(R.AAA<AA.ARR.ACT.INPUTTER>,'_',2)
        END
    END
RETURN
END
