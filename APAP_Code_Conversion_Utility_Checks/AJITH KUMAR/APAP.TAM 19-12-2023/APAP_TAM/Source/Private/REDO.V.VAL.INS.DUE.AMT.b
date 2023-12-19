* @ValidationCode : MjoxMTQ0NjIxOTQxOkNwMTI1MjoxNzAyOTY1Njc1MTU1OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:31:15
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.VAL.INS.DUE.AMT

*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Program   Name    :REDO.V.VAL.INS.DUE.AMT
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is a validation routine attached to install payment version of FT and TELLER
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 4-NOV-2011        Marimuthu S     PACS00146864
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM, SM TO @SM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON  ;*Not Used anymore;
    $INSERT I_EQUATE ;*Not Used anymore;
*   $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.FUNDS.TRANSFER ;* Not Used anymore;
*  $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ARRANGEMENT ;*Not Used anymore;
    $INSERT I_F.ACCOUNT ;*Not Used anymore;
    $INSERT I_F.VERSION ;*Not Used anymore;
*$USING AC.AccountOpening
    $USING AA.PaymentSchedule

    IF VAL.TEXT EQ '' THEN
        GOSUB INIT
    END
RETURN
INIT:

    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS='F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS=''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    VAR.NO.OF.INSTALLMENT=COMI
    Y.DUP.NO.OF.INS = COMI

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESS.FT

    END
RETURN
PROCESS.FT:
    VAR.AA.ID=R.NEW(FT.CREDIT.ACCT.NO)
    LREF.APP='FUNDS.TRANSFER'
    LREF.FLD = 'L.FT.INSTAL.AMT'
    GOSUB PROCESS
    Y.POS.INS.AMT = LREF.POS<1,3>
    Y.VAL.CK = R.NEW(FT.LOCAL.REF)<1,Y.POS.INS.AMT>
    R.NEW(FT.CREDIT.AMOUNT)= Y.FIN.AMT

*------ Group 12 ---
    IF R.VERSION(EB.VER.VERSION.TYPE) EQ 'NV' THEN
        Y.COMI = COMI
        Y.AF   = AF
        Y.AV   = AV
        Y.AS   = AS
        COMI = R.NEW(FT.CREDIT.AMOUNT)
*CALL REDO.VAL.MTS.AMOUNT.FT
*R22 MANUAL CONVERSION
*APAP.TAM.REDO.VAL.MTS.AMOUNT.FT ;*R22 MANUAL CODE CONVERSION
        APAP.TAM.redoValMtsAmountFt() ;*R22 MANUAL CODE CONVERSION
        COMI  =     Y.COMI
        AF    =     Y.AF
        AV    =     Y.AV
        AS    =     Y.AS
    END
*------ Group 12 ---
RETURN

PROCESS:

* PACS00080543 -s
    LREF.FIELDS='L.PRINC.AMT.DUE':@VM:'L.INT.AMT.DUE':@VM:LREF.FLD ;*R22 AUTO CONVERSION
* PACS00080543 -E
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)

    CALL F.READ(FN.ACCOUNT,VAR.AA.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    VAR.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>

    R.AA.ACCOUNT.DETAILS = AA.PaymentSchedule.AccountDetails.Read(VAR.AA.ID, AA.AC.ERR)
* Before incorporation : CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.AC.ERR)
*  Y.TOT.BILS = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.TOT.BILS = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillId>
    Y.TOT.BILS = CHANGE(Y.TOT.BILS,@SM,@VM) ;*R22 AUTO CONVERSION START
    Y.CN.VM = DCOUNT(Y.TOT.BILS,@VM)
    Y.CNT = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE>,@VM) ;*R22 AUTO CONVERSION END
    FLG = '' ; FIN.CNT = ''
    GOSUB PROCESS1

    IF PGM.VERSION EQ ',REDO.MULTI.AA.ACRP.DISB' THEN
        IF VAR.NO.OF.INSTALLMENT GT FLG THEN
            AF = FT.LOCAL.REF
            AV = Y.POS.INS.AMT
            ETEXT = 'EB-INS.CNT.GT.INS'
            CALL STORE.END.ERROR
        END
    END ELSE
        GOSUB ADV.AMT.CALC
    END

RETURN

PROCESS1:

    LOOP
    WHILE Y.CNT GT 0 DO
        FLG.VAL += 1
* Y.TYPE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL>
        Y.TYPE = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillType,FLG.VAL>
        Y.CNT.TYPE = DCOUNT(Y.TYPE,@SM) ;*R22 AUTO CONVERSION
        IF Y.CNT.TYPE EQ 1 THEN
*IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,1> EQ 'PAYMENT' THEN
            IF R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillType,FLG.VAL,1> EQ 'PAYMENT' THEN
*Y.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,FLG.VAL,1>
                Y.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillId,FLG.VAL,1>
* CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
*AA.PaymentSchedule.BillDetails.Read(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
                R.AA.BILL.DETAILS = AA.PaymentSchedule.BillDetails.Read(Y.BILL.ID, BILL.ERR)
*Y.SETTLE.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
                Y.SETTLE.STATUS = R.AA.BILL.DETAILS<AA.PaymentSchedule.BillDetails.BdSettleStatus,1>
                GOSUB CHECK.UNPAID
            END
*IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,1> EQ 'ACT.CHARGE' THEN
            IF R.AA.ACCOUNT.DETAILS<AA.PaymentSchedule.AccountDetails.AdBillType,FLG.VAL,1> EQ 'ACT.CHARGE' THEN
                
            
                FIN.CNT += 1
            END
        END
        Y.CNT -= 1
    REPEAT
RETURN
ADV.AMT.CALC:

    IF VAR.NO.OF.INSTALLMENT GT FLG THEN
        FLG.FIN = FIN.CNT + FLG
        Y.ADV.CNT = VAR.NO.OF.INSTALLMENT - FLG
*CALL AA.SCHEDULE.PROJECTOR(VAR.AA.ID, SIM.REF, "",CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.TYPES, DUE.DEFER.DATES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
*AA.PaymentScheule.ScheduleProjector(VAR.AA.ID, SIM.REF, "",CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.TYPES, DUE.DEFER.DATES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
        AA.PaymentSchedule.ScheduleProjector(VAR.AA.ID, SIM.REF, "",CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.TYPES, DUE.DEFER.DATES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
        Y.NO.OF.DATE=DCOUNT(DUE.DATES,@FM) ;*R22 AUTO CONVERSION
        VAR1=1
        LOOP
        WHILE (Y.ADV.CNT GT 0) AND (Y.NO.OF.DATE GT 0) DO
            FLG.FIN += 1
            Y.PROP = DUE.PROPS<FLG.FIN>
            Y.PROP = CHANGE(Y.PROP,@SM,@VM) ;*R22 AUTO CONVERSION
            IF 'ACCOUNT' MATCHES Y.PROP OR 'PRINCIPALINT' MATCHES Y.PROP OR 'PENALTYINT' MATCHES Y.PROP THEN
                Y.FIN.AMT += TOT.PAYMENT<FLG.FIN>
                Y.ADV.CNT -= 1
            END
            Y.NO.OF.DATE -= 1
        REPEAT
    END

RETURN
**************
CHECK.UNPAID:
**************
    IF Y.SETTLE.STATUS EQ 'UNPAID' THEN
        Y.DUP.NO.OF.INS -= 1
        IF Y.DUP.NO.OF.INS GE 0 THEN
            Y.FIN.AMT += SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
        END
        FLG += 1
    END ELSE
        FIN.CNT += 1
    END

RETURN
***********************************************
END
