* @ValidationCode : MjoxOTUwOTQ4NzQzOlVURi04OjE3MDU5MTkwMDg2NzU6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Jan 2024 15:53:28
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
SUBROUTINE REDO.NOF.INS.DAILY.REPORT(Y.OUT.ARRAY)
*-----------------------------------------------------------------------------
*  Company   Name    : Asociacion Popular de Ahorros y Prestamos
*  Developed By      : Renugadevi B
*  ODR Number        : ODR-2010-03-0110
*  Program   Name    : REDO.NOF.INS.DAILY.REPORT
*-----------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : Y.OUT.ARRAY
*-----------------------------------------------------------------------------
* DESCRIPTION       : This is a NOFILE enquiry routine to get a report that shows
*                     all insurance daily entries report
*------------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE            WHO             REFERENCE            DESCRIPTION
*  -----           ----            ----------           -----------
*  18-Oct-2010     Renugadevi B    ODR-2010-03-0140     INITIAL CREATION
* 13-APRIL-2023      Conversion Tool       R22 Auto Conversion - VM to @VM , FM to @FM  and SM to @SM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*19-01-2024      Narmadha V    R22 Utility Changes,Manual R22 Conversion   Call Routine Format Modified

*-------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
*    $INSERT I_F.AA.ARRANGEMENT ;*Manual R22 Conversion
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.REDO.T.AUTH.ARRANGEMENT
    $USING AA.Framework ;*Manual R22 Conversion

    GOSUB OPENFILES
    GOSUB GET.LOCAL.REF
    GOSUB PROCESS
RETURN

**********
OPENFILES:
**********
    Y.BALANCE                  = '' ; Y.PREV.LOAN.NUM  = '' ; Y.PRODUCT.TYPE  = '' ; Y.AGENCY  = '' ; Y.POLICY.TYPE  = '' ; Y.POLICY.NUMBER = '' ; Y.POL.STATUS = ''
    Y.RECEIVE.PRE              = '' ; Y.PAYABLE.PRE    = '' ; Y.NET.PREM.BAL  = '' ; Y.CURRENT.ACCOUNT  = '' ; Y.LOAN.STATUS = '' ; Y.CURRENCY = '' ; Y.STATUS2 = ''
    Y.POL.COMP.TYPE            = ''
    FN.AA.ACCOUNT.DETAILS      = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS       = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ARRANGEMENT          = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT           = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ARR.ACCOUNT          = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT           = ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)

    FN.AA.ARR.CHARGE           = 'F.AA.ARR.CHARGE'
    F.AA.ARR.CHARGE            = ''
    CALL OPF(FN.AA.ARR.CHARGE,F.AA.ARR.CHARGE)

    FN.AA.ARR.OVERDUE          = 'F.AA.ARR.OVERDUE'
    F.AA.ARR.OVERDUE           = ''
    CALL OPF(FN.AA.ARR.OVERDUE,F.AA.ARR.OVERDUE)

    FN.AA.BILL.DETAILS         = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS          = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.AA.PROPERTY             = 'F.AA.PROPERTY'
    F.AA.PROPERTY              = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)

    FN.ALTERNATE.ACCOUNT       = 'F.ALTERNATE.ACCOUNT'
    F.ALTERNATE.ACCOUNT        = ''
    CALL OPF(FN.ALTERNATE.ACCOUNT,F.ALTERNATE.ACCOUNT)

    FN.RE.STAT.REP.LINE        = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE         = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.ACCOUNT                 = 'F.ACCOUNT'
    F.ACCOUNT                  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER                = 'F.CUSTOMER'
    F.CUSTOMER                 = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.T.AUTH.ARRANGEMENT = 'F.REDO.T.AUTH.ARRANGEMENT'
    F.REDO.T.AUTH.ARRANGEMENT  = ''
    CALL OPF(FN.REDO.T.AUTH.ARRANGEMENT,F.REDO.T.AUTH.ARRANGEMENT)
RETURN

