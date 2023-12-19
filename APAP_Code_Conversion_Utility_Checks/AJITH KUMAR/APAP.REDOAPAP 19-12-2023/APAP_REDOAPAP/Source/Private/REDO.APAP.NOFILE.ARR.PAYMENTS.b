* @ValidationCode : MjotMTU4MjM5NTMyMzpDcDEyNTI6MTcwMjk3NzAwMjE1Nzphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 14:40:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP

SUBROUTINE REDO.APAP.NOFILE.ARR.PAYMENTS(Y.COMMON.ARRAY,VAR.EFFECTIVE.DATE,Y.EFF.DATE,Y.FORM.PAY,VAR.FORM.PAY,Y.PAY.TYPE,VAR.PAY,Y.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.APAP.NOFILE.ARR.PAYMENTS
* ODR NO      : ODR-2010-03-0138
*----------------------------------------------------------------------
*DESCRIPTION: This routine is an internal call routine called by the Nofile routine NOFILE.APAP.DETAIL.LOANS.PAYMENTS
*IN PARAMETER :Y.COMMON.ARRAY
*OUT PARAMETER:Y.ARRAY
*CALLED BY :NOFILE.APAP.DETAIL.LOANS.PAYMENTS
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.09.2010  S SUDHARSANAN   ODR-2010-03-0138   INITIAL CREATION
*13/07/2023      Conversion tool            R22 Auto Conversion            FM TO @FM, VM TO @VM, SM TO @SM,++ TO +=, F.READ TO CACHE.READ
*13/07/2023      Suresh                     R22 Manual Conversion          AA.CUS.PRIMARY.OWNER TO AA.CUS.CUSTOMER, AA.CUS.OWNER TO AA.CUS.CUSTOMER
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.USER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.ACCOUNT
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.REDO.AA.PAYMENT.DETAILS

    GOSUB OPENFILES
    GOSUB LOC.REF
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
* All variables are intialized here
    Y.ARR.ID = ''
    Y.ARR.ACT.ID = ''
    VAR.ARR = ''
    VAR.ARR.ACT = ''
    Y.ARR.LIST = ''
    VAR.FINAL.AMT=0
    Y.BILL.AMT=''
    VAR.CHEQUE = ''
    R.TELLER = ''
    VAR.DUE.AMOUNT = 0
    VAR.CAP.AMT = 0
    Y.CAP.AMT = ''
    VAR.INT.AMT = 0
    Y.INT.AMT = ''
    VAR.DUE.AMT=0
    Y.DUE.AMT =''
    Y.CHG.AMT = ''
    VAR.INS.AMT=0
    VAR.OTHR.CHG.AMT=0
    Y.OTHR.CHG.AMT=''
    VAR.NO.PAID.FEES = 0
    VAR.PAYMENT.TYPE = ''
    VAR.EFFECT.DATE = ''
    VAR.CLIENT.NAME = ''
    VAR.FORM.TYPE = ''
    VAR.TELLER.ID=''
    VAR.NCF.NO = ''
    VAR.OWNER =''
    LAN.POS = R.USER<EB.USE.LANGUAGE>
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
* All files needed throughtout the routine are opened here
    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    FN.AA.ARRANGEMENT.ACTIVITY='F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY=''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)
    FN.REDO.AA.PAYMENT.DETAILS = 'F.REDO.AA.PAYMENT.DETAILS'
    F.REDO.AA.PAYMENT.DETAILS = ''
    CALL OPF(FN.REDO.AA.PAYMENT.DETAILS,F.REDO.AA.PAYMENT.DETAILS)
*FN.AA.ARR.CUSTOMER          = 'F.AA.ARR.CUSTOMER'
*F.AA.ARR.CUSTOMER           = ''
*CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)
    FN.AA.PRD.DES.CUSTOMER = 'F.AA.PRD.DES.CUSTOMER'
    F.AA.PRD.DES.CUSTOMER = ''
    CALL OPF(FN.AA.PRD.DES.CUSTOMER, F.AA.PRD.DES.CUSTOMER)
    FN.AA.ARR.ACCOUNT = 'F.AA.ARR.ACCOUNT'
    F.AA.ARR.ACCOUNT = ''
    CALL OPF(FN.AA.ARR.ACCOUNT,F.AA.ARR.ACCOUNT)
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    FN.AA.INTEREST.ACCRUALS='F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS=''
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS=''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)
    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)
    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)
    FN.TFS='F.T24.FUND.SERVICES'
    F.TFS = ''
    CALL OPF(FN.TFS,F.TFS)
    FN.FT.TXN.TYPE.CONDITION = 'F.FT.TXN.TYPE.CONDITION'
    F.FT.TXN.TYPE.CONDITION= ''
    CALL OPF(FN.FT.TXN.TYPE.CONDITION,F.FT.TXN.TYPE.CONDITION)
    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION=''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)
