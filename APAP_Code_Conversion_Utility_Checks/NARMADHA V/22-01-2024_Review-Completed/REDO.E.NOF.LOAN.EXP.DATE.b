* @ValidationCode : Mjo5NTgxNjg5MDc6VVRGLTg6MTcwNDI3MzI4MjM1NDpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 03 Jan 2024 14:44:42
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.NOF.LOAN.EXP.DATE(LN.ARRAY)

*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : TAM.E.NOF.LOAN.EXP.DATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is nofile enquiry routine is used to retrieve the Expiration loan List from multiple files
*Linked With  : Enquiry REDO.E.NOF.LOAN.EXP.DATE
*In Parameter : N/A
*Out Parameter: LN.ARRAY
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------                -------------            -------------
*  15th SEPT 2010   JEEVA T              ODR-2010-03-0152        Initial Creation
* 28-APR-2011      H GANESH           CR009              Change the Vetting value of local field
*  DATE             WHO                     REFERENCE
* 23-05-2023     Conversion Tool        R22 Auto Conversion - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO + =1 AND F.READ TO CACHE.READ AND REMOVED F.COMPANY and CHAR TO CHARX
* 23-05-2023      ANIL KUMAR B          R22 Manual Conversion - AA.CUS.OWNER changed to AA.CUS.CUSTOMER and AA.CUS.PRIMARY.OWNER changed to AA.CUS.CUSTOMER AND ADD PACKAG TO CALL ROUTINE
*18-12-2023        VIGNESHWARI S       R22 MANUAL CONVERSION-  CHANGE "AA.ARR.CUSTOMER" TO "AA.PRD.DES.CUSTOMER"
* 19-01-2024      Narmadha V           R22 Utility Changes, Manual R22 Conversion  -   Call Routine Format Modified
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.COMPANY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
*    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.ACCT.ACTIVITY
*    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.INTEREST
    $USING APAP.AA
    $USING APAP.TAM
    $USING AA.Framework ;* Manual R22 Conversion


    GOSUB OPENFILES
    GOSUB GET.LR.FLD.POS
    GOSUB LOCATE.VALUE
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.AA.ACCOUNT='F.AA.ACCOUNT'
    F.AA.ACCOUNT=''
    CALL OPF(FN.AA.ACCOUNT,F.AA.ACCOUNT)
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS=''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
    FN.AA.INTEREST.ACCRUALS='F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS=''
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    FN.COMPANY ='F.COMPANY'; F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)
    FN.CUSTOMER='F.CUSTOMER'; F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'; F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)
    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'; F.AA.ARR.ACCOUNT = ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)
    FN.COLLATERAL='F.COLLATERAL'; F.COLLATERAL=''
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    FN.DEPT.ACCT.OFFICER='F.DEPT.ACCT.OFFICER'; F.DEPT.ACCT.OFFICER=''
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)
    Y.STATUS.FLAGE='';Y.OVER.FLAG1='';Y.LOAN.OVERALL.STATUS.FLAG='';Y.OVERALL.STATUS.FLAG='';Y.FEE.AMOUNT='0.00';Y.COMMISSION.CHARGE.BALANCE='0.00';Y.TOTAL.BALANCE.DUE='0.00';Y.CAPITAL.BALANCE='0.00';Y.INSURANCE.BALANCE='0.00';Y.INTEREST.BALANCE='0.00';Y.REGION.VAL='';Y.AGENCY.VAL='';Y.OVERALL.STATUS.VAL='';Y.REGION.VAL='';Y.EXPIRATION.DATE.FROM.VAL='';Y.EXPIRATION.DATE.TO.VAL='';Y.REGION.FLAG='';Y.LOAN.STATUS='';Y.REGION.NUMBER=''
RETURN
*-----------------------------------------------------------------------------
GET.LR.FLD.POS:
*-----------------------------------------------------------------------------
    Y.LRF.APPL = "AA.ARR.ACCOUNT":@FM:"AA.ARR.TERM.AMOUNT":@FM:'AA.ARR.OVERDUE':@FM:"AA.ARR.CHARGE":@FM:"AA.PRD.DES.CUSTOMER"     ;* PACS00312713 - 2015APR24 - Cristina's email - S;*R22 MANUAL CONVERSION-  CHANGE "AA.ARR.CUSTOMER" TO "AA.PRD.DES.CUSTOMER"
    Y.LRF.FIELDS = "L.AA.AGNCY.CODE":@FM:"L.AA.COL":@FM:'L.LOAN.STATUS.1':@FM:"MON.TOT.PRE.AMT":@FM:"L.AA.CAMP.TY"  ;* PACS00312713 - 2015APR24 - Cristina's email - S
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(Y.LRF.APPL,Y.LRF.FIELDS,FIELD.POS)
    L.AA.AGNCY.CODE.POS=FIELD.POS<1,1>
    L.AA.COL.POS=FIELD.POS<2,1>
    L.LOAN.STATUS.POS=FIELD.POS<3,1>
    L.MON.TOT.PRE.AMT.POS=FIELD.POS<4,1>
    L.AA.CUS.TICAM.POS=FIELD.POS<5,1>