**************
GET.LOCAL.REF:
**************
    APPL.ARRAY              = 'AA.ARR.ACCOUNT':@FM:'AA.ARR.CHARGE':@FM:'AA.ARR.OVERDUE'
    FLD.ARRAY               = 'POLICY.STATUS':@FM:'INS.POLICY.TYPE':@VM:'POLICY.NUMBER':@FM:'L.LOAN.STATUS.1'
    FLD.POS                 = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.POL.STATUS.POS        = FLD.POS<1,1>
    L.INS.POLICY.TYPE.POS   = FLD.POS<2,1>
    L.POLICY.NUMBER.POS     = FLD.POS<2,2>
    L.LOAN.STATUS.POS       = FLD.POS<3,1>
RETURN

********
PROCESS:
********
    SEL.CMD = "SELECT ":FN.REDO.T.AUTH.ARRANGEMENT
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

    LOOP
        REMOVE Y.AA.ID FROM SEL.LIST SETTING POS1
    WHILE Y.AA.ID:POS1
        CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.ACCT.DETS,F.AA.ACCOUNT.DETAILS,ACCT.ERR)
        Y.BILL.ARR      = R.ACCT.DETS<AA.AD.BILL.ID>
        ArrangementID = Y.AA.ID ; idPropertyClass = 'CHARGE'; effectiveDate = ''; returnIds = ''; returnConditions =''; returnError = ''; idProperty = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
        AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 Utility Changes
        R.CONDITION        = RAISE(returnConditions)
        Y.POLICY.TYPE      = R.CONDITION<AA.CHG.LOCAL.REF,L.INS.POLICY.TYPE.POS>
        IF NOT(Y.POLICY.TYPE) THEN
            CONTINUE
        END
        Y.POLICY.NUMBER    = R.CONDITION<AA.CHG.LOCAL.REF,L.POLICY.NUMBER.POS>

        LOOP
            REMOVE Y.BILL.ID FROM Y.BILL.ARR SETTING BILL.POS
        WHILE Y.BILL.ID:BILL.POS
            IF Y.BILL.ID THEN
                CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.BILL.DETS,F.AA.BILL.DETAILS,BILL.ERR)
                Y.PAY.PROPERTY = R.BILL.DETS<AA.BD.PAY.PROPERTY>
                Y.PROPERTY     = R.BILL.DETS<AA.BD.PROPERTY>
                Y.PAY.DATE     = R.BILL.DETS<AA.BD.PAYMENT.DATE>
                GOSUB GET.REPAY
                IF Y.PAY.DATE EQ TODAY AND Y.REPAY.REF EQ TODAY THEN
                    GOSUB FETCH.BILL.CONDITION
                END
            END
        REPEAT
    REPEAT
RETURN
**********
GET.REPAY:
**********
    Y.REPAY = R.BILL.DETS<AA.BD.REPAY.REF>
    LOOP
        REMOVE Y.REP.ID FROM Y.REPAY SETTING Y.REP.POS
    WHILE Y.REP.ID : Y.REP.POS
        IF Y.REP.ID THEN
            Y.REPAY.REF = FIELD(Y.REP.ID,'-',2)
            Y.REPAY = ''
        END
    REPEAT
RETURN
*********************
FETCH.BILL.CONDITION:
*********************

*    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    R.ARRANGEMENT = AA.Framework.Arrangement.Read(Y.AA.ID, ARR.ERR) ;*Manual R22 Conversion
*    Y.AGENCY        = R.ARRANGEMENT<AA.ARR.CO.CODE>
    Y.AGENCY        = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrCoCode> ;*Manual R22 Conversion
*    Y.CUST          = R.ARRANGEMENT<AA.ARR.CUSTOMER>
    Y.CUST          = R.ARRANGEMENT<AA.Framework.ArrangementSim.ArrCustomer> ;*Manual R22 Conversion
    CALL F.READ(FN.CUSTOMER,Y.CUST,R.CUSTOMER,F.CUSTOMER,CUST.ERR)
    Y.SECTOR        = R.CUSTOMER<EB.CUS.SECTOR>
