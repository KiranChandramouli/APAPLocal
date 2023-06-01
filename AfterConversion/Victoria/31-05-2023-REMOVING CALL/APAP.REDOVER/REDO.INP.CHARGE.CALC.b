* @ValidationCode : MjotMTE0NTYyNTQ2NjpDcDEyNTI6MTY4NTUzNjAwMjM5Mjp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:56:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.INP.CHARGE.CALC
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.INP.CHARGE.CALC
* ODR NO      : ODR-2009-10-0324
*----------------------------------------------------------------------
*DESCRIPTION: This is VALIDATION Routine for both TELLER & FT to calculate the charges
* and limit the user to disburse only remaining amount



*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: TELLER & FT
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO               REFERENCE                     DESCRIPTION
*02.06.2010  H GANESH           ODR-2009-10-0324               INITIAL CREATION
*05-04-2023  Conversion Tool     R22 Auto Code conversion      FM TO @FM,VM TO @VM , SM TO @SM , ++ TO +=1, > TO GT
*05-04-2023    Samaran T         Manual R22 Code Conversion      Call Routine Format Modified
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $USING APAP.TAM

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB LOCAL.REF
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS=''
    Y.DISBURSED.AMOUNT=''
    Y.CHARGE.AMOUNT=0
    Y.AMOUNT=0
RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------

    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)


    FN.AA.ARRANGEMENT.ACTIVITY='F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY=''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)



RETURN


*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------

    LOC.REF.APPLICATION="TELLER":@FM:"FUNDS.TRANSFER"
    LOC.REF.FIELDS='L.DISB.AMT':@FM:'L.DISB.AMT'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.TT.L.DISB.AMT=LOC.REF.POS<1,1>
    POS.FT.L.DISB.AMT=LOC.REF.POS<2,1>

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    IF APPLICATION EQ 'TELLER' THEN
        IN.ACC.ID=R.NEW(TT.TE.ACCOUNT.2)
        DISB.AMOUNT= COMI
        GOSUB CHARGE
        IF (DISB.AMOUNT+Y.DISBURSED.AMOUNT) GT Y.COMMITMENT.AMOUNT THEN  ;*R22 AUTO CODE CONVERSION
            Y.AMOUNT=Y.COMMITMENT.AMOUNT-Y.DISBURSED.AMOUNT
            AF=TT.TE.LOCAL.REF
            AV=POS.TT.L.DISB.AMT
            ETEXT='EB-REDO.CHRG.CHK':@FM:Y.AMOUNT
            CALL STORE.END.ERROR
            GOSUB END1
        END
        R.NEW(TT.TE.AMOUNT.LOCAL.1)=(DISB.AMOUNT-Y.CHARGE.AMOUNT)
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        IN.ACC.ID=R.NEW(FT.DEBIT.ACCT.NO)
        DISB.AMOUNT= COMI
        GOSUB CHARGE
        IF (DISB.AMOUNT+Y.DISBURSED.AMOUNT) GT Y.COMMITMENT.AMOUNT THEN  ;*R22 AUTO CODE CONVERSION
            Y.AMOUNT=Y.COMMITMENT.AMOUNT-Y.DISBURSED.AMOUNT
            AF=FT.LOCAL.REF
            AV=POS.FT.L.DISB.AMT
            ETEXT='EB-REDO.CHRG.CHK':@FM:Y.AMOUNT
            CALL STORE.END.ERROR
            GOSUB END1
        END
        R.NEW(FT.DEBIT.AMOUNT)=(DISB.AMOUNT-Y.CHARGE.AMOUNT)
    END

RETURN
*----------------------------------------------------------------------
CHARGE:
*----------------------------------------------------------------------
* This part gets the details of the arrangement

    APAP.TAM.redoConvertAccount(IN.ACC.ID,IN.ARR.ID,OUT.ID,ERR.TEXT) ;*R22 MANUAL CODE CONVERSION
    Y.ARRANGEMENT.ID=OUT.ID
    PROP.CLASS='TERM.AMOUNT'
    PROPERTY=''
    R.Condition=''
    ERR.MSG=''
    APAP.TAM.redoCrrGetConditions(Y.ARRANGEMENT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)  ;*R22 MANUAL CODE CONVERSION
    Y.COMMITMENT.AMOUNT=R.Condition<AA.AMT.AMOUNT>
    SEL.DISB.CMD='SELECT ':FN.AA.ARRANGEMENT.ACTIVITY:' WITH ARRANGEMENT EQ ':Y.ARRANGEMENT.ID:' AND ACTIVITY.CLASS EQ LENDING-DISBURSE-TERM.AMOUNT'
    CALL EB.READLIST(SEL.DISB.CMD,SEL.DISB.LIST,'',SEL.DISB.NOR,SEL.RET)
    VAR3=1
    LOOP
    WHILE VAR3 LE SEL.DISB.NOR
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,SEL.DISB.LIST<VAR3>,R.ARR.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,ARR.ACT.ERR)
        Y.DISBURSED.AMOUNT+= R.ARR.ACTIVITY<AA.ARR.ACT.TXN.AMOUNT>
        VAR3 += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.ARRANGEMENT.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ERR.ACC.DET)
    Y.BILL.TYPE=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE>
    Y.BILL.ID=R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.SET.STATUS=R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>

    CHANGE @SM TO @FM IN Y.BILL.TYPE
    CHANGE @VM TO @FM IN Y.BILL.TYPE
    CHANGE @SM TO @FM IN Y.BILL.ID
    CHANGE @VM TO @FM IN Y.BILL.ID
    CHANGE @SM TO @FM IN Y.SET.STATUS
    CHANGE @VM TO @FM IN Y.SET.STATUS
    Y.BILL.COUNT=DCOUNT(Y.BILL.TYPE,@FM)
    VAR2=1
    LOOP
    WHILE VAR2 LE Y.BILL.COUNT
        IF Y.BILL.TYPE<VAR2> EQ "ACT.CHARGE" AND Y.SET.STATUS<VAR2> EQ 'UNPAID' THEN
            Y.BILL=Y.BILL.ID<VAR2>
            GOSUB AMOUNT.CALC
        END
        VAR2 += 1 ;*R22 AUTO CODE CONVERSION
    REPEAT

RETURN
*----------------------------------------------------------------------
AMOUNT.CALC:
*----------------------------------------------------------------------
* Calculates the amount for charges Bills
    CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL,R.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
    Y.CHARGE.AMOUNT+= SUM(R.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
RETURN
*----------------------------------------------------------------------
END1:
*----------------------------------------------------------------------

END
