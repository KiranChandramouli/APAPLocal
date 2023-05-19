* @ValidationCode : MjoxMTA0ODYzNTY1OkNwMTI1MjoxNjg0MzkzNTQ1OTgyOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 12:35:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.PRE.PRIN.INT.PENAL.INT(Y.SEL.LIST)
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This is a Multi Threaded COB Routine for the development B16
* It is generaly used to update a field MARGIN.RATE in AA.ARR.INTEREST with a new value
* from the field
* Using OFS the message is posted
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
* 02-JUL-2010    Kishore.SP               B.16                   INITIALVERSION
* 17-MAY-2011    H Ganesh                 PACS00055012 - B.16    Changes made as per issue
* 10-10-2011     JEEVA T                  PACS00136838 - B.16    RATE review freq is changed
* 21-11-2011     JEEVA T                  PACS00165067 - B.16    RATE review freq is changed
* 28-03-2018     Edwin Charles D          PACS00625964           Duplicate bills issue
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*25/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, SM TO @SM,++ TO +=,
*25/04/2023         SURESH           MANUAL R22 CODE CONVERSION        CALL routine format modified
*-----------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.COMPANY
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.DATES
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.REDO.RATE.CHANGE.CRIT
    $INSERT I_F.REDO.LOAN.MARGIN.RATE
    $INSERT I_F.REDO.SUCESS.RATE.CHANGE.COB
    $INSERT I_REDO.PRE.PRIN.INT.PENAL.INT.COMMON
    $USING APAP.AA

    CALL OCOMO("Processing the arrangement :":Y.SEL.LIST)

    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------

    Y.FLAG = ''
    Y.CAMP.TYPE=''
    Y.AFF.COMP=''
    Y.MARGIN.ID=''
    Y.PRODUCT=''
    Y.LOC.AFF.COMP=''
    Y.UNPAID.BILL.IDS=''
    Y.UNPAID.BILL.CNT=0
    Y.ERR.MSG = ''
    Y.PRIN.PROP = ''
    OUT.PROP = ''

RETURN
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    ARR.ID = Y.SEL.LIST

    R.AA.ARRANGEMENT = ''
    CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,Y.ARR.ERR)

    PROP.NAME='PRINCIPAL'     ;* Interest Property to obtain
*CALL APAP.TAM.REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,OUT.PROP,ERR) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoGetInterestProperty(ARR.ID,PROP.NAME,OUT.PROP,ERR) ;*MANUAL R22 CODE CONVERSION
    Y.PRIN.PROP=OUT.PROP      ;* This variable hold the value of principal interest property

    IF R.AA.ARRANGEMENT NE '' AND Y.PRIN.PROP THEN
        Y.ARR.PRODUCT = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
        GOSUB GET.ARR.CONDITION
    END

RETURN
*-----------------------------------------------------------------------------
GET.ARR.CONDITION:
*-----------------
* Get the Interest rate properties of the particular arrangemnet
*
    Y.ARRG.ID = ARR.ID
    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PRIN.PROP
    EFF.DATE = ''
    ERR.MSG = ''
    R.INT.ARR.COND = ''
*CALL APAP.AA.REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.INT.ARR.COND,ERR.MSG) ;*MANUAL R22 CODE CONVERSION

    IF R.INT.ARR.COND NE '' THEN
*
        Y.FIRST.REV.DATE      = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.FST.REV.DT.POS>
        Y.NEXT.REV.DATE       = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.SND.REV.DT.POS>
        Y.AA.REV.FORM         = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.REV.FORM.POS>
        Y.AA.REV.RT.TYPE      = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.REV.RT.TY.POS>
        Y.AA.RT.REV.FQU       = R.INT.ARR.COND<AA.INT.LOCAL.REF><1,Y.RATE.REV.FQU.POS>

        IF Y.AA.REV.RT.TYPE EQ 'PERIODICO' AND Y.AA.REV.FORM EQ 'AUTOMATICA' ELSE
            RETURN
        END
*
        GOSUB CHECK.HOLIDAY
    END
RETURN
*-----------------------------------------------------------------------------
CHECK.HOLIDAY:
*--------------
* Checking if they are holiday
*
    IF Y.NEXT.REV.DATE NE '' THEN
        Y.CHECK.DATE = Y.NEXT.REV.DATE
    END ELSE
        Y.CHECK.DATE = Y.FIRST.REV.DATE
    END
*
    IF Y.CHECK.DATE LE TODAY AND Y.CHECK.DATE GT R.DATES(EB.DAT.LAST.WORKING.DAY) THEN
        GOSUB CHECK.REVIEW.DATES
    END

*
RETURN