*    Y.PRODUCT.TYPE  = R.ARRANGEMENT<AA.ARR.PRODUCT>
    Y.PRODUCT.TYPE  = R.ARRANGEMENT<AA.Framework.Arrangement.ArrProduct> ;*Manual R22 Conversion
*    Y.CURRENCY      = R.ARRANGEMENT<AA.ARR.CURRENCY>
    Y.CURRENCY      = R.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency> ;*Manual R22 Conversion
    GOSUB GET.AA.ACCT.DETAILS
    GOSUB GET.AA.CHARGE.DETAILS
    GOSUB GET.AA.OVERDUE.DETAILS

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.ARR.ACCOUNT,F.AA.ACCOUNT.DETAILS,ACC.ERR)
    Y.STAT           = R.ARR.ACCOUNT<AA.AD.ARR.AGE.STATUS>
    IF Y.STAT EQ 'GRC' THEN
        Y.STATUS2  = 'Current 0-30 days'
    END
    IF Y.STAT EQ 'DEL' THEN
        Y.STATUS2  = 'Overdue from 31 to 90 days'
    END
    IF Y.STAT EQ 'NAB' THEN
        Y.STATUS2  = 'Overdue more than 90 days'
    END
    Y.LOAN.STATUS        = Y.STATUS1:" ":Y.STATUS2

    GOSUB GET.BALANCE.DETAILS
    GOSUB GET.CURR.ACCT.DET

    Y.OUT.ARRAY<-1> = Y.AA.ID:"*":Y.PREV.LOAN.NUM:"*":Y.PRODUCT.TYPE:"*":Y.AGENCY:"*":Y.POLICY.TYPE:"*":Y.POLICY.NUMBER:"*":Y.POL.COMP.TYPE:"*":Y.RECEIVE.PRE:"*":Y.PAYABLE.PRE:"*":Y.NET.PREM.BAL:"*":Y.CURRENT.ACCOUNT:"*":Y.LOAN.STATUS:"*":Y.POL.STATUS:"*":Y.CURRENCY
    Y.STATUS2 = ''
RETURN

********************
GET.AA.ACCT.DETAILS:
********************

    ArrangementID = Y.AA.ID ; idPropertyClass = 'ACCOUNT'; effectiveDate = ''; returnIds = ''; returnConditions =''; returnError = ''; idProperty = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 Utility Changes
    R.CONDITION        = RAISE(returnConditions)
    Y.PREV.LOAN.NUM    = R.CONDITION<AA.AC.ALT.ID>
    Y.POL.STATUS       = R.CONDITION<AA.AC.LOCAL.REF,L.POL.STATUS.POS>
RETURN

**********************
GET.AA.CHARGE.DETAILS:
**********************
    ArrangementID = Y.AA.ID ; idPropertyClass = 'CHARGE'; effectiveDate = ''; returnIds = ''; returnConditions =''; returnError = ''; idProperty = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 Utility Changes
    R.CONDITION        = RAISE(returnConditions)
    Y.POLICY.TYPE      = R.CONDITION<AA.CHG.LOCAL.REF,L.INS.POLICY.TYPE.POS>
    Y.POLICY.NUMBER    = R.CONDITION<AA.CHG.LOCAL.REF,L.POLICY.NUMBER.POS>
RETURN

***********************
GET.AA.OVERDUE.DETAILS:
***********************

    ArrangementID = Y.AA.ID ; idPropertyClass = 'OVERDUE'; effectiveDate = ''; returnIds = ''; returnConditions =''; returnError = ''; idProperty = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
    AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 Utility Changes
    R.CONDITION        = RAISE(returnConditions)
    Y.STATUS1          = R.CONDITION<AA.OD.LOCAL.REF,L.LOAN.STATUS.POS>
RETURN

