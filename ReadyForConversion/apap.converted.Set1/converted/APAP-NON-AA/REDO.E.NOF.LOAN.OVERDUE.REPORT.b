SUBROUTINE REDO.E.NOF.LOAN.OVERDUE.REPORT(Y.OUT.DATA)
*----------------------------------------------------------------------------------------
*Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By  : Temenos Application Management
*Program Name  : REDO.E.NOF.LOAN.OVERDUE.REPORT
*----------------------------------------------------------------------------------------
*Description   : REDO.E.NOF.LOAN.OVERDUE.REPORT is a no-file enquiry routine for the
* enquiry REDO.APAP.NOF.LOAN.OVERDUE.RPT, the routine based on the
* selection criteria selects the records from respective files and displays the processed records
*Linked With   : Enquiry REDO.OVERDUE.LOAN.REPORT.ONLINE
*In Parameter  : N/A
*Out Parameter : Y.OUT.DATA
*----------------------------------------------------------------------------------------
* Modification History :
*   Date             Who                  Reference               Description
*----------------------------------------------------------------------------------------
*  12th Nov 2010     Bharath G            ODR-2010-03-0123        Initial Creation
*
*  06th Apr 2011     Ravikiran AV            HD1100277            The selection criteria now refers an template REDO.OVERDUE.STATUS
*                                                                 to fetch the values
* 28-APR-2011      H GANESH           CR009              Change the Vetting value of local field
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.REDO.OVERDUE.STATUS
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
*----------------------------------------------------------------------------------------
MAIN.LOGIC:

    GOSUB INITIALIZE
    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.REF.POS
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------------------------
INITIALIZE:
*----------------------------------------------------------------------------------------
    SEL.CMD.ARR        = ''     ; Y.CAMPAIGN.TYPE   = ''   ; SEL.LIST         = '' ;
    Y.LOAN.STATUS.VAL  = ''     ; Y.LOAN.ORG.AGENCY = ''   ; Y.PERIOD.DELAY   = '' ;
    Y.PRODUCT.TYPE     = ''     ; Y.DATE.REPORT     = ''   ; Y.OVERDUE.FEE    = '' ;
    Y.CAMPAIGN.TYPE    = ''     ; SEL.LIST.ARR      = ''   ; SEL.LIST.ACC     = '' ;
    SEL.LIST.CUS       = ''     ; SEL.LIST.OVR      = ''   ; SEL.CMD.ACC      = '' ;
    SEL.CMD.CUS        = ''     ; SEL.CMD.OVR       = ''   ; Y.OUT.DATA       = '' ;Y.PERIOD.DELAY1 = ''
RETURN
*----------------------------------------------------------------------------------------
NULLIFY:
*----------------------------------------------------------------------------------------
    X.LOAN.BOOK.TYPE = ''             ; X.LOAN.PRODUCT.TYPE = ''        ; X.CAMPAIGN = ''                 ;
    X.LOAN.SOURCE.AGENCY = ''         ; X.LOAN.NUMBER = ''              ; X.PREVIOUS.LOAN.NUMBER = ''     ;
    X.CLIENT.NAME = ''                ; X.CLIENTS.ID.NUMBER = ''        ; X.CLIENT.TELEPHONE = ''         ;
    X.LOAN.STATUS = ''                ; X.LOAN.CONDITION = ''           ; X.PERIOD.OF.DELAY = ''          ;
    X.CURRENCY = ''                   ; X.INTEREST.RATE = ''            ; X.OVERDUE.BILLS.AMOUNT = ''     ;
    X.LAST.PAYMENT.DATE = ''          ; X.LAST.PAYMENT.VALUE = ''       ; X.PROVISION.BALANCE = ''        ;
    X.DISBURSEMENT.AMOUNT = ''        ; X.CAPITAL.BALANCE.DELAY = ''    ; X.INTEREST.DEFAULT.BALANCE = '' ;
    X.TOTAL.BALANCE.DUE = ''          ; X.INSURANCE.DEFAULT.BALANCE = ''; X.CHARGE.DEFAULT.BALANCE = ''   ;
    X.TOTAL.DEFAULT.BALANCE = ''      ; Y.EFFECTIVE.DATE = ''           ; Y.TXN.AMOUNT = ''               ;
    Y.DISB.AMT = 0                    ; Y.PROV.PRINC = 0                ; Y.PROV.INTEREST = 0             ;
    Y.PROV.RESTRUCT = 0               ; Y.PROV.FX = 0                   ; Y.DATA = ''                     ;
    Y.LOAN.STATUS = Y.LOAN.STATUS.VAL ; Y.OWNER = ''                    ; Y.PRIMARY.OWNER = ''            ;
RETURN
*----------------------------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------------------------
    FN.AA.ARRANGEMENT     = "F.AA.ARRANGEMENT"   ; FN.CUSTOMER           = "F.CUSTOMER"                 ; FN.ACCT.ACTIVITY = 'F.ACCT.ACTIVITY'
    F.AA.ARRANGEMENT      = ''                   ; F.CUSTOMER            = ''                           ; F.ACCT.ACTIVITY  = ''
    R.AA.ARRANGEMENT      = ''                   ; R.CUSTOMER            = ''                           ; R.ACCT.ACTIVITY  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT) ; CALL OPF(FN.CUSTOMER,F.CUSTOMER)                     ; CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)
*
    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"       ; FN.AA.ACCOUNT.DETAILS = "F.AA.ACCOUNT.DETAILS"       ; FN.AA.BILL.DETAILS = "F.AA.BILL.DETAILS"
    F.AA.ARRANGEMENT  = ''                       ; F.AA.ACCOUNT.DETAILS  = ''                           ; F.AA.BILL.DETAILS  = ''
    R.AA.ARRANGEMENT  = ''                       ; R.AA.ACCOUNT.DETAILS  = ''                           ; R.AA.BILL.DETAILS  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT) ; CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS) ; CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
*
    FN.AA.PROPERTY = 'F.AA.PROPERTY'             ; FN.ALTERNATE.ACCOUNT = 'F.ALTERNATE.ACCOUNT'         ; FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.AA.PROPERTY = ''                           ; F.ALTERNATE.ACCOUNT  = ''                            ; F.EB.CONTRACT.BALANCES  = ''
    R.AA.PROPERTY = ''                           ; R.ALTERNATE.ACCOUNT  = ''                            ; R.EB.CONTRACT.BALANCES  = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)       ; CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)   ; CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)
*
    FN.AA.ARRANGEMENT.ACTIVITY = "F.AA.ARRANGEMENT.ACTIVITY"       ; FN.AA.ACTIVITY.HISTORY  = "F.AA.ACTIVITY.HISTORY"
    F.AA.ARRANGEMENT.ACTIVITY  = ''                                ; F.AA.ACTIVITY.HISTORY   = ''
    R.AA.ARRANGEMENT.ACTIVITY  = ''                                ; R.AA.ACTIVITY.HISTORY   = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY) ; CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
