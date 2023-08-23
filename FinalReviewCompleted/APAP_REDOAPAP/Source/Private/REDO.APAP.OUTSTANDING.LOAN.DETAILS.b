<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationCode : MjoxOTI4MDg5OTU5OkNwMTI1MjoxNjkwMjY0MjcxMDk3OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Jul 2023 11:21:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
=======
=======
>>>>>>> Stashed changes
* @ValidationCode : MjoxMDEwNjM0MjI2OkNwMTI1MjoxNjg1OTQ5MjM1MTg1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jun 2023 12:43:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
<<<<<<< Updated upstream
<<<<<<< Updated upstream
* @ValidationInfo : Compiler Version  : R22_SP5.0
=======
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
=======
* @ValidationInfo : Compiler Version  : R21_AMR.0
>>>>>>> Stashed changes
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.OUTSTANDING.LOAN.DETAILS(Y.FINAL.ARRAY,Y.END.DATE,Y.CRITERIA.SEL,Y.ENQ.OUT)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: SHANKAR RAJU
* PROGRAM NAME: REDO.APAP.OUTSTANDING.LOAN.DETAILS
* ODR NO      : ODR-2010-03-0176
*----------------------------------------------------------------------
*DESCRIPTION: This routine is a call routine to fetch the values for the loan id's selected
*IN PARAMETER:  NA
*OUT PARAMETER: Y.ENQ.OUT
*LINKED WITH: REDO.APAP.OUTSTANDING.LOAN routine
*Modification history:
*DATE              WHO                REFERENCE                        DESCRIPTION
*23-05-2023      MOHANRAJ R        AUTO R22 CODE CONVERSION         VM TO @VM,FM TO @FM,SM TO @SM,++ TO +=1
*23-05-2023      MOHANRAJ R        MANUAL R22 CODE CONVERSION         changed to AA.CUS.CUSTOMER
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.INTEREST
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.REDO.AA.PAYMENT.DETAILS
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
    $INSERT I_F.REDO.H.CUSTOMER.PROVISIONING
    $INSERT I_F.REDO.H.PROVISION.PARAMETER
    $INSERT I_F.REDO.AA.CHARGE.PARAM
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    $USING APAP.AA
    $USING APAP.TAM
=======
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes

    GOSUB OPEN.FILES
    GOSUB GET.LOCAL.FLDPOS
    GOSUB ASSIGN.VALUES
RETURN
*---------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------
    Y.ARR.ID = '' ;Y.PRE.LOAN.NO = '' ; Y.LOAN.BK.TYP = '' ; Y.PRODUCT.TYP = '' ; Y.CAMPAIGN.TYPE = ''
    Y.AGENCY.CODE = '' ; Y.AFF.COMPANY = '' ; Y.CLIENT.NAME = '' ; Y.CLIENT.NO = '' ; Y.ID.TYPE = ''
    Y.ID.NUMBER = '' ; Y.DAO = '' ; Y.CURRENCY = '' ; Y.OPENING.DATE = '' ; Y.MATURITY.DATE = ''
    Y.COLLATERAL.NAME = '' ; Y.APPRVD.VAL = 0 ; Y.PAIDUP.VALUE = 0 ; Y.INTEREST.RATE = 0 ; Y.LAS.REV.DAT = ''
    Y.NXT.REV.DAT = '' ; Y.POOL.RATE = 0 ; Y.LOAN.OVRAL.STAT = '' ; Y.LOAN.STATUS = '' ; Y.FORM.OF.PAYMNT = ''
    Y.TOTAL.CAP.BAL = 0 ; Y.INTEREST.BALANCE = 0 ; Y.BALANCE.CHARGE = 0;Y.TOT.BAL.DUE = 0 ; Y.LIAB.BAL = 0 ; Y.BILL.AMOUNT = 0
    Y.UNPAID.BILL.CNT = 0 ; Y.DELAYED.BILLS.VAL = 0 ; Y.FORMAT.TYPE = '' ; Y.DEBIT.AC = '' ; Y.TYPE.OF.SECURITY = ''
    Y.SEC.NO = '' ; Y.SEC.VAL  = 0 ; Y.GUAR.VAL.USED = 0 ;Y.CLASSIFIC  = '' ; Y.PROVISION.VALUE = 0 ; Y.LIFE.POL.NO = '' ; Y.FLAG = 1
    Y.LIFE.GUAR.VAL = "" ; Y.LIFE.GUAR.EXTRAVAL = "" ; Y.PROP.POL.NO = '' ; Y.PROP.POL.VAL = "" ; Y.VEHI.POL.NO = '' ; Y.VEHI.POL.VAL = "" ; Y.AGING.STATUS = ''
RETURN
*----------------------------------------------------------------------
OPEN.FILES:
*----------------------------------------------------------------------
    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    FN.AA.ARRANGEMENT.ACTIVITY='F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY=''
    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.COLLATERAL = 'F.COLLATERAL'
    F.COLLATERAL = ''
    FN.AA.INTEREST.ACCRUALS='F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS=''
    FN.REDO.H.CUSTOMER.PROVISIONING = 'F.REDO.H.CUSTOMER.PROVISIONING'
    F.REDO.H.CUSTOMER.PROVISIONING = ''
    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    FN.REDO.AA.PAYMENT.DETAILS = 'F.REDO.AA.PAYMENT.DETAILS'
    F.REDO.AA.PAYMENT.DETAILS = ''
    CALL OPF(FN.REDO.AA.PAYMENT.DETAILS,F.REDO.AA.PAYMENT.DETAILS)
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
    CALL OPF(FN.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING)
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
    CALL OPF(FN.COLLATERAL,F.COLLATERAL)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'
    F.REDO.APAP.PROPERTY.PARAM  = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.REDO.H.PROVISION.PARAMETER = 'F.REDO.H.PROVISION.PARAMETER'
    F.REDO.H.PROVISION.PARAMETER  = ''
    CALL OPF(FN.REDO.H.PROVISION.PARAMETER,F.REDO.H.PROVISION.PARAMETER)

    CALL CACHE.READ(FN.REDO.H.PROVISION.PARAMETER,'SYSTEM',R.REDO.H.PROVISION.PARAMETER,PARAM.ERR)

    FN.REDO.AA.CHARGE.PARAM = 'F.REDO.AA.CHARGE.PARAM'
    F.REDO.AA.CHARGE.PARAM  = ''
    CALL OPF(FN.REDO.AA.CHARGE.PARAM,F.REDO.AA.CHARGE.PARAM)

    CALL CACHE.READ(FN.REDO.AA.CHARGE.PARAM,'SYSTEM',R.REDO.AA.CHARGE.PARAM,PARAM.ERR)

    LOCATE 'LIFE.INS' IN R.REDO.AA.CHARGE.PARAM<REDO.AA.CHG.POLICY.CLASSIFY,1> SETTING POS1 THEN
        Y.LIFE.INS.TYPE = R.REDO.AA.CHARGE.PARAM<REDO.AA.CHG.POLICY.TYPE,POS1>
        CHANGE @SM TO @VM IN Y.LIFE.INS.TYPE
    END
    LOCATE 'VEH.INS' IN R.REDO.AA.CHARGE.PARAM<REDO.AA.CHG.POLICY.CLASSIFY,1> SETTING POS2 THEN
        Y.VEH.INS.TYPE  = R.REDO.AA.CHARGE.PARAM<REDO.AA.CHG.POLICY.TYPE,POS2>
        CHANGE @SM TO @VM IN Y.VEH.INS.TYPE
    END
    LOCATE 'CONS.INS' IN R.REDO.AA.CHARGE.PARAM<REDO.AA.CHG.POLICY.CLASSIFY,1> SETTING POS3 THEN
        Y.CONS.INS.TYPE = R.REDO.AA.CHARGE.PARAM<REDO.AA.CHG.POLICY.TYPE,POS3>
        CHANGE @SM TO @VM IN Y.CONS.INS.TYPE
    END