RETURN
*-----------------------------------------------------------------------------
LOCATE.VALUE:
*-----------------------------------------------------------------------------
    LOCATE "AGENCY" IN D.FIELDS<1> SETTING Y.AGENCY.POS  THEN
        Y.AGENCY.VAL= D.RANGE.AND.VALUE<Y.AGENCY.POS>
        CHANGE @SM TO ' ' IN Y.AGENCY.VAL
    END
    LOCATE "OVERALL.STATUS" IN D.FIELDS<1> SETTING Y.OVERALL.STATUS.POS  THEN
        Y.OVERALL.STATUS.VAL= D.RANGE.AND.VALUE<Y.OVERALL.STATUS.POS>
        CHANGE @SM TO ' ' IN Y.OVERALL.STATUS.VAL
    END
    LOCATE "PRODUCT.TYPE" IN D.FIELDS<1> SETTING Y.PRODUCT.TYPE.POS THEN
        Y.PRODUCT.TYPE.VAL= D.RANGE.AND.VALUE<Y.PRODUCT.TYPE.POS>
        CHANGE @SM TO ' ' IN Y.PRODUCT.TYPE.VAL
    END
    LOCATE "PORTFOLIO.TYPE" IN D.FIELDS<1> SETTING Y.LOAN.PORTFOLIO.TYPE.POS THEN
        Y.LOAN.PORTFOLIO.TYPE.VAL= D.RANGE.AND.VALUE<Y.LOAN.PORTFOLIO.TYPE.POS>
        CHANGE @SM TO ' ' IN Y.LOAN.PORTFOLIO.TYPE.VAL
    END
    LOCATE "REGION" IN D.FIELDS<1> SETTING Y.REGION.POS THEN
        Y.REGION.VAL= D.RANGE.AND.VALUE<Y.REGION.POS>
        CHANGE @SM TO ' ' IN Y.REGION.VAL
    END
    LOCATE "LOAN.STATUS" IN D.FIELDS<1> SETTING Y.LOAN.STATUS.POS THEN
        Y.LOAN.STATUS.VAL= D.RANGE.AND.VALUE<Y.LOAN.STATUS.POS>
        CHANGE @SM TO ' ' IN Y.LOAN.STATUS.VAL
    END
    LOCATE "EXP.DATE.FROM" IN D.FIELDS<1> SETTING Y.EXPIRATION.DATE.FROM.POS THEN
* PACS00312713 - 2014NOV12 - S Cristina's email
        Y.TMP.EXP.DATE.VALS = D.RANGE.AND.VALUE<Y.EXPIRATION.DATE.FROM.POS>
        Y.EXPIRATION.DATE.FROM.VAL = Y.TMP.EXP.DATE.VALS
        CHANGE @SM TO ' ' IN Y.TMP.EXP.DATE.VALS
        Y.NO.DATES = DCOUNT(Y.TMP.EXP.DATE.VALS,' ')
        IF Y.NO.DATES GT 1 THEN
            Y.EXPIRATION.DATE.FROM.VAL = FIELD(Y.TMP.EXP.DATE.VALS,' ',1)
            Y.EXPIRATION.DATE.TO.VAL = FIELD(Y.TMP.EXP.DATE.VALS,' ',2)
        END
    END
*    LOCATE "EXP.DATE.TO" IN D.FIELDS<1> SETTING Y.EXPIRATION.DATE.TO.POS THEN
*        Y.EXPIRATION.DATE.TO.VAL= D.RANGE.AND.VALUE<Y.EXPIRATION.DATE.TO.POS>
*        CHANGE SM TO ' ' IN Y.EXPIRATION.DATE.TO.VAL
*    END
* PACS00312713 - 2014NOV12 - E
RETURN
*-----------------------------------------------------------------------------
ACCOUNT.DETAILS:
*-----------------------------------------------------------------------------
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCOUNT.DETAILS.ERR)
    Y.LOAN.EXPIRATION.DATE=R.AA.ACCOUNT.DETAILS<AA.AD.MATURITY.DATE>
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    GOSUB ERROR.CHECK
    GOSUB SELECT.CMD
    CALL EB.READLIST(SEL.CMD.AA,SEL.LIST.AA,'',NO.OF.AA.REC,SEL.ERR.AA)
    LOOP
        REMOVE Y.AA.ID FROM SEL.LIST.AA SETTING AA.POS
    WHILE Y.AA.ID : AA.POS

*CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.ERR.AA)
        R.AA.ARRANGEMENT = AA.Framework.Arrangement.Read(Y.AA.ID, Y.ERR.AA) ;*Manual R22 Conversion
*Y.ACC.ID=R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        Y.ACC.ID=R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedApplId> ;*Manual R22 Conversion
*        CALL REDO.E.NOF.GET.REGION(Y.ACC.ID,Y.REGION.VAL,Y.REGION,Y.REGION.NUMBER,Y.REGION.FLAG) ;* PACS00312713 - Cristina's email sent 2015APR21 - S/E
        GOSUB ACCOUNT.DETAILS
        GOSUB EXP.DATE
    REPEAT
RETURN
*-----------------------------------------------------------------------------
EXP.DATE:
*-----------------------------------------------------------------------------
    IF Y.EXPIRATION.DATE.TO.VAL NE '' OR Y.EXPIRATION.DATE.FROM.VAL NE '' THEN
        IF Y.EXPIRATION.DATE.TO.VAL NE '' AND Y.EXPIRATION.DATE.FROM.VAL NE '' THEN
            IF Y.EXPIRATION.DATE.TO.VAL GE Y.LOAN.EXPIRATION.DATE AND Y.EXPIRATION.DATE.FROM.VAL LE Y.LOAN.EXPIRATION.DATE THEN
                GOSUB ASSIGN.PROCESS
            END
            FLAG=1
        END
        IF Y.EXPIRATION.DATE.TO.VAL NE '' AND  FLAG NE '1' THEN
            IF Y.EXPIRATION.DATE.TO.VAL GE Y.LOAN.EXPIRATION.DATE THEN
                GOSUB ASSIGN.PROCESS
            END
            FLAG=2
        END
        IF Y.EXPIRATION.DATE.FROM.VAL NE '' AND  FLAG NE '1' AND FLAG NE '2' THEN
            IF Y.EXPIRATION.DATE.FROM.VAL LE Y.LOAN.EXPIRATION.DATE THEN
                GOSUB ASSIGN.PROCESS
            END
        END
    END ELSE
        GOSUB ASSIGN.PROCESS
    END
