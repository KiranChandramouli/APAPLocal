* @ValidationCode : MjotMTY2NjE4NDk0OTpVVEYtODoxNzA0MjY3MTQ0MjA4OkFkbWluOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 Jan 2024 13:02:24
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
SUBROUTINE REDO.E.NOF.LOAN.SUM(Y.FINAL.ARRAY)
*------------------------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Sakthi Sellappillai
*Program Name      : REDO.NOF.FHA.INSURANCE.REPORT
*Developed for     : ODR-2010-03-0124
*Date              : 28.10.2010
*------------------------------------------------------------------------------------------------------------------
*Description:This is No File Enquiry routine,fetch the values from the selected ARRANGEMENT records for ENQUIRY.REPORT-REDO.E.LOAN.SUMMARY
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -----------------------------------------------------------------------------------------------------------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
*------------------------------------------------------------------------------------------------------------------
* Linked with : NOFILE.REDO.LOAN.ACCT.SUM - Standard Selection of REDO.LOAN.ACCT.SUMMARY(ENQUIRY)
* Calls       : AA.GET.ARRANGEMENT.CONDITIONS,AA.GET.PERIOD.BALANCES
* Called By   : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
*------------------------------------------------------------------------------------------------------------------
* Date              Name                         Reference                    Version
* -------           ----                         ----------                   --------
* 28.10.2010       Sakthi Sellappillai           ODR-2010-03-0124             Initial Version

* 13-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, SM to @SM, ++ to +=
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
*    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
*    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $USING AA.Framework
    GOSUB MAIN.PARA
    GOSUB GOEND
RETURN
*------------------------------------------------------------------------------------------------------------------
MAIN.PARA:
*------------------------------------------------------------------------------------------------------------------

    GOSUB INITIALISE.PARA
    GOSUB LOCATE.PARA
    GOSUB CHECK.SEL.CONDITIONS
RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE.PARA:
*------------------------------------------------------------------------------------------------------------------
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    R.AA.ARRANGEMENT = ''
    Y.AA.ARRANGE.ERR = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    R.ACCOUNT.REC = ''
    Y.ACCT.ERR = ''
    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
    R.RE.STAT.REP.LINE = ''
    Y.RE.STAT.REP.ERR = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    R.CUSTOMER.REC = ''
    Y.CUST.ERR = ''
    OUT.PROPERTY = ''
    Y.SEL.LOAN.STAT.VAL = ''
    Y.RE.CUR.ACCT.VAL = ''
    Y.RE.CUR.ACCT.DESC = ''
    Y.RE.SUPER.ACCT.VAL = ''
    Y.RE.STAT.REP.VAL.ARRAY = ''
    Y.RE.REQ.ASSET.VALUES = ''
    Y.AA.ARRANGE.INIT.CNT = 1
    Y.SEL.STAT.MATCH.VAL = ''
    Y.LOAN.STAT.INIT = ''
    Y.TOTAL.CAP.BAL.LIST = ''
    Y.LOAN.STAT.VAL3.LIST = ''
RETURN
*------------------------------------------------------------------------------------------------------------------
LOCATE.PARA:
*------------------------------------------------------------------------------------------------------------------
    LOCATE 'DATE' IN D.FIELDS SETTING Y.SEL.DATE.POS THEN
        Y.SEL.DATE.VAL = D.RANGE.AND.VALUE<Y.SEL.DATE.POS>
    END ELSE
        Y.SEL.DATE.VAL = ''
    END
    LOCATE 'LOAN.STATUS' IN D.FIELDS SETTING Y.SEL.LOAN.STATUS.POS THEN
        Y.SEL.LOAN.STATUS.VAL = D.RANGE.AND.VALUE<Y.SEL.LOAN.STATUS.POS>
    END ELSE
        Y.SEL.LOAN.STATUS.VAL = ''
    END
    IF Y.SEL.LOAN.STATUS.VAL THEN
        CHANGE @SM TO ' ' IN Y.SEL.LOAN.STATUS.VAL
    END
    LOCATE 'LOAN.NUMBER' IN D.FIELDS SETTING Y.SEL.LOAN.NUM.POS THEN
        Y.SEL.LOAN.NUM.VAL = D.RANGE.AND.VALUE<Y.SEL.LOAN.NUM.POS>
    END ELSE
        Y.SEL.LOAN.NUM.VAL = ''
    END