*
    FN.AA.INTEREST.ACCRUALS = 'F.AA.INTEREST.ACCRUALS'             ; FN.REDO.H.CUSTOMER.PROVISIONING = 'F.REDO.H.CUSTOMER.PROVISIONING'
    F.AA.INTEREST.ACCRUALS  = ''                                   ; F.REDO.H.CUSTOMER.PROVISIONING = ''
    R.AA.INTEREST.ACCRUALS  = ''                                   ; R.REDO.H.CUSTOMER.PROVISIONING = ''
    CALL OPF(FN.AA.INTEREST.ACCRUALS, F.AA.INTEREST.ACCRUALS)      ; CALL OPF(FN.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING)

    FN.BASIC.INTEREST = 'F.BASIC.INTEREST'                         ; FN.PROP.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'
    F.BASIC.INTEREST = ''                                          ; F.PROP.PARAM = ''
    R.BASIC.INTEREST = ''                                          ; CALL OPF(FN.PROP.PARAM,F.PROP.PARAM)
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)
RETURN
*----------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------
    GOSUB GET.SELECTION.FIELDS.VALUES
    GOSUB GET.DETAILS
RETURN
*----------------------------------------------------------------------------------------
GET.SELECTION.FIELDS.VALUES:
*----------------------------------------------------------------------------------------

    SEL.CMD.ARR = "SELECT ":FN.AA.ARRANGEMENT:" WITH @ID NE ''"
    LOCATE "LOAN.PORTFOLIO" IN D.FIELDS<1> SETTING Y.LOAN.PORTFOLIO.POS THEN
        Y.LOAN.PORTFOLIO = D.RANGE.AND.VALUE<Y.LOAN.PORTFOLIO.POS>
        SEL.CMD.ARR := " AND PRODUCT.GROUP EQ ":Y.LOAN.PORTFOLIO
    END
    LOCATE "LOAN.STATUS" IN D.FIELDS<1> SETTING Y.LOAN.STATUS.POS THEN
        Y.LOAN.STATUS.VAL = D.RANGE.AND.VALUE<Y.LOAN.STATUS.POS>
        Y.LOAN.STATUS.VAL = CHANGE(Y.LOAN.STATUS.VAL,@SM," ")
    END
    LOCATE "PRODUCT.TYPE" IN D.FIELDS<1> SETTING Y.PRODUCT.TYPE.POS THEN
        Y.PRODUCT.TYPE = D.RANGE.AND.VALUE<Y.PRODUCT.TYPE.POS>
        SEL.CMD.ARR := " AND PRODUCT EQ ":Y.PRODUCT.TYPE
    END
    LOCATE "LOAN.ORG.AGENCY" IN D.FIELDS<1> SETTING Y.LOAN.ORG.AGENCY.POS THEN
        Y.LOAN.ORG.AGENCY = D.RANGE.AND.VALUE<Y.LOAN.ORG.AGENCY.POS>
        SEL.CMD.ARR := " AND CO.CODE EQ ":Y.LOAN.ORG.AGENCY
    END
    LOCATE "PERIOD.DELAY" IN D.FIELDS<1> SETTING Y.PERIOD.DELAY.POS THEN
        Y.PERIOD.DELAY1     = D.RANGE.AND.VALUE<Y.PERIOD.DELAY.POS>
    END
    LOCATE "DATE.REPORT" IN D.FIELDS<1> SETTING Y.DATE.REPORT.POS THEN
        Y.DATE.REPORT = D.RANGE.AND.VALUE<Y.DATE.REPORT.POS>
    END
    LOCATE "OVERDUE.FEE" IN D.FIELDS<1> SETTING Y.OVERDUE.FEE.POS THEN
        Y.OVERDUE.FEE = D.RANGE.AND.VALUE<Y.OVERDUE.FEE.POS>
    END
    LOCATE "CAMPAIGN.TYPE" IN D.FIELDS<1> SETTING Y.CAMPAIGN.TYPE.POS THEN
        Y.CAMPAIGN.TYPE = D.RANGE.AND.VALUE<Y.CAMPAIGN.TYPE.POS>
    END
RETURN
*----------------------------------------------------------------------------------------
GET.DETAILS:
*----------------------------------------------------------------------------------------
    CALL EB.READLIST(SEL.CMD.ARR,SEL.LIST.ARR.ID,'',NO.OF.REC.ARR,SEL.RET.ARR)
    IF NOT(SEL.LIST.ARR.ID) THEN
        RETURN
    END
    LOOP
        REMOVE Y.AA.ID FROM SEL.LIST.ARR.ID SETTING Y.AA.ARR.POS
    WHILE Y.AA.ID:Y.AA.ARR.POS

        GOSUB ALL.DETAILS
    REPEAT
RETURN
*----------------------------------------------------------------------------------------
ACCOUNT.CALSS:
*----------------------------------------------------------------------------------------
    idPropertyClass = 'ACCOUNT'
    idProperty = ''
    GOSUB GET.ARR.CONDITION   ;* For AA.ARR.ACCOUNT
    Y.AA.ARR.ACCOUNT = R.CONDITION
    X.PREVIOUS.LOAN.NUMBER = Y.AA.ARR.ACCOUNT<AA.AC.ALT.ID>
    IF X.LOAN.SOURCE.AGENCY NE Y.LOAN.ORG.AGENCY AND Y.LOAN.ORG.AGENCY NE '' THEN
        RETURN
    END
RETURN
*----------------------------------------------------------------------------------------
CUSTOMER.CLASS:
*----------------------------------------------------------------------------------------
    idPropertyClass = 'CUSTOMER'        ;* For AA.ARR.CUSTOMER
    idProperty = ''
    GOSUB GET.ARR.CONDITION
    Y.AA.ARR.CUSTOMER = R.CONDITION
    X.CAMPAIGN = Y.AA.ARR.CUSTOMER<AA.CUS.LOCAL.REF><1,LOC.L.AA.CAMP.TY.POS>
    GOSUB GET.AA.ARR.CUSTOMER.DETAILS
    IF X.CAMPAIGN NE Y.CAMPAIGN.TYPE AND Y.CAMPAIGN.TYPE NE '' THEN   ;* Selection Criteria "Campaign"
        RETURN
    END