RETURN
*----------------------------------------------------------------------
GET.LOCAL.FLDPOS:
*----------------
    LOC.REF.APPLICATION="AA.PRD.DES.CUSTOMER":@FM:"CUSTOMER":@FM:"AA.PRD.DES.TERM.AMOUNT":@FM:"COLLATERAL":@FM:"AA.PRD.DES.ACCOUNT":@FM:"AA.PRD.DES.CHARGE":@FM:"AA.PRD.DES.PAYMENT.SCHEDULE":@FM:"AA.ARR.INTEREST":@FM:"AA.ARR.OVERDUE":@FM:"ACCOUNT"
    LOC.REF.FIELDS='L.AA.CAMP.TY':@VM:'L.AA.AFF.COM':@FM:'L.CU.CIDENT':@VM:'L.CU.RNC':@FM:'L.AA.COL':@VM:'L.AA.COL.VAL':@VM:'INS.AMOUNT':@VM:'L.AA.AV.COL.BAL':@FM:'L.COL.VALU.NAM':@FM:'L.AA.AGNCY.CODE':@FM:'POLICY.TYPE':@VM:'POL.NUMBER':@VM:'MNTY.POLICY.AMT':@VM:'EXTRA.POLICY':@FM:'L.AA.FORM':@VM:'L.AA.DEBT.AC':@VM:'L.AA.PAY.METHD':@FM:'L.AA.RT.RV.FREQ':@VM:'L.AA.LST.REV.DT':@VM:'L.AA.NXT.REV.DT':@VM:'L.AA.POOL.RATE':@FM:'L.LOAN.STATUS.1':@FM:'L.OD.STATUS'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.CAMP.TYPE=LOC.REF.POS<1,1>
    POS.L.AA.AFF.COM=LOC.REF.POS<1,2>
    POS.L.CU.CIDENT=LOC.REF.POS<2,1>
    POS.L.CU.RNC=LOC.REF.POS<2,2>
    POS.L.AA.COL = LOC.REF.POS<3,1>
    POS.L.AA.COL.VAL = LOC.REF.POS<3,2>
    POS.INS.AMOUNT = LOC.REF.POS<3,3>
    POS.L.AA.AV.COL.BAL = LOC.REF.POS<3,4>
    POS.L.COL.VALU.NAM = LOC.REF.POS<4,1>
    POS.AGENCY.CODE = LOC.REF.POS<5,1>
*POS.POLICY = LOC.REF.POS<6,1>
*POS.POLICY.NUMBER = LOC.REF.POS<6,2>
*POS.MON.POL.AMT = LOC.REF.POS<6,3>
*POS.EXTRA.AMT = LOC.REF.POS<6,4>
    POS.POLICY.TYPE      = LOC.REF.POS<6,1>
    POS.POL.NUMBER       = LOC.REF.POS<6,2>
    POS.MNTY.POLICY.AMT  = LOC.REF.POS<6,3>
    POS.EXTRA.POLICY     = LOC.REF.POS<6,4>
    POS.L.AA.FORM = LOC.REF.POS<7,1>
    POS.L.AA.DEBT.AC = LOC.REF.POS<7,2>
    POS.L.AA.PAY.METHD = LOC.REF.POS<7,3>
    POS.L.AA.RT.RV.FREQ = LOC.REF.POS<8,1>
    POS.L.AA.LST.REV.DT = LOC.REF.POS<8,2>
    POS.L.AA.NXT.REV.DT = LOC.REF.POS<8,3>
    POS.L.AA.POOL.RATE = LOC.REF.POS<8,4>
    POS.L.LOAN.STATUS.1 = LOC.REF.POS<9,1>
    POS.L.OD.STATUS     = LOC.REF.POS<10,1>
RETURN
*----------------------------------------------------------------------
ARR.CONDITION:
*-------------
    EFF.DATE = ''
    R.CONDITION = ''
    ERR.MSG = ''
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*    CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
=======
    CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
>>>>>>> Stashed changes
=======
    CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