RETURN
*------------------------------------------------------------------------------------------------------------------
CHECK.SEL.CONDITIONS:
*------------------------------------------------------------------------------------------------------------------

    IF Y.SEL.LOAN.NUM.VAL THEN
*        Y.AA.LOAN.NO = Y.SEL.LOAN.NUM.VAL
        CALL F.READ(FN.ACCOUNT,Y.SEL.LOAN.NUM.VAL,R.ACCOUNT,F.ACCOUNT,Y.AC.ERR)
        Y.AA.LOAN.NO = R.ACCOUNT<AC.ARRANGEMENT.ID>
        Y.SEL.LOAN.NUM.VAL = Y.AA.LOAN.NO
        GOSUB ACCT.DETS.PROCESS
        GOSUB LOAN.PROCESS
    END ELSE
        Y.AA.ARRANGE.SEL.CMD ="SELECT ": FN.AA.ARRANGEMENT:" WITH ARR.STATUS NE AUTH AND ARR.STATUS NE UNAUTH"
        CALL EB.READLIST(Y.AA.ARRANGE.SEL.CMD,Y.AA.ARRANGE.SEL.LIST,'',Y.NO.OF.AA.ARRNGE,Y.SEL.AA.ARRANGE.ERR)
        GOSUB PROCESS.PARA
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*------------------------------------------------------------------------------------------------------------------
    IF Y.AA.ARRANGE.SEL.LIST THEN
        LOOP
            REMOVE Y.SEL.AA.ARRANGEMENT FROM Y.AA.ARRANGE.SEL.LIST SETTING Y.AA.ARRANGE.SEL.POS
        WHILE Y.SEL.AA.ARRANGEMENT : Y.AA.ARRANGE.SEL.POS
            Y.AA.LOAN.NO = Y.SEL.AA.ARRANGEMENT
            GOSUB ACCT.DETS.PROCESS
            GOSUB LOAN.PROCESS
            Y.AA.ARRANGE.INIT.CNT += 1
        REPEAT
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
ACCT.DETS.PROCESS:
*-------------------------------------------------------------------------------------------------------------------
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    R.AA.ACCOUNT.DETAILS = ''
    Y.AA.ACCT.DET.ERR = ''
    Y.AA.ACCT.DET.DATE = ''
    X.LOAN.STATUS = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.LOAN.NO,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCT.DET.ERR)
    IF NOT(Y.AA.ACCT.DET.ERR) THEN
        Y.AA.ACCT.DET.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.START.DATE>
        Y.ARR.AGE.STATUS   = R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
        GOSUB ASSIGN.STATUS
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
ASSIGN.STATUS:
*------------------------------------------------------------------------------------------------------------------
    IF Y.ARR.AGE.STATUS EQ 'DEL1' OR Y.ARR.AGE.STATUS EQ 'CUR' THEN
        X.LOAN.STATUS<1,-1> = 'Current 0-30 Days'
    END
    IF Y.ARR.AGE.STATUS EQ 'DEL' THEN
        X.LOAN.STATUS<1,-1> = 'Overdue 31-90 Days'
    END
    IF Y.ARR.AGE.STATUS EQ 'NAB' THEN
        X.LOAN.STATUS<1,-1> = 'Overdue more 90 Days'
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
LOAN.PROCESS:
*------------------------------------------------------------------------------------------------------------------
*CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.LOAN.NO,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.AA.ARRANGE.ERR)
    R.AA.ARRANGEMENT = AA.Framework.Arrangement.Read(Y.AA.LOAN.NO, Y.AA.ARRANGE.ERR)
    Y.CUST.SECTOR.VAL = ''
    Y.ACCT.CATEG.VAL = ''
    IF NOT(Y.AA.ARRANGE.ERR) THEN