RETURN
*----------------------------------------------------------------------
LOC.REF:
*----------------------------------------------------------------------
* To get the position of local fields
    LOC.REF.APPLICATION="FUNDS.TRANSFER":@FM:"TELLER":@FM:"T24.FUND.SERVICES":@FM:'AA.PRD.DES.CHARGE'
    LOC.REF.FIELDS='L.NCF.NUMBER':@FM:'L.NCF.NUMBER':@FM:'L.NCF.NUMBER':@FM:'INS.POLICY.TYPE'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    FT.LOC.REF.POS = LOC.REF.POS<1,1>
    TT.LOC.REF.POS = LOC.REF.POS<2,1>
    TFS.LOC.REF.POS = LOC.REF.POS<3,1>
    INS.POL.TYPE.POS = LOC.REF.POS<4,1>
RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    ARR.ID.COUNT = DCOUNT(Y.COMMON.ARRAY,@FM)
    ARR.ID.CNT = 1
    LOOP
    WHILE ARR.ID.CNT LE ARR.ID.COUNT
        GOSUB INIT
        Y.ARR.ID   =  Y.COMMON.ARRAY<ARR.ID.CNT>
        GOSUB UPD.ARR.DETAILS
        ARR.ID.CNT += 1 ;*R22 Auto Conversion
    REPEAT
