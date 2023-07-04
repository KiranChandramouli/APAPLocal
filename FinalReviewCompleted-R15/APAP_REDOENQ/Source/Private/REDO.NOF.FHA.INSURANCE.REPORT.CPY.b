* @ValidationCode : MjotMTE2Njc0MDEyNzpDcDEyNTI6MTY4NTk0OTY4NjYwNDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jun 2023 12:51:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.FHA.INSURANCE.REPORT.CPY(Y.FINAL.ARRAY)
*------------------------------------------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Sakthi Sellappillai
*Program Name      : REDO.NOF.FHA.INSURANCE.REPORT
*Developed for     : ODR-2010-03-0085
*Date              : 19.08.2010
*------------------------------------------------------------------------------------------------------------------
*Description:This is No File Enquiry routine.This will select the live file REDO.T.AUTH.ARRANGEMENT records,
* and fetch the values from the selected ARRANGEMENT records for ENQUIRY.REPORT-REDO.FHA.INSURANCE.REPORT
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : --N/A--
* Out : Y.FINAL.ARRAY
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
*-------------
* Linked with : NOFILE.REDO.FHA.INSURANCE.REPORT - Standard Selection of REDO.ENQ.FHA.INSURANCE.REP(ENQUIRY)
* Calls       : AA.GET.ARRANGEMENT.CONDITIONS,AA.GET.PERIOD.BALANCES
* Called By   : --N/A--
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
* Date              Name                         Reference                    Version
* -------           ----                         ----------                   --------
* 19.08.2010       Sakthi Sellappillai           ODR-2010-03-0085             Initial Version
*DATE              WHO                REFERENCE                        DESCRIPTION
*23-05-2023      HARSHA         AUTO R22 CODE CONVERSION          FM TO @FM,VM TO @VM,SM TO @SM
*23-05-2023      HARSHA         MANUAL R22 CODE CONVERSION         changed to AA.AH.ACTIVITY.REF and changed from AA.AH.ACT.AMOUNT to AA.AH.ACTIVITY.AMT
*------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.T.AUTH.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.CUSTOMER
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.ACCT.ACTIVITY
    GOSUB MAIN.PARA

RETURN
*------------------------------------------------------------------------------------------------------------------
MAIN.PARA:
*------------------------------------------------------------------------------------------------------------------

    GOSUB INITIALISE.PARA
    GOSUB LOCATE.PARA
    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB MG.FHA.COUNT.PARA
    GOSUB FORM.FINAL.ARRAY
RETURN
*------------------------------------------------------------------------------------------------------------------
INITIALISE.PARA:
*------------------------------------------------------------------------------------------------------------------
    F.REDO.T.AUTH.ARRANGEMENT = ''
    FN.REDO.T.AUTH.ARRANGEMENT = 'F.REDO.T.AUTH.ARRANGEMENT'
    Y.AUTH.SEL.CMD = ""
    CALL OPF(FN.REDO.T.AUTH.ARRANGEMENT,F.REDO.T.AUTH.ARRANGEMENT)
    F.AA.ARRANGEMENT = ''
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    R.AA.ARRANGEMENT = ''
    Y.AA.ARRANGE.ERR = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    F.CUSTOMER = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    R.CUSTOMER = ''
    Y.CUST.ERR = ''
    Y.DISBURSED.VALUE = ''
    Y.MG.WITH.FHA.COUNT = ''
    Y.MG.WITHOUT.FHA.COUNT = ''
    Y.MORT.WITH.FHA.PERC = ''
    Y.MORT.WITHOUT.FHA.PERC = ''
    Y.SEL.ORIGIN.AGENCY = ''
    Y.SEL.OPEN.DATE.FROM = ''
    Y.SEL.OPEN.DATE.UNTIL = ''
    Y.SEL.CUS.REQ.DATE.FROM = ''
    Y.SEL.CUS.REQ.DATE.TO = ''
    Y.SEL.LOAN.PRD.VALUE = ''