*ARR.STATUS.VAL = R.AA.ARRANGEMENT<AA.ARR.ARR.STATUS>
        ARR.STATUS.VAL = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrArrStatus>
*  CURRENCY.VAL = R.AA.ARRANGEMENT<AA.ARR.CURRENCY>
        CURRENCY.VAL = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency>
*CO.CODE.VAL = R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
        CO.CODE.VAL = R.AA.ARRANGEMENT<AA.Framework.Arrangement.ArrCurrency>
*Y.LINK.APPL.VAL = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        Y.LINK.APPL.VAL = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrLinkedApplId>
*Y.ARRANGE.CUST = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
        Y.ARRANGE.CUST = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrCustomer>
        CALL F.READ(FN.CUSTOMER,Y.ARRANGE.CUST,R.CUSTOMER.REC,F.CUSTOMER,Y.CUST.ERR)
        Y.CUST.SECTOR.VAL = R.CUSTOMER.REC<EB.CUS.SECTOR>
        GOSUB ACCOUNT.PROCESS
        GOSUB AA.ARR.ACCT.PROCESS
        GOSUB AA.ARR.OVERDUE.PROCESS
        GOSUB AA.ARR.OVERDUE.SUB.PROCESS
        GOSUB FORM.FINAL.ARRAY
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
ACCOUNT.PROCESS:
*------------------------------------------------------------------------------------------------------------------
    IF Y.LINK.APPL.VAL THEN
        CALL F.READ(FN.ACCOUNT,Y.LINK.APPL.VAL,R.ACCOUNT.REC,F.ACCOUNT,Y.ACCT.ERR)
        CATEG.VAL = ''
        IF NOT(Y.ACCT.ERR) THEN
            CATEG.VAL = R.ACCOUNT.REC<AC.CATEGORY>
        END
    END
    Y.ACCT.CATEG.VAL  = CATEG.VAL
    IF Y.AA.ARRANGE.INIT.CNT EQ 1 THEN
        Y.SEL.RE.STAT.CMD = "SELECT ":FN.RE.STAT.REP.LINE
        CALL EB.READLIST(Y.SEL.RE.STAT.CMD,Y.RE.STAT.SEL.LIST,'',Y.NO.OF.RE.STAT.REC,Y.RE.STAT.SEL.ERR)
        LOOP
            REMOVE Y.RE.STAT.ID.VAL FROM Y.RE.STAT.SEL.LIST SETTING Y.RE.STAT.SEL.POS
        WHILE Y.RE.STAT.ID.VAL : Y.RE.STAT.SEL.POS
            CALL F.READ(FN.RE.STAT.REP.LINE,Y.RE.STAT.ID.VAL,R.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE,Y.RE.STAT.REP.ERR)
            IF R.RE.STAT.REP.LINE THEN
                Y.RE.STAT.REP.VAL = R.RE.STAT.REP.LINE<RE.SRL.DESC>
                IF Y.RE.STAT.REP.VAL THEN
                    Y.RE.CUR.ACCT.DUM.VAL = FIELD(Y.RE.STAT.REP.VAL,@VM,2)
                    Y.RE.CUR.ACCT.DUM.DESC = FIELD(Y.RE.STAT.REP.VAL,@VM,3)
                    Y.RE.SUPER.ACCT.DUM.VAL = FIELD(Y.RE.STAT.REP.VAL,@VM,1)
                END
                Y.RE.STAT.REP.ASSET1 = R.RE.STAT.REP.LINE<RE.SRL.ASSET1>
                Y.RE.STAT.REP.ASSET2 = R.RE.STAT.REP.LINE<RE.SRL.ASSET2>
                Y.RE.STAT.REP.ASSET.TYPE = R.RE.STAT.REP.LINE<RE.SRL.ASSET.TYPE>
            END
            Y.RE.STAT.REP.VAL.ARRAY<-1> =Y.RE.STAT.REP.ASSET1:"*":Y.RE.STAT.REP.ASSET2:"*":Y.RE.STAT.REP.ASSET.TYPE:"*":Y.RE.CUR.ACCT.DUM.VAL:"*":Y.RE.CUR.ACCT.DUM.DESC:"*":Y.RE.SUPER.ACCT.DUM.VAL
        REPEAT
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
AA.ARR.ACCT.PROCESS:
*------------------------------------------------------------------------------------------------------------------
    ARR.ID1=Y.AA.LOAN.NO
    PROP.CLASS1='ACCOUNT'
    RETURN.IDS1=''
    PRODUCT.TYPE.VAL = ''
    RETURN.COND1=''
    RETURN.ERR1=''
    R.CONDITION = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID1,PROP.CLASS1,"","",RETURN.IDS1,RETURN.COND1,RETURN.ERR1)
    AA.Framework.GetArrangementConditions(ARR.ID1,PROP.CLASS1,"","",RETURN.IDS1,RETURN.COND1,RETURN.ERR1);* R22 Utility Changes
    R.CONDITION=RAISE(RETURN.COND1)
    AL.ID.TYPE.VAL = R.CONDITION<AA.AC.ALT.ID>
    ACCOUNT.TITLE.VAL = R.CONDITION<AA.AC.ACCOUNT.TITLE.1>
    PRODUCT.TYPE.VAL = ACCOUNT.TITLE.VAL