*-----------------------------------------------------------------------------
CHECK.REVIEW.DATES:
*-----------------------------------------------------------------------------

    GOSUB GET.CAMPAIGN.TYPE
    Y.PRODUCT=R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
    CALL F.READ(FN.REDO.LOAN.MARGIN.RATE,Y.PRODUCT,R.REDO.LOAN.MARGIN.RATE,F.REDO.LOAN.MARGIN.RATE,MAR.ERR)
    GOSUB READ.MARGIN.RATE

    IF Y.MARGIN.ID THEN
        GOSUB INCLUDE.CRITERIA
    END ELSE
        IF Y.ERR.MSG EQ '' THEN
            Y.ERR.MSG = 'Camp or Aff Comp not located in param table'
            GOSUB WRITE.ERR.MSG
        END
        Y.ERR.MSG = ''
    END
    IF Y.FLAG EQ '' THEN
        GOSUB NON.CRITERIA.UPDATE
    END
RETURN
*-----------------------------------------------------------------------------
GET.CAMPAIGN.TYPE:
*-----------------------------------------------------------------------------
* Here we get the Campaign type of the loan

    EFF.DATE = ''
    PROP.CLASS='CUSTOMER'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
*CALL APAP.AA.REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CUSTOMER,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.CUSTOMER,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    Y.CAMP.TYPE=R.CONDITION.CUSTOMER<AA.CUS.LOCAL.REF,Y.CAMP.TYPE.POS>
    Y.AFF.COMP= R.CONDITION.CUSTOMER<AA.CUS.LOCAL.REF,Y.AFFLI.COMP.POS>

RETURN
*-----------------------------------------------------------------------------
READ.MARGIN.RATE:
*-----------------------------------------------------------------------------


    R.ARRAY  = ''
    R.ARRAY<1>  = R.REDO.LOAN.MARGIN.RATE<REDO.LO.MAR.CAMPAIGN.TYPE>
    R.ARRAY<2>  = R.REDO.LOAN.MARGIN.RATE<REDO.LO.MAR.AFFIL.COMP>
    R.ARRAY<3>  = R.REDO.LOAN.MARGIN.RATE<REDO.LO.MAR.MARGIN.ID>
    R.ARRAY<4>  = R.REDO.LOAN.MARGIN.RATE<REDO.LO.MAR.BY.DEFAULT>

*CALL APAP.TAM.REDO.GET.MARGIN.ID(Y.CAMP.TYPE,Y.AFF.COMP,R.ARRAY,Y.MARGIN.ID) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoGetMarginId(Y.CAMP.TYPE,Y.AFF.COMP,R.ARRAY,Y.MARGIN.ID) ;*MANUAL R22 CODE CONVERSION

RETURN
*-----------------------------------------------------------------------------
INCLUDE.CRITERIA:
*-----------------------------------------------------------------------------
* This part checks the loan for incluse criteria

    R.REDO.RATE.CHANGE = ''
    CALL F.READ(FN.REDO.RATE.CHANGE.CRIT,Y.MARGIN.ID,R.REDO.RATE.CHANGE,F.REDO.RATE.CHANGE.CRIT,Y.RRC.ERR)
    GOSUB GET.TERM.AMOUNT
    GOSUB CHECK.AMOUNT
RETURN
*-----------------------------------------------------------------------------
GET.TERM.AMOUNT:
*-----------------------------------------------------------------------------
* This part gets the Loan amount

    EFF.DATE = ''
    PROP.CLASS='TERM.AMOUNT'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
*CALL APAP.AA.REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.TERM,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.TERM,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    Y.LOAN.AMOUNT=R.CONDITION.TERM<AA.AMT.AMOUNT>
    Y.MAT.DATE   =R.CONDITION.TERM<AA.AMT.MATURITY.DATE>
RETURN
*-----------------------------------------------------------------------------
CHECK.AMOUNT:
*-----------------------------------------------------------------------------

    Y.AMOUNT.START.RANGE = R.REDO.RATE.CHANGE<RATE.CHG.ORG.AMT.ST.RG>
    Y.AMOUNT.END.RANGE   = R.REDO.RATE.CHANGE<RATE.CHG.ORG.AMT.END.RG>
    Y.AMOUNT.RANGE.CNT=DCOUNT(Y.AMOUNT.START.RANGE,@VM)
    Y.ERR.MSG = 'Loan Amt not matched'
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.AMOUNT.RANGE.CNT
        Y.START.AMT = Y.AMOUNT.START.RANGE<1,Y.VAR1>
        Y.END.AMT   = Y.AMOUNT.END.RANGE<1,Y.VAR1>
        IF Y.LOAN.AMOUNT GE Y.START.AMT AND Y.LOAN.AMOUNT LE Y.END.AMT THEN
            GOSUB RATE.CHECK
            Y.VAR1 = Y.AMOUNT.RANGE.CNT+1         ;* Instead of break statement
        END
        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