RETURN
*-----------------------------------------------------------------------------
ASSIGN.PROCESS:
*-----------------------------------------------------------------------------

    Y.LOAN.NUMBER=Y.ACC.ID;Y.PAYMENT.AGENCY='';Y.DISBURSED.AMOUNT='0.00'          ;* PACS00312713 - 2014NOV12 - Cristina's email - S/E
*    Y.PRODUCT.TYPE=R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.PRODUCT.TYPE=R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrProduct> ;*Manual R22 Conversion
*   Y.OPENING.DATE=R.AA.ARRANGEMENT<AA.ARR.PROD.EFF.DATE>
    Y.OPENING.DATE=R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrProdEffDate> ;*Manual R22 Conversion
*    Y.CURRENCY=R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
    Y.CURRENCY=R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency> ;* R22 Utility Changes
*    Y.LOAN.OVERALL.STATUS=R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
    Y.LOAN.OVERALL.STATUS=R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrArrStatus> ;*Manual R22 Conversion
*TUS AA Changes 20161021
*  Y.LOAN.OVER.STATUS="CURRENT":FM:"MATURED":FM:"EXPIRED":FM:"REVERSED"
    Y.LOAN.OVER.STATUS="CURRENT":@FM:"PENDING.CLOSURE":@FM:"EXPIRED":@FM:"REVERSED"
*TUS END
    LOCATE Y.LOAN.OVERALL.STATUS IN Y.LOAN.OVER.STATUS SETTING L.POS1 ELSE
        Y.LOAN.OVERALL.STATUS.FLAG='1'
    END
    APAP.REDOENQ.redoENofArrangmentProcess(Y.AA.ID,Y.PAYMENT.AGENCY,Y.DISBURSED.AMOUNT)  ;*R22 MANUAL CONVERSION
    APAP.REDOENQ.redoENofBillDetails(Y.AA.ID,Y.TOTAL.BALANCE.DUE,Y.COMMISSION.CHARGE.BALANCE)  ;*R22 MANUAL CONVERSION
    GOSUB CUSTOMER.CLASS
    GOSUB GET.AA.COLLATERALS    ;* PACS00312713 - S/E

    GOSUB ACCOUNT.CLASS
* PACS00312713 - 2015APR21 - Cristina's email - S
*    GOSUB CHARGE.CLASS
* PACS00312713 - 2015APR21 - Cristina's email - E
    GOSUB PAYMENT.SCHEDULE.CLASS
    GOSUB OVERDUE.CLASS
    GOSUB READ.INT.ACCRUALS
    GOSUB ARR.ACCT.ALT.ID
    IF Y.DISBURSED.AMOUNT EQ '' THEN
        Y.DISBURSED.AMOUNT ='0.00'
    END
* PACS00312713 - 2015APR21 - Cristina's email - S
    VIRTUAL.TAB.ID = 'AA.ARR.STATUS' ; Y.DES = '' ; Y.VAL = Y.LOAN.OVERALL.STATUS
    GOSUB GET.LOOK.LSTAT
    Y.LOAN.OVERALL.STATUS = Y.DES
    VIRTUAL.TAB.ID = 'L.LOAN.STATUS.1' ; Y.DES = '' ; Y.VAL = Y.OVERDUE.LOAN.STATUS
    GOSUB GET.LOOK.LSTAT
    Y.LOAN.STATUS = FIELD(Y.LOAN.STATUS,",",1) : "," :Y.DES
* PACS00312713 - 2015APR21 - Cristina's email - E
    GOSUB FINAL.ARRAY
RETURN

*-----------------------------------------------------------------------------
GET.LOOK.LSTAT:
*-----------------------------------------------------------------------------

    CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
    Y.LOOKUP.LIST = VIRTUAL.TAB.ID<2>
    Y.LOOKUP.LIST = CHANGE(Y.LOOKUP.LIST,'_',@FM )
*
    Y.DESC.LIST = VIRTUAL.TAB.ID<11>
    Y.DESC.LIST = CHANGE(Y.DESC.LIST,'_',@FM)
*
    W.FLG = '' ; W.POS = ''
    W.CNT = DCOUNT(Y.DESC.LIST,@FM)
    LOOP
    WHILE W.CNT GT 0 DO
        W.FLG += 1
        LOCATE Y.VAL IN Y.LOOKUP.LIST SETTING W.POS THEN
            Y.DES = Y.DESC.LIST<W.POS,LNGG>
            RETURN
        END
        W.CNT -= 1
    REPEAT
RETURN