RETURN
*------------------------------------------------------------------------------------------------------------------
AA.ARR.OVERDUE.PROCESS:
*------------------------------------------------------------------------------------------------------------------
    ARR.ID1=Y.AA.LOAN.NO
    PROP.CLASS1='OVERDUE'
    RETURN.IDS1=''
    RETURN.COND1=''
    RETURN.ERR1=''
    R.CONDITION = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID1,PROP.CLASS1,"","",RETURN.IDS1,RETURN.COND1,RETURN.ERR1)
    AA.Framework.GetArrangementConditions(ARR.ID1,PROP.CLASS1,"","",RETURN.IDS1,RETURN.COND1,RETURN.ERR1);* R22 Utility Changes
    R.CONDITION=RAISE(RETURN.COND1)
    APPL.ARRAY = "AA.PRD.DES.OVERDUE"
    FIELD.ARRAY = "L.LOAN.STATUS.1"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    Y.LOC.OVER.DUE.LOAN.STAT.POS = FIELD.POS<1,1>
    VAR.ARR.ID = Y.AA.LOAN.NO
RETURN
*------------------------------------------------------------------------------------------------------------------
AA.ARR.OVERDUE.SUB.PROCESS:
*------------------------------------------------------------------------------------------------------------------
    Y.LOAN.STAT.VALUE = ''
    Y.LOAN.STAT.VALUE = R.CONDITION<AA.OD.LOCAL.REF,Y.LOC.OVER.DUE.LOAN.STAT.POS,1>
    LOAN.STATUS.VAL = ''
    Y.LOAN.DEFULT.STAT = ''
    Y.LOAN.OD.SEL.STAT = ''
*  Y.LOAN.DEFULT.STAT = 'CUR':VM:'DUE':VM:'UNC':VM:'ACC'
    Y.LOAN.DEFULT.STAT = 'CUR':@SM:'DUE':@SM:'UNC':@SM:'ACC'
    Y.LOAN.OD.SEL.STAT = R.CONDITION<AA.OD.OVERDUE.STATUS>
*  LOAN.STATUS.VAL = Y.LOAN.DEFULT.STAT:VM:Y.LOAN.OD.SEL.STAT
    LOAN.STATUS.VAL = Y.LOAN.DEFULT.STAT:@SM:Y.LOAN.OD.SEL.STAT
    CHANGE @SM TO @FM IN LOAN.STATUS.VAL
    IF LOAN.STATUS.VAL THEN