RETURN
*----------------------------------------------------------------------------------------
OVERDU.CLASS:
*----------------------------------------------------------------------------------------
    idPropertyClass = 'OVERDUE'         ;* For AA.ARR.OVERDUE
    idProperty = ''
    GOSUB GET.ARR.CONDITION
    Y.AA.ARR.OVERDUE = R.CONDITION
    X.LOAN.CONDITION = Y.AA.ARR.OVERDUE<AA.OD.LOCAL.REF><1,LOC.L.LOAN.COND.POS>
    X.LOAN.STATUS    = Y.AA.ARR.OVERDUE<AA.OD.LOCAL.REF><1,LOC.L.LOAN.STATUS.1.POS>
    IF Y.PERIOD.DELAY EQ "Judicial Collection" OR Y.PERIOD.DELAY EQ "Restructured" OR Y.PERIOD.DELAY EQ "Write-off" THEN
        IF Y.PERIOD.DELAY EQ X.LOAN.STATUS ELSE
            Y.ERR.FLAG = '1'
        END
    END
    IF Y.LOAN.STATUS EQ 'Judicial Collection' OR Y.LOAN.STATUS EQ 'Restructured' OR Y.LOAN.STATUS EQ 'Write-off' THEN
        LOCATE Y.LOAN.STATUS IN X.LOAN.STATUS<1,1,1> SETTING Y.LOAN.POS ELSE
            RETURN
        END
    END
    Y.ARR.AGE.STATUS = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,E.AA.ACCOUNT.DETAILS)
    Y.ARR.AGE.STATUS =  R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
    IF Y.ARR.AGE.STATUS EQ 'CUR' OR Y.ARR.AGE.STATUS EQ '' THEN
        RETURN
    END
RETURN
*------------------------------------------------------------------------------------------
CASE.SEL:
*------------------------------------------------------------------------------------------
    BEGIN CASE
        CASE Y.LOAN.STATUS EQ 'Current 0-30 Days'
            Y.LOAN.STATUS = 'GRC'
        CASE Y.LOAN.STATUS EQ 'Overdue 31-90 Days'
            Y.LOAN.STATUS = 'DEL'
        CASE Y.LOAN.STATUS EQ 'Overdue more 90 Days'
            Y.LOAN.STATUS = 'NAB'
    END CASE
RETURN
*------------------------------------------------------------------------------------------
LOAN.STATUS.VAL.SEL:
*------------------------------------------------------------------------------------------
    IF Y.LOAN.STATUS EQ '' OR Y.LOAN.STATUS EQ 'Judicial Collection' OR Y.LOAN.STATUS EQ 'Restructured' OR Y.LOAN.STATUS EQ 'Write-off' ELSE
        LOCATE Y.LOAN.STATUS IN Y.ARR.LOAN.STATUS SETTING POS.LOAN ELSE
            RETURN
        END
        LOCATE Y.LOAN.STATUS IN Y.ARR.AGE.STATUS SETTING LN.POS.STAT ELSE
            RETURN
        END
    END
RETURN
*------------------------------------------------------------------------------------------
ALL.DETAILS:
*------------------------------------------------------------------------------------------


    GOSUB NULLIFY
    GOSUB GET.LOAN.STATUS     ;* HD1100277
    GOSUB GET.ARRANGEMENT.DETAILS
    GOSUB ACCOUNT.CALSS
    GOSUB CUSTOMER.CLASS
    GOSUB OVERDU.CLASS
    Y.ARR.LOAN.STATUS = "Judicial Collection":@FM:"Restructured":@FM:"Write-off":@FM:"GRC":@FM:"DEL":@FM:"NAB":@FM:"Current 0-30 Days":@FM:"Overdue 31-90 Days":@FM:"Overdue more 90 Days"
    GOSUB CASE.SEL
    GOSUB LOAN.STATUS.VAL.SEL
    GOSUB ASSIGN.STATUS
    GOSUB GET.AA.INTEREST.ACCRUALS.DETAILS
    GOSUB GET.ACTIVITY.ID.FOR.PAYMENT.RULES.AND.TERM.AMOUNT
    GOSUB AA.BILL.DETAILS.PROCESS
    IF X.OVERDUE.BILLS.AMOUNT NE '' AND Y.OVERDUE.FEE NE '' THEN
        IF X.OVERDUE.BILLS.AMOUNT GE Y.OVERDUE.FEE<1,1,1> AND X.OVERDUE.BILLS.AMOUNT LE Y.OVERDUE.FEE<1,1,2> ELSE
            RETURN
        END
    END
    IF Y.PERIOD.DELAY1 THEN
        IF Y.ARR.AGE.STATUS EQ Y.OVERDUE.STATUS ELSE
            Y.STATUS.FLAG = '1'
        END
    END
    GOSUB CHECK.PERIOD.DELAY
    GOSUB LIST.OF.GOSUBS
    X.TOTAL.DEFAULT.BALANCE = X.CAPITAL.BALANCE.DELAY + X.INTEREST.DEFAULT.BALANCE + X.TOTAL.BALANCE.DUE + X.INSURANCE.DEFAULT.BALANCE + X.CHARGE.DEFAULT.BALANCE
    IF Y.ERR.FLAG NE '1' THEN
        IF Y.STATUS.FLAG NE '1' THEN
            GOSUB FINAL.ARRAY
        END
    END
    Y.ERR.FLAG = ''; Y.STATUS.FLAG = ''
RETURN
*******************
CHECK.PERIOD.DELAY:
*******************
    IF Y.PERIOD.DELAY THEN
        GOSUB CHECK.DAYS
    END
RETURN
*********************
CHECK.DAYS:
*********************
    IF Y.PERIOD.DELAY EQ '91' THEN
        IF X.PERIOD.OF.DELAY GE Y.PERIOD.DELAY<1,1,1> ELSE
            Y.ERR.FLAG = '1'
        END
    END ELSE
        CHANGE ' ' TO @SM IN Y.PERIOD.DELAY
        Y.FROM.DELAY = Y.PERIOD.DELAY<1,1,1>
        Y.TO.DELAY   = Y.PERIOD.DELAY<1,1,2>
        GOSUB CHECK.DELAY
    END
RETURN
*******************
CHECK.DELAY:
*******************
    LOOP
    WHILE Y.FROM.DELAY LE Y.TO.DELAY
        IF Y.FROM.DELAY EQ X.PERIOD.OF.DELAY THEN
            Y.ERR.FLAG = ''
            Y.FROM.DELAY = Y.TO.DELAY + 1
        END ELSE
            Y.ERR.FLAG = '1'
        END
        Y.FROM.DELAY +=1
    REPEAT
RETURN
*------------------------------------------------------------------------------------------
GET.LOAN.STATUS:
* This reads the template REDO.OVERDUE.STATUS and gets the description to validate
* Fix done as part of HD1100277
    FN.REDO.OVERDUE.STATUS = 'F.REDO.OVERDUE.STATUS'
    F.REDO.OVERDUE.STATUS = ''
    R.REDO.OVERDUE.STATUS = ''
    CALL OPF(FN.REDO.OVERDUE.STATUS, F.REDO.OVERDUE.STATUS)
    LOAN.STATUS.ID = Y.PERIOD.DELAY1
    CALL F.READ(FN.REDO.OVERDUE.STATUS, LOAN.STATUS.ID, R.REDO.OVERDUE.STATUS, F.REDO.OVERDUE.STATUS, READ.ERR)
    Y.PERIOD.DELAY  = R.REDO.OVERDUE.STATUS<REDO.OD.STATUS.OD.STATUS>
    Y.OVERDUE.STATUS = R.REDO.OVERDUE.STATUS<REDO.OD.STATUS.DESCRIPTION>
    GOSUB GET.STATUS