RETURN
*--------------------------------------------------------------------------------------------------------------
ARR.CONDITION:
*-------------
    EFF.DATE = ''
    R.CONDITION = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(VAR.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
RETURN
*-----------------------------------------------------------------------------------------------------------------------
GET.PRODUCT.DETAIL:
*------------------
    R.ARRANGEMENT=''
    CALL F.READ(FN.AA.ARRANGEMENT,VAR.ARR.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
RETURN
*----------------------------------------------------------------------
GET.INTEREST.RATE:
*----------------------------------------------------------------------
    VAR.INT.ID= VAR.ARR.ID:'-PRINCIPALINT'
    CALL F.READ(FN.AA.INTEREST.ACCRUALS,VAR.INT.ID,R.INT.ACCRUAL,F.AA.INTEREST.ACCRUALS,INT.ACC.ERR)
    VAR.INTEREST.RATE=R.INT.ACCRUAL<AA.INT.ACC.RATE,1,1>      ;**************************************9th field
RETURN
*------------------------------------------------------------------------------
GET.CLIENT.NAME:
*-----------------------------------------------------------------------------

    Y.CUSTOMER.CONDITION=R.CONDITION
*    VAR.PRIM.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.PRIMARY.OWNER>
    VAR.PRIM.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.CUSTOMER>   ;*R22 Manual Conversion
*   VAR.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.OWNER>
    VAR.OWNER = Y.CUSTOMER.CONDITION<AA.CUS.CUSTOMER>       ;*R22 Manual Conversion
    CHANGE @VM TO @FM IN VAR.OWNER
    CNT.VAR.OWNER = DCOUNT(VAR.OWNER,@FM)
    COUNT.OWNER = 1
    LOOP
    WHILE COUNT.OWNER LE CNT.VAR.OWNER
        IF VAR.PRIM.OWNER NE VAR.OWNER<COUNT.OWNER> THEN
            Y.OWNER  =  VAR.OWNER<COUNT.OWNER>
            R.CUSTOMER = ''
            CALL F.READ(FN.CUSTOMER,Y.OWNER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
            VAR.CLIENT.NAME<1,-1> = R.CUSTOMER<EB.CUS.SHORT.NAME,1>
        END
        COUNT.OWNER += 1 ;*R22 Auto Conversion
    REPEAT
    R.CUSTOMER = ''
    CALL F.READ(FN.CUSTOMER,VAR.PRIM.OWNER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    VAR.CLIENT.NAME<1,-1> = R.CUSTOMER<EB.CUS.SHORT.NAME,1>   ;*****************7th Field
RETURN
*--------------------------------------------------------------------------
GET.PAYMENT.DETAILS:
*--------------------------------------------------------------------------
*To gets the all payment details for arrangement
    LOOP
        REMOVE AA.ACTIVITY.ID FROM SEL.UPD.LIST SETTING POS3
    WHILE AA.ACTIVITY.ID:POS3
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,AA.ACTIVITY.ID,R.AA.ARR.ACT,F.AA.ARRANGEMENT.ACTIVITY,AA.ERR)
        TXN.SYST.ID  = R.AA.ARR.ACT<AA.ARR.ACT.TXN.SYSTEM.ID>
        TXN.CONTR.ID = R.AA.ARR.ACT<AA.ARR.ACT.TXN.CONTRACT.ID>
        VAR.EFF.DATE = R.AA.ARR.ACT<AA.ARR.ACT.EFFECTIVE.DATE>
        IF VAR.EFFECTIVE.DATE THEN
            IF VAR.EFF.DATE EQ Y.EFF.DATE THEN
                GOSUB CHECK.FORM.PAY
            END
        END ELSE
            GOSUB CHECK.FORM.PAY
        END
    REPEAT
RETURN
*--------------------------------
CHECK.FORM.PAY:
*--------------------------------

    IF VAR.FORM.PAY THEN
        BEGIN CASE
            CASE Y.FORM.PAY EQ 'TRANSFERS'
                IF TXN.SYST.ID EQ 'FT' THEN
                    GOSUB CHK.FT.TYPE
                END
            CASE Y.FORM.PAY EQ 'CASHPAYMENT'
                IF TXN.SYST.ID EQ 'TT' THEN
                    GOSUB CHK.TELL.TYPE
                END
            CASE Y.FORM.PAY EQ 'CHEQUEPAYMENT'
                IF TXN.SYST.ID EQ 'TT' THEN
                    GOSUB CHK.TELL.TYPE
                END
            CASE Y.FORM.PAY EQ 'MIXED'
                IF TXN.SYST.ID EQ 'TT' THEN
                    GOSUB CHK.TELL.TYPE
                END
        END CASE
    END ELSE
        BEGIN CASE
            CASE TXN.SYST.ID EQ 'FT'
                GOSUB CHK.FT.TYPE
            CASE TXN.SYST.ID EQ 'TT'
                GOSUB CHK.TELL.TYPE
        END CASE
    END
RETURN
*----------------------------------------------------------------
CHK.FT.TYPE:
*-----------------------------------------------------------------
*To get the values for transaction system id is FT
    CALL F.READ(FN.FUNDS.TRANSFER,TXN.CONTR.ID,R.FUNDS.TRANS,F.FUNDS.TRANSFER,FT.ERR)
    IF R.FUNDS.TRANS EQ '' THEN
        CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,TXN.CONTR.ID,R.FT.HIS,FT.ERROR)
        VAR.FT.TYPE=R.FT.HIS<FT.TRANSACTION.TYPE>
        VAR.FT.NCF.NO = R.FT.HIS<FT.LOCAL.REF,FT.LOC.REF.POS>
    END ELSE
        VAR.FT.TYPE=R.FUNDS.TRANS<FT.TRANSACTION.TYPE>
        VAR.FT.NCF.NO = R.FUNDS.TRANS<FT.LOCAL.REF,FT.LOC.REF.POS>
    END
    CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, VAR.FT.TYPE, R.FT.TYPE, FT.TYPE.ERR) ;*R22 Auto Conversion
    IF VAR.PAY THEN
        IF Y.PAY.TYPE EQ VAR.FT.TYPE THEN
            GOSUB CHK.FT.TYPE1
        END
    END ELSE
        GOSUB CHK.FT.TYPE1
    END
RETURN
*----------------------------------------------------------------
CHK.TELL.TYPE:
*----------------------------------------------------------------
*To get the values for transaction system id is TELLER
    VAR.TELLER = '1'
    VAR.CONTRACT.ID= TXN.CONTR.ID[1,2]
    IF VAR.CONTRACT.ID EQ 'TT' THEN
        Y.TELL.ID = TXN.CONTR.ID
        GOSUB TELL.CHECK
        IF VAR.PAY THEN
            IF Y.PAY.TYPE EQ VAR.TT.TXN THEN
                GOSUB CHK.TT.TYPE1
            END
        END ELSE
            GOSUB CHK.TT.TYPE1
        END
    END ELSE
        VAR.TFS = 1
        CALL F.READ(FN.TFS,TXN.CONTR.ID,R.TFS,F.TFS,TFS.ERR)
        TFS.TRANS.ID =R.TFS<TFS.TRANSACTION>
        Y.TELLER.ID = R.TFS<TFS.UNDERLYING>
        VAR.TFS.NCF.NO = R.TFS<TFS.LOCAL.REF,TFS.LOC.REF.POS>
        FIND 'TT' IN Y.TELLER.ID<1,1> SETTING TT.POS THEN
            Y.TELL.ID = VAR.TELLER.ID<1,TT.POS>
        END
        GOSUB TELL.CHECK
        IF VAR.PAY THEN
            IF Y.PAY.TYPE EQ VAR.TT.TXN THEN
                GOSUB CHK.TFS.TYPE1
            END
        END ELSE
            GOSUB CHK.TFS.TYPE1
        END
    END
RETURN
*------------------------------------------------------------
TELL.CHECK:
*------------------------------------------------------------
*To get the description value for teller txn
    R.TELLER = ''
    CALL F.READ(FN.TELLER,Y.TELL.ID,R.TELLER,F.TELLER,TELL.ERR)
    IF R.TELLER EQ '' THEN
        CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.TELL.ID,R.TELLER.HIS,YERR)
        VAR.CHEQUE = R.TELLER.HIS<TT.TE.CHEQUE.NUMBER>
        VAR.TT.TXN = R.TELLER.HIS<TT.TE.TRANSACTION.CODE>
        Y.TEL.ID = R.TELLER.HIS<TT.TE.TELLER.ID.1>
        VAR.TT.NCF.NO = R.TELLER.HIS<TT.TE.LOCAL.REF,TT.LOC.REF.POS>
    END ELSE
        VAR.CHEQUE  = R.TELLER<TT.TE.CHEQUE.NUMBER>
        VAR.TT.TXN = R.TELLER<TT.TE.TRANSACTION.CODE>
        Y.TEL.ID = R.TELLER<TT.TE.TELLER.ID.1>
        VAR.TT.NCF.NO = R.TELLER<TT.TE.LOCAL.REF,TT.LOC.REF.POS>
    END
    R.TT.TXN = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, VAR.TT.TXN, R.TT.TXN, TT.TXN.ERR) ;*R22 Auto Conversion
    TT.DESC = R.TT.TXN<TT.TR.DESC,1,1>