RETURN
*------------------------------------------------------------------------------------------------------------------
LOCATE.PARA:
*------------------------------------------------------------------------------------------------------------------
    LOCATE 'ORIGIN.AGENCY' IN D.FIELDS SETTING Y.SEL.ORIGIN.AGENCY.POS THEN
        Y.SEL.ORIGIN.AGENCY = D.RANGE.AND.VALUE<Y.SEL.ORIGIN.AGENCY.POS>
    END
    LOCATE 'OPENING.DATE.FROM' IN D.FIELDS SETTING Y.SEL.CUS.REQ.DATE.POS THEN
        Y.SEL.OPEN.DATE.FROM = D.RANGE.AND.VALUE<Y.SEL.CUS.REQ.DATE.POS>
    END
    LOCATE 'OPENING.DATE.UNTIL' IN D.FIELDS SETTING Y.SEL.CUS.REQ.DATE.POS THEN
        Y.SEL.OPEN.DATE.UNTIL = D.RANGE.AND.VALUE<Y.SEL.CUS.REQ.DATE.POS>
    END
    LOCATE 'CUST.REQ.DATE.FROM' IN D.FIELDS SETTING Y.SEL.CUS.REQ.DATE.POS THEN
        Y.SEL.CUS.REQ.DATE.FROM = D.RANGE.AND.VALUE<Y.SEL.CUS.REQ.DATE.POS>
    END
    LOCATE 'CUST.REQ.DATE.TO' IN D.FIELDS SETTING Y.SEL.CUS.REQ.DATE.POS THEN
        Y.SEL.CUS.REQ.DATE.TO = D.RANGE.AND.VALUE<Y.SEL.CUS.REQ.DATE.POS>
    END
    LOCATE 'LOAN.PRODUCT' IN D.FIELDS SETTING Y.SEL.LOAN.PRD.POS THEN
        Y.SEL.LOAN.PRD.VALUE = D.RANGE.AND.VALUE<Y.SEL.LOAN.PRD.POS>
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
FIND.MULTI.LOCAL.REF:
*------------------------------------------------------------------------------------------------------------------
    APPL.ARRAY = "AA.PRD.DES.TERM.AMOUNT":@FM:"AA.PRD.DES.CUSTOMER":@FM:"AA.PRD.DES.CHARGE":@FM:"AA.PRD.DES.ACCOUNT"
    FIELD.ARRAY = "INS.AMOUNT":@FM:"INS.APPLN.DATE":@FM:"L.FHA.CASE.NO":@FM:"L.AA.AGNCY.CODE"
    FIELD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FIELD.ARRAY,FIELD.POS)
    Y.LOC.TERM.INS.AMT.POS = FIELD.POS<1,1>
    Y.LOC.CUS.INS.APPLN.POS = FIELD.POS<2,1>
    Y.LOC.CHARGE.FHA.NUM.POS = FIELD.POS<3,1>
    Y.LOC.AC.AGENCY.CODE.POS = FIELD.POS<4,1>
RETURN
*------------------------------------------------------------------------------------------------------------------
MG.FHA.COUNT.PARA:
*------------------------------------------------------------------------------------------------------------------
*
    Y.FHA.AUTH.SEL.CMD ="SELECT ": FN.REDO.T.AUTH.ARRANGEMENT
    CALL EB.READLIST(Y.FHA.AUTH.SEL.CMD,Y.TOT.NOT.AUTH.SEL.LIST,'',Y.NO.OF.NOT.FHA.AUTH,Y.TOT.NOT.FHA.SEL.ERR)
    LOOP
        REMOVE Y.NOT.FHA.AA.ID FROM Y.TOT.NOT.AUTH.SEL.LIST SETTING Y.NOT.FHA.AA.POS
    WHILE Y.NOT.FHA.AA.ID : Y.NOT.FHA.AA.POS
        R.REDO.T.AUTH.ARRANGEMENT = '' ; ERR.REDO.T.AUTH.ARRANGEMENT = ''
        CALL F.READ(FN.REDO.T.AUTH.ARRANGEMENT,Y.NOT.FHA.AA.ID ,R.REDO.T.AUTH.ARRANGEMENT, F.REDO.T.AUTH.ARRANGEMENT, ERR.REDO.T.AUTH.ARRANGEMENT)
        R.AA.ARRANGEMENT = '' ; Y.AA.ARRANGE.ERR = ''
        CALL F.READ(FN.AA.ARRANGEMENT,Y.NOT.FHA.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.AA.ARRANGE.ERR)
        IF R.REDO.T.AUTH.ARRANGEMENT<REDO.ARR.INS.POLICY.TYPE> NE 'FHA' THEN
            Y.SEL.LOAN.READ.PRD.VALUE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
            Y.ARRANGEMENT.ID = Y.NOT.FHA.AA.ID
            GOSUB FIND.PROD.GROUP
            IF R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'MORTGAGE' THEN
                Y.MG.WITHOUT.FHA.COUNT +=1
            END
        END ELSE
            Y.SEL.LOAN.READ.PRD.VALUE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
            Y.ARRANGEMENT.ID = Y.NOT.FHA.AA.ID
            GOSUB FIND.PROD.GROUP
            GOSUB PROCESS.PARA
            IF R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP> EQ 'MORTGAGE' THEN
                Y.MG.WITH.FHA.COUNT +=1
            END
        END
    REPEAT