RETURN

*-----------------------------------------------------------------------------
RATE.CHECK:
*-----------------------------------------------------------------------------

    Y.ERR.MSG = 'Interest Rate not Matched'
    GOSUB GET.INTEREST.RATE
    Y.START.INT = R.REDO.RATE.CHANGE<RATE.CHG.RATE.ST.RG,Y.VAR1>
    Y.END.INT   = R.REDO.RATE.CHANGE<RATE.CHG.RATE.END.RG,Y.VAR1>
    IF (Y.INTEREST.RATE GE Y.START.INT AND Y.INTEREST.RATE LE Y.END.INT) OR (Y.START.INT EQ '' AND Y.END.INT EQ '') THEN
        GOSUB ORIG.AMT.CHECK
    END
RETURN
*-----------------------------------------------------------------------------
GET.INTEREST.RATE:
*-----------------------------------------------------------------------------
*CALL APAP.TAM.REDO.GET.INTEREST.RATE(ARR.ID,Y.INTEREST.RATE) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.RedoGetInterestRate(ARR.ID,Y.INTEREST.RATE) ;*MANUAL R22 CODE CONVERSION

RETURN
*-----------------------------------------------------------------------------
ORIG.AMT.CHECK:
*-----------------------------------------------------------------------------
    Y.ERR.MSG = 'Original Amt not matching'
    OUT.PROP.ACC=''
*CALL APAP.TAM.REDO.GET.PROPERTY.NAME(ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,OUT.PROP.ACC,OUT.ERR) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoGetPropertyName(ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,OUT.PROP.ACC,OUT.ERR) ;*MANUAL R22 CODE CONVERSION
    IN.ACC.ID=''
*CALL APAP.TAM.REDO.CONVERT.ACCOUNT(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoConvertAccount(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT) ;*MANUAL R22 CODE CONVERSION
    BALANCE.TO.CHECK='CUR':OUT.PROP.ACC
    BALANCE.AMOUNT=''
    Y.TODAY = TODAY
    CALL AA.GET.ECB.BALANCE.AMOUNT(OUT.ID,BALANCE.TO.CHECK,Y.TODAY,BALANCE.AMOUNT,RET.ERROR)
    Y.OUTSTANDING.BAL=ABS(BALANCE.AMOUNT)

    Y.OS.START.AMT = R.REDO.RATE.CHANGE<RATE.CHG.OS.AMT.ST.RG,Y.VAR1>
    Y.OS.END.AMT   = R.REDO.RATE.CHANGE<RATE.CHG.OS.AMT.END.RG,Y.VAR1>

    IF (Y.OUTSTANDING.BAL GE Y.OS.START.AMT AND Y.OUTSTANDING.BAL LE Y.OS.END.AMT) OR (Y.OS.START.AMT EQ '' AND Y.OS.END.AMT EQ '') THEN
        GOSUB CHECK.LOAN.DATE
    END

RETURN
*-----------------------------------------------------------------------------
CHECK.LOAN.DATE:
*-----------------------------------------------------------------------------

    Y.LOAN.START.DATE=R.AA.ARRANGEMENT<AA.ARR.START.DATE>
    Y.START.DATE = R.REDO.RATE.CHANGE<RATE.CHG.LOAN.ST.DATE,Y.VAR1>
    Y.END.DATE   = R.REDO.RATE.CHANGE<RATE.CHG.LOAN.END.DATE,Y.VAR1>
    Y.ERR.MSG = 'Loan Date not matching'
    IF (Y.LOAN.START.DATE GE Y.START.DATE AND Y.LOAN.START.DATE LE Y.END.DATE) OR (Y.START.DATE EQ '' AND Y.END.DATE EQ '') THEN
        GOSUB EXCLUDE.CONDITION.START
    END

RETURN
*-----------------------------------------------------------------------------
EXCLUDE.CONDITION.START:
*-----------------------------------------------------------------------------
* Exclude condition starts here

    GOSUB GET.OVERDUE.DETAILS
    Y.STATUS.CNT = DCOUNT(Y.LOAN.STATUS,@SM)
    Y.COND.CNT   = DCOUNT(Y.LOAN.COND,@SM)
    Y.VAR2=1
    LOOP
    WHILE Y.VAR2 LE Y.STATUS.CNT
        Y.LOAN.STATUS.INDV=Y.LOAN.STATUS<1,1,Y.VAR2>
        LOCATE Y.LOAN.STATUS.INDV IN R.REDO.RATE.CHANGE<RATE.CHG.LOAN.STATUS,Y.VAR1,1> SETTING STAT.POS THEN
            Y.ERR.MSG = 'Loan Status matched with param'
            GOSUB NON.CRITERIA.UPDATE
        END
        Y.VAR2 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    Y.VAR3=1
    LOOP
    WHILE Y.VAR3 LE Y.COND.CNT
        Y.LOAN.COND.INDV=Y.LOAN.COND<1,1,Y.VAR3>
        LOCATE Y.LOAN.COND.INDV IN R.REDO.RATE.CHANGE<RATE.CHG.LOAN.COND,Y.VAR1,1> SETTING COND.POS THEN
            Y.ERR.MSG = 'Loan Condition matched with param'
            GOSUB NON.CRITERIA.UPDATE
        END
        Y.VAR3 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    GOSUB CHECK.UNPAID.INSTALL
RETURN
*-----------------------------------------------------------------------------
GET.OVERDUE.DETAILS:
*-----------------------------------------------------------------------------

    EFF.DATE = ''
    PROP.CLASS='OVERDUE'
    PROPERTY = ''
    R.CONDITION = ''
    ERR.MSG = ''
*CALL APAP.AA.REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    Y.LOAN.STATUS = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,Y.LOAN.STATUS.1.POS>
    Y.LOAN.COND   = R.CONDITION.OVERDUE<AA.OD.LOCAL.REF,Y.LOAN.COND.POS>

RETURN

*-----------------------------------------------------------------------------
CHECK.UNPAID.INSTALL:
*-----------------------------------------------------------------------------

    R.AA.ACCOUNT.DETAILS = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.ACT.DET.ERR)

    Y.BILL.ID    = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.SET.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    Y.BILL.TYPE  = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>

    CHANGE @SM TO @FM IN Y.BILL.ID
    CHANGE @VM TO @FM IN Y.BILL.ID
    CHANGE @SM TO @FM IN Y.SET.STATUS
    CHANGE @VM TO @FM IN Y.SET.STATUS
    CHANGE @SM TO @FM IN Y.BILL.TYPE
    CHANGE @VM TO @FM IN Y.BILL.TYPE
    Y.UNPAID.BILL.IDS = ''
    Y.UNPAID.BILL.CNT = 0
    Y.BILL.COUNT=DCOUNT(Y.BILL.ID,@FM)
    Y.BILL=1
    LOOP
    WHILE Y.BILL LE Y.BILL.COUNT
        IF Y.SET.STATUS<Y.BILL> EQ 'UNPAID' AND Y.BILL.TYPE<Y.BILL> EQ 'PAYMENT' THEN
            Y.UNPAID.BILL.CNT += 1
            Y.UNPAID.BILL.IDS<-1>=Y.BILL.ID<Y.BILL>
        END
        Y.BILL += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    Y.DEFINED.UNPAID.BILLS= R.REDO.RATE.CHANGE<RATE.CHG.UNPAID.INST,Y.VAR1>
    IF Y.DEFINED.UNPAID.BILLS THEN
        IF Y.UNPAID.BILL.CNT GE Y.DEFINED.UNPAID.BILLS THEN