******************
GET.CURR.ACCT.DET:
******************
    CALL F.READ(FN.ALTERNATE.ACCOUNT,Y.AA.ID,R.ALTERNATE.ACCT,F.ALTERNATE.ACCOUNT,ALTER.ERR)
    Y.ACCT.NO          = R.ALTERNATE.ACCT<AAC.GLOBUS.ACCT.NUMBER>
    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,AC.ERR)
    Y.CATEG            = R.ACCOUNT<AC.CATEGORY>
    SEL.CMD1 = "SELECT ":FN.RE.STAT.REP.LINE:" WITH ASSET.APPLIC.ID EQ AC AND WITH ASSET1 EQ ":Y.CATEG:" AND WITH ASSET2 EQ ":Y.SECTOR
    CALL EB.READLIST(SEL.CMD1,SEL.LIST1,'',NO.OF.REC1,RET.CODES)
    IF SEL.LIST1 THEN
        CALL F.READ(FN.RE.STAT.REP.LINE,SEL.LIST1,R.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE,STAT.REP.LINE.ERR)
        Y.CURRENT.ACCOUNT  = R.RE.STAT.REP.LINE<RE.SRL.DESC,2>
    END
RETURN

********************
GET.BALANCE.DETAILS:
********************
    Y.RECEIVE.PRE      = ''
    Y.PAYABLE.PRE      = ''
    Y.PAY.PROPERTY     = R.BILL.DETS<AA.BD.PAY.PROPERTY>
    Y.CNT              = DCOUNT(Y.PAY.PROPERTY,@SM)
    Y.INIT             = 1
    LOOP
    WHILE Y.INIT LE Y.CNT
        Y.PROP.ID     = R.BILL.DETS<AA.BD.PAY.PROPERTY,1,Y.INIT>
        ArrangementID = Y.AA.ID ; idPropertyClass = 'CHARGE'; effectiveDate = ''; returnIds = ''; returnConditions ='';returnError = ''; idProperty = Y.PROP.ID
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError)
        AA.Framework.GetArrangementConditions(ArrangementID, idPropertyClass, idProperty, effectiveDate, returnIds, returnConditions, returnError);* R22 Utility Changes
        R.CONDITION        = RAISE(returnConditions)
        IF R.CONDITION<AA.CHG.LOCAL.REF,L.INS.POLICY.TYPE.POS> NE '' THEN
            IF R.BILL.DETS<AA.BD.OS.PR.AMT,1,Y.INIT> AND R.BILL.DETS<AA.BD.OR.PR.AMT,1,Y.INIT> THEN
                Y.RECEIVE.PRE   += R.BILL.DETS<AA.BD.OS.PR.AMT,1,Y.INIT>
                Y.PAY.FEE        = R.BILL.DETS<AA.BD.OR.PR.AMT,1,Y.INIT> - R.BILL.DETS<AA.BD.OS.PR.AMT,1,Y.INIT>
                Y.PAYABLE.PRE   += Y.PAY.FEE
                Y.POL.COMP.TYPE  = "All"
            END
            IF R.BILL.DETS<AA.BD.OS.PR.AMT,1,Y.INIT> AND NOT(R.BILL.DETS<AA.BD.OR.PR.AMT,1,Y.INIT>) THEN
                Y.RECEIVE.PRE   += R.BILL.DETS<AA.BD.OS.PR.AMT,1,Y.INIT>
                Y.POL.COMP.TYPE  = "Receivable Premium"
            END
            IF NOT(R.BILL.DETS<AA.BD.OS.PR.AMT,1,Y.INIT>) AND R.BILL.DETS<AA.BD.OR.PR.AMT,1,Y.INIT> THEN
                Y.PAYABLE.PRE   += R.BILL.DETS<AA.BD.OR.PR.AMT,1,Y.INIT>
                Y.POL.COMP.TYPE  = "Payable Premium"
            END
        END
        Y.NET.PREM.BAL     = Y.RECEIVE.PRE + Y.PAYABLE.PRE
        Y.INIT +=1
    REPEAT
RETURN
END
