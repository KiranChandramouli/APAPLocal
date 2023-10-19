$PACKAGE APAP.REDOENQ
SUBROUTINE NOFILE.APAP.DETAIL.LOANS.PAYMENTS(Y.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: NOFILE.APAP.DETAIL.LOANS.PAYMENTS
* ODR NO      : ODR-2010-03-0138
*----------------------------------------------------------------------
*DESCRIPTION:This routine is attached in NOFILE ENQUIRY REDO.APAP.DETAIL.LOANS.PAYMENTS to
*shows all repayment details on or until a specific date
*IN PARAMETER : NA
*OUT PARAMETER: Y.ARRAY
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*15.09.2010  S SUDHARSANAN   ODR-2010-03-0138    INITIAL CREATION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     F.READ TO CACHE.READ,FM TO @FM
*13-07-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE MODIFIED
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.COLLATERAL
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.INTEREST.ACCRUALS
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.TELLER
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ENQUIRY
    $INSERT I_F.REDO.AA.PAYMENT.DETAILS
    $USING APAP.REDOAPAP
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB GET.ARR.IDS
    GOSUB GET.EFF.DATE
    GOSUB GET.FORM.TYPE
    GOSUB GET.PAY.TYPE
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
* All variables are intialized here
    Y.ARR.ID = ''
    Y.ARR.ACT.ID = ''
    VAR.ARR = ''
    VAR.EFFECTIVE.DATE = ''
    Y.COMMON.ARRAY = ''
    Y.ARR.LIST = ''
    Y.ARR.LIST1 = ''
    Y.ARR.LIST2 = ''
    VAR.CHEQUE = ''
    VAR.FORM.PAY = ''
    VAR.PAY = ''
    Y.PAY.TYPE.LIST = ''

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

    FN.AA.ARR.CUSTOMER = 'F.AA.ARR.CUSTOMER'
    F.AA.ARR.CUSTOMER = ''
    CALL OPF(FN.AA.ARR.CUSTOMER,F.AA.ARR.CUSTOMER)

    FN.REDO.AA.PAYMENT.DETAILS = 'F.REDO.AA.PAYMENT.DETAILS'
    F.REDO.AA.PAYMENT.DETAILS = ''
    CALL OPF(FN.REDO.AA.PAYMENT.DETAILS,F.REDO.AA.PAYMENT.DETAILS)

    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.INTEREST.ACCRUALS='F.AA.INTEREST.ACCRUALS'
    F.AA.INTEREST.ACCRUALS=''
    CALL OPF(FN.AA.INTEREST.ACCRUALS,F.AA.INTEREST.ACCRUALS)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.TELLER = 'F.TELLER'
    F.TELLER = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

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
GET.ARR.IDS:
*----------------------------------------------------------------------
* All selection fields related to AA.ARRANGEMENT application are processed here

    VALUE.BK = D.RANGE.AND.VALUE
    OPERAND.BK = D.LOGICAL.OPERANDS
    FIELDS.BK = D.FIELDS

    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''

    ARR.APP.FLDS = 'CO.CODE':@FM:'PRODUCT.GROUP':@FM:'PRODUCT' ;*R22 AUTO CONVERSION
    LOOP
        REMOVE APP.FLD FROM ARR.APP.FLDS SETTING ARR.FLD.POS
    WHILE APP.FLD:ARR.FLD.POS
        LOCATE APP.FLD IN FIELDS.BK<1> SETTING POS1 THEN
            VAR.ARR=1
            GOSUB UPDATE.COM.VAR
        END
    REPEAT

    IF D.FIELDS NE '' THEN
        FILE.NAME = FN.AA.ARRANGEMENT
*CALL REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.ARR.CMD)
*R22 MANUAL CONVERSION
        APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.ARR.CMD)
        CALL EB.READLIST(SEL.ARR.CMD,ARR.ID.LST,'',NO.OF.REC.ARR,SEL.ERR)
        Y.COMMON.ARRAY = ARR.ID.LST
    END
RETURN