* Needs to define a Gosub
            Y.ERR.MSG = 'Unpaid Bills matched with param'
            GOSUB NON.CRITERIA.UPDATE
        END
    END
    GOSUB CHECK.OVERDUE.DAYS

RETURN
*-------------------------------------------------------------
CHECK.OVERDUE.DAYS:
*-------------------------------------------------------------

    LOOP.BILL=1
    LOOP
    WHILE LOOP.BILL LE Y.UNPAID.BILL.CNT
        Y.AA.OVERDUE.DAYS=''
        BILL=Y.UNPAID.BILL.IDS<LOOP.BILL>
        Y.BILL.RET.ERR=''
        CALL AA.GET.BILL.DETAILS(ARR.ID,BILL,R.BILL.DETAILS,Y.BILL.RET.ERR)
*Y.AGING.DATE.ARR = R.BILL.DETAILS<AA.BD.AGING.ST.CHG.DT>
*Y.AGING.DATE.SORT =  SORT(Y.AGING.DATE.ARR)
*Y.AA.AGING.DATE = FIELD(Y.AGING.DATE.SORT,FM,1)
        Y.AA.AGING.DATE = ''
        LOCATE 'DUE' IN R.BILL.DETAILS<AA.BD.BILL.STATUS,1> SETTING DUE.POS THEN
            Y.AA.AGING.DATE = R.BILL.DETAILS<AA.BD.BILL.ST.CHG.DT,DUE.POS>
        END

        Y.DATE = TODAY
        IF Y.AA.AGING.DATE NE '' THEN
            Y.AA.OVERDUE.DAYS = 'C'
            CALL CDD('',Y.AA.AGING.DATE,Y.DATE,Y.AA.OVERDUE.DAYS)
        END
        Y.DEFINED.OVR.DAYS=R.REDO.RATE.CHANGE<RATE.CHG.OVERDUE.DAYS,Y.VAR1>
        IF Y.DEFINED.OVR.DAYS THEN
            IF Y.AA.OVERDUE.DAYS GE Y.DEFINED.OVR.DAYS THEN