*
    Y.AA.ARRANGE.SEL.CMD ="SELECT ": FN.AA.ARRANGEMENT:" WITH PRODUCT.GROUP EQ MORTGAGE"
    CALL EB.READLIST(Y.AA.ARRANGE.SEL.CMD,Y.TOT.AA.SEL.LIST,'',Y.NO.OF.MG.ARRANGE,Y.TOT.AA.SEL.ERR)
    Y.TOTAL.AA.PROD.MG = Y.NO.OF.MG.ARRANGE
    Y.MORT.WITH.FHA.PERC = Y.MG.WITH.FHA.COUNT / Y.TOTAL.AA.PROD.MG * 100
    Y.MORT.WITHOUT.FHA.PERC = Y.MG.WITHOUT.FHA.COUNT / Y.TOTAL.AA.PROD.MG * 100
*
RETURN
*-----------------------------------------------------------------------------------------------------------------
FIND.PROD.GROUP:
*-----------------------------------------------------------------------------------------------------------------
    IF Y.SEL.LOAN.PRD.VALUE EQ 'MORTGAGE' OR Y.SEL.LOAN.PRD.VALUE EQ '' THEN
        CALL F.READ(FN.AA.ARRANGEMENT,Y.ARRANGEMENT.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.AA.ARRANGE.ERR)
        Y.PROD.GROUP.VALUE = R.AA.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    END ELSE
        ENQ.ERROR = 'EB-ONLY.MG.LOAN'
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*------------------------------------------------------------------------------------------------------------------
    IF Y.PROD.GROUP.VALUE  EQ 'MORTGAGE' THEN
        Y.AA.REC.ORIGIN.AGENCY =  R.AA.ARRANGEMENT<AA.ARR.CO.CODE>
        Y.AA.REC.START.DATE = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
        IF Y.SEL.ORIGIN.AGENCY THEN
            IF  Y.AA.REC.ORIGIN.AGENCY EQ Y.SEL.ORIGIN.AGENCY THEN
                Y.ORIGIN.AGENCY = Y.SEL.ORIGIN.AGENCY
                Y.LOAN.NO = Y.ARRANGEMENT.ID
                GOSUB LOC.CUSTOMER
                GOSUB SEL.REQ.DATES.CHECK
                IF  Y.AA.START.DATE EQ 1 AND Y.OPEN.DATE.COUNT EQ 1 THEN
                    RETURN
                END
                IF Y.CUST.REQ.DATE EQ 1 AND Y.CUS.REQ.DATE.COUNT EQ 1 THEN
                    RETURN
                END
            END ELSE
                RETURN
            END
        END ELSE
            Y.LOAN.NO = Y.ARRANGEMENT.ID
            GOSUB LOC.CUSTOMER
            GOSUB SEL.REQ.DATES.CHECK
            IF  Y.AA.START.DATE EQ 1 AND Y.OPEN.DATE.COUNT EQ 1 THEN
                RETURN
            END
            IF Y.CUST.REQ.DATE EQ 1 AND Y.CUS.REQ.DATE.COUNT EQ 1 THEN
                RETURN
            END
        END
        Y.LOAN.NO = Y.ARRANGEMENT.ID
        GOSUB SEL.FIELD.CHECK
        GOSUB SUBPROCESS
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
SEL.REQ.DATES.CHECK:
*------------------------------------------------------------------------------------------------------------------
    Y.AA.START.DATE = 0
    Y.OPEN.DATE.COUNT = 0
    Y.CUS.REQ.DATE.COUNT = 0
    Y.CUST.REQ.DATE = 0

    IF Y.SEL.OPEN.DATE.FROM OR Y.SEL.OPEN.DATE.UNTIL THEN
        GOSUB AA.OPEN.DATE.CHECK
    END
    IF Y.SEL.CUS.REQ.DATE.FROM OR Y.SEL.CUS.REQ.DATE.TO THEN
        GOSUB CUS.REQ.DATE.CHECK
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
CUS.REQ.DATE.CHECK:
*------------------------------------------------------------------------------------------------------------------
    IF Y.SEL.CUS.REQ.DATE.FROM AND Y.SEL.CUS.REQ.DATE.TO AND Y.REC.CUST.REQ.DATE THEN
        Y.CUST.REQ.DATE = 1
        Y.CUS.REQ.DATE.COUNT = 1
        IF Y.REC.CUST.REQ.DATE GE Y.SEL.CUS.REQ.DATE.FROM AND Y.REC.CUST.REQ.DATE LE Y.SEL.CUS.REQ.DATE.TO THEN
            Y.CUST.REQ.DATE = Y.REC.CUST.REQ.DATE
        END
    END
    IF Y.SEL.CUS.REQ.DATE.FROM AND Y.REC.CUST.REQ.DATE THEN
        Y.CUST.REQ.DATE = 1
        Y.CUS.REQ.DATE.COUNT = 1
        IF Y.REC.CUST.REQ.DATE GE Y.SEL.CUS.REQ.DATE.FROM THEN
            Y.CUST.REQ.DATE = Y.REC.CUST.REQ.DATE
        END
    END
    IF Y.SEL.CUS.REQ.DATE.TO AND Y.REC.CUST.REQ.DATE THEN
        Y.CUST.REQ.DATE = 1
        Y.CUS.REQ.DATE.COUNT = 1
        IF Y.REC.CUST.REQ.DATE LE Y.SEL.CUS.REQ.DATE.TO THEN
            Y.CUST.REQ.DATE = Y.REC.CUST.REQ.DATE
        END
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
LOC.CUSTOMER:
*------------------------------------------------------------------------------------------------------------------
    ARR.ID1=Y.LOAN.NO
    PROP.CLASS1='CUSTOMER'
    RETURN.IDS1=''
    RETURN.COND1=''
    RETURN.ERR1=''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID1,PROP.CLASS1,"","",RETURN.IDS1,RETURN.COND1,RETURN.ERR1)
    R.CONDITION=RAISE(RETURN.COND1)
    Y.REC.CUST.REQ.DATE  = R.CONDITION<AA.CUS.LOCAL.REF,Y.LOC.CUS.INS.APPLN.POS>