*----------------------------------------------------------------------
GET.EFF.DATE:
*----------------------------------------------------------------------
* All selection fields related to AA.ARRANGEMENT.ACTIVITY application are processed here

    D.RANGE.AND.VALUE=''
    D.LOGICAL.OPERANDS=''
    D.FIELDS=''
    IF ARR.ID.LST THEN
        ARR.ACT.FLDS = 'EFFECTIVE.DATE'
        LOCATE ARR.ACT.FLDS IN FIELDS.BK<1> SETTING POS1 THEN
            VAR.EFFECTIVE.DATE=1
            GOSUB UPDATE.COM.VAR
        END
        IF D.FIELDS NE '' THEN
            LOOP
                REMOVE Y.ARRANGE.ID FROM ARR.ID.LST SETTING ARRNGMT.ID.POS
            WHILE Y.ARRANGE.ID:ARRNGMT.ID.POS
                Y.EFF.DATE = D.RANGE.AND.VALUE
                FILE.NAME = FN.REDO.AA.PAYMENT.DETAILS
*CALL REDO.E.FORM.SEL.STMT(FILE.NAME, '', '', SEL.ACT.CMD)
*R22 MANUAL CONVERSION
                APAP.REDOENQ.redoEFormSelStmt(FILE.NAME, '', '', SEL.ACT.CMD)
                SEL.ACTIVITY.CMD = SEL.ACT.CMD:' AND ARR.ID EQ ':Y.ARRANGE.ID
                CALL EB.READLIST(SEL.ACTIVITY.CMD,ACT.ID.LST,'',NO.OF.REC.ACT,SEL.ACT.ERR)
                IF ACT.ID.LST NE '' THEN
                    GOSUB CHECK.CONDITION
                END
            REPEAT
            IF Y.ARR.LIST NE '' THEN
                Y.COMMON.ARRAY = Y.ARR.LIST
            END ELSE
                Y.COMMON.ARRAY =''
                ARR.ID.LST = ''
            END
        END
    END
RETURN
*---------------------------------------------------------------------
CHECK.CONDITION:
*---------------------------------------------------------------------
    LOCATE Y.ARRANGE.ID IN Y.ARR.LIST<1> SETTING AA.POS2 ELSE
        Y.ARR.LIST<-1> = Y.ARRANGE.ID
    END
RETURN
*----------------------------------------------------------------------
UPDATE.COM.VAR:
*----------------------------------------------------------------------
    D.RANGE.AND.VALUE<-1>=VALUE.BK<POS1>
    D.LOGICAL.OPERANDS<-1>=OPERAND.BK<POS1>
    D.FIELDS<-1>=FIELDS.BK<POS1>
RETURN
*----------------------------------------------------------------------
GET.FORM.TYPE:
*----------------------------------------------------------------------
*If form of payment value is given to sort out the common array
    IF ARR.ID.LST NE '' THEN
        LOCATE 'FORM.OF.PAYMENT' IN FIELDS.BK<1> SETTING POS2 THEN
            VAR.FORM.PAY = 1
            Y.FORM.PAY = VALUE.BK<POS2>
            Y.FORM.TYPE = Y.COMMON.ARRAY
            LOOP
                REMOVE Y.ARRANGEMENT.ID FROM Y.FORM.TYPE SETTING ARRNGMT.ID.POS1
            WHILE Y.ARRANGEMENT.ID:ARRNGMT.ID.POS1
                SEL.ACTI.CMD = 'SELECT ':FN.REDO.AA.PAYMENT.DETAILS:' WITH ARR.ID EQ ':Y.ARRANGEMENT.ID
                CALL EB.READLIST(SEL.ACTI.CMD,SEL.ACT.LIST,'',NOR,ERR)
                IF SEL.ACT.LIST THEN
                    GOSUB CHK.ACT.REC
                END
            REPEAT
            IF Y.FORM.PAY.LIST THEN
                Y.COMMON.ARRAY = Y.FORM.PAY.LIST
            END ELSE
                Y.COMMON.ARRAY = ''
                Y.ARR.ID.LST = ''
                Y.ARR.LIST = ''
            END
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------------------
CHK.ACT.REC:
*--------------------------------------------------------------------------------------------------------------
    LOOP
        REMOVE Y.ACTIVITY FROM SEL.ACT.LIST SETTING ACT.ID.POS
    WHILE Y.ACTIVITY:ACT.ID.POS
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ACTIVITY,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ACT.ERR)
        TXN.SYS.ID  = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.SYSTEM.ID>
        TXN.CONT.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
        GOSUB CHK.TELLER.TYPE
        BEGIN CASE
            CASE Y.FORM.PAY EQ 'TRANSFERS'
                IF TXN.SYS.ID EQ 'FT' THEN
                    GOSUB UPDATE.FORM.PAY
                END
            CASE Y.FORM.PAY EQ 'CASHPAYMENT'
                IF VAR.CHEQUE EQ '' AND VAR.TT NE '' THEN
                    GOSUB UPDATE.FORM.PAY
                END
            CASE Y.FORM.PAY EQ 'CHEQUEPAYMENT'
                IF VAR.CHEQUE NE '' AND VAR.TT NE '' THEN
                    GOSUB UPDATE.FORM.PAY
                END
            CASE Y.FORM.PAY EQ 'MIXEDPAYMENT'
                IF VAR.TFS NE '' AND VAR.TT NE '' THEN
                    GOSUB UPDATE.FORM.PAY
                END
        END CASE
    REPEAT