*    Y.LOAN.STAT.CNT = DCOUNT(LOAN.STATUS.VAL,VM)
        Y.LOAN.STAT.CNT = DCOUNT(LOAN.STATUS.VAL,@FM)
        Y.LOAN.STAT.INIT = 1
        IF Y.LOAN.STAT.CNT THEN
            LOOP
                REMOVE Y.LOAN.STAT.VAL1 FROM LOAN.STATUS.VAL  SETTING Y.LOAN.STAT.POS
            WHILE Y.LOAN.STAT.INIT LE Y.LOAN.STAT.CNT
                IF Y.SEL.LOAN.STATUS.VAL THEN
                    IF Y.SEL.LOAN.STATUS.VAL EQ Y.LOAN.STAT.VALUE THEN
                        Y.SEL.LOAN.STAT.VAL = Y.LOAN.STAT.VALUE
                        Y.SEL.STAT.MATCH.VAL = 1
                        GOSUB AA.BILL.DUE.BAL.PROCESS
                    END
                END ELSE
                    GOSUB AA.BILL.DUE.BAL.PROCESS
                END
                Y.LOAN.STAT.INIT += 1
            REPEAT
        END
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
AA.BILL.DUE.BAL.PROCESS:
*------------------------------------------------------------------------------------------------------------------
    IF Y.LOAN.STAT.INIT EQ 1 OR Y.SEL.STAT.MATCH.VAL EQ 1 THEN
        Y.ACT.PROPERTY.ARRAY = ''
        Y.AA.LAST.ACT.PROPERTY.LIST = ''
        Y.AA.ACT.PROPERTY.DUM.LIST = ''
        Y.AA.ACT.PROPERTY.LIST = ''
        Y.ACC.PROPERTY = ''
        Y.INT.PROPERTY = ''
        Y.CHARGE.PROPERTY = ''
        OUT.PROPERTY = ''
        IN.PROPERTY.CLASS='ACCOUNT'
        CALL AA.GET.PROPERTY.NAME(VAR.ARR.ID,IN.PROPERTY.CLASS,OUT.PROPERTY)
        Y.ACC.PROPERTY = OUT.PROPERTY
        IF Y.ACC.PROPERTY THEN
            Y.AA.ACT.PROPERTY.DUM.LIST = Y.ACC.PROPERTY
        END
        OUT.PROPERTY = ''
        Y.TOTAL.CAP.BAL = ''
        IN.PROPERTY.CLASS='INTEREST'
        CALL AA.GET.PROPERTY.NAME(VAR.ARR.ID,IN.PROPERTY.CLASS,OUT.PROPERTY)
        Y.INT.PROPERTY = OUT.PROPERTY
        IF Y.INT.PROPERTY THEN
            Y.AA.ACT.PROPERTY.DUM.LIST:=@FM:Y.INT.PROPERTY
        END
        OUT.PROPERTY = ''
        IN.PROPERTY.CLASS='CHARGE'
        CALL AA.GET.PROPERTY.NAME(VAR.ARR.ID,IN.PROPERTY.CLASS,OUT.PROPERTY)
        Y.CHARGE.PROPERTY = OUT.PROPERTY
        IF Y.CHARGE.PROPERTY THEN
            Y.AA.ACT.PROPERTY.DUM.LIST:=@FM:Y.CHARGE.PROPERTY
        END
        Y.AA.ACT.PROPERTY.LIST = Y.AA.ACT.PROPERTY.DUM.LIST
    END
    IF Y.SEL.DATE.VAL NE '' AND Y.SEL.LOAN.STATUS.VAL EQ '' THEN
        IF Y.LOAN.STAT.INIT EQ 1 THEN
            Y.AA.LAST.ACT.PROPERTY.LIST = Y.AA.ACT.PROPERTY.LIST
        END ELSE
            Y.AA.ACT.PROPERTY.LIST = Y.AA.LAST.ACT.PROPERTY.LIST
        END
    END
    IF Y.SEL.LOAN.NUM.VAL EQ '' AND Y.SEL.DATE.VAL EQ '' AND Y.SEL.STAT.MATCH.VAL EQ '' THEN
        IF Y.LOAN.STAT.INIT EQ 1 THEN
            Y.AA.LAST.ACT.PROPERTY.LIST = Y.AA.ACT.PROPERTY.LIST
        END ELSE
            Y.AA.ACT.PROPERTY.LIST = Y.AA.LAST.ACT.PROPERTY.LIST
        END
    END
    IF Y.SEL.LOAN.NUM.VAL NE '' AND Y.SEL.DATE.VAL EQ '' AND Y.SEL.STAT.MATCH.VAL EQ '' THEN
        IF Y.LOAN.STAT.INIT EQ 1 THEN
            Y.AA.LAST.ACT.PROPERTY.LIST = Y.AA.ACT.PROPERTY.LIST
        END ELSE
            Y.AA.ACT.PROPERTY.LIST = Y.AA.LAST.ACT.PROPERTY.LIST
        END
    END
    Y.TOT.AA.ACT.PROP.CNT = DCOUNT(Y.AA.ACT.PROPERTY.LIST,@FM)
    Y.INIT.PROP.CNT = 1
    IF Y.LOAN.STAT.VAL1 THEN
        Y.SEL.LOAN.STAT =  Y.LOAN.STAT.VAL1
    END

    IF Y.AA.ACT.PROPERTY.LIST THEN
        LOOP
            REMOVE Y.AA.ACT.PROPERTY FROM Y.AA.ACT.PROPERTY.LIST  SETTING Y.AA.ACT.PROP.POS
        WHILE Y.INIT.PROP.CNT LE Y.TOT.AA.ACT.PROP.CNT
            Y.RE.CUR.ACCT.VAL = ''
            Y.RE.CUR.ACCT.DESC = ''
            Y.RE.SUPER.ACCT.VAL = ''
            Y.LOAN.STAT.VAL3 = Y.SEL.LOAN.STAT:Y.AA.ACT.PROPERTY
            BALANCE.TO.CHECK = Y.SEL.LOAN.STAT:Y.AA.ACT.PROPERTY
            DATE.OPTIONS = ''
            DATE.OPTIONS<4>  = 'ECB'
            BALANCE.AMOUNT = ""
            Y.TOTAL.CAP.BAL = ''
            Y.START.DATE = ''
            Y.END.DATE = ''
            IF Y.AA.ACCT.DET.DATE THEN
                Y.START.DATE = Y.AA.ACCT.DET.DATE
            END
            IF Y.SEL.DATE.VAL THEN
                Y.END.DATE = Y.SEL.DATE.VAL
            END ELSE
                Y.END.DATE = TODAY
            END