*-----------------------------------------------------------------------------
ERROR.CHECK:
*-----------------------------------------------------------------------------
    IF Y.AGENCY.VAL NE '' THEN
        CALL CACHE.READ(FN.COMPANY, Y.AGENCY.VAL, R.COMP, Y.ERR.COMPANY)  ;*R22 AUTO CONVERSION F.READ TO CACHE.READ AND REMOVED F.COMPANY
        IF R.COMP EQ '' THEN
            ENQ.ERROR = "EB-INVALID.CO.CODE"
        END
    END
    IF Y.LOAN.STATUS.VAL NE '' THEN
        Y.LOAN.STAT = "Current 0-30 days":@FM:"Overdue from 31 to 90 days":@FM:"Overdue more than 90 days":@FM:"Normal":@FM:"JudicialCollection":@FM:"Restructured":@FM:"Write-off":@FM:"GRC":@FM:"DEL":@FM:"NAB"    ;* PACS00312713 - 2014NOV04 - S/E
        LOCATE Y.LOAN.STATUS.VAL IN Y.LOAN.STAT SETTING LN.POS THEN
        END ELSE
            ENQ.ERROR = "EB-INVALID.LOAN.STATUS"
        END
    END
    IF Y.EXPIRATION.DATE.FROM.VAL NE '' AND Y.EXPIRATION.DATE.TO.VAL NE '' THEN
        IF Y.EXPIRATION.DATE.FROM.VAL GT Y.EXPIRATION.DATE.TO.VAL THEN
            ENQ.ERROR = "EB-DATE.LESS.THAN.DATE"
        END
    END
RETURN
*-----------------------------------------------------------------------------
SELECT.CMD:
*-----------------------------------------------------------------------------
    SEL.CMD.AA = "SELECT ":FN.AA.ARRANGEMENT:" WITH (PRODUCT.GROUP EQ '":Y.LOAN.PORTFOLIO.TYPE.VAL:"')"
    SEL.CMD.AA :=" AND (PRODUCT EQ '":Y.PRODUCT.TYPE.VAL:"')"
    IF Y.AGENCY.VAL NE '' THEN
        SEL.CMD.AA = SEL.CMD.AA:" AND (CO.CODE EQ ":Y.AGENCY.VAL:")"
    END
    IF Y.OVERALL.STATUS.VAL NE '' THEN
        SEL.CMD.AA = SEL.CMD.AA:" AND (ARR.STATUS EQ ":Y.OVERALL.STATUS.VAL:")"
    END
RETURN
*----------------------------------------------------------------------------
LOAN.SELECT:
*----------------------------------------------------------------------------

    Y.STATUS.FLAGE = ''
    Y.STATUS = R.OVERDUE.CONDITION<AA.OD.LOCAL.REF,L.LOAN.STATUS.POS>
    Y.STAT=Y.STATUS
    CHANGE @SM TO @FM IN Y.STAT
    CHANGE @VM TO @FM IN Y.STAT
    IF Y.STATUS EQ '' THEN
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCOUNT.DETAILS.ERR)
        Y.LOAN.STATUS=R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
    END
    Y.STAT.COUNT = DCOUNT(Y.STATUS,@SM)
    Y.COUNT2 = 1
    Y.AA.STATUS = "Current 0-30 days":@FM:"Overdue from 31 to 90 days":@FM:"Overdue more than 90 days":@FM:"GRC":@FM:"NAB":@FM:"DEL"
    IF Y.LOAN.STATUS.VAL NE '' THEN
        LOCATE Y.LOAN.STATUS.VAL IN Y.STAT SETTING L.S.POS ELSE
            LOCATE Y.LOAN.STATUS.VAL IN Y.AA.STATUS SETTING AA.POS THEN
                IF Y.LOAN.STATUS.VAL NE Y.LOAN.STATUS THEN
                    Y.STATUS.FLAGE = '1'
                END
            END ELSE
                Y.STATUS.FLAGE='1'
            END
        END
        IF Y.LOAN.STATUS.VAL EQ "Current 0-30 days" THEN
            Y.LOAN.STATUS.VAL ="GRC"
        END
        IF Y.LOAN.STATUS.VAL EQ "Overdue from 31 to 90 days" THEN
            Y.LOAN.STATUS.VAL ="DEL"
        END
        IF Y.LOAN.STATUS.VAL EQ "Overdue more than 90 days" THEN
            Y.LOAN.STATUS.VAL ="NAB"
        END
        GOSUB ACCOUNT.OVERDUE
        IF Y.STATUS EQ '' THEN
            IF Y.LOAN.STATUS NE '' THEN
                LOCATE Y.LOAN.STATUS IN Y.AA.STATUS SETTING AA.POS1 ELSE
                    Y.OVER.FLAG='1'
                END
            END
        END
    END ELSE
        GOSUB OVERDUE.ACCOUNT
    END
RETURN
*----------------------------------------------------------------------------
ACCOUNT.OVERDUE:
*----------------------------------------------------------------------------
    LOOP
    WHILE Y.COUNT2 LE Y.STAT.COUNT
        Y.OVERDUE.LOAN.STATUS = FIELD(Y.STATUS,@SM,Y.COUNT2,1)
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCOUNT.DETAILS.ERR)
        Y.AA.LOAN.STATUS=R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
        IF Y.AA.LOAN.STATUS NE '' THEN
            LOCATE Y.AA.LOAN.STATUS IN Y.AA.STATUS SETTING POS.LOAN THEN
                IF Y.LOAN.STATUS EQ '' THEN
                    Y.LOAN.STATUS=Y.AA.LOAN.STATUS:",":Y.OVERDUE.LOAN.STATUS
                END ELSE
                    Y.LOAN.STATUS:=@VM:Y.AA.LOAN.STATUS:",":Y.OVERDUE.LOAN.STATUS
                END
            END ELSE
                Y.OVER.FLAG1='1'
            END
        END ELSE
            Y.LOAN.STATUS=Y.AA.LOAN.STATUS:",":Y.OVERDUE.LOAN.STATUS
        END
        Y.COUNT2 += 1
    REPEAT