RETURN
*------------------------------------------------------------------------------------------------------------------
AA.OPEN.DATE.CHECK:
*------------------------------------------------------------------------------------------------------------------
    IF Y.SEL.OPEN.DATE.FROM  AND Y.SEL.OPEN.DATE.UNTIL AND Y.AA.REC.START.DATE THEN
        Y.AA.START.DATE = 1
        Y.OPEN.DATE.COUNT = 1
        IF Y.AA.REC.START.DATE GE Y.SEL.OPEN.DATE.FROM AND Y.AA.REC.START.DATE LE Y.SEL.OPEN.DATE.UNTIL THEN
            Y.AA.START.DATE = Y.AA.REC.START.DATE
        END
    END
    IF Y.SEL.OPEN.DATE.FROM AND Y.AA.REC.START.DATE THEN
        Y.AA.START.DATE = 1
        Y.OPEN.DATE.COUNT = 1
        IF Y.AA.REC.START.DATE GE Y.SEL.OPEN.DATE.FROM THEN
            Y.AA.START.DATE = Y.AA.REC.START.DATE
        END
    END
    IF Y.SEL.OPEN.DATE.UNTIL AND Y.AA.REC.START.DATE THEN
        Y.AA.START.DATE = 1
        Y.OPEN.DATE.COUNT = 1
        IF Y.AA.REC.START.DATE LE Y.SEL.OPEN.DATE.UNTIL THEN
            Y.AA.START.DATE = Y.AA.REC.START.DATE
        END
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
SEL.FIELD.CHECK:
*------------------------------------------------------------------------------------------------------------------
    IF NOT(Y.SEL.ORIGIN.AGENCY) THEN
        Y.LOAN.NO = Y.ARRANGEMENT.ID
        Y.ORIGIN.AGENCY = Y.AA.REC.ORIGIN.AGENCY
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
SUBPROCESS:
*------------------------------------------------------------------------------------------------------------------
    GOSUB MG.PROCESS
    GOSUB FINAL.ARRAY
