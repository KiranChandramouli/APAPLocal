* @ValidationCode : MjoyMDc3NTk5NTI2OkNwMTI1MjoxNjg0ODU0MzgwNDMyOklUU1M6LTE6LTE6NTIwOjE6ZmFsc2U6Ti9BOlIyMl9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 520
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.AUTO.PAYMENT(Y.DD.ACCOUNT)
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.DIRECT.DEBIT
* Primary Purpose : Batch routine selects AA.ACCOUNT.DETAILS having SET.STATUS as 'UNPAID'
*                   and for each AA.ACCOUNT.DETAILS, read the linked account through
**                   AA.ARRANGEMENT Calculate the Total Repayment Amount and FT transaction
*                   is done for the same amount through OFS message
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              31-10-2011         B.9-DIRECT DEBIT
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION SM TO @SM AND VM TO @VM AND FM TO @FM AND ++ TO += 1 AND VAR1 - VAR2 TO -= VAR2
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION CALL RTN METHOD ADDED
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_REDO.B.AUTO.PAYMENT.COMMON
    $USING APAP.AA  ;*MANUAL R22 CODE CONVERSION
    $USING APAP.TAM

    R.REDO.DIRECT.DEBIT.ACCOUNTS = ''
    CALL F.READ(FN.REDO.DIRECT.DEBIT.ACCOUNTS,Y.DD.ACCOUNT,R.REDO.DIRECT.DEBIT.ACCOUNTS,F.REDO.DIRECT.DEBIT.ACCOUNTS,DD.ERR)
    CALL OCOMO("DD Processing Started - ":Y.DD.ACCOUNT:'[':R.REDO.DIRECT.DEBIT.ACCOUNTS:']')
    IF R.REDO.DIRECT.DEBIT.ACCOUNTS THEN
        GOSUB PROCESS
    END ELSE
        CALL OCOMO("Record Empty for the Account - ":Y.DD.ACCOUNT)
    END
    CALL OCOMO("DD Processing Completed - ":Y.DD.ACCOUNT:'[':R.REDO.DIRECT.DEBIT.ACCOUNTS:']')
