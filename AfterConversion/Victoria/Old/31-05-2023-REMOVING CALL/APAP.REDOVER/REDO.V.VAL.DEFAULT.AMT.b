* @ValidationCode : MjotMTMxMTcxMjEyNjpDcDEyNTI6MTY4NTUzNjA0MDY5Mjp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:57:20
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
SUBROUTINE REDO.V.VAL.DEFAULT.AMT
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : H GANESH
* PROGRAM NAME : REDO.V.VAL.DEFAULT.AMT
*----------------------------------------------------------


* DESCRIPTION : This routine is a validation routine attached
* to ACCOUNT.2 of TELLER & CREDIT.ACCOUNT.NO of FUNDS.TRANSFER
* model bank version to do overpayment validations
*------------------------------------------------------------

*    LINKED WITH : TELLER & CREDIT.ACCOUNT.NO AS VALIDATION ROUTINE
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE

*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE         DESCRIPTION
*20.12.2009      H GANESH            ODR-2009-10-0305  INITIAL CREATION
*24.06.2011      MARIMUTHU S         PACS00080543
*17.08.2011      MARIMUTHU S         PACS00060279 & PACS00074323
*27.10.2011      MARIMUTHU S         PACS00142802
*12.11.2011      MARIMUTHU S         PACS00146864
*----------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM
*13-04-2023              Samaran T                R22 Manual Code conversion                      CALL ROUTINE FORMAT MODIFIED
*----------------------------------------------------------------------------------------------------------------------------------------


*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.TELLER
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.ACCT.ACTIVITY
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.BILL.DETAILS
    $USING APAP.TAM

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*-------------------------------------------------------------
INIT:
*-------------------------------------------------------------
* intilaise the variables
    FN.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.ACCOUNT.DETAILS=''
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    FN.ACCT.ACTIVITY='F.ACCT.ACTIVITY'
    F.ACCT.ACTIVITY=''
    FN.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.ARRANGEMENT=''
    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    Y.ARRANGEMENT.ID=''
    Y.NO.OF.DATE=''
    Y.VALUE.DATE=''
    Y.PAYMENT.DATE=''
    Y.TOTAL.DUE=''
    Y.NO.BILL=''
    Y.MAX.AMOUNT=''
    Y.MIN.AMOUNT=''
    Y.MAX.TIME=''
    Y.MIN.TIME=''
    Y.OVERDUE.AMT=0

RETURN
*-------------------------------------------------------------
OPENFILES:
*-------------------------------------------------------------
* To  open the files that are needed

    CALL OPF(FN.ACCOUNT.DETAILS,F.ACCOUNT.DETAILS)
    CALL OPF(FN.ACCT.ACTIVITY,F.ACCT.ACTIVITY)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.ARRANGEMENT,F.ARRANGEMENT)
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)
RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------

    IF APPLICATION EQ 'TELLER' THEN
        LOC.REF.APPLICATION="TELLER":@FM:"AA.ARR.TERM.AMOUNT":@FM:"AA.ARR.PAYMENT.SCHEDULE"
        LOC.REF.FIELDS='L.TT.INSTAL.AMT':@VM:'L.TT.NEXT.PAY':@VM:'L.TT.BIL.OVRDUE':@VM:'L.TT.OVRDUE.AMT':@VM:'L.TT.MAX.AMOUNT':@VM:'L.TT.MIN.AMOUNT':@VM:'L.TT.MAX.TIME':@VM:'L.TT.MIN.TIME':@FM:'L.AA.MAX.AMOUNT':@VM:'L.AA.MIN.AMOUNT':@VM:'L.AA.MAX.TIME':@VM:'L.AA.MIN.TIME':@FM:'L.AA.MAX.AMOUNT':@VM:'L.AA.MIN.AMOUNT'
        LOC.REF.POS=''
        GOSUB LOC.REF
        GOSUB TELLER
    END
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        LOC.REF.APPLICATION="FUNDS.TRANSFER":@FM:"AA.ARR.TERM.AMOUNT":@FM:"AA.ARR.PAYMENT.SCHEDULE"
        LOC.REF.FIELDS='L.FT.INSTAL.AMT':@VM:'L.FT.NEXT.PAY':@VM:'L.FT.BIL.OVRDUE':@VM:'L.FT.OVRDUE.AMT':@VM:'L.FT.MAX.AMOUNT':@VM:'L.FT.MIN.AMOUNT':@VM:'L.FT.MAX.TIME':@VM:'L.FT.MIN.TIME':@FM:'L.AA.MAX.AMOUNT':@VM:'L.AA.MIN.AMOUNT':@VM:'L.AA.MAX.TIME':@VM:'L.AA.MIN.TIME':@FM:'L.AA.MAX.AMOUNT':@VM:'L.AA.MIN.AMOUNT'
        LOC.REF.POS=''
        GOSUB LOC.REF
        GOSUB FUNDSTRANSFER
    END