RETURN
*--------------------------------------------------------------------------
CHK.FT.TYPE1:
*---------------------------------------------------------------------------
    VAR.PAYMENT.TYPE<1,-1> = R.FT.TYPE<FT6.DESCRIPTION,LAN.POS>         ;*****************10th field
    VAR.FORM.TYPE<1,-1> = 'TRANSFERS'     ;*************************************11th field
    VAR.EFFECT.DATE<1,-1> = VAR.EFF.DATE  ;***************************12th Field

    VAR.TELLER.ID<1,-1> = ' '   ;*****************************13th field
    IF VAR.FT.NCF.NO EQ '' THEN
        VAR.NCF.NO<1,-1> = ' '    ;**********************************************14th field
    END ELSE
        VAR.NCF.NO<1,-1> = VAR.FT.NCF.NO
    END
RETURN
*---------------------------------------------------------------------------
CHK.TT.TYPE1:
*---------------------------------------------------------------------------
    VAR.PAYMENT.TYPE<1,-1> = TT.DESC
    IF VAR.CHEQUE EQ '' AND VAR.TELLER NE '' THEN
        VAR.FORM.TYPE<1,-1> = 'CASHPAYMENT'
    END
    IF VAR.CHEQUE NE '' AND VAR.TELLER NE '' THEN
        VAR.FORM.TYPE<1,-1> = 'CHEQUEPAYMENT'
    END
    VAR.EFFECT.DATE<1,-1> = VAR.EFF.DATE

    VAR.TELLER.ID<1,-1> = Y.TEL.ID
    IF VAR.TT.NCF.NO EQ '' THEN
        VAR.NCF.NO<1,-1> = ' '
    END ELSE
        VAR.NCF.NO<1,-1> = VAR.TT.NCF.NO
    END