*; Needs to define a Gosub

                Y.ERR.MSG = 'Overdue days matched with param'
                GOSUB NON.CRITERIA.UPDATE
            END
        END
        LOOP.BILL += 1
    REPEAT

    GOSUB UPDATE.MARGIN

RETURN
*------------------------------------------------------------------------------
UPDATE.MARGIN:
*------------------------------------------------------------------------------

    Y.ERR.MSG = ''
    R.INT.ARR.COND.OFS = ''
    Y.MARGIN.TYPE=R.REDO.RATE.CHANGE<RATE.CHG.MARGIN.TYPE,Y.VAR1>
    Y.MARGIN.RATE=R.REDO.RATE.CHANGE<RATE.CHG.PROP.SPRD.CHG,Y.VAR1>
    Y.MARGIN.OPERAND=R.REDO.RATE.CHANGE<RATE.CHG.MARGIN.OPERAND,Y.VAR1>
    Y.MARGIN.INT.RATE= R.REDO.RATE.CHANGE<RATE.CHG.PROP.INT.CHG,Y.VAR1>
    IF Y.MARGIN.INT.RATE NE '' AND Y.MARGIN.RATE EQ '' THEN
        Y.FIXED.RATE = R.INT.ARR.COND<AA.INT.FIXED.RATE>
        Y.RATE.CNT = DCOUNT(Y.FIXED.RATE,@VM)
        Y.RATE=1
        LOOP
        WHILE Y.RATE LE Y.RATE.CNT
            R.INT.ARR.COND.OFS<AA.INT.FIXED.RATE,Y.RATE> = Y.MARGIN.INT.RATE
            R.INT.ARR.COND.OFS<AA.INT.FLOATING.INDEX,Y.RATE> = ''
            Y.AA.MAR = R.INT.ARR.COND<AA.INT.MARGIN.TYPE,Y.RATE>
            Y.MAR.VAL = 1

            Y.MAR.CNT = DCOUNT(Y.AA.MAR,@SM)
            LOOP
            WHILE Y.MAR.VAL LE Y.MAR.CNT

                R.INT.ARR.COND.OFS<AA.INT.MARGIN.RATE,Y.RATE,Y.MAR.VAL> = '0'

                Y.MAR.VAL += 1
            REPEAT


            Y.RATE += 1
        REPEAT

    END
    IF Y.MARGIN.RATE NE '' AND Y.MARGIN.INT.RATE EQ '' THEN
        Y.RATE.CNT = DCOUNT(R.INT.ARR.COND<AA.INT.FIXED.RATE>,@VM)
        Y.CNT1 = 1
        LOOP
        WHILE Y.CNT1 LE Y.RATE.CNT
            Y.FINAL.MARGIN.RATE = 0
            Y.SUB.CNT = DCOUNT(R.INT.ARR.COND<AA.INT.MARGIN.RATE,Y.CNT1>,@SM)
            Y.CNT2 = 1
            LOOP
            WHILE Y.CNT2 LE Y.SUB.CNT
                IF R.INT.ARR.COND<AA.INT.MARGIN.OPER,Y.CNT1,Y.CNT2> EQ 'ADD' THEN
                    Y.FINAL.MARGIN.RATE += R.INT.ARR.COND<AA.INT.MARGIN.RATE,Y.CNT1,Y.CNT2>
                END
                IF R.INT.ARR.COND<AA.INT.MARGIN.OPER,Y.CNT1,Y.CNT2> EQ 'SUB' THEN
                    Y.FINAL.MARGIN.RATE -= R.INT.ARR.COND<AA.INT.MARGIN.RATE,Y.CNT1,Y.CNT2>
                END
                Y.CNT2 += 1
            REPEAT
            IF Y.MARGIN.OPERAND EQ 'ADD' THEN
                Y.FINAL.MARGIN.RATE+=Y.MARGIN.RATE
            END
            IF Y.MARGIN.OPERAND EQ 'SUB' THEN
                Y.FINAL.MARGIN.RATE-=Y.MARGIN.RATE
            END
            R.INT.ARR.COND.OFS<AA.INT.MARGIN.TYPE,Y.CNT1> = Y.MARGIN.TYPE
            IF Y.FINAL.MARGIN.RATE GE 0 THEN
                R.INT.ARR.COND.OFS<AA.INT.MARGIN.OPER,Y.CNT1> = 'ADD'
            END
            IF Y.FINAL.MARGIN.RATE LT 0 THEN
                R.INT.ARR.COND.OFS<AA.INT.MARGIN.OPER,Y.CNT1> = 'SUB'
            END
            R.INT.ARR.COND.OFS<AA.INT.MARGIN.RATE,Y.CNT1> = ABS(Y.FINAL.MARGIN.RATE)
            Y.CNT1 += 1
        REPEAT
    END
    GOSUB UPDATE.REVIEW.DATES
    GOSUB POST.MARGIN.OFS
    GOSUB PENALTY.UPDATE