RETURN
*-------------------------------------------------------------
LOC.REF:
*-------------------------------------------------------------
* calling core routine to get the LOCAL.REF positions

    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
RETURN

*-------------------------------------------------------------
TELLER:
*-------------------------------------------------------------
* if repayment is made through TELLER

    Y.ACCOUNT.ID=COMI
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACC,F.ACCOUNT,ERR.ACC)
    Y.ARRANGEMENT.ID=R.ACC<AC.ARRANGEMENT.ID>
    Y.VALUE.DATE=R.NEW(TT.TE.VALUE.DATE.2)
    POS.INSTAL.AMT=LOC.REF.POS<1,1>
    POS.NEXT.PAY=LOC.REF.POS<1,2>
    POS.BILL.OVERDUE=LOC.REF.POS<1,3>
    POS.OVRDUE.AMT=LOC.REF.POS<1,4>
    POS.MAX.AMT=LOC.REF.POS<1,5>
    POS.MIN.AMT=LOC.REF.POS<1,6>
    POS.MAX.TIME=LOC.REF.POS<1,7>
    POS.MIN.TIME=LOC.REF.POS<1,8>
    R.ACCOUNT.DETAILS = ''; ACT.DET.ERR = ''
    CALL F.READ(FN.ACCOUNT.DETAILS,Y.ARRANGEMENT.ID,R.ACCOUNT.DETAILS,F.ACCOUNT.DETAILS,ACT.DET.ERR)
    GOSUB UPDATE.VERS.AA.ACCRAP
    GOSUB INSTALLMENT
    R.NEW(TT.TE.LOCAL.REF)<1,POS.INSTAL.AMT>=Y.TOTAL.DUE
    R.NEW(TT.TE.LOCAL.REF)<1,POS.NEXT.PAY>=Y.NEXT.TOTAL.DUE

    R.NEW(TT.TE.LOCAL.REF)<1,POS.BILL.OVERDUE>= FLG
    R.NEW(TT.TE.LOCAL.REF)<1,POS.OVRDUE.AMT>= Y.FIN.AMT
    GOSUB OVERPAYRULES
    R.NEW(TT.TE.LOCAL.REF)<1,POS.MAX.AMT>=Y.MAX.AMOUNT
    R.NEW(TT.TE.LOCAL.REF)<1,POS.MIN.AMT>=Y.MIN.AMOUNT
    R.NEW(TT.TE.LOCAL.REF)<1,POS.MAX.TIME>=Y.MAX.TIME
    R.NEW(TT.TE.LOCAL.REF)<1,POS.MIN.TIME>=Y.MIN.TIME

RETURN
*-------------------------------------------------------------
FUNDSTRANSFER:
*-------------------------------------------------------------
* if repayment is made through FT

    Y.ACCOUNT.ID=COMI
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACC,F.ACCOUNT,ERR.ACC)
    Y.ARRANGEMENT.ID=R.ACC<AC.ARRANGEMENT.ID>
    Y.VALUE.DATE=R.NEW(FT.CREDIT.VALUE.DATE)
    POS.INSTAL.AMT=LOC.REF.POS<1,1>
    POS.NEXT.PAY=LOC.REF.POS<1,2>
    POS.BILL.OVERDUE=LOC.REF.POS<1,3>
    POS.OVRDUE.AMT=LOC.REF.POS<1,4>
    POS.MAX.AMT=LOC.REF.POS<1,5>
    POS.MIN.AMT=LOC.REF.POS<1,6>
    POS.MAX.TIME=LOC.REF.POS<1,7>
    POS.MIN.TIME=LOC.REF.POS<1,8>
    R.ACCOUNT.DETAILS = ''; ACT.DET.ERR = ''
    CALL F.READ(FN.ACCOUNT.DETAILS,Y.ARRANGEMENT.ID,R.ACCOUNT.DETAILS,F.ACCOUNT.DETAILS,ACT.DET.ERR)
    GOSUB UPDATE.VERS.AA.ACCRAP
    R.NEW(FT.LOCAL.REF)<1,POS.BILL.OVERDUE> = FLG
    R.NEW(FT.LOCAL.REF)<1,POS.OVRDUE.AMT> = Y.FIN.AMT