RETURN
***********
GET.STATUS:
***********
    IF Y.OVERDUE.STATUS EQ 'Current 0-30 Days' THEN
        Y.OVERDUE.STATUS = 'GRC'
    END
    IF Y.OVERDUE.STATUS EQ 'Overdue 31-90 Days' THEN
        Y.OVERDUE.STATUS = 'DEL'
    END
    IF Y.OVERDUE.STATUS EQ  'Overdue more 90 Days' THEN
        Y.OVERDUE.STATUS = 'NAB'
    END
RETURN
*----------------------------------------------------------------------------------------
LIST.OF.GOSUBS:
*----------------------------------------------------------------------------------------

    GOSUB SUB.PROCESS
    GOSUB GET.PROVISION.BALANCE
    GOSUB GET.CAPITAL.BALANCE.DELAY
    GOSUB GET.INTEREST.DEFAULT.BALANCE
    GOSUB GET.INSURANCE.DEFAULT.BALANCE
    GOSUB GET.CHARGE.DEFAULT.BALANCE
RETURN
*----------------------------------------------------------------------------------------
GET.AA.ARR.CUSTOMER.DETAILS:
*----------------------------------------------------------------------------------------
    Y.PRI.OWNER = Y.AA.ARR.CUSTOMER<AA.CUS.PRIMARY.OWNER>
    CALL F.READ(FN.CUSTOMER,Y.PRI.OWNER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.CLIENT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
    Y.OWNER.LIST = Y.AA.ARR.CUSTOMER<AA.CUS.OWNER>
    Y.OWNER.LIST.SIZE = DCOUNT(Y.OWNER.LIST,@VM)
    Y.OWNER.CNT = 1
    CHANGE @VM TO @FM IN Y.OWNER.LIST
    IF Y.OWNER.LIST.SIZE NE '' THEN
        GOSUB CHECK.OWNER.LIST
    END
    IF R.CUSTOMER THEN
        GOSUB GET.CLIENT.DETAILS
    END
RETURN
******************
CHECK.OWNER.LIST:
******************
    LOOP
    WHILE Y.OWNER.CNT LE Y.OWNER.LIST.SIZE
        IF Y.PRI.OWNER NE Y.OWNER.LIST<Y.OWNER.CNT> THEN
            Y.CUS.ID=Y.OWNER.LIST<Y.OWNER.CNT>
            GOSUB CUST.NAME
        END
        Y.OWNER.CNT += 1
    REPEAT
RETURN
*----------------------------------------------------------------------------------------
GET.ARRANGEMENT.DETAILS:
*----------------------------------------------------------------------------------------
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARR.ERR)
    X.LOAN.BOOK.TYPE     = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    X.LOAN.PRODUCT.TYPE  = R.AA.ARRANGEMENT<AA.ARR.PRODUCT> ;  X.LOAN.NUMBER        = Y.AA.ID
    X.CURRENCY           = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>;  X.LOAN.SOURCE.AGENCY = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
RETURN
*----------------------------------------------------------------------------------------
GET.ARR.CONDITION:
*----------------------------------------------------------------------------------------
* -------------------------------- property class --------------------------------
    ArrangementID = Y.AA.ID     ; returnError      = ''  ; returnIds        = '' ; effectiveDate    = ''       ; R.CONDITION      = ''  ; returnConditions = ''
*---------------------------------------------------------------------------------
*-- Call AA.GET.ARRANGEMENT.CONDITIONS to get the arrangement condition record ---
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    R.CONDITION = RAISE(returnConditions)
RETURN
*----------------------------------------------------------------------------------------
GET.AA.INTEREST.ACCRUALS.DETAILS:
*----------------------------------------------------------------------------------------
    ARR.INFO = ''        ;       Y.EFF.DATE = R.AA.ARRANGEMENT<AA.ARR.PROD.EFF.DATE>
    ARR.INFO<1> =Y.AA.ID ; R.ARRANGEMENT = ''
    CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO, Y.EFF.DATE, R.ARRANGEMENT, PROP.LIST)
    CLASS.LIST = ''  ; INT.PROPERTY = ''
    CALL AA.GET.PROPERTY.CLASS(PROP.LIST, CLASS.LIST)       ;* Find their Property classes
    CLASS.LIST = RAISE(CLASS.LIST) ; PROP.LIST = RAISE(PROP.LIST)
    CLASS.CTR = ''
    LOOP
        REMOVE Y.CLASS FROM CLASS.LIST SETTING CLASS.POS
        CLASS.CTR +=1
    WHILE Y.CLASS:CLASS.POS
        IF Y.CLASS EQ "INTEREST" THEN
            INT.PROPERTY<-1> = PROP.LIST<CLASS.CTR>
        END
    REPEAT
    CHANGE @FM TO '*' IN INT.PROPERTY
    Y.COUNT.PROP = DCOUNT(INT.PROPERTY,'*')
    INIT = 1
    LOOP
    WHILE INIT LE Y.COUNT.PROP
        GOSUB INT.SUB.PROCESS
    REPEAT
RETURN
*----------------------------------------------------------------------------------------
INT.SUB.PROCESS:
*----------------------------------------------------------------------------------------
    Y.FIRST.PROP = FIELD(INT.PROPERTY,'*',INIT)
    AA.INTEREST.ACCRUALS.ID = Y.AA.ID:'-':Y.FIRST.PROP      ;* form the accrual id using the property
    CALL F.READ(FN.AA.INTEREST.ACCRUALS,AA.INTEREST.ACCRUALS.ID,R.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS,Y.AA.INTEREST.ACCRUALS.ER)
    Y.FIRST.DATE     = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.PERIOD.START>
    Y.END.DATE       = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.PERIOD.END>
    IF Y.END.DATE AND Y.FIRST.DATE THEN
        GOSUB INT.CLASS
    END
    INIT +=1
RETURN
*----------------------------------------------------------------------------------------
INT.CLASS:
*----------------------------------------------------------------------------------------
    IF R.AA.INTEREST.ACCRUALS THEN
        X.INTEREST.RATE = R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,1,1>
    END
    IF NOT(X.INTEREST.RATE) THEN
        GOSUB GET.INT.RATE
    END