>>>>>>> Stashed changes
RETURN
*----------------------------------------------------------------------
GET.PRODUCT.DETAIL:
*------------------
    R.ARRANGEMENT=''
    CALL F.READ(FN.AA.ARRANGEMENT,Y.ARR.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
RETURN
*----------------------------------------------------------------------
ASSIGN.VALUES:
*-------------
    Y.PARAM.ARRAY = ''
    Y.ARR.COUNT=DCOUNT(Y.FINAL.ARRAY,@FM)
    VAR1=1
    LOOP
    WHILE VAR1 LE Y.ARR.COUNT
        CRT "REDO.APAP.OUTSTANDING.LOAN.DETAILS - ":VAR1:"/":Y.ARR.COUNT
        GOSUB INIT
        Y.FLAG = 0
        Y.ARR.ID = Y.FINAL.ARRAY<VAR1>      ;*------------------------------------------------------------------------- 1ST FIELD VALUE
        GOSUB GET.PRODUCT.DETAIL
        GOSUB EVAL.CRITERIA
        IF  Y.FLAG EQ 1 ELSE
            VAR1 += 1
            CONTINUE
        END
        GOSUB PICK.AND.ASSIGN
        GOSUB FORM.ARRAY
        VAR1 += 1

    REPEAT
RETURN
*-----------------------------------------------------------------------
PICK.AND.ASSIGN:
*---------------

    PROP.CLASS='CUSTOMER'
    PROPERTY = ''
    GOSUB ARR.CONDITION
    Y.CUSTOMER.CONDITION=R.CONDITION
    PROP.CLASS='ACCOUNT'
    PROPERTY = ''
    GOSUB ARR.CONDITION
    Y.ACCOUNT.CONDITION=R.CONDITION
    Y.PRE.LOAN.NO = Y.ACCOUNT.CONDITION<AA.AC.ALT.ID>         ;*----------------------------------------------------- 2ND FIELD VALUE
    Y.LOAN.BK.TYP = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>       ;*----------------------------------------------------- 3RD FIELD VALUE
    Y.PRODUCT.TYP = R.ARRANGEMENT<AA.ARR.PRODUCT>   ;*--------------------------------------------------------------- 4TH FIELD VALUE
    Y.CAMPAIGN.TYPE  =Y.CUSTOMER.CONDITION<AA.CUS.LOCAL.REF,POS.L.AA.CAMP.TYPE>   ;*--------------------------------- 5TH FIELD VALUE
    Y.AGENCY.CODE = Y.ACCOUNT.CONDITION<AA.AC.LOCAL.REF,POS.AGENCY.CODE>          ;*--------------------------------- 6TH FIELD VALUE
    Y.AFF.COMPANY = Y.CUSTOMER.CONDITION<AA.CUS.LOCAL.REF,POS.L.AA.AFF.COM>       ;*--------------------------------- 7TH FIELD VALUE
    Y.PRI.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.CUSTOMER>     ;*R22 Manual Conversion - changed to AA.CUS.CUSTOMER
    Y.OWNER.S = Y.CUSTOMER.CONDITION<AA.CUS.CUSTOMER>       ;*R22 Manual Conversion - changed to AA.CUS.CUSTOMER
    GOSUB CUST.DET    ;*--------------------------------------------------------------------------------------------- 8TH FIELD VALUE
    Y.CLIENT.NO = R.ARRANGEMENT<AA.ARR.CUSTOMER>    ;*--------------------------------------------------------------- 9TH FIELD VALUE
    GOSUB GET.ID.TYPE ;*----------------------------------------------------------------------------------- 10TH FIELD VALUE
    Y.CU.CIDENT   = R.CUS<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT>
    Y.CU.RNC      = R.CUS<EB.CUS.LOCAL.REF,POS.L.CU.RNC>
    Y.CU.LEGAL.ID = R.CUS<EB.CUS.LEGAL.ID>
    IF Y.CU.CIDENT NE '' THEN
        IF Y.CU.RNC NE '' THEN
            IF Y.CU.LEGAL.ID  NE '' THEN
                Y.ID.NUMBER = Y.CU.CIDENT:@VM:Y.CU.RNC:@VM:Y.CU.LEGAL.ID
            END ELSE
                Y.ID.NUMBER = Y.CU.CIDENT:@VM:Y.CU.RNC
            END
        END ELSE
            IF Y.CU.LEGAL.ID  NE '' THEN
                Y.ID.NUMBER = Y.CU.CIDENT:@VM:Y.CU.LEGAL.ID
            END ELSE
                Y.ID.NUMBER = Y.CU.CIDENT
            END
        END
    END ELSE
        IF Y.CU.RNC NE '' THEN
            IF Y.CU.LEGAL.ID  NE '' THEN
                Y.ID.NUMBER = Y.CU.RNC:@VM:Y.CU.LEGAL.ID
            END ELSE
                Y.ID.NUMBER = Y.CU.RNC
            END
        END ELSE
            IF Y.CU.LEGAL.ID  NE '' THEN
                Y.ID.NUMBER = Y.CU.LEGAL.ID     ;*---- 11TH FIELD VALUE
            END ELSE
                Y.ID.NUMBER = ''
            END
        END
    END
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*  CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
    APAP.TAM.redoConvertAccount(IN.ACC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)   ;*R22 Manual Code Conversion
=======
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
>>>>>>> Stashed changes
=======
    CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,Y.ARR.ID,OUT.ID,ERR.TEXT)