*CALL AA.GET.PERIOD.BALANCES(Y.LINK.APPL.VAL, BALANCE.TO.CHECK, DATE.OPTIONS,Y.START.DATE ,Y.END.DATE , "", BAL.DETAILS, "")
            AA.Framework.GetPeriodBalances(Y.LINK.APPL.VAL, BALANCE.TO.CHECK, DATE.OPTIONS,Y.START.DATE ,Y.END.DATE , "", BAL.DETAILS, "");* R22 Utility Changes
            IF BAL.DETAILS THEN
                Y.BAL.DETAIL.DATE = BAL.DETAILS<1>
                Y.BAL.DET.DATE.CNT = DCOUNT(Y.BAL.DETAIL.DATE,@VM)
                Y.BAL.DETAIL.LIST = BAL.DETAILS<IC.ACT.BALANCE,Y.BAL.DET.DATE.CNT>
                IF NOT(Y.TOTAL.CAP.BAL) THEN
                    Y.TOTAL.CAP.BAL =  Y.BAL.DETAIL.LIST
                END
            END
            Y.INIT.PROP.CNT += 1
            GOSUB RE.STAT.REP.PROCESS
*GOSUB FORM.FINAL.ARRAY
        REPEAT
    END
*GOSUB FORM.FINAL.ARRAY
RETURN
*------------------------------------------------------------------------------------------------------------------
RE.STAT.REP.PROCESS:
*------------------------------------------------------------------------------------------------------------------
    Y.RE.SEC.CATEG.ASSET.VAL = ''
    Y.RE.SEC.CATEG.ASSET.VAL = Y.ACCT.CATEG.VAL:"*":Y.CUST.SECTOR.VAL:"*":Y.LOAN.STAT.VAL3
    Y.RE.REQ.ASSET.VALUES = ''
    FINDSTR Y.RE.SEC.CATEG.ASSET.VAL IN Y.RE.STAT.REP.VAL.ARRAY SETTING Y.POS.VAL1, Y.POS.VAL2 THEN
        Y.RE.REQ.ASSET.VALUES = Y.RE.STAT.REP.VAL.ARRAY<Y.POS.VAL1,Y.POS.VAL2>
    END
    IF Y.RE.REQ.ASSET.VALUES THEN
        Y.RE.REQ.PROP.VAL = ''
        Y.RE.REQ.PROP.VAL = Y.RE.REQ.ASSET.VALUES['*',3,1]
        IF Y.LOAN.STAT.VAL3 EQ Y.RE.REQ.PROP.VAL THEN
            Y.RE.CUR.ACCT.VAL = Y.RE.REQ.ASSET.VALUES['*',4,1]
            Y.RE.CUR.ACCT.DESC = Y.RE.REQ.ASSET.VALUES['*',5,1]
            Y.RE.SUPER.ACCT.VAL = Y.RE.REQ.ASSET.VALUES['*',6,1]
        END
    END
    IF Y.TOTAL.CAP.BAL THEN

        LOCATE Y.LOAN.STAT.VAL3 IN Y.LOAN.STAT.VAL3.LIST SETTING POS.LOAN THEN
            Y.TOTAL.CAP.BAL.LIST<POS.LOAN> = Y.TOTAL.CAP.BAL.LIST<POS.LOAN> + ABS(Y.TOTAL.CAP.BAL)
        END ELSE
            Y.TOTAL.CAP.BAL.LIST<-1> = ABS(Y.TOTAL.CAP.BAL)
            Y.LOAN.STAT.VAL3.LIST<-1> = Y.LOAN.STAT.VAL3
        END
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
FORM.FINAL.ARRAY:
*------------------------------------------------------------------------------------------------------------------