RETURN
*----------------------------------------------------------------
CHK.TELLER.TYPE:
*----------------------------------------------------------------
    IF TXN.SYS.ID EQ 'TT' THEN
        VAR.TT = 1
        TXN.CONTRACT.ID= TXN.CONT.ID[1,2]
        IF TXN.CONTRACT.ID EQ 'TT' THEN
            CALL F.READ(FN.TELLER,TXN.CONT.ID,R.TELLER,F.TELLER,TELL.ERR)
            IF R.TELLER EQ '' THEN
                CALL EB.READ.HISTORY.REC(F.TELLER.HIS,TXN.CONT.ID,R.TELLER.HIS,YERR)
                VAR.CHEQUE = R.TELLER.HIS<TT.TE.CHEQUE.NUMBER>
            END ELSE
                VAR.CHEQUE  = R.TELLER<TT.TE.CHEQUE.NUMBER>
            END
        END ELSE
            VAR.TFS = 1
        END
    END
RETURN
*-------------------------------------------------------------------
UPDATE.FORM.PAY:
*----------------------------------------------------------------------
    LOCATE Y.ARRANGEMENT.ID IN Y.FORM.PAY.LIST SETTING AA.POS3 ELSE
        Y.FORM.PAY.LIST<-1> = Y.ARRANGEMENT.ID
    END
RETURN
*--------------------------------------------------------------------
GET.PAY.TYPE:
*--------------------------------------------------------------------
*If Payment type value is given to sort out the common array
    IF ARR.ID.LST NE '' THEN
        LOCATE 'PAYMENT.TYPE' IN FIELDS.BK<1> SETTING POS3 THEN
            VAR.PAY = 1
            GOSUB GET.PAY
            LOOP
                REMOVE Y.ARR.ID FROM Y.PAY.LIST SETTING ARR.ID.POS
            WHILE Y.ARR.ID:ARR.ID.POS
                SEL.ACTIV.CMD = 'SELECT ':FN.REDO.AA.PAYMENT.DETAILS:' WITH ARR.ID EQ ':Y.ARR.ID
                CALL EB.READLIST(SEL.ACTIV.CMD,SEL.ACTIV.LIST,'',NOR.ACTIV,ERR.ACTIV)
                IF SEL.ACTIV.LIST THEN
                    GOSUB CHK.PAY.TYPE
                END
            REPEAT
            IF Y.PAY.TYPE.LIST THEN
                Y.COMMON.ARRAY = Y.PAY.TYPE.LIST
            END ELSE
                Y.COMMON.ARRAY = ''   ;***************************Consolidated common array from all selection fields
                Y.ARR.ID.LST = ''     ;*******************************Array formed based on product ,product group and co.code fields
                Y.ARR.LIST = ''       ;*******************************Array formed based on effective date field
                Y.FORM.TYPE.LIST = '' ;*******************************Array formed based on form of type field
            END
        END
    END
RETURN
*----------------------------------------------------------------------
GET.PAY:
*----------------------------------------------------------------------
*Checks the payment type is belonging to TT or FT and also get the final common array
    Y.PAY.TYPE = VALUE.BK<POS3>
    CALL CACHE.READ(FN.TELLER.TRANSACTION, Y.PAY.TYPE, R.TT.TXN, TT.TXN.ERR) ;*R22 AUTO CONVERSION
    IF R.TT.TXN THEN
        Y.TXN.TYPE = 'TT'
    END ELSE
        CALL CACHE.READ(FN.FT.TXN.TYPE.CONDITION, Y.PAY.TYPE, R.FT.TXN.TYPE, FT.TXN.ERR) ;*R22 AUTO CONVERSION
        Y.TXN.TYPE = 'FT'
    END
    Y.PAY.LIST = Y.COMMON.ARRAY