* PACS00142802 - S
    GOSUB INSTALLMENT
    IF FLG EQ '' THEN
        R.NEW(FT.LOCAL.REF)<1,POS.INSTAL.AMT>= ''
        R.NEW(FT.LOCAL.REF)<1,POS.NEXT.PAY>= ''
    END ELSE
        R.NEW(FT.LOCAL.REF)<1,POS.INSTAL.AMT>= Y.TOTAL.DUE
        R.NEW(FT.LOCAL.REF)<1,POS.NEXT.PAY>= Y.NEXT.TOTAL.DUE
    END
* PACS00142802 -E

    GOSUB OVERPAYRULES
    R.NEW(FT.LOCAL.REF)<1,POS.MAX.AMT>=Y.MAX.AMOUNT
    R.NEW(FT.LOCAL.REF)<1,POS.MIN.AMT>=Y.MIN.AMOUNT
    R.NEW(FT.LOCAL.REF)<1,POS.MAX.TIME>=Y.MAX.TIME
    R.NEW(FT.LOCAL.REF)<1,POS.MIN.TIME>=Y.MIN.TIME

RETURN
*-------------------------------------------------------------
UPDATE.VERS.AA.ACCRAP:
*-------------------------------------------------------------
    Y.CNT = DCOUNT(R.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE>,@VM)
    YFIRST.BILLDTE = ''
    YFIRST.BILLDTE = R.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1>
    IF NOT(YFIRST.BILLDTE) THEN
        YFIRST.BILLDTE = TODAY
    END
    FLG.VAL = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG.VAL += 1
        Y.TYPE = R.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL>
        Y.CNT.TYPE = DCOUNT(Y.TYPE,@SM)
        IF Y.CNT.TYPE EQ 1 THEN
            GOSUB PR.ACCT.DET.PYMNT
        END ELSE
            GOSUB PROCESS.MANY.BILS
        END
* PACS00142802 -E

        Y.CNT -= 1
    REPEAT

RETURN
*-----------------
PR.ACCT.DET.PYMNT:
*-----------------

    IF R.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,1> EQ 'PAYMENT' THEN
        Y.BILL.ID = R.ACCOUNT.DETAILS<AA.AD.BILL.ID,FLG.VAL,1>
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
        Y.SETTLE.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
        GOSUB PROCESS.SETTLE.STATUS
    END
    IF R.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,1> EQ 'ACT.CHARGE' THEN
        FLG.PY += 1
    END
RETURN
*---------------------
PROCESS.SETTLE.STATUS:
*---------------------

    IF Y.SETTLE.STATUS EQ 'UNPAID' THEN
        Y.FIN.AMT += SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
        FLG += 1
    END ELSE
        FLG.PY += 1
    END

RETURN

PROCESS.MANY.BILS:

    FG.LG = ''
    LOOP
    WHILE Y.CNT.TYPE GT 0 DO
        FG.LG += 1

        IF R.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,FG.LG> EQ 'PAYMENT' THEN
            Y.BILL.ID = R.ACCOUNT.DETAILS<AA.AD.BILL.ID,FLG.VAL,FG.LG>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
            Y.SETTLE.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
            GOSUB PROCESS.SET.STATUS.UNP
        END
        IF R.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,FG.LG> EQ 'ACT.CHARGE' THEN
            Y.BILL.ID = R.ACCOUNT.DETAILS<AA.AD.BILL.ID,FLG.VAL,FG.LG>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)

            Y.PAY.DATE = R.AA.BILL.DETAILS<AA.BD.PAYMENT.DATE>
            IF Y.PAY.DATE NE Y.DUP.DATE THEN
                Y.DUP.DATE = Y.PAY.DATE
                FLG.PY += 1
            END
        END
        Y.CNT.TYPE -= 1
    REPEAT

* PACS00142802 -E

RETURN
*----------------------
PROCESS.SET.STATUS.UNP:
*----------------------

    IF Y.SETTLE.STATUS EQ 'UNPAID' THEN
        Y.FIN.AMT += SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
        FLG += 1
    END ELSE
        Y.PAY.DATE = R.AA.BILL.DETAILS<AA.BD.PAYMENT.DATE>
        IF Y.PAY.DATE NE Y.DUP.DATE THEN
            Y.DUP.DATE = Y.PAY.DATE
            FLG.PY += 1
        END
    END