RETURN
*----------------------------------------------------------------------------------------
AA.BILL.DETAILS.PROCESS:
*----------------------------------------------------------------------------------------

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,E.AA.ACCOUNT.DETAILS)
    Y.BILL.ID        = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.BILL.ID = CHANGE(Y.BILL.ID,@VM,@FM)    ; Y.BILL.ID = CHANGE(Y.BILL.ID,@SM,@FM)
    Y.PAYMENT.DATE = 99999999              ; Z.OVERDUE.BILLS.AMOUNT = 0
    Z.OS.PR.AMT = 0                        ; Z.Y.BILL.ST.CHG.DT = ''
    LOOP
        REMOVE BILL.ID FROM Y.BILL.ID SETTING BILL.POS
    WHILE BILL.ID:BILL.POS
        GOSUB GET.MAIN.BILL.DETS
    REPEAT
    REGION = "" ; GET.DAYS = "C"
    IF Z.Y.BILL.ST.CHG.DT NE '' THEN
        CALL CDD(REGION,Z.Y.BILL.ST.CHG.DT,TODAY,GET.DAYS)
        X.PERIOD.OF.DELAY = GET.DAYS
    END
    X.OVERDUE.BILLS.AMOUNT = Z.OVERDUE.BILLS.AMOUNT
    X.TOTAL.BALANCE.DUE    = Z.OS.PR.AMT
RETURN
*----------------------------------------------------------------------------------------
SUB.PROCESS:
*----------------------------------------------------------------------------------------
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ACT.HIS.ERR)
    IF R.AA.ACTIVITY.HISTORY THEN
        Y.ACTIVITY.REF   = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF>
        Y.ACTIVITY       = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
    END
    LOOP
        REMOVE Y.ACTIVITY.ID FROM Y.ACTIVITY SETTING ACT.POS
        REMOVE Y.ACTIVITY.REF.ID FROM Y.ACTIVITY.REF SETTING ACT.REF.POS
    WHILE Y.ACTIVITY.ID:ACT.POS
        LOCATE Y.ACTIVITY.ID IN Y.PR.ACTIVITY SETTING Y.PR.POS THEN
            GOSUB GET.EFF.DATE.AND.TXN.AMOUNT
        END
        LOCATE Y.ACTIVITY.ID IN Y.TERM.AMT.ACTIVITY SETTING Y.TERM.AMT.POS THEN
            GOSUB GET.DISBURSEMENT.AMOUNT
        END
    REPEAT
    Y.TXN.AMOUNT.SUM = 0
    COUNT.EFF.DATE = DCOUNT(Y.EFFECTIVE.DATE,@FM)
    Y.MAX.EFF.DATE = MAXIMUM(Y.EFFECTIVE.DATE)
    FOR Y.I = 1 TO COUNT.EFF.DATE
        IF Y.EFFECTIVE.DATE<Y.I> EQ Y.MAX.EFF.DATE THEN
            Y.TXN.AMOUNT.SUM += Y.TXN.AMOUNT<Y.I>
        END
    NEXT Y.I
    X.LAST.PAYMENT.DATE   = Y.MAX.EFF.DATE
    X.LAST.PAYMENT.VALUE  = Y.TXN.AMOUNT.SUM
    X.DISBURSEMENT.AMOUNT = Y.DISB.AMT
RETURN
*----------------------------------------------------------------------------------------
GET.EFF.DATE.AND.TXN.AMOUNT:
*----------------------------------------------------------------------------------------
    IF Y.ACTIVITY.REF.ID EQ '' THEN
        RETURN
    END
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ACTIVITY.REF.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ARR.ACTY.ERR)
    IF Y.EFFECTIVE.DATE EQ '' THEN
        Y.EFFECTIVE.DATE     = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.EFFECTIVE.DATE>
        Y.TXN.AMOUNT         = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>
    END ELSE
        Y.EFFECTIVE.DATE<-1> = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.EFFECTIVE.DATE>
        Y.TXN.AMOUNT<-1>     = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>
    END
RETURN
*----------------------------------------------------------------------------------------
GET.DISBURSEMENT.AMOUNT:
*----------------------------------------------------------------------------------------
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ACTIVITY.REF.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ARR.ACTY.ERR)
    IF R.AA.ARRANGEMENT.ACTIVITY THEN
        Y.DISB.AMT += R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>
    END
RETURN
*----------------------------------------------------------------------------------------
GET.PROVISION.BALANCE:
*----------------------------------------------------------------------------------------
    Y.CUS = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    CALL F.READ(FN.REDO.H.CUSTOMER.PROVISIONING,Y.CUS,R.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING,CUST.PROV.ERR)
    CUST.PROV.AA.ID = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.ARRANGEMENT.ID>
    LOCATE Y.AA.ID IN CUST.PROV.AA.ID<1,1> SETTING CUST.PROV.POS THEN
        Y.PROV.PRINC    = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.PRINC,CUST.PROV.POS>
        Y.PROV.INTEREST = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.INTEREST,CUST.PROV.POS>
        Y.PROV.RESTRUCT = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.RESTRUCT,CUST.PROV.POS>
        Y.PROV.FX       = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.FX,CUST.PROV.POS>
    END
    X.PROVISION.BALANCE = Y.PROV.PRINC + Y.PROV.INTEREST + Y.PROV.RESTRUCT + Y.PROV.FX
RETURN
*----------------------------------------------------------------------------------------
GET.CAPITAL.BALANCE.DELAY:
*----------------------------------------------------------------------------------------
    Y.BAL.TYPE = "GRCACCOUNT":@FM:"DELACCOUNT":@FM:"NABACCOUNT"
    GOSUB GET.BK.BALANCE
    X.CAPITAL.BALANCE.DELAY = ABSS(Y.BK.BALANCE)
RETURN
*----------------------------------------------------------------------------------------
GET.INTEREST.DEFAULT.BALANCE:
*----------------------------------------------------------------------------------------
    Y.BAL.TYPE = "GRCPRINCIPALINT":@FM:"DELPRINCIPALINT":@FM:"NABPRINCIPALINT"
    GOSUB GET.BK.BALANCE
    X.INTEREST.DEFAULT.BALANCE = ABSS(Y.BK.BALANCE)
RETURN
*----------------------------------------------------------------------------------------
CHANGE.SUB.PROCESS:
*----------------------------------------------------------------------------------------
    CALL CACHE.READ(FN.AA.PROPERTY, Y.AA.PROP.ID, R.AA.PROPERTY, AA.PROP.ERR)
    IF R.AA.PROPERTY<AA.PROP.PROPERTY.CLASS> EQ 'CHARGE' THEN
        Z.AA.PROPERTY = Y.AA.PROP.ID
        Y.BAL.TYPE = "GRC":Z.AA.PROPERTY:@FM:"DEL":Z.AA.PROPERTY:@FM:"NAB":Z.AA.PROPERTY
        GOSUB GET.BK.BALANCE
        Z.CHARGE.DEF.BAL += Y.BK.BALANCE
    END