RETURN
*----------------------------------------------------------------------------
OVERDUE.ACCOUNT:
*----------------------------------------------------------------------------
    LOOP
    WHILE Y.COUNT2 LE Y.STAT.COUNT
        Y.OVERDUE.LOAN.STATUS = FIELD(Y.STATUS,@SM,Y.COUNT2,1)
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCOUNT.DETAILS.ERR)
        Y.AA.LOAN.STATUS=R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
        IF Y.LOAN.STATUS EQ '' THEN
            Y.LOAN.STATUS=Y.AA.LOAN.STATUS:",":Y.OVERDUE.LOAN.STATUS
        END ELSE
            Y.LOAN.STATUS:=@VM:Y.AA.LOAN.STATUS:",":Y.OVERDUE.LOAN.STATUS
        END
        Y.COUNT2 += 1
    REPEAT
RETURN
*-----------------------------------------------------------------------------
ARR.CONDITIONS:
*-----------------------------------------------------------------------------
    ArrangementID = Y.AA.ID ; idProperty = ''; effectiveDate = ''; returnIds = ''; R.CONDITION =''; returnConditions = ''; returnError = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 Utility Changes
RETURN
*-----------------------------------------------------------------------------
CUSTOMER.CLASS:
*-----------------------------------------------------------------------------
    idPropertyClass = "CUSTOMER"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        RETURN
    END
    R.CONDITION = RAISE(returnConditions)
    IF R.CONDITION THEN
        GOSUB CUST.DET
    END
RETURN
*----------------------------------------------------------------------
CUST.DET:
*----------------------------------------------------------------------
*Y.PRI.OWNER=R.CONDITION<AA.CUS.PRIMARY.OWNER>
    Y.PRI.OWNER=R.CONDITION<AA.CUS.CUSTOMER>  ;*R22 Manual CONVERSION
    CALL F.READ(FN.CUSTOMER,Y.PRI.OWNER,R.CUS,F.CUSTOMER,CUS.ERR)
    Y.CLIENT.NAME =R.CUS<EB.CUS.SHORT.NAME>
*Y.OWNER.LIST=R.CONDITION<AA.CUS.OWNER>
    Y.OWNER.LIST=R.CONDITION<AA.CUS.CUSTOMER> ;*R22 Manual Conversion
    Y.OWNER.LIST.SIZE=DCOUNT(Y.OWNER.LIST,@VM)
    Y.OWNER.CNT=1
    CHANGE @VM TO @FM IN Y.OWNER.LIST
    IF Y.OWNER.LIST.SIZE NE '' THEN
        LOOP
        WHILE Y.OWNER.CNT LE Y.OWNER.LIST.SIZE
            IF Y.PRI.OWNER NE Y.OWNER.LIST<Y.OWNER.CNT> THEN
                Y.CUS.ID=Y.OWNER.LIST<Y.OWNER.CNT>
                GOSUB CUST.NAME
            END
            Y.OWNER.CNT += 1
        REPEAT
    END
* PACS00312713 - 2015APR21 - Cristina's email - S
    Y.PAYMENT.AGENCY = R.CUS<EB.CUS.CO.CODE>
    Y.REGION.NUMBER  = R.CONDITION<AA.CUS.LOCAL.REF,L.AA.CUS.TICAM.POS>
    Y.REGION.FLAG    = ''
    IF Y.REGION.VAL AND Y.REGION.VAL NE Y.REGION.NUMBER THEN
        Y.REGION.FLAG = 1
    END
* PACS00312713 - 2015APR21 - Cristina's email - E

RETURN
*----------------------------------------------------------------------
CUST.NAME:
*----------------------------------------------------------------------
    CALL F.READ(FN.CUSTOMER,Y.CUS.ID,R.CUS,F.CUSTOMER,CUS.ERR)
    IF Y.CLIENT.NAME NE '' THEN
        Y.CLIENT.NAME := @VM:R.CUS<EB.CUS.SHORT.NAME>
    END
RETURN
*-----------------------------------------------------------------------------
ACCOUNT.CLASS:
*-----------------------------------------------------------------------------
    idPropertyClass = "ACCOUNT"
    GOSUB ARR.CONDITIONS
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 Utility Changes
    IF returnError THEN
        RETURN
    END
    R.CONDITION = RAISE(returnConditions)
    IF R.CONDITION THEN
        Y.PREVIOUS.LOAN.NUMBER=R.CONDITION<AA.AC.ALT.ID>
        Y.LOAN.SOURCE.AGENCY=R.CONDITION<AA.AC.LOCAL.REF,L.AA.AGNCY.CODE.POS>
    END
RETURN
*-----------------------------------------------------------------------------
PAYMENT.SCHEDULE.CLASS:
*-----------------------------------------------------------------------------
    idPropertyClass = "PAYMENT.SCHEDULE"
    GOSUB ARR.CONDITIONS
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 Utility Changes
    IF returnError THEN
        RETURN
    END

    R.CONDITION = RAISE(returnConditions)
    IF R.CONDITION THEN
