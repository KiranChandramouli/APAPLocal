*-----------------------------------------------------------------------------
* <Rating>-97</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.V.VAL.ADV.CNT.PAY
*-------------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used as validation routine for the the local field L.ADV.INS.CNT
*-------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 10-08-2011        S.MARIMUTHU     PACS00074323         Initial Creation
* 14-10-2011        S.MARIMUTHU     PACS00142802
* 12-11-2011        S.MARIMUTHU     PACS00146864
* 05-03-2012        S.MARIMUTHU     PACS00170057
*-------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.VERSION
MAIN:

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PGM.END

OPENFILES:

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ACCOUNT.DETAILS.HIST = 'F.AA.ACCOUNT.DETAILS.HIST'
    F.AA.ACCOUNT.DETAILS.HIST = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS.HIST,F.AA.ACCOUNT.DETAILS.HIST)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    APPLS = 'FUNDS.TRANSFER':FM:'AA.PRD.DES.TERM.AMOUNT'
    F.FIELDS = 'L.NO.OF.INSTAL':VM:'L.ADV.INS.CNT':VM:'L.AA.PART.ALLOW':FM:'L.AA.PART.PCNT':VM:'L.AA.PART.ALLOW'
    POS.VAL = ''
    CALL MULTI.GET.LOC.REF(APPLS,F.FIELDS,POS.VAL)
    POS.NO.INS = POS.VAL<1,1>
    POS.ADV.INS = POS.VAL<1,2>
    POS.FT.PART = POS.VAL<1,3>
    POS.PART.PERC = POS.VAL<2,1>
    POS.PART = POS.VAL<2,2>

    RETURN

PROCESS:


    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END

    Y.ADV.INS = COMI

    Y.NO.OF.INS = R.NEW(FT.LOCAL.REF)<1,POS.NO.INS>
    Y.DUP.NO.OF.INS = Y.NO.OF.INS

    VAR.AA.ID = R.NEW(FT.CREDIT.ACCT.NO)

    IF VAR.AA.ID[1,2] NE 'AA' THEN
        CALL F.READ(FN.ACCOUNT,VAR.AA.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        VAR.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
        Y.CUS = R.ACCOUNT<AC.CUSTOMER>
    END ELSE
        CALL F.READ(FN.AA.ARRANGEMENT,VAR.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARR.ERR)
        Y.CUS = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    END

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,AA.AC.ERR)
    
    CALL F.READ(FN.AA.ACCOUNT.DETAILS.HIST,VAR.AA.ID,R.AA.ACCOUNT.DETAILS.HIST,F.AA.ACCOUNT.DETAILS.HIST,AA.AC.ERR.HIST)
    IF R.AA.ACCOUNT.DETAILS.HIST THEN
        R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID, -1> = R.AA.ACCOUNT.DETAILS.HIST<AA.AD.BILL.ID>
        R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE, -1> = R.AA.ACCOUNT.DETAILS.HIST<AA.AD.BILL.PAY.DATE>
        R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE, -1> = R.AA.ACCOUNT.DETAILS.HIST<AA.AD.BILL.TYPE>
    END
    Y.TOT.BILS = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.TOT.BILS = CHANGE(Y.TOT.BILS,SM,VM)
    Y.CN.VM = DCOUNT(Y.TOT.BILS,VM)
    Y.CNT = DCOUNT(R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE>,VM)
    YFIRST.BILLDTE = ''
    YFIRST.BILLDTE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.PAY.DATE,1>
    IF NOT(YFIRST.BILLDTE) THEN
       YFIRST.BILLDTE = TODAY
    END

    FLG = '' ; FIN.CNT = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG.VAL += 1
        Y.TYPE = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL>
        Y.CNT.TYPE = DCOUNT(Y.TYPE,SM)
        IF Y.CNT.TYPE EQ 1 THEN
            GOSUB CHECK.PAYMENT
            IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,1> EQ 'ACT.CHARGE' THEN
                FIN.CNT += 1
            END
        END ELSE
            GOSUB PROCESS.MANY.BILS
        END
        Y.CNT -= 1
    REPEAT

    IF FLG NE '' AND Y.NO.OF.INS NE FLG AND Y.ADV.INS NE '' THEN
        AF = FT.LOCAL.REF
        AV = POS.ADV.INS
        ETEXT = 'EB-DUES.ARE.THERE'
        CALL STORE.END.ERROR
    END ELSE
        PROP.CLASS='TERM.AMOUNT'; YMAT.DATE = ''
        CALL REDO.CRR.GET.CONDITIONS(VAR.AA.ID,EFF.DATE,PROP.CLASS, PROPERTY,R.CONDITION,ERR.MSG)
        Y.PARTIAL = R.CONDITION<AA.AMT.LOCAL.REF,POS.PART.PERC>
        Y.PART.AA = R.CONDITION<AA.AMT.LOCAL.REF,POS.PART>
        Y.PART.VAL = R.NEW(FT.LOCAL.REF)<1,POS.FT.PART>
* FIX R15 20170801
        YMAT.DATE = R.CONDITION<AA.AMT.MATURITY.DATE>

        IF Y.NO.OF.INS NE FLG THEN
            AF = FT.LOCAL.REF
            AV = POS.NO.INS
            ETEXT = 'EB-INS.CNT.GT.INS'
            CALL STORE.END.ERROR
            R.NEW(FT.CREDIT.AMOUNT) = ''
        END

        GOSUB CALC.ADV.AMT
        R.NEW(FT.CREDIT.AMOUNT) = Y.FIN.AMT
        CALL System.setVariable("CURRENT.CRED.AMT",Y.FIN.AMT)
    END