RETURN
*----------------------------------------------------------------------------------------
GET.CHARGE.DEFAULT.BALANCE:
*----------------------------------------------------------------------------------------


    Z.CHARGE.DEF.BAL = 0
    Y.AA.PROPERTY = R.AA.ARRANGEMENT<AA.ARR.PROPERTY>
    LOOP
        REMOVE Y.AA.PROP.ID FROM Y.AA.PROPERTY SETTING PROP.POS
    WHILE Y.AA.PROP.ID:PROP.POS
        GOSUB CHANGE.SUB.PROCESS
    REPEAT
    X.CHARGE.DEFAULT.BALANCE = ABSS(Z.CHARGE.DEF.BAL)
RETURN
*----------------------------------------------------------------------------------------
INS.SUB.PROCESS:
*----------------------------------------------------------------------------------------


    CALL CACHE.READ(FN.AA.PROPERTY, Y.AA.PROP.ID, R.AA.PROPERTY, AA.PROP.ERR)
    IF R.AA.PROPERTY<AA.PROP.PROPERTY.CLASS> EQ 'CHARGE' THEN
        Y.INS.POLICY.TYPE = ''
        idPropertyClass = 'CHARGE'
        idProperty = Y.AA.PROP.ID
        GOSUB GET.ARR.CONDITION
        GOSUB GET.INSURANCE.DEFAULT.BAL
    END
RETURN
*----------------------------------------------------------------------------------------
GET.INSURANCE.DEFAULT.BALANCE:
*----------------------------------------------------------------------------------------
    Z.INS.CHG.DEF.BAL = 0
    Y.AA.PROPERTY = R.AA.ARRANGEMENT<AA.ARR.PROPERTY>
    LOOP
        REMOVE Y.AA.PROP.ID FROM Y.AA.PROPERTY SETTING PROP.POS
    WHILE Y.AA.PROP.ID:PROP.POS
        GOSUB INS.SUB.PROCESS
    REPEAT
    X.INSURANCE.DEFAULT.BALANCE = ABSS(Z.INS.CHG.DEF.BAL)
RETURN
*----------------------------------------------------------------------------------------
GET.INSURANCE.DEFAULT.BAL:
*----------------------------------------------------------------------------------------

    Y.AA.ARR.CHARGE = R.CONDITION
    Y.INS.POLICY.TYPE    = Y.AA.ARR.CHARGE<AA.CHG.LOCAL.REF><1,LOC.INS.POLICY.TYPE.POS>
    IF Y.INS.POLICY.TYPE NE '' THEN
        Z.AA.PROPERTY = Y.AA.PROP.ID
        Y.BAL.TYPE = "GRC":Z.AA.PROPERTY:@FM:"DEL":Z.AA.PROPERTY:@FM:"NAB":Z.AA.PROPERTY
        GOSUB GET.BK.BALANCE
        Z.INS.CHG.DEF.BAL += Y.BK.BALANCE
    END
RETURN
*----------------------------------------------------------------------------------------
GET.BK.BALANCE:
*----------------------------------------------------------------------------------------
    Y.BK.BALANCE = 0
    ALTERNATE.ACCOUNT.ID = Y.AA.ID
    GOSUB READ.ALTERNATE.ACCOUNT
    EB.CONTRACT.BALANCES.ID = R.ALTERNATE.ACCOUNT<AAC.GLOBUS.ACCT.NUMBER>
    GOSUB READ.EB.CONTRACT.BALANCES
    LOOP
        REMOVE Y.BAL.TYPE.ID FROM Y.BAL.TYPE SETTING Y.BAL.POS
    WHILE Y.BAL.TYPE.ID:Y.BAL.POS
        LOCATE Y.BAL.TYPE.ID IN R.EB.CONTRACT.BALANCES<ECB.BAL.TYPE,1> SETTING Y.BAL.TYPE.POS ELSE
            CONTINUE
        END
        Y.BT.ACT.MONTHS.LIST = R.EB.CONTRACT.BALANCES<ECB.BT.ACT.MONTHS,Y.BAL.TYPE.POS>
        Y.BT.ACT.MONTHS.LIST = SORT(Y.BT.ACT.MONTHS.LIST)
        Y.BT.ACT.MONTHS = FIELD(Y.BT.ACT.MONTHS.LIST,@FM,DCOUNT(Y.BT.ACT.MONTHS.LIST,@FM),1)
*TUS change START
*ACCT.ACTIVITY.ID = EB.CONTRACT.BALANCES.ID:'.':Y.BAL.TYPE.ID:'-':Y.BT.ACT.MONTHS
        ACCT.BAL.ACTIVITY.ID = EB.CONTRACT.BALANCES.ID:'-':Y.BT.ACT.MONTHS
*TUS change END
        GOSUB READ.ACCT.ACTIVITY
        IF R.ACCT.ACTIVITY THEN
            Y.BK.BALANCE += SUM(R.ACCT.ACTIVITY<IC.ACT.BK.BALANCE>)
        END
    REPEAT
RETURN
*----------------------------------------------------------------------------------------
READ.ALTERNATE.ACCOUNT:
*----------------------------------------------------------------------------------------
    R.ALTERNATE.ACCOUNT  = ''
    ALTERNATE.ACCOUNT.ER = ''
    CALL F.READ(FN.ALTERNATE.ACCOUNT,ALTERNATE.ACCOUNT.ID,R.ALTERNATE.ACCOUNT ,F.ALTERNATE.ACCOUNT ,ALTERNATE.ACCOUNT.ER)
RETURN
*----------------------------------------------------------------------------------------
READ.EB.CONTRACT.BALANCES:
*----------------------------------------------------------------------------------------
    R.EB.CONTRACT.BALANCES  = ''
    EB.CONTRACT.BALANCES.ER = ''
    CALL F.READ(FN.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ID,R.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES,EB.CONTRACT.BALANCES.ER)
RETURN
*----------------------------------------------------------------------------------------
READ.ACCT.ACTIVITY:
*----------------------------------------------------------------------------------------
*TUS change START

    R.ACCT.ACTIVITY  = ''
    R.ACCT.ACTIVITY.TEMP = ''
    R.ACCT.BAL.ACTIVITY = ''

    ACCT.ACTIVITY.ER = ''
    CALL F.READ(FN.ACCT.ACTIVITY,ACCT.BAL.ACTIVITY.ID,R.ACCT.BAL.ACTIVITY,F.ACCT.ACTIVITY,ACCT.ACTIVITY.ER)
    IF R.ACCT.BAL.ACTIVITY THEN
        LOCATE Y.BAL.TYPE.ID IN R.ACCT.BAL.ACTIVITY<1, 1> SETTING BALANCE.TYPE.POS THEN
            R.ACCT.ACTIVITY.TEMP = R.ACCT.BAL.ACTIVITY<2, BALANCE.TYPE.POS>
            R.ACCT.ACTIVITY=RAISE(RAISE(R.ACCT.ACTIVITY.TEMP))
        END
    END

*TUS change END