>>>>>>> Stashed changes
    Y.ACCT.NO = OUT.ID
    CALL F.READ(FN.ACCOUNT,OUT.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.DAO = R.ACCOUNT<AC.ACCOUNT.OFFICER> ;*--------------------------------------------------------------- 12TH FIELD VALUE
    Y.CURRENCY = R.ARRANGEMENT<AA.ARR.CURRENCY>     ;*--------------------------------------------------------------- 13TH FIELD VALUE
    Y.OPENING.DATE=R.ARRANGEMENT<AA.ARR.START.DATE> ;*----------------------------------------------------- 14TH FIELD VALUE
    Y.AGING.STATUS= R.ACCOUNT<AC.LOCAL.REF,POS.L.OD.STATUS>
    PROP.CLASS = 'TERM.AMOUNT'
    PROPERTY = ''
    GOSUB ARR.CONDITION
    TERM.CONDITION = R.CONDITION
    Y.MATURITY.DATE = TERM.CONDITION<AA.AMT.MATURITY.DATE>    ;*----------------------------------------------------- 15TH FIELD VALUE
    PROP.CLASS = 'PAYMENT.SCHEDULE'
    PROPERTY = ''
    GOSUB ARR.CONDITION
    PAYMENT.SCHEDULE.CONDITION = R.CONDITION
    IF PAYMENT.SCHEDULE.CONDITION THEN
        Y.FORMAT.TYPE = PAYMENT.SCHEDULE.CONDITION<AA.PS.LOCAL.REF,POS.L.AA.PAY.METHD>        ;*----------------------- 38TH FIELD VALUE
        Y.DEBIT.AC = PAYMENT.SCHEDULE.CONDITION<AA.PS.LOCAL.REF,POS.L.AA.DEBT.AC>   ;*----------------------- 39TH FIELD VALUE
    END
    Y.SEC.NO = TERM.CONDITION<AA.AMT.LOCAL.REF,POS.L.AA.COL>  ;*------------------------------------------- 41ST FIELD VALUE
    Y.SEC.VAL += TERM.CONDITION<AA.AMT.LOCAL.REF,POS.L.AA.COL.VAL>      ;*------------------------------------------- 42ND FIELD VALUE
    Y.GUAR.VAL.USED = Y.SEC.VAL - TERM.CONDITION<AA.AMT.LOCAL.REF,POS.L.AA.AV.COL.BAL>      ;*----------------------- 43RD FIELD VALUE
    GOSUB GET.COLLATERAL.DET    ;*----------------------------------------------------------------------------------- 16TH & 40TH FIELD VALUE
*GOSUB GET.CHARGE.PROPERTY
*Y.CHRG.CNT=DCOUNT(Y.CHARGE.PROPERTY,FM)
*Y.VAR1=1
*LOOP
*WHILE Y.VAR1 LE Y.CHRG.CNT
*PROP.CLASS = 'CHARGE'
*PROPERTY = Y.CHARGE.PROPERTY<Y.VAR1>
*GOSUB ARR.CONDITION
*CHARGE.CONDITION = R.CONDITION
*IF CHARGE.CONDITION THEN
*Y.POLICY.TYPE=R.CONDITION<AA.CHG.LOCAL.REF,POS.POLICY>
*Y.POLICY.CNT=DCOUNT(Y.POLICY.TYPE,SM)
*CHANGE SM TO FM IN Y.POLICY.TYPE
*Y.COUNT =1
*LOOP
*WHILE Y.COUNT LE Y.POLICY.CNT
*Y.POLICY=Y.POLICY.TYPE<Y.COUNT>
*GOSUB POLICY.CHECK
*Y.COUNT++
*REPEAT
*END
*Y.VAR1++
*REPEAT
    GOSUB POLICY.CHECK
    Y.APPRVD.VAL = TERM.CONDITION<AA.AMT.AMOUNT>    ;*--------------------------------------------------------------- 19TH FIELD VALUE
    GOSUB GET.PAIDUP.VALUE      ;*----------------------------------------------------------------------------------- 20TH FIELD VALUE
    GOSUB GET.INTEREST.RATE     ;*----------------------------------------------------------------------------------- 21ST FIELD VALUE
    GOSUB GET.ARR.INTEREST      ;*----------------------------------------------------------------------------------- 22ND FIELD VALUE
    Y.LOAN.OVRAL.STAT = R.ARRANGEMENT<AA.ARR.ARR.STATUS>      ;*----------------------------------------------------- 26TH FIELD VALUE
    GOSUB GET.ARR.OVERDUE.DETAILS         ;*------------------------------------------------------------------------- 27TH FIELD VALUE
    Y.FORM.OF.PAYMNT = PAYMENT.SCHEDULE.CONDITION<AA.PS.PAYMENT.TYPE>   ;*------------------------------------------- 28TH FIELD VALUE
    GOSUB ACCT.ACT.BK.BAL       ;*----------------------------------------------------------------------------------- 29TH FIELD VALUE
    GOSUB ACCT.INT.BAL          ;*----------------------------------------------------------------------------------- 30TH FIELD VALUE
    GOSUB CALL.GET.CHARGE       ;*----------------------------------------------------------------------------------- 31ST & 32ND FIELD VALUE
    GOSUB CALL.GET.ACC.INT      ;*----------------------------------------------------------------------------------- 37TH FIELD VALUE
    Y.CANCEL.VALUE = Y.INTEREST.BALANCE+Y.BALANCE.CHARGE+Y.TOTAL.CAP.BAL+Y.TOT.BAL.DUE - Y.LIAB.BAL   ;* We need to show the cancellation amount minus UNC balance.
*Y.BILL.AMOUNT = PAYMENT.SCHEDULE.CONDITION<AA.PS.CALC.AMOUNT>
    Y.DATE = TODAY
    Y.BILL.AMOUNT = 0
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*   CALL REDO.GET.NEXT.PAYMENT.AMOUNT.OLD(Y.ARR.ID,Y.DATE,Y.BILL.AMOUNT)
    APAP.TAM.redoGetNextPaymentAmountOld(Y.ARR.ID,Y.DATE,Y.BILL.AMOUNT) ;*R22 Manual Code Conversion
=======
    CALL REDO.GET.NEXT.PAYMENT.AMOUNT.OLD(Y.ARR.ID,Y.DATE,Y.BILL.AMOUNT)
>>>>>>> Stashed changes
=======
    CALL REDO.GET.NEXT.PAYMENT.AMOUNT.OLD(Y.ARR.ID,Y.DATE,Y.BILL.AMOUNT)
>>>>>>> Stashed changes
    CHANGE @VM TO @FM IN Y.BILL.AMOUNT
    CHANGE @SM TO @FM IN Y.BILL.AMOUNT
    Y.BILL.AMOUNT = SUM(Y.BILL.AMOUNT)    ;*------------------------------------------------------------------------- 35TH FIELD VALUE
    CALL F.READ(FN.REDO.H.CUSTOMER.PROVISIONING,Y.CLIENT.NO,R.REDO.H.CUSTOMER.PROVISIONING,F.REDO.H.CUSTOMER.PROVISIONING,ERR.RHCP)
    FINDSTR Y.LOAN.BK.TYP IN R.REDO.H.PROVISION.PARAMETER<PROV.PRODUCT.GROUP> SETTING LN.POS.AF,LN.POS.AV,LN.POS.AS THEN
        Y.LOAN.TYPE = R.REDO.H.PROVISION.PARAMETER<PROV.LOAN.TYPE,LN.POS.AV>
    END
    LOCATE Y.LOAN.TYPE IN R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.LOAN.TYPE,1> SETTING CCLS.POS THEN
        Y.CLASSIFIC = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.CURRENT.CLASS,CCLS.POS>
        LOCATE Y.ARR.ID IN R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.ARRANGEMENT.ID,1> SETTING PROV.POS THEN
            Y.PROVISION.VALUE = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.TOTAL.PROV,PROV.POS>

*Y.PROVISION.VALUE = R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.PRINC,PROV.POS>
*Y.PROVISION.VALUE += R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.INTEREST,PROV.POS>
*Y.PROVISION.VALUE += R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.RESTRUCT,PROV.POS>
*Y.PROVISION.VALUE += R.REDO.H.CUSTOMER.PROVISIONING<REDO.CUS.PROV.PROV.FX,PROV.POS>     ;*------------- 45TH FIELD VALUE
        END
    END ELSE
        Y.CLASSIFIC = R.CUS<EB.CUS.CUSTOMER.RATING>   ;*----------------------------------------------------- 44TH FIELD VALUE
    END
RETURN
*-----------------------------------------------------------------------------
CALL.GET.CHARGE:
*---------------
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    APAP.REDOAPAP.redoApapGetChargeAmt(Y.ARR.ID,Y.LOAN.BK.TYP,Y.FIRST.DISB.DATE,Y.END.DATE,Y.BALANCE.CHARGE,Y.TOT.BAL.DUE)     ;*------ 31ST & 32ND FIELD VALUE
=======
     APAP.REDOAPAP.redoApapGetChargeAmt(Y.ARR.ID,Y.LOAN.BK.TYP,Y.FIRST.DISB.DATE,Y.END.DATE,Y.BALANCE.CHARGE,Y.TOT.BAL.DUE)     ;*------ 31ST & 32ND FIELD VALUE
>>>>>>> Stashed changes
=======
     APAP.REDOAPAP.redoApapGetChargeAmt(Y.ARR.ID,Y.LOAN.BK.TYP,Y.FIRST.DISB.DATE,Y.END.DATE,Y.BALANCE.CHARGE,Y.TOT.BAL.DUE)     ;*------ 31ST & 32ND FIELD VALUE
>>>>>>> Stashed changes
    Y.BALANCE.CHARGE -= Y.TOT.BAL.DUE
RETURN
*-----------------------------------------------------------------------------
CALL.GET.ACC.INT:
*---------------
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    APAP.REDOAPAP.redoApapGetIntAcc(Y.ARR.ID,Y.FIRST.DISB.DATE,Y.END.DATE,Y.UNPAID.BILL.CNT,Y.DELAYED.BILLS.VAL)     ;*----------------- 36TH & 37TH FIELD VALUE
=======
     APAP.REDOAPAP.redoApapGetIntAcc(Y.ARR.ID,Y.FIRST.DISB.DATE,Y.END.DATE,Y.UNPAID.BILL.CNT,Y.DELAYED.BILLS.VAL)     ;*----------------- 36TH & 37TH FIELD VALUE
>>>>>>> Stashed changes
=======
     APAP.REDOAPAP.redoApapGetIntAcc(Y.ARR.ID,Y.FIRST.DISB.DATE,Y.END.DATE,Y.UNPAID.BILL.CNT,Y.DELAYED.BILLS.VAL)     ;*----------------- 36TH & 37TH FIELD VALUE
>>>>>>> Stashed changes
RETURN
*-----------------------------------------------------------------------------
ACCT.INT.BAL:
*-----------------------------------------------------------------------------
    Y.INTEREST.BALANCE = 0
    Y.PROPERTY.LIST = OUT.PROP
    Y.BALANCE.TYPE  = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    GOSUB GET.BALANCE
    Y.INTEREST.BALANCE = Y.BALANCE        ;*---------------------- 30TH FIELD VALUE

    Y.PENALTY.INT = 0
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*    CALL REDO.GET.INTEREST.PROPERTY(Y.ARR.ID,"PENALTY",PENAL.PROP,ERR)
    APAP.TAM.redoGetInterestProperty(Y.ARR.ID,"PENALTY",PENAL.PROP,ERR) ;*R22 Manual Code Conversion
=======
    CALL REDO.GET.INTEREST.PROPERTY(Y.ARR.ID,"PENALTY",PENAL.PROP,ERR)
>>>>>>> Stashed changes
=======
    CALL REDO.GET.INTEREST.PROPERTY(Y.ARR.ID,"PENALTY",PENAL.PROP,ERR)
>>>>>>> Stashed changes
    Y.PROPERTY.LIST = PENAL.PROP
    Y.BALANCE.TYPE  = 'ACC':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    GOSUB GET.BALANCE
    Y.PENALTY.INT = Y.BALANCE   ;*---------------------- 30TH FIELD VALUE
    Y.INTEREST.BALANCE += Y.PENALTY.INT     ;* Accrued penalty interest has been added to interest balance as per the issue raised by cristina on 11 Mar 2015.
RETURN
*-----------------------------------------------------------------------------
ACCT.ACT.BK.BAL:
*---------------

    Y.TOTAL.CAP.BAL = 0
    Y.ACCOUNT.PROPERTY = ''
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*    CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(Y.ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR) ;*R22 Manual Code onversion
=======
    CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)
