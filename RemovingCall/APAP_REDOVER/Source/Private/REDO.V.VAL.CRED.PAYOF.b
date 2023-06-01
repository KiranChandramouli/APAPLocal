* @ValidationCode : MjotMTYxMTA5Njk1MTpDcDEyNTI6MTY4MjY5MTUxODc3NTpJVFNTOi0xOi0xOjY1NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 28 Apr 2023 19:48:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 656
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.V.VAL.CRED.PAYOF
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :MARIMUTHU S
*Program   Name    :REDO.V.VAL.CRED.PAYOF
*---------------------------------------------------------------------------------
*

*DESCRIPTION       :
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who                Reference                       Description
* 03-APR-2010        MARIMUTHU S        PACS00187868                     Initial Creation
*13-04-2023          Conversion Tool     R22 Auto Code conversion       FM TO @FM,VM TO @VM,SM TO @SM,
*13-04-2023           Samaran T           R22 Manual Code conversion      Call Routine Format Modified
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.FUNDS.TRANSFER
    $USING APAP.TAM

    GOSUB OPEN.FILES
    GOSUB INIT
RETURN

*****
OPEN.FILES:
*****
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS  = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS  = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS   = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.AA.PROPERTY  = 'F.AA.PROPERTY'
    F.AA.PROPERTY   = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)

RETURN
*****
INIT:
*****

    VAR.ACCOUNT.ID = COMI

    GOSUB PROCESS.FT

RETURN

PROCESS.FT:

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        LREF.APP = 'FUNDS.TRANSFER':@FM:'AA.PRD.DES.OVERDUE'
        LREF.FIELDS = 'L.PRINC.AMT.DUE':@VM:'L.INT.AMT.DUE':@VM:'TFS.STO.ID':@FM:'L.LOAN.STATUS.1':@VM:'L.LOAN.COND'
        LREF.POS = ''
        CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
        Y.POS.PRIN = LREF.POS<1,1>
        Y.POS.INT = LREF.POS<1,2>
        Y.POS.TFS = LREF.POS<1,3>
        POS.L.LOAN.ST = LREF.POS<2,1>
        POS.L.LOAN.CON = LREF.POS<2,2>

        GOSUB GET.BILL.DETAILS

        PROP.CLASS = 'OVERDUE'
        PROPERTY = ''
        R.Condition = ''
        ERR.MSG = ''
        EFF.DATE = ''

        CALL APAP.TAM.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)   ;*R22 MANUAL CODE CONVERSION
        LOAN.STATUS = R.Condition<AA.OD.LOCAL.REF,POS.L.LOAN.ST>
        LOAN.COND = R.Condition<AA.OD.LOCAL.REF,POS.L.LOAN.CON>

        R.NEW(FT.CREDIT.AMOUNT) =  Y.OR.PAYOFF.AMT
        R.NEW(FT.LOCAL.REF)<1,Y.POS.PRIN> = Y.AC.AMT
        R.NEW(FT.LOCAL.REF)<1,Y.POS.INT> = Y.INT.AMT
        R.NEW(FT.CREDIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>
        R.NEW(FT.ORDERING.CUST) = R.ACCOUNT<AC.CUSTOMER>
        R.NEW(FT.LOCAL.REF)<1,Y.POS.TFS> = ''
*   IF MESSAGE EQ 'VAL' THEN

*       IF LOAN.STATUS MATCHES 'JudicialCollection' OR LOAN.STATUS MATCHES 'Write-off' THEN
*           AF = FT.LOCAL.REF
*           AV = POS.L.LOAN.ST
*           CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),VM) + 1
*           TEXT = 'REDO.LOAN.BLOCK.ST'
*           CALL STORE.OVERRIDE(CURR.NO)
*       END
*       IF LOAN.COND MATCHES 'Legal' THEN
*           AF = FT.LOCAL.REF
*           AV = POS.L.LOAN.CON
*           CURR.NO = DCOUNT(R.NEW(FT.OVERRIDE),VM) + 1
*           TEXT = 'REDO.LOAN.BLOCK.ST'
*           CALL STORE.OVERRIDE(CURR.NO)
*       END
*   END
    END

RETURN
*****************
GET.BILL.DETAILS:
*****************

    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    Y.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    IF NOT(Y.ARR.ID) THEN
        AF = FT.CREDIT.ACCT.NO
        ETEXT = 'EB-NOT.ARRANGEMENT.ID'
        CALL STORE.END.ERROR
        RETURN
    END

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.ACC.ERR)
    Y.BILLS = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.BILLS = CHANGE(Y.BILLS,@SM,@VM)
    Y.CNT = DCOUNT(Y.BILLS,@VM)
    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.BIL.ID = Y.BILLS<1,FLG>
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BIL.ID,R.BILL.DETAILS,F.AA.BILL.DETAILS,BIL.ERR)
        Y.PRPS = R.BILL.DETAILS<AA.BD.PROPERTY>
        Y.PAY.TYPE = R.BILL.DETAILS<AA.BD.PAYMENT.METHOD>
        LOCATE 'INFO' IN Y.PAY.TYPE<1,1> SETTING POS.PY THEN
            Y.OR.PAYOFF.AMT = R.BILL.DETAILS<AA.BD.OR.TOTAL.AMOUNT>
            LOCATE 'ACCOUNT' IN Y.PRPS<1,1> SETTING POS.AC THEN
                Y.AC.AMT = R.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT,POS.AC>
            END
            LOCATE 'PRINCIPALINT' IN Y.PRPS<1,1> SETTING POS.PR THEN
                Y.INT.AMT = R.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT,POS.PR>
            END
            LOCATE 'PENALTINT' IN Y.PRPS<1,1> SETTING POS.PN THEN
                Y.INT.AMT += R.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT,POS.PN>
            END
            RETURN
        END
        Y.CNT -= 1
    REPEAT

RETURN
*-------------------------------------------------------
END