RETURN
*------------------------------------------------------------------
CHK.PAY.TYPE:
*-------------------------------------------------------------------
    LOOP
        REMOVE Y.ACTIVITY FROM SEL.ACTIV.LIST SETTING ACT.POS
    WHILE Y.ACTIVITY:ACT.POS
        R.AA.ARRANGEMENT.ACTIVITY = ''
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.ACTIVITY,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ACT.ERR)
        TXN.SYS.ID  = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.SYSTEM.ID>
        TXN.CONT.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
        GOSUB CHEK.TELLER.TYPE
        GOSUB CHEK.FT.TYPE
        IF Y.PAY.TYPE EQ VAR.PAY.TYPE THEN
            GOSUB UPD.FORM.PAY
        END
    REPEAT
RETURN
*---------------------------------------------------------------
UPD.FORM.PAY:
*---------------------------------------------------------------
    IF VAR.FORM.PAY THEN
        BEGIN CASE
            CASE Y.FORM.PAY EQ 'TRANSFERS'
                IF TXN.SYS.ID EQ 'FT' THEN
                    GOSUB UPDATE.PAY.TYPE
                END
            CASE Y.FORM.PAY EQ 'CASHPAYMENT'
                IF VAR.CHQ EQ '' AND VAR.TT.TYPE NE '' THEN
                    GOSUB UPDATE.PAY.TYPE
                END
            CASE Y.FORM.PAY EQ 'CHEQUEPAYMENT'
                IF VAR.CHQ NE '' AND VAR.TT.TYPE NE '' THEN
                    GOSUB UPDATE.PAY.TYPE
                END
            CASE Y.FORM.PAY EQ 'MIXEDPAYMENT'
                IF VAR.TFS NE '' AND VAR.TT.TYPE NE '' THEN
                    GOSUB UPDATE.PAY.TYPE
                END
        END CASE
    END ELSE
        GOSUB UPDATE.PAY.TYPE
    END
RETURN
*----------------------------------------------------------------
CHEK.TELLER.TYPE:
*----------------------------------------------------------------
    IF TXN.SYS.ID EQ 'TT' THEN
        VAR.TT.TYPE = 1
        TXN.CONTRACT.ID= TXN.CONT.ID[1,2]
        IF TXN.CONTRACT.ID EQ 'TT' THEN
            CALL F.READ(FN.TELLER,TXN.CONT.ID,R.TELLER,F.TELLER,TELL.ERR)
            IF R.TELLER EQ '' THEN
                CALL EB.READ.HISTORY.REC(F.TELLER.HIS,TXN.CONT.ID,R.TELLER.HIS,YERR)
                VAR.PAY.TYPE = R.TELLER.HIS<TT.TE.TRANSACTION.CODE>
                VAR.CHQ = R.TELLER.HIS<TT.TE.CHEQUE.NUMBER>
            END ELSE
                VAR.CHQ = R.TELLER<TT.TE.CHEQUE.NUMBER>
                VAR.PAY.TYPE  = R.TELLER<TT.TE.TRANSACTION.CODE>
            END
        END ELSE
            VAR.TFS = 1
        END
    END
RETURN
*-------------------------------------------------------------------
CHEK.FT.TYPE:
*----------------------------------------------------------------------
    IF TXN.SYS.ID EQ 'FT' THEN
        CALL F.READ(FN.FUNDS.TRANSFER,TXN.CONT.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)
        IF R.FUNDS.TRANSFER EQ '' THEN
            CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,TXN.CONT.ID,R.FT.HIS,FT.ERROR)
            VAR.PAY.TYPE = R.FT.HIS<FT.TRANSACTION.TYPE>
        END ELSE
            VAR.PAY.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
        END
    END
RETURN
*-------------------------------------------------------------------
UPDATE.PAY.TYPE:
*----------------------------------------------------------------------
    LOCATE Y.ARR.ID IN Y.PAY.TYPE.LIST SETTING AA.POS3 ELSE
        Y.PAY.TYPE.LIST<-1> = Y.ARR.ID
    END
RETURN
*--------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------

*CALL REDO.APAP.NOFILE.ARR.PAYMENTS(Y.COMMON.ARRAY,VAR.EFFECTIVE.DATE,Y.EFF.DATE,Y.FORM.PAY,VAR.FORM.PAY,Y.PAY.TYPE,VAR.PAY,Y.ARRAY)
*R22 MANUAL CONVERSION
    APAP.REDOAPAP.redoApapNofileArrPayments(Y.COMMON.ARRAY,VAR.EFFECTIVE.DATE,Y.EFF.DATE,Y.FORM.PAY,VAR.FORM.PAY,Y.PAY.TYPE,VAR.PAY,Y.ARRAY)
RETURN
*-----------------------------------------------------------------------
END