>>>>>>> Stashed changes
=======
    CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)
>>>>>>> Stashed changes

    ACC.BALANCE.TYPE = 'CUR':@FM:'DUE':@FM:Y.OVERDUE.STATUS
    Y.PROPERTY.LIST = Y.ACCOUNT.PROPERTY
    Y.BALANCE.TYPE  = ACC.BALANCE.TYPE
    GOSUB GET.BALANCE
    Y.TOTAL.CAP.BAL = Y.BALANCE ;*-------------------------------- 29TH FIELD VALUE

    Y.LIAB.BAL      = 0
    Y.BALANCE.TYPE  = 'UNC'
    Y.PROPERTY.LIST = Y.ACCOUNT.PROPERTY
    GOSUB GET.BALANCE
    Y.LIAB.BAL      = Y.BALANCE ;*-------------------------------- 33RD FIELD VALUE


RETURN
*-----------------------------------------------------------------
GET.BALANCE:
*-----------------------------------------------------------------

    Y.BALANCE = 0
    Y.PROPERTY.CNT = DCOUNT(Y.PROPERTY.LIST,@FM)
    Y.BALANCE.CNT  = DCOUNT(Y.BALANCE.TYPE,@FM)
    Y.LOOP1 = 1
    LOOP
    WHILE Y.LOOP1 LE Y.PROPERTY.CNT
        Y.LOOP2 = 1
        LOOP
        WHILE Y.LOOP2 LE Y.BALANCE.CNT

            BALANCE.TO.CHECK = Y.BALANCE.TYPE<Y.LOOP2>:Y.PROPERTY.LIST<Y.LOOP1>
            BALANCE.AMOUNT=''
            CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ACCT.NO,BALANCE.TO.CHECK,TODAY,BALANCE.AMOUNT,RET.ERROR)
            Y.BALANCE += ABS(BALANCE.AMOUNT)
            Y.LOOP2 += 1
        REPEAT
        Y.LOOP1 += 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------
GET.ARR.OVERDUE.DETAILS:
*-----------------------
    Y.LOAN.STATUS = ''
    PROP.CLASS = 'OVERDUE'
    PROPERTY = ''
    GOSUB ARR.CONDITION
    OVERDUE.CONDITION = R.CONDITION
    Y.LOAN.STATUS    = OVERDUE.CONDITION<AA.OD.LOCAL.REF,POS.L.LOAN.STATUS.1>
    Y.OVERDUE.STATUS = OVERDUE.CONDITION<AA.OD.OVERDUE.STATUS>
*  CHANGE VM TO FM IN Y.OVERDUE.STATUS
    CHANGE @SM TO @FM IN Y.OVERDUE.STATUS
*GOSUB GET.AA.ACCOUNT.DETAILS
RETURN
*-----------------------------------------------------------------------------
GET.AA.ACCOUNT.DETAILS:
*----------------------
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ACCOUNT.DETAILS.ERR)
    Y.LN.STA = R.AA.ACCOUNT.DETAILS<AA.AD.ARR.AGE.STATUS>
    Y.FIRST.DISB.DATE = R.AA.ACCOUNT.DETAILS<AA.AD.START.DATE>
    IF Y.LN.STA EQ 'GRC' THEN
        Y.LOAN.STATUS<1,-1> = 'Current 0-30 days'
    END
    IF Y.LN.STA EQ 'DEL' THEN
        Y.LOAN.STATUS<1,-1> = 'Overdue from 31 to 90 days'
    END
    IF Y.LN.STA EQ 'NAB' THEN
        Y.LOAN.STATUS<1,-1> = 'Overdue more than 90 days'       ;*--------------------------------------------------- 27TH FIELD VALUE
    END