RETURN
*------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------


    GOSUB GET.DEBIT.ACCOUNT.DETAILS       ;* Here we will get the details of the Direct Debit Account.
    Y.LOAN.CNT = DCOUNT(R.REDO.DIRECT.DEBIT.ACCOUNTS,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.LOAN.CNT
        Y.AA.ID = R.REDO.DIRECT.DEBIT.ACCOUNTS<Y.VAR1>
        CALL OCOMO("Processing the Loan - ":Y.AA.ID)

        GOSUB GET.LOAN.STATUS     ;* Here we will get the loan status details
        IF Y.SKIP.FLAG EQ '' AND Y.PAY.SCH.FLAG EQ '' AND Y.ARR.FLAG EQ '' THEN
            GOSUB PROCESS.LOAN      ;* Here we will process the loan for payment.
        END ELSE
            CALL OCOMO("Loan has been skip due to status/Pay Sch problem - ":Y.SKIP.FLAG:" - ":Y.PAY.SCH.FLAG:" - ":Y.ARR.FLAG)
        END
        Y.VAR1 += 1
    REPEAT

RETURN

*-----------------------------------------------------------------------------
*** <region name= GET.DEBIT.ACCOUNT.DETAILS>
GET.DEBIT.ACCOUNT.DETAILS:
*** <desc>Here we will get the details of the Direct Debit Account.</desc>
*-----------------------------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,Y.DD.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.STATUS.LIST =  R.ACCOUNT<AC.LOCAL.REF,POS.STATUS.2>
    CHANGE @VM TO @FM IN Y.STATUS.LIST
    CHANGE @SM TO @FM IN Y.STATUS.LIST
    LOCATE 'DECEASED' IN Y.STATUS.LIST SETTING POS THEN
        CALL OCOMO("Deceased DD Account - ":Y.DD.ACCOUNT)
        GOSUB END1      ;* Here the program quits
    END
    Y.TRANSIT.AMOUNT  = R.ACCOUNT<AC.LOCAL.REF,POS.TRANS.AMT>
    Y.L.AC.AVL.BAL    = R.ACCOUNT<AC.LOCAL.REF,POS.AVL.BAL>
    Y.ACCOUNT.BALANCE = Y.TRANSIT.AMOUNT + Y.L.AC.AVL.BAL
RETURN
*** </region>



*-----------------------------------------------------------------------------
*** <region name= GET.LOAN.STATUS>
GET.LOAN.STATUS:
*** <desc>Here we will get the loan status details</desc>
*-----------------------------------------------------------------------------
    Y.SKIP.FLAG          = ''
    Y.PAY.SCH.FLAG       = ''
    Y.ARR.FLAG           = ''
    EFF.DATE             = ''
    PROP.CLASS           ='OVERDUE'
    PROPERTY             = ''
    R.OVERDUE.CONDITION  = ''
    ERR.MSG              = ''
* APAP.TAM.REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.OVERDUE.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.OVERDUE.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    Y.LOAN.STATUS = R.OVERDUE.CONDITION<AA.OD.LOCAL.REF,OD.LOAN.STATUS.POS>
    Y.LOAN.COND   = R.OVERDUE.CONDITION<AA.OD.LOCAL.REF,OD.LOAN.COND.POS>
    CHANGE @SM TO @VM IN Y.LOAN.STATUS
    CHANGE @SM TO @VM IN Y.LOAN.COND
    IF ('JudicialCollection' MATCHES Y.LOAN.STATUS) OR ('Write-off' MATCHES Y.LOAN.STATUS) OR ('Legal' MATCHES Y.LOAN.COND) THEN
        Y.SKIP.FLAG = 'LOAN.STATUS.PROB'
        RETURN
    END

    EFF.DATE             = ''
    PROP.CLASS           ='PAYMENT.SCHEDULE'
    PROPERTY             = ''
    R.PAYSCH.CONDITION   = ''
    ERR.MSG              = ''
*APAP.TAM.REDO.CRR.GET.CONDITIONS(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.PAYSCH.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    APAP.AA.redoCrrGetConditions(Y.AA.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.PAYSCH.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
   
    Y.LOAN.DD.ACCOUNT = R.PAYSCH.CONDITION<AA.PS.LOCAL.REF><1,DEBIT.ACCT.POS>
    Y.STATUS.DD       = R.PAYSCH.CONDITION<AA.PS.LOCAL.REF><1,PAYMT.METHOD.POS>
    Y.ARC.PMT.REF     = R.PAYSCH.CONDITION<AA.PS.LOCAL.REF><1,L.AA.PYMT.REF.POS>

    IF Y.LOAN.DD.ACCOUNT NE Y.DD.ACCOUNT OR Y.STATUS.DD NE 'Direct Debit' THEN
        Y.PAY.SCH.FLAG = 'PAY.SCH.PROB'
    END

    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.ARRANGEMENT,F.AA.ARRANGEMENT,Y.ERR.ARR)
    Y.CURRENCY    = R.ARRANGEMENT<AA.ARR.CURRENCY>
    Y.CREDIT.ACCT = R.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
    Y.ARR.STATUS = R.ARRANGEMENT<AA.ARR.ARR.STATUS>
*TSR-137108
    IF Y.ARR.STATUS EQ 'CLOSE' OR Y.ARR.STATUS EQ 'PENDING.CLOSURE' THEN
        Y.ARR.FLAG = 'CANCEL'
    END

RETURN
*** </region>
*-----------------------------------------------------------------------------

*** <region name= PROCESS.LOAN>
PROCESS.LOAN:
*** <desc>Here we will process the loan for payment.</desc>
*-----------------------------------------------------------------------------
    Y.NO.BILL.FLAG = 'YES'
    R.ACCOUNT.DETAILS = ''
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,F.ERR.ACC)

    Y.BILL.LIST    = R.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.BILL.TYPE    = R.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>
    Y.BILL.STATUS  = R.ACCOUNT.DETAILS<AA.AD.SET.STATUS>

    CHANGE @SM TO @FM IN  Y.BILL.LIST
    CHANGE @SM TO @FM IN  Y.BILL.TYPE
    CHANGE @SM TO @FM IN  Y.BILL.STATUS

    CHANGE @VM TO @FM IN  Y.BILL.LIST
    CHANGE @VM TO @FM IN  Y.BILL.TYPE
    CHANGE @VM TO @FM IN  Y.BILL.STATUS

    Y.LOOP1 = 1
    Y.BILLS.CNT = DCOUNT(Y.BILL.LIST,@FM)

    LOOP
    WHILE Y.LOOP1 LE Y.BILLS.CNT
        IF Y.BILL.STATUS<Y.LOOP1> EQ 'UNPAID' AND Y.BILL.TYPE<Y.LOOP1> EQ 'PAYMENT' THEN
            Y.NO.BILL.FLAG = ''
            Y.BILL.ID = Y.BILL.LIST<Y.LOOP1>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,Y.ERR.BILL)
            Y.TOT.BILL.AMT = SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
            GOSUB GET.TAX.AMT       ;* Here we will calculate the TAX amount.
            CALL OCOMO("Loan has bills, Y.ACCOUNT.BALANCE - ":Y.ACCOUNT.BALANCE:"& Y.TOT.FT.AMOUNT - ":Y.TOT.FT.AMOUNT)
            IF Y.TOT.FT.AMOUNT AND Y.TOT.FT.AMOUNT LE Y.ACCOUNT.BALANCE THEN
                GOSUB POST.OFS        ;* Here we will post OFS message for direct debit.
            END ELSE
                CALL OCOMO("Bill & Loan skipped - ":Y.BILL.ID:" - ":Y.AA.ID:"- ":Y.TOT.FT.AMOUNT:"/":Y.ACCOUNT.BALANCE)
                Y.LOOP1 = Y.BILLS.CNT + 1       ;* Break.
            END
        END
        Y.LOOP1 += 1
    REPEAT
    IF Y.NO.BILL.FLAG EQ 'YES' THEN
        CALL OCOMO("Loan has no unpaid bills - ":Y.AA.ID)
    END

    CALL OCOMO("Process completed for the loan - ":Y.AA.ID)

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= GET.TAX.AMT>
GET.TAX.AMT:
*** <desc>Here we will calculate the TAX amount.</desc>

    Y.TOT.FT.AMOUNT = Y.TOT.BILL.AMT
    CALL F.READ(FN.FTTC,'ACPY',R.FTTC,F.FTTC,Y.ERR)
    Y.TAX.TYPES = R.FTTC<FT6.COMM.TYPES>
    Y.VAR2 = 1
    LOOP
        REMOVE Y.TAX.ID FROM Y.TAX.TYPES SETTING POS.TAX
    WHILE Y.TAX.ID:POS.TAX

        CUSTOMER.ID         = R.ACCOUNT<AC.CUSTOMER>
        DEAL.AMOUNT         = Y.TOT.BILL.AMT
        DEAL.CURRENCY       = R.ACCOUNT<AC.CURRENCY>
        CCY.MKT             = '1'
        CROSS.RATE          = ""
        CROSS.CURRENCY      = R.ACCOUNT<AC.CURRENCY>
        DRAWDOWN.CURRENCY   = R.ACCOUNT<AC.CURRENCY>
        T.DATA              = ""
        TOTAL.FOREIGN.AMT   = ""
        TOTAL.LOCAL.AMT     = ""
        TOTAL.AMT           = ""
        T.DATA<1,1>         = Y.TAX.ID

        CALL CALCULATE.CHARGE(CUSTOMER.ID, DEAL.AMOUNT, DEAL.CURRENCY, CCY.MKT, CROSS.RATE,CROSS.CURRENCY, DRAWDOWN.CURRENCY, T.DATA, '', TOTAL.LOCAL.AMT, TOTAL.FOREIGN.AMT)
        VAR.TOT.CHG.AMT = T.DATA<4,1>
        Y.TOT.FT.AMOUNT += VAR.TOT.CHG.AMT
    REPEAT

RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= POST.OFS>
POST.OFS:
*** <desc>Here we will post OFS message for direct debit.</desc>
    CALL OCOMO("OFS Process Started ":Y.DD.ACCOUNT:" - ":Y.AA.ID)
    R.FUNDS.TRANSFER = ''
    R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>    =  Y.DD.ACCOUNT
    R.FUNDS.TRANSFER<FT.CREDIT.CURRENCY>  =  Y.CURRENCY
    R.FUNDS.TRANSFER<FT.CREDIT.AMOUNT>    =  Y.TOT.BILL.AMT
    R.FUNDS.TRANSFER<FT.DEBIT.VALUE.DATE> =  TODAY
    R.FUNDS.TRANSFER<FT.CREDIT.ACCT.NO>   =  Y.CREDIT.ACCT

    IF Y.ARC.PMT.REF[1,3] EQ 'STO' THEN   ;* ARCIB Payment.
        OFSVERSION = 'FUNDS.TRANSFER,AI.REDO.ARC.DD.PROCESS'
    END ELSE
        OFSVERSION = 'FUNDS.TRANSFER,REDO.DD.PROCESS'
    END
    FT.ID          = ''
    APP.NAME       = 'FUNDS.TRANSFER'
    OFSFUNCT       = 'I'
    PROCESS        = 'VALIDATE'
    OFS.SOURCE.ID  = 'REDO.OFS.STATUS.UPD'
    VAR.GTSMODE    = ''
    NO.OF.AUTH     = 0
    OFSRECORD      = ''

    CALL OCOMO("PRINITNG OFSRECORD REQUEST - ":OFSRECORD)


    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,PROCESS,OFSVERSION,VAR.GTSMODE,NO.OF.AUTH,FT.ID,R.FUNDS.TRANSFER,OFSRECORD)
    CALL OCOMO("PRINITNG OFSRECORD REQUEST - ":OFSRECORD)
