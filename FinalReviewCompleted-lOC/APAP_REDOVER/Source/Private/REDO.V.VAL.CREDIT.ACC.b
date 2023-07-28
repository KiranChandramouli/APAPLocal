* @ValidationCode : MjoxMjAwNTM0MDc3OkNwMTI1MjoxNjgzMDE3ODgzMzQ5OklUU1M6LTE6LTE6NjUzOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 02 May 2023 14:28:03
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 653
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE  REDO.V.VAL.CREDIT.ACC
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.CREDIT.ACC
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a deal slip routine for FT and TT payment
*LINKED WITH       :
*
* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 3-JUN-2010        Prabhu.N       ODR-2010-01-0081    Initial Creation
* 17-JUL-2011       MARIMUTHU      PACS00085210
* 02-SEP-2011       MARIMUTHU S    PACS00112741
* 25-NOV-2011       MARIMUTHU S    PACS00146864
*-------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM
*13-04-2023              Samaran T                R22 Manual Code conversion                      Call Routine Format Modified
*----------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.ALTERNATE.ACCOUNT
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.VERSION
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

    VAR.ACCOUNT.ID=COMI

    LREF.APP='TELLER':@FM:'FUNDS.TRANSFER'
    LREF.FIELDS='L.PRINC.AMT.DUE':@VM:'L.INT.AMT.DUE':@VM:'L.LOAN.STATUS.1':@VM:'L.LOAN.COND':@VM:'L.TT.DUE.PRS':@FM:'L.PRINC.AMT.DUE':@VM:'L.INT.AMT.DUE'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    VAR.TT.LOAN.STAT = LREF.POS<1,3>
    VAR.TT.LOAN.COND = LREF.POS<1,4>
    POS.TT.PROCESS = LREF.POS<1,5>
    Y.POS.PR.AMT = LREF.POS<2,1>
    Y.POS.INT.AMT = LREF.POS<2,2>

    GOSUB PROCESS.FT

    IF APPLICATION EQ 'TELLER' THEN
        GOSUB GET.BILL.DETAILS
        CALL APAP.REDOVER.redoVDefTtLoanStatusCond();*R22 MANUAL CODE CONVERSION
* PACS00085210 -S
        Y.LOAN.STATUS = R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.LOAN.STAT>
        Y.LOAN.COND = R.NEW(TT.TE.LOCAL.REF)<1,VAR.TT.LOAN.COND>
        Y.TT.PROCESS = R.NEW(TT.TE.LOCAL.REF)<1,POS.TT.PROCESS>
        CHANGE @SM TO @VM IN Y.LOAN.STATUS
        CHANGE @SM TO @VM IN Y.LOAN.COND

        Y.REQ.CHK = APPLICATION:PGM.VERSION
        IF Y.REQ.CHK EQ "TELLER,REDO.MULTI.AA.ACRPAP" OR Y.REQ.CHK EQ "TELLER,REDO.AA.PART.CHQ" OR Y.REQ.CHK EQ "TELLER,REDO.MULTI.ADVANCE.CHQ" OR Y.REQ.CHK EQ "TELLER,REDO.MULTI.AA.OVR.CHQ" OR Y.REQ.CHK EQ "TELLER,REDO.MULTI.AA.CHQ" THEN
            IF Y.LOAN.COND MATCHES 'ThreeReturnedChecks' THEN
                AF = TT.TE.LOCAL.REF
                AV = VAR.TT.LOAN.COND
                ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
                CALL STORE.END.ERROR
                R.NEW(TT.TE.AMOUNT.LOCAL.1) = ''
            END
        END

        GOSUB CHECK.STATUS

* PACS00085210 -E
        IF Y.PRINCIPAL.AMOUNT EQ '' THEN
            Y.PRINCIPAL.AMOUNT  = 0
        END
        IF Y.INTEREST.AMOUNT EQ '' THEN
            Y.INTEREST.AMOUNT  = 0
        END
        R.NEW(TT.TE.AMOUNT.LOCAL.1) = Y.OR.PAYOFF.AMT
        R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS<1,1>> = Y.AC.AMT
        R.NEW(TT.TE.LOCAL.REF)<1,LREF.POS<1,2>> = Y.INT.AMT
    END

RETURN

CHECK.STATUS:

    IF ('JudicialCollection' MATCHES Y.LOAN.STATUS) OR ('Write-off' MATCHES Y.LOAN.STATUS) THEN
        IF Y.TT.PROCESS EQ '' THEN
            ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
            AF = TT.TE.LOCAL.REF
            AV = VAR.TT.LOAN.STAT
            CALL STORE.END.ERROR
            R.NEW(TT.TE.AMOUNT.LOCAL.1) = ''
        END

        IF ('Legal' MATCHES Y.LOAN.COND) THEN
            ETEXT = 'EB-REQ.COLL.AREA.AUTH1'
            AF = TT.TE.LOCAL.REF
            AV = VAR.TT.LOAN.COND
            CALL STORE.END.ERROR
            R.NEW(TT.TE.AMOUNT.LOCAL.1) = ''
        END
    END

RETURN

PROCESS.FT:

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB GET.BILL.DETAILS
        CALL APAP.REDOVER.redoVDefFtLoanStatusCond();*R22 MANUAL CODE CONVERSION
        IF Y.PRINCIPAL.AMOUNT EQ '' THEN
            Y.PRINCIPAL.AMOUNT  = 0
        END
        IF Y.INTEREST.AMOUNT EQ '' THEN
            Y.INTEREST.AMOUNT  = 0
        END
        R.NEW(FT.CREDIT.AMOUNT)= Y.OR.PAYOFF.AMT
        R.NEW(FT.LOCAL.REF)<1,Y.POS.PR.AMT> = Y.AC.AMT
        R.NEW(FT.LOCAL.REF)<1,Y.POS.INT.AMT> = Y.INT.AMT
        R.NEW(FT.CREDIT.CURRENCY) = R.ACCOUNT<AC.CURRENCY>


*------ Group 12 ---
        IF R.VERSION(EB.VER.VERSION.TYPE) EQ 'NV' THEN
            Y.COMI = COMI
            Y.AF   = AF
            Y.AV   = AV
            Y.AS   = AS
            COMI = R.NEW(FT.CREDIT.AMOUNT)
            CALL APAP.TAM.redoValMtsAmountFt()    ;*R22 MANUAL CODE CONVERSION
            COMI  =     Y.COMI
            AF    =     Y.AF
            AV    =     Y.AV
            AS    =     Y.AS
        END
*------ Group 12 ---

    END

RETURN
*****************
GET.BILL.DETAILS:
*****************
** PACS000112741 -S
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    Y.ARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
* IF NOT(Y.ARR.ID) THEN
*     AF = FT.CREDIT.ACCT.NO
*     ETEXT = 'EB-NOT.ARRANGEMENT.ID'
*     CALL STORE.END.ERROR
*     RETURN
* END
** PACS000112741 -E

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
            LOCATE 'PENALTYINT' IN Y.PRPS<1,1> SETTING POS.PN THEN
                Y.INT.AMT += R.BILL.DETAILS<AA.BD.OR.PROP.AMOUNT,POS.PN>
            END
            RETURN
        END
        Y.CNT -= 1
    REPEAT

RETURN
*-------------------------------------------------------
END