RETURN
*-----------------------------------------------------------------------------
GET.ARR.INTEREST:
*----------------
    PROP.CLASS = 'INTEREST'
    PROPERTY = OUT.PROP
    GOSUB ARR.CONDITION
    INTEREST.CONDITION = R.CONDITION
    IF INTEREST.CONDITION THEN
        Y.PER.RAT.REV = INTEREST.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.RT.RV.FREQ>    ;*--------------------- 22ND FIELD VALUE
        Y.LAS.REV.DAT = INTEREST.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.LST.REV.DT>    ;*--------------------- 23RD FIELD VALUE
        Y.NXT.REV.DAT = INTEREST.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.NXT.REV.DT>    ;*--------------------- 24TH FIELD VALUE
        Y.POOL.RATE = INTEREST.CONDITION<AA.INT.LOCAL.REF,POS.L.AA.POOL.RATE>       ;*------------------------------- 25TH FIELD VALUE
        Y.INTEREST.RATE = INTEREST.CONDITION<AA.INT.EFFECTIVE.RATE,1>     ;*---------------------------------------------------- 21ST FIELD VALUE
    END
RETURN
*-----------------------------------------------------------------------------
POLICY.CHECK:
*-----------------------------------------------------------------------------

    GOSUB GET.CHARGE.CONDITIONS ;* Here we will call AA.GET.ARRANGEMENT.CONDITIONS & get all the charge property arrangement conditions
    GOSUB GET.INSURANCE.DETAILS ;* Here we will get insurance details.

RETURN
*-----------------------------------------------------------------------------
*** <region name= GET.CHARGE.CONDITIONS>
GET.CHARGE.CONDITIONS:
*** <desc>Here we will call AA.GET.ARRANGEMENT.CONDITIONS & get all the charge property arrangement conditions</desc>
*-----------------------------------------------------------------------------

    EFF.DATE     = ""
    PROP.CLASS   = "CHARGE"
    PROPERTY     = ""
    R.CHARGE.CONDITION  = ""
    ERR.MSG      = ''
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*    CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CHARGE.CONDITION,ERR.MSG)
    APAP.AA.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CHARGE.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
=======
    CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CHARGE.CONDITION,ERR.MSG)

>>>>>>> Stashed changes
=======
    CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CHARGE.CONDITION,ERR.MSG)

>>>>>>> Stashed changes
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.INSURANCE.DETAILS>
GET.INSURANCE.DETAILS:
*** <desc>Here we will get insurance details.</desc>
*-----------------------------------------------------------------------------

    Y.DELIM = RAISE(@FM)
    Y.CHG.CNT = DCOUNT(R.CHARGE.CONDITION,Y.DELIM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.CHG.CNT
        R.CHG.COND = FIELD(R.CHARGE.CONDITION,Y.DELIM,Y.VAR1)
        GOSUB GET.CHARGE.DETAILS  ;* Get charge details
        Y.VAR1 += 1
    REPEAT
RETURN
*** </region>
*-----------------------------------------------------------------------------
*** <region name= GET.CHARGE.DETAILS>
GET.CHARGE.DETAILS:
*** <desc>Get charge details</desc>
*-----------------------------------------------------------------------------
    Y.POLICY.CNT = DCOUNT(R.CHG.COND<AA.CHG.LOCAL.REF,POS.POLICY.TYPE>,@SM)
    Y.VAR2 = 1
    LOOP
    WHILE Y.VAR2 LE Y.POLICY.CNT
        Y.POLICY.TYPE = R.CHG.COND<AA.CHG.LOCAL.REF,POS.POLICY.TYPE,Y.VAR2>

        BEGIN CASE
            CASE Y.POLICY.TYPE MATCHES Y.LIFE.INS.TYPE
                Y.LIFE.POL.NO<1,-1>     = R.CHG.COND<AA.CHG.LOCAL.REF,POS.POL.NUMBER,Y.VAR2>        ;*----------- 46TH FIELD VALUE
                Y.LIFE.GUAR.VAL<1,-1>   = R.CHG.COND<AA.CHG.LOCAL.REF,POS.MNTY.POLICY.AMT,Y.VAR2>   ;*----------- 47TH FIELD VALUE
                Y.LIFE.GUAR.EXTRAVAL<1,-1> = R.CHG.COND<AA.CHG.LOCAL.REF,POS.EXTRA.POLICY,Y.VAR2>   ;*----------- 48TH FIELD VALUE
            CASE Y.POLICY.TYPE MATCHES Y.VEH.INS.TYPE
                Y.VEHI.POL.NO<1,-1>  = R.CHG.COND<AA.CHG.LOCAL.REF,POS.POL.NUMBER,Y.VAR2> ;*---------------------- 51ST FIELD VALUE
                Y.VEHI.POL.VAL<1,-1> = R.CHG.COND<AA.CHG.LOCAL.REF,POS.MNTY.POLICY.AMT,Y.VAR2>      ;*-------------------------------- 52ND FIELD VALUE

            CASE Y.POLICY.TYPE MATCHES Y.CONS.INS.TYPE
                Y.PROP.POL.NO<1,-1> = R.CHG.COND<AA.CHG.LOCAL.REF,POS.POL.NUMBER,Y.VAR2>  ;*--------------------- 49TH FIELD VALUE
                Y.PROP.POL.VAL<1,-1> = R.CHG.COND<AA.CHG.LOCAL.REF,POS.MNTY.POLICY.AMT,Y.VAR2>      ;*------------------------------- 50TH FIELD VALUE
        END CASE
        Y.VAR2 += 1
    REPEAT

RETURN
*** </region>


*-----------------------------------------------------------------------------
GET.PAIDUP.VALUE:
*----------------

    Y.PAIDUP.VALUE = 0
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*  CALL REDO.GET.DISBURSEMENT.DETAILS(Y.ARR.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)
    APAP.TAM.redoGetDisbursementDetails(Y.ARR.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB) ;*R22 Manaul Code Conversion
=======
    CALL REDO.GET.DISBURSEMENT.DETAILS(Y.ARR.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)
>>>>>>> Stashed changes
=======
    CALL REDO.GET.DISBURSEMENT.DETAILS(Y.ARR.ID,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)
>>>>>>> Stashed changes
    Y.PAIDUP.VALUE = R.DISB.DETAILS<3>    ;*-------------------------------- 20TH FIELD VALUE




*SEL.COMD = "SELECT ":FN.REDO.AA.PAYMENT.DETAILS:" WITH ARR.ID EQ ":Y.ARR.ID
*CALL EB.READLIST(SEL.COMD,Y.ACT.ARR,'',NO.OF.ACCT.REC,COMD.ERR)
*CALL CACHE.READ('F.REDO.APAP.PROPERTY.PARAM',Y.LOAN.BK.TYP,R.REDO.APAP.PROPERTY.PARAM,PARA.ERR)
*Y.NO.OF.PRINC = DCOUNT(R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PRIN.DECREASE>,VM)
*PRIN.VAR = 1
*LOOP
*WHILE PRIN.VAR LE Y.NO.OF.PRINC
*Y.VAL.CHK = "LENDING-APPLYPAYMENT-":R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PRIN.DECREASE,PRIN.VAR>
*Y.PAIDUP.VALUE = 0
*Y.LIAB.BAL = 0
*LOOP
*REMOVE CURR.ARR.ID FROM Y.ACT.ARR SETTING Y.BAL.CHECK.POS
*WHILE CURR.ARR.ID:Y.BAL.CHECK.POS
*CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,CURR.ARR.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ERR.AAA)