* PACS00312713 - 2015APR21 - Cristina's email - S
*        Y.FEE.AMOUNT=R.CONDITION<AA.PS.CALC.AMOUNT>
* PACS00312713 - 2015APR21 - Cristina's email - E
        Y.FEE.AMOUNT=R.CONDITION<AA.PS.ACTUAL.AMT>
    END
    CHANGE @VM TO '' IN  Y.FEE.AMOUNT
RETURN
*-----------------------------------------------------------------------------
CHARGE.CLASS:
*-----------------------------------------------------------------------------
    idPropertyClass = "CHARGE"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        RETURN
    END
    R.CONDITION = RAISE(returnConditions)
    IF R.CONDITION THEN
        Y.INSURANCE.BALANCE=R.CONDITION<AA.CHG.LOCAL.REF,L.MON.TOT.PRE.AMT.POS>
    END
    IF Y.INSURANCE.BALANCE EQ '' THEN
        Y.INSURANCE.BALANCE ='0.00'
    END
RETURN
*-----------------------------------------------------------------------------
GET.AA.COLLATERALS:
*-----------------------------------------------------------------------------
    COL.ID.LINKED      = ''             ; Y.COL.IDS        = ''
    Y.GUARANTEE.NUMBER = 'Sin Garantia' ; Y.GUARANTEE.TYPE = 'Sin Garantia'
*    CALL REDO.COL.AA.GET.LINKS.COL(Y.AA.ID,COL.ID.LINKED)
    APAP.AA.redoColAaGetLinksCol(Y.AA.ID,COL.ID.LINKED) ;*R22 Manual Code Converison
    IF COL.ID.LINKED NE "ERROR" THEN
        MMARK        = CHARX(251)
        Y.COL.IDS    = CHANGE(COL.ID.LINKED, MMARK , @VM )
        Y.CL.NUM     = DCOUNT(Y.COL.IDS<1>,@VM)
        Y.CL.ID      = 1
        LOOP
        WHILE Y.CL.ID LE Y.CL.NUM
            Y.GUARANTEE.NUMBER = FIELD(Y.COL.IDS<1>,@VM,Y.CL.ID)
            R.COLLATERAL       = ''
            CALL F.READ(FN.COLLATERAL,Y.GUARANTEE.NUMBER,R.COLLATERAL,F.COLLATERAL,Y.COLLATERAL.ERR)
            IF R.COLLATERAL NE "" THEN
                Y.GUARANTEE.TYPE   = R.COLLATERAL<COLL.COLLATERAL.CODE>
            END
            Y.CL.ID += 1
        REPEAT
    END

RETURN
*-----------------------------------------------------------------------------
OVERDUE.CLASS:
*-----------------------------------------------------------------------------
    idPropertyClass = "OVERDUE"
    GOSUB ARR.CONDITIONS
    IF returnError THEN
        RETURN
    END
    R.OVERDUE.CONDITION = RAISE(returnConditions)
    IF R.OVERDUE.CONDITION THEN
        GOSUB LOAN.SELECT
    END
RETURN
*-----------------------------------------------------------------------------
READ.INT.ACCRUALS:
*-----------------------------------------------------------------------------
    Y.INT.ACC.ID=Y.AA.ID:'-':'PRINCIPALINT' ;
    CALL F.READ(FN.AA.INTEREST.ACCRUALS,Y.INT.ACC.ID,R.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS,Y.AA.INTEREST.ACCRUALS.ERR)
    Y.INTEREST.RATE=R.AA.INTEREST.ACCRUALS<AA.INT.ACC.RATE,1,1>
* PACS00312713 - S
    IF Y.INTEREST.RATE EQ '' THEN
        GOSUB GET.RATEINT.ARRCOND
    END
    IF Y.INTEREST.RATE EQ '' THEN
        Y.INTEREST.RATE ='0.00'
    END
* PACS00312713 - E
RETURN
*-----------------------------------------------------------------------------
********************
GET.RATEINT.ARRCOND:
********************

    Y.ARRG.ID = Y.AA.ID
    PROP.NAME = 'PRINCIPAL'     ;* Interest Property to obtain
*   CALL REDO.GET.INTEREST.PROPERTY(Y.ARRG.ID,PROP.NAME,OUT.PROP,ERR)
    APAP.TAM.redoGetInterestProperty(Y.ARRG.ID,PROP.NAME,OUT.PROP,ERR) ;*R22 Manual Code Converison
    Y.PRIN.PROP = OUT.PROP      ;* This variable hold the value of principal interest property

    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PRIN.PROP
    EFF.DATE = ''
    ERR.MSG = ''
    R.INT.ARR.COND = ''
    Y.FIXED.RATE.ARR = ''
*   CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG) ;*R22 Manual Code Converison
    IF R.INT.ARR.COND NE '' THEN
        Y.FIXED.RATE.ARR = R.INT.ARR.COND<AA.INT.FIXED.RATE>
    END

    IF Y.FIXED.RATE.ARR AND COUNT(Y.FIXED.RATE.ARR,'.') NE 1 THEN
        Y.INTEREST.RATE  = Y.FIXED.RATE.ARR:'.00'
    END

    IF Y.FIXED.RATE.ARR AND FIELD(Y.FIXED.RATE.ARR,'.',2) GT 0 THEN
        Y.INTEREST.RATE  = Y.FIXED.RATE.ARR
    END

RETURN
*----------------------------------------------------------------------
ARR.ACCT.ALT.ID:
*----------------------------------------------------------------------
*    Y.AA.ARR.LINK.APPLN = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
    Y.AA.ARR.LINK.APPLN = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedAppl> ;*Manual R22 Conversion
    IF Y.AA.ARR.LINK.APPLN EQ 'ACCOUNT' THEN