RETURN
*------------------------------------------------------------------------------------------------------------------
MG.PROCESS:
*------------------------------------------------------------------------------------------------------------------
    LOCATE 'CLOSING.DAY' IN D.FIELDS SETTING Y.CLOSE.DAY.POS THEN
        Y.CLOSING.DAY = D.RANGE.AND.VALUE<Y.CLOSE.DAY.POS>
    END ELSE
        Y.CLOSING.DAY = TODAY
    END
    Y.CUST.REQ.DATE = Y.REC.CUST.REQ.DATE
    ARR.ID1=Y.LOAN.NO
    PROP.CLASS1='ACCOUNT'
    RETURN.IDS1=''
    RETURN.COND1=''
    RETURN.ERR1=''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID1,PROP.CLASS1,"","",RETURN.IDS1,RETURN.COND1,RETURN.ERR1)
    R.CONDITION=RAISE(RETURN.COND1)
    Y.PREV.LOAN.NO = R.CONDITION<AA.AC.ALT.ID>
    Y.ARRANGE.CUST = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.ARRANGE.CUST,R.CUSTOMER,F.CUSTOMER,Y.CUST.ERR)
    Y.CLIENT.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
    GOSUB AA.ARRANGE.ACT.READ
    GOSUB TERM.AMOUNT
RETURN
*------------------------------------------------------------------------------------------------------------------
AA.ARRANGE.ACT.READ:
*------------------------------------------------------------------------------------------------------------------
    F.AA.ACTIVITY.HISTORY = ''
    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    R.AA.ACTVITY.HISTORY  = ''
    Y.AA.ACT.HIS.ERR = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.LOAN.NO,R.AA.ACTVITY.HISTORY,F.AA.ACTIVITY.HISTORY,Y.AA.ACT.HIS.ERR)
    IF NOT(Y.AA.ACT.HIS.ERR) THEN
        Y.AA.ACTIVITY.HIS.ACT.ID = R.AA.ACTVITY.HISTORY<AA.AH.ACTIVITY.REF>      ;*R22 Manual Conversion - changed to AA.AH.ACTIVITY.REF
    END
    Y.AA.ACTIVITY.HIS.ACT.VAR = 'LENDING-DISBURSE-COMMITMENT'
    LOCATE Y.AA.ACTIVITY.HIS.ACT.VAR IN Y.AA.ACTIVITY.HIS.ACT.ID<1,1> SETTING Y.AA.ACTIVITY.HIS.ACT.POS THEN
        Y.DISBURSED.VALUE = R.AA.ACTVITY.HISTORY<AA.AH.ACTIVITY.AMT,Y.AA.ACTIVITY.HIS.ACT.POS,1>  ;*R22 Manual Conversion - changed from AA.AH.ACT.AMOUNT to AA.AH.ACTIVITY.AMT
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
TERM.AMOUNT:
*------------------------------------------------------------------------------------------------------------------
    ARR.ID1=Y.LOAN.NO
    PROP.CLASS1='TERM.AMOUNT'
    RETURN.IDS1=''
    RETURN.COND1=''
    RETURN.ERR1=''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID1,PROP.CLASS1,"","",RETURN.IDS1,RETURN.COND1,RETURN.ERR1)
    R.CONDITION=RAISE(RETURN.COND1)
    Y.INSURED.AMT = R.CONDITION<AA.AMT.LOCAL.REF,Y.LOC.TERM.INS.AMT.POS>
    GOSUB AA.LOC.CHARGE
    GOSUB ARR.ACCT.ALT.ID