*    Y.TOTAL.CAP.BAL = ABS(Y.TOTAL.CAP.BAL)
    CHANGE @FM TO @VM IN Y.TOTAL.CAP.BAL.LIST
    CHANGE @FM TO @VM IN Y.LOAN.STAT.VAL3.LIST
    IF Y.TOTAL.CAP.BAL.LIST THEN
        Y.FINAL.ARRAY<-1>=Y.LINK.APPL.VAL:'*':AL.ID.TYPE.VAL:'*':PRODUCT.TYPE.VAL:'*':CO.CODE.VAL:'*':Y.LOAN.STAT.VAL3.LIST:'*'
        Y.FINAL.ARRAY:=Y.RE.CUR.ACCT.VAL:'*':Y.RE.CUR.ACCT.DESC:'*':Y.RE.SUPER.ACCT.VAL:'*':Y.TOTAL.CAP.BAL.LIST:'*'
        Y.FINAL.ARRAY:=Y.LOAN.STAT.VALUE:'*':ARR.STATUS.VAL:'*':CURRENCY.VAL:"*":X.LOAN.STATUS
    END
    Y.LOAN.STAT.VAL3.LIST = ''
    Y.TOTAL.CAP.BAL.LIST = ''
RETURN
*------------------------------------------------------------------------------------------------------------------
GOEND:
*------------------------------------------------------------------------------------------------------------------
END
*-------------------------------------------*END OF SUBROUTINE*----------------------------------------------------