*Y.PAIDUP.VALUE += R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>  ;*-------------------------------- 20TH FIELD VALUE
*IF R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.ACTIVITY> EQ Y.VAL.CHK THEN
*Y.LIAB.BAL += R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>  ;*-------------------------------- 33RD FIELD VALUE
*END
*REPEAT
*PRIN.VAR += 1
*REPEAT
*Y.LIAB.BAL = ABS(Y.LIAB.BAL)
RETURN
*----------------------------------------------------------------------
CUST.DET:
*--------
    CNT.ON.CK = ''
    CALL F.READ(FN.CUSTOMER,Y.PRI.OWNER,R.CUS,F.CUSTOMER,CUS.ERR)
    Y.CLIENT.NAME=R.CUS<EB.CUS.SHORT.NAME>          ;*-------------------------------------------------------------- 8TH FIELD VALUE
    Y.OWNER.S = CHANGE(Y.OWNER.S,@VM,@FM)
    Y.CNT.OWNER.S = DCOUNT(Y.OWNER.S,@FM)
    IF Y.CNT.OWNER.S EQ 1 THEN
        IF Y.OWNER.S NE Y.PRI.OWNER THEN
            CALL F.READ(FN.CUSTOMER,Y.OWNER.S,R.CUS1,F.CUSTOMER,CUS.ERR)
            Y.CLIENT.NAME<1,-1> = R.CUS1<EB.CUS.SHORT.NAME>
        END
    END ELSE
        LOOP
        WHILE Y.CNT.OWNER.S GT 0 DO
            CNT.ON.CK += 1
            Y.CK.OWNER = Y.OWNER.S<CNT.ON.CK>
            IF Y.CK.OWNER NE Y.PRI.OWNER THEN
                CALL F.READ(FN.CUSTOMER,Y.CK.OWNER,R.CUS2,F.CUSTOMER,CUS.ERR)
                Y.CLIENT.NAME<1,-1> = R.CUS2<EB.CUS.SHORT.NAME>
            END
            Y.CNT.OWNER.S -= 1
        REPEAT
    END
RETURN
*----------------------------------------------------------------------
GET.ID.TYPE:
*-----------
    IF R.CUS<EB.CUS.LOCAL.REF,POS.L.CU.CIDENT> NE '' THEN
        Y.ID.TYPE='CEDULA'        ;*---------------------------------------------------------------------------------- 12TH FIELD VALUE
        RETURN
    END
    IF R.CUS<EB.CUS.LEGAL.ID> NE '' THEN
        Y.ID.TYPE='PASAPORTE'     ;*---------------------------------------------------------------------------------- 12TH FIELD VALUE
        RETURN
    END
    IF R.CUS<EB.CUS.LOCAL.REF,POS.L.CU.RNC> NE '' THEN
        Y.ID.TYPE='RNC' ;*---------------------------------------------------------------------------------- 12TH FIELD VALUE
        RETURN
    END
RETURN
*----------------------------------------------------------------------
GET.COLLATERAL.DET:
*------------------
    CALL F.READ(FN.COLLATERAL,Y.SEC.NO,R.COLLATERAL,F.COLLATERAL,CALL.ERR)
    Y.COLLATERAL.NAME = R.COLLATERAL<COLL.LOCAL.REF,POS.L.COL.VALU.NAM> ;*-------------------------------- 16TH FIELD VALUE
    Y.TYPE.OF.SECURITY = R.COLLATERAL<COLL.COLLATERAL.CODE>   ;*COLLATERAL > TYPE.OF.SECURITY       ;*-------------- 40TH FIELD VALUE
RETURN
*----------------------------------------------------------------------
GET.INTEREST.RATE:
*----------------------------------------------------------------------
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*   CALL REDO.GET.INTEREST.PROPERTY(Y.ARR.ID,"PRINCIPAL",OUT.PROP,ERR)
    APAP.TAM.redoGetInterestProperty(Y.ARR.ID,"PRINCIPAL",OUT.PROP,ERR) ;*R22 Manual Code Conversion
=======
    CALL REDO.GET.INTEREST.PROPERTY(Y.ARR.ID,"PRINCIPAL",OUT.PROP,ERR)
>>>>>>> Stashed changes
=======
    CALL REDO.GET.INTEREST.PROPERTY(Y.ARR.ID,"PRINCIPAL",OUT.PROP,ERR)
>>>>>>> Stashed changes
*Y.INT.ID=Y.ARR.ID:'-':OUT.PROP
*CALL F.READ(FN.AA.INTEREST.ACCRUALS,Y.INT.ID,R.INT.ACCRUAL,F.AA.INTEREST.ACCRUALS,INT.ACC.ERR)
*Y.INTEREST.RATE=R.INT.ACCRUAL<AA.INT.ACC.RATE,1,1>      ;*---------------------------------------------------- 21ST FIELD VALUE
RETURN
*----------------------------------------------------------------------
GET.CHARGE.PROPERTY:
*----------------------------------------------------------------------
* This part get the charge properties for that loan
    Y.CHARGE.PROPERTY = ''
<<<<<<< Updated upstream
<<<<<<< Updated upstream
*   CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHARGE.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHARGE.PROPERTY,OUT.ERR) ;*R22 Manual Code Conversion
=======
    CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHARGE.PROPERTY,OUT.ERR)
>>>>>>> Stashed changes
=======
    CALL REDO.GET.PROPERTY.NAME(Y.ARR.ID,'CHARGE',R.OUT.AA.RECORD,Y.CHARGE.PROPERTY,OUT.ERR)
>>>>>>> Stashed changes