RETURN
*----------------------------------------------------------------------------------------
GET.ACTIVITY.ID.FOR.PAYMENT.RULES.AND.TERM.AMOUNT:
*----------------------------------------------------------------------------------------
    Y.EFF.DATE = R.AA.ARRANGEMENT<AA.ARR.PROD.EFF.DATE>
    ARR.INFO<1> = Y.AA.ID     ;  R.ARRANGEMENT = ''
    CALL AA.GET.ARRANGEMENT.PROPERTIES(ARR.INFO,Y.EFF.DATE,R.ARRANGEMENT,PROP.LIST)
    CLASS.LIST = ''           ; PR.PROPERTY = '' ; Y.TERM.AMT.ACTIVITY = ''
    CALL AA.GET.PROPERTY.CLASS(PROP.LIST,CLASS.LIST)        ;* Find their Property classes
    CLASS.LIST = RAISE(CLASS.LIST)
    PROP.LIST = RAISE(PROP.LIST)
    CLASS.CTR = ''            ; Y.PR.ACTIVITY = '' ;
    LOOP
        REMOVE Y.CLASS FROM CLASS.LIST SETTING CLASS.POS
        CLASS.CTR +=1
    WHILE Y.CLASS:CLASS.POS
        IF Y.CLASS EQ "PAYMENT.RULES" THEN
            PR.PROPERTY = PROP.LIST<CLASS.CTR>
            Y.PR.ACTIVITY<-1> = 'LENDING-APPLYPAYMENT-':PR.PROPERTY
        END
        IF Y.CLASS EQ "TERM.AMOUNT" THEN
            TERM.AMT.PROPERTY = PROP.LIST<CLASS.CTR>
            Y.TERM.AMT.ACTIVITY<-1> = 'LENDING-DISBURSE-':TERM.AMT.PROPERTY
        END
    REPEAT
RETURN
*----------------------------------------------------------------------------------------
GET.LOCAL.REF.POS:
*----------------------------------------------------------------------------------------
    APPLI.ID   = 'AA.PRD.DES.OVERDUE':@FM:'AA.PRD.DES.ACCOUNT':@FM:'CUSTOMER':@FM:'AA.PRD.DES.CUSTOMER'
    APPLI.ID   = APPLI.ID:@FM:'AA.PRD.DES.CHARGE'
    FLD.NAME   = "L.LOAN.COND":@VM:"L.LOAN.STATUS.1":@FM:"L.AA.AGNCY.CODE":@VM:"L.PROV.RESTRUCT":@FM:"L.CU.CIDENT":@VM:"L.CU.RNC"
    FLD.NAME   = FLD.NAME:@VM:"L.CU.NOUNICO":@VM:"L.CU.ACTANAC":@FM:'L.AA.CAMP.TY':@VM:"L.AA.AFFLI.COM"
    FLD.NAME   = FLD.NAME:@FM:"INS.POLICY.TYPE"
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPLI.ID,FLD.NAME,FLD.POS)
    LOC.L.LOAN.COND.POS     = FLD.POS<1,1>  ; LOC.L.LOAN.STATUS.1.POS = FLD.POS<1,2>  ;
    LOC.L.AA.AGNCY.CODE.POS = FLD.POS<2,1>  ; LOC.L.PROV.RESTRUCT.POS = FLD.POS<2,2>  ;
    LOC.L.CU.CIDENT.POS     = FLD.POS<3,1>  ; LOC.L.CU.RNC.POS        = FLD.POS<3,2>  ;
    LOC.L.CU.NOUNICO.POS    = FLD.POS<3,3>  ; LOC.L.CU.ACTANAC.POS    = FLD.POS<3,4>  ;
    LOC.L.AA.CAMP.TY.POS    = FLD.POS<4,1>  ; LOC.L.AA.AFFLI.COM.POS  = FLD.POS<4,2>  ;
    LOC.INS.POLICY.TYPE.POS = FLD.POS<5,1>  ;
RETURN
*----------------------------------------------------------------------------------------
FINAL.ARRAY:
*----------------------------------------------------------------------------------------
    Y.DATA = X.LOAN.BOOK.TYPE:'*':X.LOAN.PRODUCT.TYPE:'*':X.CAMPAIGN:'*':X.LOAN.SOURCE.AGENCY:'*':X.LOAN.NUMBER:'*'
    Y.DATA = Y.DATA:X.PREVIOUS.LOAN.NUMBER:'*':X.CLIENT.NAME:'*':X.CLIENTS.ID.NUMBER:'*':X.CLIENT.TELEPHONE:'*'
    Y.DATA = Y.DATA:X.LOAN.STATUS:'*':X.LOAN.CONDITION:'*':X.PERIOD.OF.DELAY:'*':X.CURRENCY:'*':X.INTEREST.RATE:'*'
    Y.DATA = Y.DATA:X.OVERDUE.BILLS.AMOUNT:'*':X.LAST.PAYMENT.DATE:'*':X.LAST.PAYMENT.VALUE:'*':X.PROVISION.BALANCE:'*'
    Y.DATA = Y.DATA:X.DISBURSEMENT.AMOUNT:'*':X.CAPITAL.BALANCE.DELAY:'*':X.INTEREST.DEFAULT.BALANCE:'*'
    Y.DATA = Y.DATA:X.TOTAL.BALANCE.DUE:'*':X.INSURANCE.DEFAULT.BALANCE:'*':X.CHARGE.DEFAULT.BALANCE:'*':X.TOTAL.DEFAULT.BALANCE
    IF Y.OUT.DATA EQ '' THEN
        Y.OUT.DATA = Y.DATA
    END ELSE
        Y.OUT.DATA<-1> = Y.DATA
    END
RETURN
*----------------------------------------------------------------------------------------
CUST.NAME:
*----------------------------------------------------------------------------------------
    R.CUS = ''
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUS,F.CUSTOMER,CUS.ERR)
    IF Y.CLIENT.NAME NE '' THEN
        Y.CLIENT.NAME := @VM:R.CUS<EB.CUS.SHORT.NAME,1>
    END
RETURN
*----------------------------------------------------------------------------------------
GET.CLIENT.DETAILS:
*----------------------------------------------------------------------------------------
    X.CLIENT.NAME = Y.CLIENT.NAME
    X.CLIENT.TELEPHONE = R.CUSTOMER<EB.CUS.PHONE.1>
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.CIDENT.POS> NE '' THEN
        X.CLIENTS.ID.NUMBER<1,-1> = R.CUSTOMER<EB.CUS.LOCAL.REF><1,LOC.L.CU.CIDENT.POS>
    END
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.RNC.POS> NE '' THEN
        X.CLIENTS.ID.NUMBER<1,-1> = R.CUSTOMER<EB.CUS.LOCAL.REF><1,LOC.L.CU.RNC.POS>
    END
    IF R.CUSTOMER<EB.CUS.LEGAL.ID> NE '' THEN
        X.CLIENTS.ID.NUMBER<1,-1> = R.CUSTOMER<EB.CUS.LEGAL.ID>
    END
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.NOUNICO.POS> NE '' THEN
        X.CLIENTS.ID.NUMBER<1,-1> = R.CUSTOMER<EB.CUS.LOCAL.REF><1,LOC.L.CU.NOUNICO.POS>
    END
    IF R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.L.CU.ACTANAC.POS> NE '' THEN
        X.CLIENTS.ID.NUMBER<1,-1> = R.CUSTOMER<EB.CUS.LOCAL.REF><1,LOC.L.CU.ACTANAC.POS>
    END