RETURN
*--------------------------------------------------------------------------
CHK.TFS.TYPE1:
*---------------------------------------------------------------------------
    VAR.PAYMENT.TYPE<1,-1> = TT.DESC
    VAR.FORM.TYPE<1,-1> = 'MIXEDPAYMENT'
    VAR.EFFECT.DATE<1,-1> = VAR.EFF.DATE
    VAR.TELLER.ID<-1>= Y.TEL.ID:@VM
    IF VAR.TFS.NCF.NO EQ '' THEN
        VAR.NCF.NO<-1> = @VM
    END ELSE
        VAR.NCF.NO<-1> = VAR.TFS.NCF.NO:@VM
    END
RETURN
*-------------------------------------------------------------------------------------------------------------
UPD.ARR.DETAILS:
*--------------------------------------------------------------------------------------------------------------
    SEL.UPD.CMD = 'SELECT ':FN.REDO.AA.PAYMENT.DETAILS:' WITH ARR.ID EQ ':Y.ARR.ID
    CALL EB.READLIST(SEL.UPD.CMD,SEL.UPD.LIST,'',NOR.UPD,ERR.UPD)
    IF SEL.UPD.LIST THEN
        VAR.ARR.ID = Y.COMMON.ARRAY<ARR.ID.CNT>
        PROP.CLASS = 'ACCOUNT'
        PROPERTY = ''
        GOSUB ARR.CONDITION
        Y.ACCOUNT.CONDITION=R.CONDITION
        GOSUB GET.PRODUCT.DETAIL
        VAR.LOAN.ORIGIN.AGENCY=R.ARRANGEMENT<AA.ARR.CO.CODE>    ;****************1st Field
        VAR.PAYMENT.AGENCY = R.ARRANGEMENT<AA.ARR.CO.CODE>      ;****************2nd Field
        VAR.PRDT.GRP =  R.ARRANGEMENT<AA.ARR.PRODUCT.GROUP>     ;****************3rd Field
        VAR.PRDT = R.ARRANGEMENT<AA.ARR.PRODUCT>      ;****************4th Field
        VAR.LOAN.NO = VAR.ARR.ID  ;****************5th Field
        VAR.ALT.ID=Y.ACCOUNT.CONDITION<AA.AC.ALT.ID>  ;****************6th Field
        PROP.CLASS='CUSTOMER'
        PROPERTY = ''
        GOSUB ARR.CONDITION
        GOSUB GET.CLIENT.NAME
        VAR.CURR = R.ARRANGEMENT<AA.ARR.CURRENCY>     ;*****************8th Field
        GOSUB GET.INTEREST.RATE
        GOSUB GET.PAYMENT.DETAILS
        GOSUB TOTAL.AMT.PAID
        GOSUB GET.ARRAY
    END
RETURN
*-------------------------------------------------------------------------
GET.PROPERTY:
*----------------------------------------------------------------------
    PROP.CLASS.ACC='ACCOUNT'
    CALL AA.GET.PROPERTY.NAME(VAR.ARR.ID,PROP.CLASS.ACC,OUT.PARAM)
    Y.ACC.PROP.CLASS=OUT.PARAM
    PROP.CLASS.ACC='INTEREST'
    CALL AA.GET.PROPERTY.NAME(VAR.ARR.ID,PROP.CLASS.ACC,OUT.PARAM)
    Y.INT.PROP.CLASS=OUT.PARAM
    PROP.CLASS.CHARGE='CHARGE'
    CALL AA.GET.PROPERTY.NAME(VAR.ARR.ID,PROP.CLASS.CHARGE,OUT.PARAM)
    Y.CHARGE.PROP.CLASS=OUT.PARAM