*------ Group 12 ---
    IF R.VERSION(EB.VER.VERSION.TYPE) EQ 'NV' THEN
        Y.COMI = COMI
        Y.AF   = AF
        Y.AV   = AV
        Y.AS   = AS
        COMI = R.NEW(FT.CREDIT.AMOUNT)
        CALL REDO.VAL.MTS.AMOUNT.FT
        COMI  =     Y.COMI
        AF    =     Y.AF
        AV    =     Y.AV
        AS    =     Y.AS
    END
*------ Group 12 ---

    RETURN

CHECK.PAYMENT:

    IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,1> EQ 'PAYMENT' THEN
        Y.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,FLG.VAL,1>
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
        Y.SETTLE.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
        IF Y.SETTLE.STATUS EQ 'UNPAID' THEN
            Y.DUP.NO.OF.INS -= 1
            IF Y.DUP.NO.OF.INS GE 0 THEN
                Y.FIN.AMT += SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
            END
            FLG += 1
        END ELSE
            FIN.CNT += 1
        END
    END

    RETURN

PROCESS.MANY.BILS:

    FG.LG = ''
    LOOP
    WHILE Y.CNT.TYPE GT 0 DO
        FG.LG += 1

        IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,FG.LG> EQ 'PAYMENT' THEN
            Y.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,FLG.VAL,FG.LG>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)
            Y.SETTLE.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1>
            GOSUB CHECK.UNPAID
        END
        IF R.AA.ACCOUNT.DETAILS<AA.AD.BILL.TYPE,FLG.VAL,FG.LG> EQ 'ACT.CHARGE' THEN
            Y.BILL.ID = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID,FLG.VAL,FG.LG>
            CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BILL.ERR)

            Y.PAY.DATE = R.AA.BILL.DETAILS<AA.BD.PAYMENT.DATE>
            IF Y.PAY.DATE NE Y.DUP.DATE THEN
                Y.DUP.DATE = Y.PAY.DATE
                FIN.CNT += 1
            END
        END
        Y.CNT.TYPE -= 1
    REPEAT

    RETURN

CALC.ADV.AMT:

* PACS00142802 -S
    IF Y.ADV.INS EQ '' AND Y.PART.VAL EQ 'YES' THEN
        IF Y.PART.AA EQ 'YES' THEN
            IF R.AA.BILL.DETAILS<AA.BD.OR.TOTAL.AMOUNT> LT SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>) THEN
                Y.DUP.FIN.AMT = (SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)*Y.PARTIAL/100)
            END ELSE
                Y.DUP.FIN.AMT = (R.AA.BILL.DETAILS<AA.BD.OR.TOTAL.AMOUNT>*Y.PARTIAL/100)
            END
            IF Y.DUP.FIN.AMT LT SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>) THEN
                Y.FIN.AMT = Y.FIN.AMT - SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>) + Y.DUP.FIN.AMT
            END ELSE
                Y.FIN.AMT = Y.FIN.AMT
            END
        END ELSE
            AF = FT.LOCAL.REF
            AV = POS.FT.PART
            ETEXT = 'EB-PART.NOT.ALLOW'
            CALL STORE.END.ERROR
            Y.FIN.AMT = ''
        END
    END

    ARRANGEMENT.ID = VAR.AA.ID
* FIX R15 20170801
    DATE.RANGE = YFIRST.BILLDTE:FM:YMAT.DATE
* FIX R15 20170801
    CALL AA.SCHEDULE.PROJECTOR(ARRANGEMENT.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS,DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)

    IF Y.PART.VAL EQ 'YES' OR Y.PART.VAL EQ 'SI' THEN
        FLG.DUP = 0
        GOSUB CALC.SCH.AMT
    END ELSE
        FLG.DUP = 1 ; Y.ADV.INS = Y.ADV.INS + 1
        GOSUB CALC.SCH.AMT
    END
    Y.FIN.AMT += VAR.INSTALL.AMOUNT
    Y.FIN.AMT = FMT(Y.FIN.AMT,'R2')

    RETURN

CALC.SCH.AMT:


    FLG.PR = ''
    FLG.FIN = FIN.CNT + FLG
    LOOP
    WHILE Y.ADV.INS GT FLG.DUP DO
        FLG.FIN += 1
        Y.PROP = DUE.PROPS<FLG.FIN>
        Y.PROP = CHANGE(Y.PROP,SM,VM)
        IF 'ACCOUNT' MATCHES Y.PROP OR 'PRINCIPALINT' MATCHES Y.PROP OR 'PENALTYINT' MATCHES Y.PROP THEN
            IF Y.ADV.INS NE 1 AND Y.ADV.INS NE '' THEN
                VAR.INSTALL.AMOUNT += TOT.PAYMENT<FLG.FIN>
            END ELSE
                VAR.INSTALL.AMOUNT += (TOT.PAYMENT<FLG.FIN> * (Y.PARTIAL/100))
            END
        END ELSE
            Y.ADV.INS += 1
        END
        Y.ADV.INS -= 1
    REPEAT

    RETURN
* PACS00142802 -E

************
CHECK.UNPAID:
*************
    IF Y.SETTLE.STATUS EQ 'UNPAID' THEN
        Y.FIN.AMT += SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
        FLG += 1
    END ELSE
        Y.PAY.DATE = R.AA.BILL.DETAILS<AA.BD.PAYMENT.DATE>
        IF Y.PAY.DATE NE Y.DUP.DATE THEN
            Y.DUP.DATE = Y.PAY.DATE
            FIN.CNT += 1
        END
    END

    RETURN
*****************************
PGM.END:

END