RETURN
*------------------------------------------------------------------------------
POST.MARGIN.OFS:
*------------------------------------------------------------------------------
    Y.ACT.PROP=''
    Y.ACT.PROP<1> = Y.PRIN.PROP
    Y.ACT.PROP<2> = "LENDING-CHANGE-":Y.PRIN.PROP
    OFS.STRING.FINAL = ''
*CALL APAP.AA.REDO.AA.BUILD.OFS(ARR.ID,R.INT.ARR.COND.OFS,Y.ACT.PROP,OFS.STRING.FINAL) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoAaBuildOfs(ARR.ID,R.INT.ARR.COND.OFS,Y.ACT.PROP,OFS.STRING.FINAL) ;*MANUAL R22 CODE CONVERSION
    OFS.SRC = 'AA.INT.UPDATE'
    OPTIONS = ''
    OFS.STRING.FINAL:="EFFECTIVE.DATE:1:1=":Y.CHECK.DATE
* PACS00625964 - S
*    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)
    OFS.RESP   = ""; TXN.COMMIT = ""
    CALL OCOMO("Change principalint procssed for via POST - ":ARR.ID:" - START")
    CALL OFS.CALL.BULK.MANAGER(OFS.SRC, OFS.STRING.FINAL, OFS.RESP, TXN.COMMIT)
* PACS00625964 - E
    GOSUB UPDATE.SUCCES.RATE
    Y.FLAG = '1'
RETURN
*-----------------------------------------------------------
PENALTY.UPDATE:
*-----------------------------------------------------------

    R.PENAL.COND.OFS = ''
    PROP.NAME='PENALTY'       ;* Interest Property to obtain
*CALL APAP.TAM.REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,OUT.PROP,ERR) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoGetInterestProperty(ARR.ID,PROP.NAME,OUT.PROP,ERR) ;*MANUAL R22 CODE CONVERSION
    Y.PENAL.PROP=OUT.PROP     ;* This variable hold the value of principal interest property

    Y.ARRG.ID = ARR.ID
    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PENAL.PROP
    EFF.DATE = ''
    ERR.MSG = ''
    R.PENAL.COND = ''