RETURN
*-------------------------------------------------------------------------------------------------
TOTAL.AMT.PAID:
*--------------------------------------------------------------------------------------------------
* This para calculates the Total Amount repaid for Arrangement
    GOSUB GET.PROPERTY
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.ARR.ID,R.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACT.DET.ERR)
    VAR.BILL.IDS=R.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    CHANGE @SM TO @FM IN VAR.BILL.IDS
    CHANGE @VM TO @FM IN VAR.BILL.IDS
    VAR.BILL.STATUS.LIST = R.ACCOUNT.DETAILS<AA.AD.BILL.STATUS>
    CHANGE @SM TO @FM IN VAR.BILL.STATUS.LIST
    CHANGE @VM TO @FM IN VAR.BILL.STATUS.LIST
    VAR.SET.STATUS.LIST = R.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
    CHANGE @SM TO @FM IN VAR.SET.STATUS.LIST
    CHANGE @VM TO @FM IN VAR.SET.STATUS.LIST
    VAR.BILLS.CNT=DCOUNT(VAR.BILL.IDS,@FM)
    VAR1=1
    LOOP
    WHILE VAR1 LE VAR.BILLS.CNT
        VAR.BILL.ID=VAR.BILL.IDS<VAR1>
        CALL F.READ(FN.AA.BILL.DETAILS,VAR.BILL.ID,R.BILL.DETAIL,F.AA.BILL.DETAILS,BILL.ERR)
        VAR.PROPERTY = R.BILL.DETAIL<AA.BD.PAY.PROPERTY>
        CHANGE @SM TO @FM IN VAR.PROPERTY
        CHANGE @VM TO @FM IN VAR.PROPERTY
        VAR.OR.AMT = R.BILL.DETAIL<AA.BD.OR.PR.AMT>
        CHANGE @SM TO @FM IN VAR.OR.AMT
        CHANGE @VM TO @FM IN VAR.OR.AMT
        VAR.OS.AMT = R.BILL.DETAIL<AA.BD.OS.PR.AMT>
        CHANGE @SM TO @FM IN VAR.OS.AMT
        CHANGE @VM TO @FM IN VAR.OS.AMT
        GOSUB GET.BILL.AMT
        GOSUB GET.CAPITAL.AMT
        GOSUB GET.INT.AMT
        GOSUB GET.DUE.AMT
        GOSUB GET.CHG.AMT
        GOSUB GET.NO.PAID.FEES
        VAR1 += 1
    REPEAT
RETURN
*----------------------------------------------------------------------
GET.BILL.AMT:
*----------------------------------------------------------------------
* This Para calculates the total repayment amt for each Bill
    VAR.REPAY.AMT = R.BILL.DETAIL<AA.BD.REPAY.AMOUNT>
    CHANGE @SM TO @FM IN VAR.REPAY.AMT
    CHANGE @VM TO @FM IN VAR.REPAY.AMT
    Y.BILL.AMT=SUM(VAR.REPAY.AMT)
    VAR.FINAL.AMT+=Y.BILL.AMT   ;********************************************* 15th field
RETURN
*----------------------------------------------------------------------
GET.CAPITAL.AMT:
*----------------------------------------------------------------------
    LOCATE Y.ACC.PROP.CLASS IN VAR.PROPERTY<1> SETTING ACC.POS THEN
        Y.OR.AMT = VAR.OR.AMT<ACC.POS>
        Y.OS.AMT = VAR.OS.AMT<ACC.POS>
        Y.CAP.AMT = Y.OR.AMT-Y.OS.AMT
        VAR.CAP.AMT+=Y.CAP.AMT    ;*****************************************16th field
    END
RETURN
*---------------------------------------------------------------------------
GET.INT.AMT:
*----------------------------------------------------------------------------
    INT.PROP.CNT=DCOUNT(Y.INT.PROP.CLASS,@FM)
    INT.CNT = 1
    LOOP
    WHILE INT.CNT LE INT.PROP.CNT
        VAR.INT.PROP.CLASS = Y.INT.PROP.CLASS<INT.CNT>
        LOCATE VAR.INT.PROP.CLASS IN VAR.PROPERTY<1> SETTING INT.POS THEN
            Y.OR.AMT = VAR.OR.AMT<INT.POS>
            Y.OS.AMT = VAR.OS.AMT<INT.POS>
            Y.INT.AMT = Y.OR.AMT-Y.OS.AMT
            VAR.INT.AMT+=Y.INT.AMT  ;********************************************17th field
        END
        INT.CNT += 1 ;*R22 Auto Conversion
    REPEAT