RETURN
*------------------------------------------------------------------------------------------------------------------
AA.LOC.CHARGE:
*------------------------------------------------------------------------------------------------------------------
    ARR.ID1=Y.LOAN.NO
    PROP.CLASS1='CHARGE'
    RETURN.IDS1=''
    RETURN.COND1=''
    RETURN.ERR1=''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID1,PROP.CLASS1,"","",RETURN.IDS1,RETURN.COND1,RETURN.ERR1)
    R.CONDITION=RAISE(RETURN.COND1)
    Y.DUM.CASE.NUMBER1 = R.CONDITION<AA.CHG.LOCAL.REF,Y.LOC.CHARGE.FHA.NUM.POS>
    IF Y.DUM.CASE.NUMBER1 THEN
        CHANGE @SM TO @FM IN Y.DUM.CASE.NUMBER1
        Y.DUM.CASE.NUMBER = Y.DUM.CASE.NUMBER1
        Y.CASE.NUMBER = Y.DUM.CASE.NUMBER<1>
    END ELSE
        Y.CASE.NUMBER = R.CONDITION<AA.CHG.LOCAL.REF,Y.LOC.CHARGE.FHA.NUM.POS>
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
ARR.ACCT.ALT.ID:
*------------------------------------------------------------------------------------------------------------------
    Y.AA.ARR.LINK.APPLN = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
    IF Y.AA.ARR.LINK.APPLN EQ 'ACCOUNT' THEN
        Y.ACCT.NO =  R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    END
    GOSUB ACCT.ACT.BK.BAL
RETURN
*------------------------------------------------------------------------------------------------------------------
ACCT.ACT.BK.BAL:
*------------------------------------------------------------------------------------------------------------------
    Y.TOTAL.CAP.BAL = ''
    Y.BALANCE.TO.CHECK.ARRAY = 'CURACCOUNT':@VM:'DUEACCOUNT':@VM:'GRCACCOUNT':@VM:'DELACCOUNT':@VM:'NABACCOUNT'
    IF Y.BALANCE.TO.CHECK.ARRAY THEN
        LOOP
            REMOVE BALANCE.TO.CHECK FROM Y.BALANCE.TO.CHECK.ARRAY SETTING Y.BAL.CHECK.POS
        WHILE BALANCE.TO.CHECK:Y.BAL.CHECK.POS
            DATE.OPTIONS = ''
            EFFECTIVE.DATE = TODAY
            DATE.OPTIONS<4>  = 'ECB'
            BALANCE.AMOUNT = ""
            CALL AA.GET.PERIOD.BALANCES(Y.ACCT.NO, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
            IF NOT(Y.TOTAL.CAP.BAL) THEN
                Y.TOTAL.CAP.BAL =  BAL.DETAILS<IC.ACT.BALANCE>
            END ELSE
                Y.TOTAL.CAP.BAL = Y.TOTAL.CAP.BAL + BAL.DETAILS<IC.ACT.BALANCE>
            END
        REPEAT
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
FINAL.ARRAY:
*------------------------------------------------------------------------------------------------------------------
    IF Y.LOAN.NO THEN
        Y.FINAL.ARRAY<-1> = Y.LOAN.NO:"*":Y.PREV.LOAN.NO:"*":Y.ORIGIN.AGENCY:"*":Y.CLIENT.NAME:"*":Y.CLOSING.DAY:"*":Y.DISBURSED.VALUE:"*"
        Y.FINAL.ARRAY:= Y.INSURED.AMT:"*":Y.CUST.REQ.DATE:"*":Y.CASE.NUMBER:"*":Y.MG.WITH.FHA.COUNT:"*":Y.MG.WITHOUT.FHA.COUNT:"*"
        Y.FINAL.ARRAY:= Y.MORT.WITH.FHA.PERC:"*":Y.MORT.WITHOUT.FHA.PERC:"*":Y.TOTAL.CAP.BAL
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
FORM.FINAL.ARRAY:
*****************
*
    Y.ARR.CNT = DCOUNT(Y.FINAL.ARRAY,@FM)
    FOR IDX1 = 1 TO Y.ARR.CNT
        Y.BKP.ARRAY = Y.FINAL.ARRAY<IDX1>
        Y.FINAL.ARRAY<IDX1> = FIELD(Y.BKP.ARRAY,'*',1,9):'*':Y.MG.WITH.FHA.COUNT:"*"
        Y.FINAL.ARRAY<IDX1> := Y.MG.WITHOUT.FHA.COUNT:"*":Y.MORT.WITH.FHA.PERC:"*":Y.MORT.WITHOUT.FHA.PERC:'*':FIELD(Y.BKP.ARRAY,'*',14,1)
    NEXT IDX1
*
RETURN


END
*--------------------------*END OF SUBROUTINE*---------------------------------------------------------------------