*CALL APAP.AA.REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PENAL.COND,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PENAL.COND,ERR.MSG) ;*MANUAL R22 CODE CONVERSION

    IF Y.MARGIN.INT.RATE NE '' AND Y.MARGIN.RATE EQ '' THEN
        Y.FIXED.RATE = R.PENAL.COND<AA.INT.FIXED.RATE>
        Y.RATE.CNT = DCOUNT(Y.FIXED.RATE,@VM)
        Y.RATE=1
        LOOP
        WHILE Y.RATE LE Y.RATE.CNT
            R.PENAL.COND.OFS<AA.INT.FIXED.RATE,Y.RATE> = Y.MARGIN.INT.RATE
            R.PENAL.COND.OFS<AA.INT.FLOATING.INDEX,Y.RATE> = ''
            Y.AA.MAR = R.PENAL.COND<AA.INT.MARGIN.TYPE,Y.RATE>
            Y.MAR.VAL = 1

            Y.MAR.CNT = DCOUNT(Y.AA.MAR,@SM)
            LOOP
            WHILE Y.MAR.VAL LE Y.MAR.CNT

                R.PENAL.COND.OFS<AA.INT.MARGIN.RATE,Y.RATE,Y.MAR.VAL> = '0'

                Y.MAR.VAL += 1
            REPEAT


            Y.RATE += 1
        REPEAT

    END
    IF Y.MARGIN.RATE NE '' AND Y.MARGIN.INT.RATE EQ '' THEN
        Y.RATE.CNT = DCOUNT(R.PENAL.COND<AA.INT.FIXED.RATE>,@VM)
        Y.CNT1 = 1
        LOOP
        WHILE Y.CNT1 LE Y.RATE.CNT
            Y.FINAL.MARGIN.RATE = 0
            Y.SUB.CNT = DCOUNT(R.PENAL.COND<AA.INT.MARGIN.RATE,Y.CNT1>,@SM)
            Y.CNT2 = 1
            LOOP
            WHILE Y.CNT2 LE Y.SUB.CNT
                IF R.PENAL.COND<AA.INT.MARGIN.OPER,Y.CNT1,Y.CNT2> EQ 'ADD' THEN
                    Y.FINAL.MARGIN.RATE += R.PENAL.COND<AA.INT.MARGIN.RATE,Y.CNT1,Y.CNT2>
                END
                IF R.PENAL.COND<AA.INT.MARGIN.OPER,Y.CNT1,Y.CNT2> EQ 'SUB' THEN
                    Y.FINAL.MARGIN.RATE -= R.PENAL.COND<AA.INT.MARGIN.RATE,Y.CNT1,Y.CNT2>
                END
                Y.CNT2 += 1
            REPEAT
            IF Y.MARGIN.OPERAND EQ 'ADD' THEN
                Y.FINAL.MARGIN.RATE+=Y.MARGIN.RATE
            END
            IF Y.MARGIN.OPERAND EQ 'SUB' THEN
                Y.FINAL.MARGIN.RATE-=Y.MARGIN.RATE
            END
            R.PENAL.COND.OFS<AA.INT.MARGIN.TYPE,Y.CNT1> = Y.MARGIN.TYPE
            IF Y.FINAL.MARGIN.RATE GE 0 THEN
                R.PENAL.COND.OFS<AA.INT.MARGIN.OPER,Y.CNT1> = 'ADD'
            END
            IF Y.FINAL.MARGIN.RATE LT 0 THEN
                R.PENAL.COND.OFS<AA.INT.MARGIN.OPER,Y.CNT1> = 'SUB'
            END
            R.PENAL.COND.OFS<AA.INT.MARGIN.RATE,Y.CNT1> = ABS(Y.FINAL.MARGIN.RATE)
            Y.CNT1 += 1
        REPEAT
    END

    R.PENAL.COND.OFS<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT> =  R.INT.ARR.COND.OFS<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT>
    R.PENAL.COND.OFS<AA.INT.LOCAL.REF,Y.SND.REV.DT.POS>    =  R.INT.ARR.COND.OFS<AA.INT.LOCAL.REF,Y.SND.REV.DT.POS>

    Y.ACT.PROP=''
    Y.ACT.PROP<1> = Y.PENAL.PROP
    Y.ACT.PROP<2> = "LENDING-CHANGE-":Y.PENAL.PROP
    OFS.STRING.FINAL = ''
*CALL APAP.AA.REDO.AA.BUILD.OFS(ARR.ID,R.PENAL.COND.OFS,Y.ACT.PROP,OFS.STRING.FINAL) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoAaBuildOfs(ARR.ID,R.PENAL.COND.OFS,Y.ACT.PROP,OFS.STRING.FINAL) ;*MANUAL R22 CODE CONVERSION
    OFS.SRC = 'AA.INT.UPDATE'
    OPTIONS = ''
    OFS.STRING.FINAL:="EFFECTIVE.DATE:1:1=":Y.CHECK.DATE
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)
    CALL OCOMO("Arrangement Processed Successfully - ":ARR.ID)

RETURN
*----------------------------------------------------------
UPDATE.SUCCES.RATE:
*----------------------------------------------------------

    R.SUCESS.CHANGE.COB = ''
    R.SUCESS.CHANGE.COB<REDO.SUC.COB.DATE> = Y.CHECK.DATE
    Y.ARR.ID = ARR.ID
*
    CALL F.WRITE(FN.REDO.SUCESS.RATE.CHANGE.COB,Y.ARR.ID,R.SUCESS.CHANGE.COB)
*
RETURN
*----------------------------------------------------------
NON.CRITERIA.UPDATE:
*----------------------------------------------------------

    R.INT.ARR.COND.OFS = ''
    R.PENAL.COND.OFS  = ''

    IF Y.ERR.MSG THEN
        GOSUB WRITE.ERR.MSG
    END
    GOSUB GET.TERM.AMOUNT
    GOSUB UPDATE.REVIEW.DATES
    Y.ACT.PROP=''
    Y.ACT.PROP<1> = Y.PRIN.PROP
    Y.ACT.PROP<2> = "LENDING-CHANGE-":Y.PRIN.PROP
    OFS.STRING.FINAL = ''
*CALL APAP.AA.REDO.AA.BUILD.OFS(ARR.ID,R.INT.ARR.COND.OFS,Y.ACT.PROP,OFS.STRING.FINAL) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoAaBuildOfs(ARR.ID,R.INT.ARR.COND.OFS,Y.ACT.PROP,OFS.STRING.FINAL) ;*MANUAL R22 CODE CONVERSION
    OFS.SRC = 'AA.INT.UPDATE'
    OPTIONS = ''
    OFS.STRING.FINAL:="EFFECTIVE.DATE:1:1=":Y.CHECK.DATE