RETURN
*------------------------------------------------------------------------
GET.DUE.AMT:
*-------------------------------------------------------------------------
    VAR.SET.STATUS = VAR.SET.STATUS.LIST<VAR1>
    VAR.BILL.STATUS = VAR.BILL.STATUS.LIST<VAR1>
    IF (VAR.SET.STATUS EQ 'UNPAID' OR VAR.SET.STATUS EQ '') AND VAR.BILL.STATUS EQ 'DUE' THEN
        Y.DUE.AMT= SUM(R.BILL.DETAIL<AA.BD.OS.PROP.AMOUNT>)
        VAR.DUE.AMT+=Y.DUE.AMT    ;****************************************18th field
    END
RETURN
*----------------------------------------------------------------------------
GET.CHG.AMT:
*----------------------------------------------------------------------------
    CHG.PROP.CNT=DCOUNT(Y.CHARGE.PROP.CLASS,@FM)
    CHG.CNT = 1
    LOOP
    WHILE CHG.CNT LE CHG.PROP.CNT
        VAR.CHARGE.PROP.CLASS = Y.CHARGE.PROP.CLASS<CHG.CNT>
        LOCATE VAR.CHARGE.PROP.CLASS IN VAR.PROPERTY<1> SETTING CHG.POS THEN
            Y.OR.AMT = VAR.OR.AMT<CHG.POS>
            Y.OS.AMT = VAR.OS.AMT<CHG.POS>
*            PROP.CLASS = VAR.CHARGE.PROP.CLASS
            PROP.CLASS = PROP.CLASS.CHARGE
            PROPERTY = VAR.CHARGE.PROP.CLASS
            GOSUB ARR.CONDITION
            Y.CHARGE.CONDITION = R.CONDITION
            Y.INS.POL=Y.CHARGE.CONDITION<AA.CHG.LOCAL.REF,INS.POL.TYPE.POS>
            IF Y.INS.POL THEN
                Y.CHG.AMT = Y.OR.AMT-Y.OS.AMT
                VAR.INS.AMT+=Y.CHG.AMT          ;*************************************************19th field
            END
            Y.OTHR.CHG.AMT = Y.OR.AMT-Y.OS.AMT
            VAR.OTHR.CHG.AMT+=Y.OTHR.CHG.AMT  ;***************************************20th field
        END
        CHG.CNT += 1 ;*R22 Auto Conversion
    REPEAT
RETURN
*-------------------------------------------------------------------------
GET.NO.PAID.FEES:
*--------------------------------------------------------------------------
    VAR.SET.STATUS = VAR.SET.STATUS.LIST<VAR1>
    IF VAR.SET.STATUS EQ 'REPAID' THEN
        VAR.NO.PAID.FEES+=1       ;********************************************************21st field
    END
RETURN
*--------------------------------------------------------------------------
GET.ARRAY:
*------------------------------------------------------------------------------

    Y.ARRAY<-1> = VAR.LOAN.ORIGIN.AGENCY:"*":VAR.PAYMENT.AGENCY:"*":VAR.PRDT.GRP:"*":VAR.PRDT:"*":VAR.LOAN.NO:"*":VAR.ALT.ID:"*":VAR.CLIENT.NAME
    Y.ARRAY := "*":VAR.CURR:"*":VAR.INTEREST.RATE:"*":VAR.PAYMENT.TYPE:"*":VAR.EFFECT.DATE:"*":VAR.FORM.TYPE:"*":VAR.TELLER.ID:"*":VAR.NCF.NO
    Y.ARRAY := "*":VAR.FINAL.AMT:"*":VAR.CAP.AMT:"*":VAR.INT.AMT:"*":VAR.DUE.AMT:"*":VAR.INS.AMT:"*":VAR.OTHR.CHG.AMT:"*":VAR.NO.PAID.FEES
RETURN
*-------------------------------------------------------------------------------
END