*        Y.ACCT.NO =  R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        Y.ACCT.NO =  R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedApplId> ;*Manual R22 Conversion
    END
    GOSUB ACCT.ACT.BK.BAL
    GOSUB ACCT.INT.BAL
    GOSUB INSU.ACT.BK.BAL       ;* PACS00312713 - 2015APR21 - Cristina's email - S/E
RETURN
*-----------------------------------------------------------------------------
ACCT.INT.BAL:
*-----------------------------------------------------------------------------
* PACS00312713 - 2015APR21 - Cristina's email - S
    Y.BALANCE.TO.CHECK.ARRAY = 'ACCPRINCIPALINT':@VM:'DUEPRINCIPALINT':@VM:'ACCPENALTINT':@VM:'GRCPRINCIPALINT':@VM:'DELPRINCIPALINT':@VM:'NABPRINCIPALINT':@VM:'DE1PRINCIPALINT'
* PACS00312713 - 2015APR21 - Cristina's email - E

    IF Y.BALANCE.TO.CHECK.ARRAY THEN
        LOOP
            REMOVE BALANCE.TO.CHECK FROM Y.BALANCE.TO.CHECK.ARRAY SETTING Y.BAL.CHECK.POS
        WHILE BALANCE.TO.CHECK:Y.BAL.CHECK.POS
            DATE.OPTIONS = ''
            EFFECTIVE.DATE = TODAY
            DATE.OPTIONS<4>  = 'ECB'
            BALANCE.AMOUNT = ""