* PACS00625964 - S
*    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)
    OFS.RESP   = ""; TXN.COMMIT = ""
    CALL OCOMO("Change principalint procssed for via CRI - ":ARR.ID:" - START")
    CALL OFS.CALL.BULK.MANAGER(OFS.SRC, OFS.STRING.FINAL, OFS.RESP, TXN.COMMIT)
* PACS00625964 - E

    PROP.NAME='PENALTY'       ;* Interest Property to obtain
*CALL APAP.TAM.REDO.GET.INTEREST.PROPERTY(ARR.ID,PROP.NAME,OUT.PROP,ERR) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.redoGetInterestProperty(ARR.ID,PROP.NAME,OUT.PROP,ERR) ;*MANUAL R22 CODE CONVERSION
    Y.PENAL.PROP=OUT.PROP     ;* This variable hold the value of principal interest property

    Y.ARRG.ID = ARR.ID
    PROPERTY.CLASS = 'INTEREST'
    PROPERTY = Y.PENAL.PROP
    EFF.DATE = ''
    ERR.MSG = ''
    R.PENAL.COND = ''
*CALL APAP.AA.REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PENAL.COND,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PENAL.COND,ERR.MSG) ;*MANUAL R22 CODE CONVERSION

    R.PENAL.COND.OFS<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT> =  R.INT.ARR.COND.OFS<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT>
    R.PENAL.COND.OFS<AA.INT.LOCAL.REF,Y.SND.REV.DT.POS>    =  R.INT.ARR.COND.OFS<AA.INT.LOCAL.REF,Y.SND.REV.DT.POS>

    Y.ACT.PROP=''
    Y.ACT.PROP<1> = Y.PENAL.PROP
    Y.ACT.PROP<2> = "LENDING-CHANGE-":Y.PENAL.PROP
    OFS.STRING.FINAL = ''
*CALL APAP.AA.REDO.AA.BUILD.OFS(ARR.ID,R.PENAL.COND.OFS,Y.ACT.PROP,OFS.STRING.FINAL)  ;*MANUAL R22 CODE CONVERSION
    CALL APAP.AA.redoAaBuildOfs(ARR.ID,R.PENAL.COND.OFS,Y.ACT.PROP,OFS.STRING.FINAL) ;*MANUAL R22 CODE CONVERSION
    OFS.SRC = 'AA.INT.UPDATE'
    OPTIONS = ''
    OFS.STRING.FINAL:="EFFECTIVE.DATE:1:1=":Y.CHECK.DATE
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)
    CALL OCOMO("Change penaltyint procssed for - ":ARR.ID)
    GOSUB END1

RETURN
*------------------
UPDATE.REVIEW.DATES:
*------------------
    IF Y.AA.RT.REV.FQU ELSE
        RETURN
    END
    Y.REVIEW.FREQ = Y.AA.RT.REV.FQU

*-------------------PACS00165067---------------------
    FREQ = Y.AA.RT.REV.FQU
    Y.DATE = Y.CHECK.DATE
*CALL APAP.TAM.REDO.GET.NEXT.CYCLEDATE(ARR.ID,FREQ,Y.DATE,Y.OUT.DATE) ;*MANUAL R22 CODE CONVERSION
    CALL APAP.TAM.RedoGetNextCycledate(ARR.ID,FREQ,Y.DATE,Y.OUT.DATE) ;*MANUAL R22 CODE CONVERSION
*-------------------PACS00165067---------------------
    Y.NEXT.DATE = Y.OUT.DATE
    IF Y.NEXT.DATE GE Y.MAT.DATE THEN
        Y.NEXT.DATE = Y.CHECK.DATE
    END
    R.INT.ARR.COND.OFS<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT> = Y.CHECK.DATE
    R.INT.ARR.COND.OFS<AA.INT.LOCAL.REF,Y.SND.REV.DT.POS>    = Y.NEXT.DATE
RETURN
*------------------
WRITE.ERR.MSG:
*------------------
    Y.WRITE.ID = TODAY:'*':ARR.ID
*CALL F.READ(FN.REDO.MASSIVE.RATE.CHANGE,Y.WRITE.ID,R.REDO.MASSIVE.RATE.CHANGE,F.REDO.MASSIVE.RATE.CHANGE,MASSIVE.RATE.ERR)
    R.REDO.MASSIVE.RATE.CHANGE = ARR.ID:'-':Y.ERR.MSG
    CALL F.WRITE(FN.REDO.MASSIVE.RATE.CHANGE,Y.WRITE.ID,R.REDO.MASSIVE.RATE.CHANGE)
    CALL OCOMO("Automatic Rate Change reason - ":ARR.ID:'-':Y.ERR.MSG)
RETURN
*------------------
END1:
*------------------
END