RETURN

*-------------------------------------------------------------
INSTALLMENT:
*-------------------------------------------------------------


    PROP.CLASS="TERM.AMOUNT"; Y.TERM.AMOUNT = ''; Y.TERM.DATE = ''; CYCLE.DATE = ''
    APAP.TAM.redoCrrGetConditions(Y.ARRANGEMENT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)   ;*R22 MANUAL CODE CONVERSION
    CALL F.READ(FN.ARRANGEMENT,Y.ARRANGEMENT.ID,R.ARRANGEMENT,F.ARRANGEMENT,ARR.ERR)
    Y.ARR.VALUE.DATE=R.ARRANGEMENT<AA.ARR.START.DATE>
    Y.TERM.AMOUNT=R.Condition<AA.AMT.AMOUNT>
    Y.TERM.DATE=R.Condition<AA.AMT.MATURITY.DATE>
* FIX R15 20170802
    CYCLE.DATE = YFIRST.BILLDTE:@FM:Y.TERM.DATE

* To calculate the next payment amount
    CALL AA.SCHEDULE.PROJECTOR(Y.ARRANGEMENT.ID, SIM.REF, "",CYCLE.DATE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS, DUE.TYPE.AMTS, DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)
    Y.NO.OF.DATE=DCOUNT(DUE.DATES,@FM)
    VAR1=1
* PACS00142802 -S
    FLG.PY += 1
    Y.DUE.PROPS = DUE.PROPS<FLG.PY>
    Y.DUE.PROPS = CHANGE(Y.DUE.PROPS,@SM,@VM)

    Y.TOTAL.DUE = TOT.PAYMENT<FLG.PY>
    Y.NEXT.TOTAL.DUE = TOT.PAYMENT<FLG.PY+1>
* PACS00142802 -E

RETURN
*-------------------------------------------------------------
OVERPAYRULES:
*-------------------------------------------------------------
* To calculate the MIN & MAX amount and period for an arrangement

    MAX.AMT.POS=LOC.REF.POS<2,1>
    MIN.AMT.POS=LOC.REF.POS<2,2>
    MAX.TIME.POS=LOC.REF.POS<2,3>
    MIN.TIME.POS=LOC.REF.POS<2,4>
    Y.TERM.MAX.AMT=R.Condition<AA.AMT.LOCAL.REF,MAX.AMT.POS>
    Y.TERM.MIN.AMT=R.Condition<AA.AMT.LOCAL.REF,MIN.AMT.POS>
    Y.TERM.MAX.TIME=R.Condition<AA.AMT.LOCAL.REF,MAX.TIME.POS>
    Y.TERM.MIN.TIME=R.Condition<AA.AMT.LOCAL.REF,MIN.TIME.POS>

    CALL EB.NO.OF.MONTHS(Y.ARR.VALUE.DATE,Y.TERM.DATE,NO.OF.MONTHS)
    Y.MAX.TIME=(NO.OF.MONTHS*Y.TERM.MAX.TIME)/100
    Y.MIN.TIME=(NO.OF.MONTHS*Y.TERM.MIN.TIME)/100

    IF Y.TERM.MAX.AMT NE '' OR Y.TERM.MIN.AMT NE '' THEN
        Y.MAX.AMOUNT=(Y.TERM.MAX.AMT*Y.TERM.AMOUNT)/100
        Y.MIN.AMOUNT=(Y.TERM.MIN.AMT*Y.TERM.AMOUNT)/100
    END
    ELSE
        PROP.CLASS="PAYMENT.SCHEDULE"
        APAP.TAM.redoCrrGetConditions(Y.ARRANGEMENT.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.Condition,ERR.MSG)   ;*R22 MANUAL CODE CONVERSION
        MAX.AMT.POS1=LOC.REF.POS<3,1>
        MIN.AMT.POS1=LOC.REF.POS<3,2>
        Y.TERM.MAX.AMT=R.Condition<AA.PS.LOCAL.REF,MAX.AMT.POS1>
        Y.TERM.MIN.AMT=R.Condition<AA.PS.LOCAL.REF,MIN.AMT.POS1>
        IF Y.TERM.MAX.AMT NE '' OR Y.TERM.MIN.AMT NE '' THEN
            Y.MAX.AMOUNT=Y.TOTAL.DUE*Y.TERM.MAX.AMT
            Y.MIN.AMOUNT=Y.TOTAL.DUE*Y.TERM.MIN.AMT
        END
    END
RETURN
END