*TSR-137108
    OFS.RESP   = ""; TXN.COMMIT = "" ;* R22 Manual conversion - Start
*CALL OFS.GLOBUS.MANAGER(OFS.SOURCE.ID, OFSRECORD)
    CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE.ID, OFSRECORD, OFS.RESP, TXN.COMMIT) ;* R22 Manual conversion - End
    CALL OCOMO("PRINITNG OFSRECORD RESPONSE - ":OFSRECORD)
    OFS.RESPONSE = ''; REP.FLAG = ''
    OFS.RESPONSE = FIELD(OFSRECORD,',',1)
    OFS.RESPONSE = FIELD(OFS.RESPONSE,'/',3,1)

    CALL OCOMO("GLOBUS RESPONSE - ":OFS.RESPONSE )
    IF OFS.RESPONSE EQ "1" THEN
        REC.PROCESS  = 'PROCESS'
        CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCT,REC.PROCESS,OFSVERSION,VAR.GTSMODE,NO.OF.AUTH,FT.ID,R.FUNDS.TRANSFER,OFSMSG)
        CALL OFS.POST.MESSAGE(OFSMSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)
        CALL OCOMO("OFS POST MSG RESPONSE completed OFSMSG: ":OFSMSG:" OFS.ERR: ":OFS.ERR)
        CALL OCOMO("OFS Process completed ":Y.BILL.ID:" - ":Y.AA.ID)
        Y.ACCOUNT.BALANCE -= Y.TOT.FT.AMOUNT ;*R22 AUTO CONVERSTION VAR1 - VAR2 TO -= VAR2
    END ELSE
        CALL OCOMO("OFS Process FAILED ":Y.AA.ID:" - ":OFS.RESPONSE)
    END

RETURN
*** </region>
END1:
    CALL OCOMO("DD Processing Completed - ":Y.DD.ACCOUNT:'[':R.REDO.DIRECT.DEBIT.ACCOUNTS:']')
END