*CALL AA.GET.PERIOD.BALANCES(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
            AA.Framework.GetPeriodBalances(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "");* R22 Utility Changes
            IF NOT(Y.INTEREST.BALANCE) THEN
                Y.INTEREST.BALANCE =  BAL.DETAILS<IC.ACT.BALANCE>
            END ELSE
                Y.INTEREST.BALANCE = Y.INTEREST.BALANCE + BAL.DETAILS<IC.ACT.BALANCE>
            END
        REPEAT
    END
    IF Y.INTEREST.BALANCE EQ '' THEN
        Y.INTEREST.BALANCE ='0.00'
    END
RETURN

*----------------------------------------------------------------------
ACCT.ACT.BK.BAL:
*----------------------------------------------------------------------
*
    Y.BALANCE.TO.CHECK.ARRAY = 'CURACCOUNT':@VM:'DUEACCOUNT':@VM:'GRCACCOUNT':@VM:'DELACCOUNT':@VM:'DE1ACCOUNT':@VM:'DE3ACCOUNT':@VM:'NABACCOUNT'
    IF Y.BALANCE.TO.CHECK.ARRAY THEN
        LOOP
            REMOVE BALANCE.TO.CHECK FROM Y.BALANCE.TO.CHECK.ARRAY SETTING Y.BAL.CHECK.POS
        WHILE BALANCE.TO.CHECK:Y.BAL.CHECK.POS
            DATE.OPTIONS = ''
            EFFECTIVE.DATE = TODAY
            DATE.OPTIONS<4>  = 'ECB'
            BALANCE.AMOUNT = ""
*CALL AA.GET.PERIOD.BALANCES(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
            AA.Framework.GetPeriodBalances(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "");* R22 Utility Changes
            IF NOT(Y.CAPITAL.BALANCE) THEN
                Y.CAPITAL.BALANCE =  BAL.DETAILS<IC.ACT.BALANCE>
            END ELSE
                Y.CAPITAL.BALANCE = Y.CAPITAL.BALANCE + BAL.DETAILS<IC.ACT.BALANCE>
            END
        REPEAT
    END
    IF Y.CAPITAL.BALANCE EQ '' THEN
        Y.CAPITAL.BALANCE ='0.00'
    END
RETURN

*----------------------------------------------------------------------
INSU.ACT.BK.BAL:
*----------------------------------------------------------------------
*
    Y.BALANCE.TO.CHECK.ARRAY  = "ACCSEGPROPIEDADPR":@VM:"ACCSEGVIDAPR":@VM:"DUESEGPROPIEDADPR":@VM:"DUESEGVIDAPR"
    Y.BALANCE.TO.CHECK.ARRAY := @VM:"GRCSEGPROPIEDADPR":@VM:"DELSEGPROPIEDADPR":@VM:"NABSEGPROPIEDADPR":@VM:"GRCSEGVIDAPR"
    Y.BALANCE.TO.CHECK.ARRAY := @VM:"DELSEGVIDAPR":@VM:"NABSEGVIDAPR"
*
    IF Y.BALANCE.TO.CHECK.ARRAY THEN
        LOOP
            REMOVE BALANCE.TO.CHECK FROM Y.BALANCE.TO.CHECK.ARRAY SETTING Y.BAL.CHECK.POS
        WHILE BALANCE.TO.CHECK:Y.BAL.CHECK.POS
            DATE.OPTIONS = ''
            EFFECTIVE.DATE  = TODAY
            DATE.OPTIONS<4>  = 'ECB'
            BAL.DETAILS     = ''
*CALL AA.GET.PERIOD.BALANCES(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
            AA.Framework.GetPeriodBalances(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "");* R22 Utility Changes
            IF NOT(Y.INSURANCE.BALANCE) THEN
                Y.INSURANCE.BALANCE =  BAL.DETAILS<IC.ACT.BALANCE>
            END ELSE
                Y.INSURANCE.BALANCE = Y.INSURANCE.BALANCE + BAL.DETAILS<IC.ACT.BALANCE>
            END
        REPEAT
    END
    IF Y.INSURANCE.BALANCE EQ '' THEN
        Y.INSURANCE.BALANCE ='0.00'
    END
    Y.INSURANCE.BALANCE = ABS(Y.INSURANCE.BALANCE)
RETURN
*----------------------------------------------------------------------
FINAL.ARRAY:
*----------------------------------------------------------------------

    IF Y.FEE.AMOUNT EQ '' THEN
        Y.FEE.AMOUNT ='0.00'
    END
    IF Y.REGION.FLAG NE '1' AND Y.OVER.FLAG NE '1' AND Y.LOAN.OVERALL.STATUS.FLAG NE '1' AND Y.STATUS.FLAGE NE '1'AND Y.OVER.FLAG1 NE '1' THEN
        Y.CURRENT.TOTAL.BALANCE=Y.COMMISSION.CHARGE.BALANCE+Y.TOTAL.BALANCE.DUE+Y.CAPITAL.BALANCE+Y.INSURANCE.BALANCE+Y.INTEREST.BALANCE

        IF LN.ARRAY EQ '' THEN
*                          1                  2                    3               4                5                        6                    7                         8                        9                         10                       11                   12                  13                  14                          15               16                  17                  18                   19                      20                         21                                  22                    23                  24                 25                     26                       27                    28                      29                       30                                 31
            LN.ARRAY = Y.LOAN.NUMBER:"*":Y.PRODUCT.TYPE:"*":Y.OPENING.DATE:"*":Y.CURRENCY:"*":Y.LOAN.OVERALL.STATUS:"*":Y.CLIENT.NAME:"*":Y.PREVIOUS.LOAN.NUMBER:"*":Y.LOAN.SOURCE.AGENCY:"*":Y.DISBURSED.AMOUNT:"*":Y.GUARANTEE.NUMBER:"*":Y.INSURANCE.BALANCE:"*":Y.GUARANTEE.TYPE:"*":Y.LOAN.STATUS:"*":Y.LOAN.EXPIRATION.DATE: "*":Y.FEE.AMOUNT:"*":Y.INTEREST.RATE:"*":Y.PAYMENT.AGENCY:"*":Y.CAPITAL.BALANCE:"*":Y.INTEREST.BALANCE:"*":Y.TOTAL.BALANCE.DUE:"*":Y.COMMISSION.CHARGE.BALANCE:"*":Y.CURRENT.TOTAL.BALANCE:"*":Y.REGION.NUMBER:"*":Y.AGENCY.VAL:"*":Y.OVERALL.STATUS.VAL:"*":Y.PRODUCT.TYPE.VAL:"*":Y.LOAN.PORTFOLIO.TYPE.VAL:"*":Y.REGION.VAL:"*":Y.LOAN.STATUS.VAL:"*":Y.EXPIRATION.DATE.FROM.VAL:"*":Y.EXPIRATION.DATE.TO.VAL
        END ELSE
            LN.ARRAY<-1> = Y.LOAN.NUMBER:"*":Y.PRODUCT.TYPE:"*":Y.OPENING.DATE:"*":Y.CURRENCY:"*":Y.LOAN.OVERALL.STATUS:"*":Y.CLIENT.NAME:"*":Y.PREVIOUS.LOAN.NUMBER:"*":Y.LOAN.SOURCE.AGENCY:"*":Y.DISBURSED.AMOUNT:"*":Y.GUARANTEE.NUMBER:"*":Y.INSURANCE.BALANCE:"*":Y.GUARANTEE.TYPE:"*":Y.LOAN.STATUS:"*":Y.LOAN.EXPIRATION.DATE: "*":Y.FEE.AMOUNT:"*":Y.INTEREST.RATE:"*":Y.PAYMENT.AGENCY:"*":Y.CAPITAL.BALANCE:"*":Y.INTEREST.BALANCE:"*":Y.TOTAL.BALANCE.DUE:"*":Y.COMMISSION.CHARGE.BALANCE:"*":Y.CURRENT.TOTAL.BALANCE:"*":Y.REGION.NUMBER:"*":Y.AGENCY.VAL:"*":Y.OVERALL.STATUS.VAL:"*":Y.PRODUCT.TYPE.VAL:"*":Y.LOAN.PORTFOLIO.TYPE.VAL:"*":Y.REGION.VAL:"*":Y.LOAN.STATUS.VAL:"*":Y.EXPIRATION.DATE.FROM.VAL:"*":Y.EXPIRATION.DATE.TO.VAL
        END
    END
    Y.STATUS.FLAGE ='';Y.REGION.FLAG ='';Y.OVER.FLAG='';Y.LOAN.STATUS='';Y.LOAN.OVERALL.STATUS='';Y.DISBURSED.AMOUNT='0.00';Y.CURRENT.TOTAL.BALANCE='0.00';Y.COMMISSION.CHARGE.BALANCE='0.00';Y.TOTAL.BALANCE.DUE='0.00';Y.INTEREST.BALANCE='0.00';Y.CAPITAL.BALANCE='0.00';Y.INTEREST.RATE='0.00';Y.FEE.AMOUNT='0.00';Y.INSURANCE.BALANCE='0.00';Y.REGION.NUMBER='';Y.LOAN.OVERALL.STATUS.FLAG ='';Y.OVER.FLAG1=''
RETURN
END