RETURN
*----------------------------------------------------------------------
EVAL.CRITERIA:      *ADD FOR CR039
*----------------------------------------------------------------------
    BEGIN CASE
        CASE Y.CRITERIA.SEL<2> EQ '3'
            IF Y.UNPAID.BILL.CNT LT Y.CRITERIA.SEL<1> THEN
                Y.FLAG = 1
            END
        CASE Y.CRITERIA.SEL<2> EQ '8'
            IF Y.UNPAID.BILL.CNT LE Y.CRITERIA.SEL<1> THEN
                Y.FLAG = 1
            END
        CASE Y.CRITERIA.SEL<2> EQ '1'
            IF Y.UNPAID.BILL.CNT EQ Y.CRITERIA.SEL<1> THEN
                Y.FLAG = 1
            END
        CASE Y.CRITERIA.SEL<2> EQ '4'
            IF Y.UNPAID.BILL.CNT GT Y.CRITERIA.SEL<1> THEN
                Y.FLAG = 1
            END
        CASE Y.CRITERIA.SEL<2> EQ '9'
            IF Y.UNPAID.BILL.CNT GE Y.CRITERIA.SEL<1> THEN
                Y.FLAG = 1
            END
        CASE 1
            Y.FLAG = 1
    END CASE

    GOSUB CHECK.CANCELLED.LOAN


RETURN

*----------------------------------------------------------------------
CHECK.CANCELLED.LOAN:
*----------------------------------------------------------------------
* we should not display the cancelled/paidoff loans in the report.


    Y.PRODUCT.GROUP.ID = R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>
    LOCATE Y.PRODUCT.GROUP.ID IN Y.PARAM.ARRAY<1,1> SETTING LOC.POS ELSE          ;* To avoild multiple read of same param record.
        CALL CACHE.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PRODUCT.GROUP.ID,R.REDO.APAP.PROPERTY.PARAM,PARAM.ERR)
        Y.PARAM.ARRAY<1,-1> = Y.PRODUCT.GROUP.ID
        Y.PAYOFF.ACTIVITIES = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PAYOFF.ACTIVITY>
        CHANGE @VM TO @SM IN Y.PAYOFF.ACTIVITIES
        Y.PARAM.ARRAY<2,-1> = Y.PAYOFF.ACTIVITIES
    END
    LOCATE Y.PRODUCT.GROUP.ID IN Y.PARAM.ARRAY<1,1> SETTING POS.PARAM THEN
        Y.PAYOFF.ACTIVITY = Y.PARAM.ARRAY<2,POS.PARAM>
        Y.PAYOFF.ACTIVITY.CNT = DCOUNT(Y.PAYOFF.ACTIVITY,@SM)
    END
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.ARR.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ACT.ERR)
    Y.ACTIVITY.HISTORY        = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY>
    Y.ACTIVITY.STATUS.HISTORY = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS>
    CHANGE @SM TO @FM IN Y.ACTIVITY.HISTORY
    CHANGE @VM TO @FM IN Y.ACTIVITY.HISTORY
    CHANGE @SM TO @FM IN Y.ACTIVITY.STATUS.HISTORY
    CHANGE @VM TO @FM IN Y.ACTIVITY.STATUS.HISTORY

    Y.PAYOFF.POS = 1
    LOOP
    WHILE Y.PAYOFF.POS LE Y.PAYOFF.ACTIVITY.CNT
        Y.CANCEL.ACTIVITY = Y.PAYOFF.ACTIVITY<1,1,Y.PAYOFF.POS>
        LOCATE Y.CANCEL.ACTIVITY IN Y.ACTIVITY.HISTORY<1> SETTING POS.ACT THEN      ;* Here we are checking whether loan has payoff activity in auth stage. we are locating once cos the latest applypayment-rp.payoff is in AUTH stage(During payoff cheque reversal, we wont trigger applypayment-rp.payoff, So we can presume that applypayment-rp.payoff is in AUTH stage then loan is cancelled).

            IF Y.ACTIVITY.STATUS.HISTORY<POS.ACT> EQ 'AUTH' THEN
                Y.FLAG = 0  ;* Skip this loan.
            END
        END

        Y.PAYOFF.POS += 1
    REPEAT

RETURN

*----------------------------------------------------------------------
FORM.ARRAY:
*----------
    DUMMY.VAR = ''
*VALUE NO :                 1                2                3                4                 5               6                7               8
    Y.ENQ.OUT<-1> = Y.ARR.ID:"*":Y.PRE.LOAN.NO:"*":Y.LOAN.BK.TYP:"*":Y.PRODUCT.TYP:"*":Y.CAMPAIGN.TYPE:"*":Y.AGENCY.CODE:"*":Y.AFF.COMPANY:"*":Y.CLIENT.NAME

*VALUE NO :                 9             10             11           12            13               14                  15             16                17
    Y.ENQ.OUT := "*":Y.CLIENT.NO:"*":Y.ID.TYPE:"*":Y.ID.NUMBER:"*":Y.DAO:"*":Y.CURRENCY:"*":Y.OPENING.DATE:"*":Y.MATURITY.DATE:"*":Y.COLLATERAL.NAME:"*":DUMMY.VAR

*VALUE NO :                   18               19                20                21             22                23                 24
    Y.ENQ.OUT := "*":      DUMMY.VAR:"*":Y.APPRVD.VAL:"*":Y.PAIDUP.VALUE:"*":Y.INTEREST.RATE:"*":Y.PER.RAT.REV:"*":Y.LAS.REV.DAT:"*":Y.NXT.REV.DAT

*VALUE NO :                   25                  26                27                28                  29                30                 31
    Y.ENQ.OUT := "*":Y.POOL.RATE:"*":Y.LOAN.OVRAL.STAT:"*":Y.LOAN.STATUS:"*":Y.FORM.OF.PAYMNT:"*":Y.TOTAL.CAP.BAL:"*":Y.INTEREST.BALANCE:"*":Y.BALANCE.CHARGE

*VALUE NO :                   32              33         34             35             36                     37                 38
    Y.ENQ.OUT := "*":Y.TOT.BAL.DUE:"*":Y.LIAB.BAL:"*":Y.CANCEL.VALUE:"*":Y.BILL.AMOUNT:"*":Y.UNPAID.BILL.CNT:"*":Y.DELAYED.BILLS.VAL:"*":Y.FORMAT.TYPE

*VALUE NO :                   39                  40            41               42             43              44                 45
    Y.ENQ.OUT := "*":Y.DEBIT.AC:"*":Y.TYPE.OF.SECURITY:"*":Y.SEC.NO:"*":Y.SEC.VAL:"*":Y.GUAR.VAL.USED:"*":Y.CLASSIFIC:"*":Y.PROVISION.VALUE

*VALUE NO :                 46                    47                48                  49                 50                 51               52                   53
    Y.ENQ.OUT :=  "*":Y.LIFE.POL.NO:"*":Y.LIFE.GUAR.VAL:"*":Y.LIFE.GUAR.EXTRAVAL:"*":Y.PROP.POL.NO:"*":Y.PROP.POL.VAL:"*":Y.VEHI.POL.NO:"*":Y.VEHI.POL.VAL:"*":Y.AGING.STATUS

RETURN
*----------------------------------------------------------------------
END