RETURN
*----------------------------------------------------------------------------------------
ASSIGN.STATUS:
*----------------------------------------------------------------------------------------
    IF Y.ARR.AGE.STATUS EQ 'GRC' THEN
        X.LOAN.STATUS<1,-1> = 'Current 0-30 Days'
    END
    IF Y.ARR.AGE.STATUS EQ 'DEL' THEN
        X.LOAN.STATUS<1,-1> = 'Overdue 31-90 Days'
    END
    IF Y.ARR.AGE.STATUS EQ 'NAB' THEN
        X.LOAN.STATUS<1,-1> = 'Overdue more 90 Days'
    END
RETURN
*----------------------------------------------------------------------------------------
GET.INT.RATE:
*----------------------------------------------------------------------------------------
    Y.INS.POLICY.TYPE = ''
    idPropertyClass = 'INTEREST'
    idProperty = ''
    GOSUB GET.ARR.CONDITION
    Y.FLOATING.INDEX = R.CONDITION<AA.INT.FLOATING.INDEX>
    IF Y.FLOATING.INDEX THEN
        Y.BI.ID = Y.FLOATING.INDEX:X.CURRENCY
        SEL.CMD.BI = "SELECT ":FN.BASIC.INTEREST:" WITH @ID LIKE ":Y.BI.ID:"..."
        CALL EB.READLIST(SEL.CMD.BI,SEL.LIST,'',NO.OF.REC,SEL.ERR)
        CALL CACHE.READ(FN.BASIC.INTEREST, SEL.LIST, R.BASIC.INTEREST, Y.BI.ERR)
        X.INTEREST.RATE = R.BASIC.INTEREST<EB.BIN.INTEREST.RATE>
    END ELSE
        X.INTEREST.RATE = R.CONDITION<AA.INT.EFFECTIVE.RATE>
    END
RETURN
*----------------------------------------------------------------------------------------
GET.BILL.DETAILS:
*----------------------------------------------------------------------------------------
    Y.BILL.STATUS    = R.AA.BILL.DETAILS<AA.BD.BILL.STATUS>
    Y.BILL.ST.CHG.DT = R.AA.BILL.DETAILS<AA.BD.BILL.ST.CHG.DT>
    Y.SETTLE.STATUS  = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS>
    Y.BILL.STATUS    = CHANGE(Y.BILL.STATUS,@VM,@FM)    ; Y.BILL.STATUS    = CHANGE(Y.BILL.STATUS,@SM,@FM)
    Y.BILL.ST.CHG.DT = CHANGE(Y.BILL.ST.CHG.DT,@VM,@FM) ; Y.BILL.ST.CHG.DT = CHANGE(Y.BILL.ST.CHG.DT,@SM,@FM)
    Y.SETTLE.STATUS  = CHANGE(Y.SETTLE.STATUS,@VM,@FM)  ; Y.SETTLE.STATUS  = CHANGE(Y.SETTLE.STATUS,@SM,@FM)
    COUNT.SETTLE.STATUS  = DCOUNT(Y.SETTLE.STATUS,@FM)
    Y.CURR.SETTLE.STATUS = Y.SETTLE.STATUS<COUNT.SETTLE.STATUS>       ;*  The last multivalue shows the current status. Thus,
    COUNT.BILL.STATUS    = DCOUNT(Y.BILL.STATUS,@FM)
    FOR Y.I = 1 TO COUNT.BILL.STATUS
        GOSUB GET.BILL.DETAILS.SUB.PROCESS
    NEXT Y.I
RETURN
*----------------------------------------------------------------------------------------
GET.BILL.DETAILS.SUB.PROCESS:
*----------------------------------------------------------------------------------------
    Y.CURR.BILL.STATUS = Y.BILL.STATUS<Y.I>
    IF Y.CURR.BILL.STATUS EQ 'AGING' AND Y.CURR.SETTLE.STATUS EQ 'UNPAID' THEN
        IF R.AA.BILL.DETAILS<AA.BD.PAYMENT.DATE> LT Y.PAYMENT.DATE THEN         ;* In case of multiple records, fetch the record which has the earliest value in PAYMENT.DATE field
            Y.PAYMENT.DATE     =  R.AA.BILL.DETAILS<AA.BD.PAYMENT.DATE>
            Z.Y.BILL.ST.CHG.DT = Y.BILL.ST.CHG.DT<Y.I>
        END
    END
RETURN
*----------------------------------------------------------------------------------------
GET.MAIN.BILL.DETS:
*----------------------------------------------------------------------------------------
    CALL F.READ(FN.AA.BILL.DETAILS,BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,ERR.BILL.DETAILS)
    IF R.AA.BILL.DETAILS THEN
        GOSUB GET.BILL.DETAILS
    END
    IF  Y.SETTLE.STATUS<1> EQ 'UNPAID' THEN
        Z.OVERDUE.BILLS.AMOUNT +=  1
    END
    Y.PAY.PROPERTY = R.AA.BILL.DETAILS<AA.BD.PAY.PROPERTY>
    Y.OS.PR.AMT    = R.AA.BILL.DETAILS<AA.BD.OS.PR.AMT>
    Y.PAY.PROPERTY = CHANGE(Y.PAY.PROPERTY,@SM,@FM) ; Y.PAY.PROPERTY = CHANGE(Y.PAY.PROPERTY,@VM,@FM)
    Y.OS.PR.AMT    = CHANGE(Y.OS.PR.AMT,@SM,@FM)    ; Y.OS.PR.AMT    = CHANGE(Y.OS.PR.AMT,@VM,@FM)
    CALL CACHE.READ(FN.PROP.PARAM,X.LOAN.BOOK.TYPE,R.PROP.PARAM.REC,PROP.PARAM.ERR)
    Y.PEN.ID = R.PROP.PARAM.REC<PROP.PARAM.PENALTY.ARREAR>
    LOCATE Y.PEN.ID IN Y.PAY.PROPERTY<1> SETTING PAY.PROP.POS THEN
        Z.OS.PR.AMT += Y.OS.PR.AMT<PAY.PROP.POS>
    END
RETURN
*----------------------------------------------------------------------------------------
END
*----------------------------------------------------------------------------------------
