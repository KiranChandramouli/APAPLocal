SUBROUTINE REDO.AUTH.REV.DISB.REPAY
*---------------------------------------------------------------------------------
*Description: This routine is to reverse the FT's generated for AA disbursement
*             charge. If the disbursement charge FT is reversed then
*             we need to reverse the repayment charge FT and vice versa.
*---------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.H.AA.DIS.CHG

    GOSUB OPEN.FILES
    GOSUB PROCESS

RETURN
*---------------------------------------------------------------------------------
OPEN.FILES:
*---------------------------------------------------------------------------------

    FN.REDO.H.AA.DIS.CHG = 'F.REDO.H.AA.DIS.CHG'
    F.REDO.H.AA.DIS.CHG  = ''
    CALL OPF(FN.REDO.H.AA.DIS.CHG,F.REDO.H.AA.DIS.CHG)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY  = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AAA  = ''
    CALL OPF(FN.AAA,F.AAA)

    FN.AAA.NAU = 'F.AA.ARRANGEMENT.ACTIVITY$NAU'
    F.AAA.NAU  = ''
    CALL OPF(FN.AAA.NAU,F.AAA.NAU)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.ERROR.MSG = ''
    CALL CACHE.READ(FN.REDO.H.AA.DIS.CHG,'SYSTEM',R.REDO.H.AA.DIS.CHG,CHG.PARAM.ERR)
    Y.CHG.DISB.FTTC      = R.REDO.H.AA.DIS.CHG<REDO.DIS.CHG.DISB.CHG.FTTC>
    Y.CHG.REPAY.FTTC     = R.REDO.H.AA.DIS.CHG<REDO.DIS.CHG.REPAY.CHG.FTTC>
    Y.CHG.DISB.ACTIVITY  = R.REDO.H.AA.DIS.CHG<REDO.DIS.CHG.CHG.DISB.ACTIVITY>
    Y.CHG.REPAY.ACTIVITY = R.REDO.H.AA.DIS.CHG<REDO.DIS.CHG.CHG.REPAY.ACTIVITY>
    BEGIN CASE
        CASE R.NEW(FT.TRANSACTION.TYPE) MATCHES Y.CHG.DISB.FTTC
            GOSUB REVERSE.REPAY.FT

        CASE R.NEW(FT.TRANSACTION.TYPE) MATCHES Y.CHG.REPAY.FTTC
            GOSUB REVERSE.DISB.FT
        CASE OTHERWISE
            Y.ERROR.MSG = 'Neither Charge disbursement or repayment'
    END CASE

    IF Y.ERROR.MSG THEN
        TEXT = 'REDO.INTERNAL.MSG':@FM:Y.ERROR.MSG
        CALL STORE.OVERRIDE("")   ;* This override has been raised to capture the error log details.
*                                          Since this is AUTO override, doesnt require user intervention.
    END

RETURN
*---------------------------------------------------------------------------------
REVERSE.REPAY.FT:
*---------------------------------------------------------------------------------
* Reversal of the charge repayment will be done here.

    Y.ACC.ID = R.NEW(FT.DEBIT.ACCT.NO)
    Y.AA.ID  = ''
    CALL REDO.CONVERT.ACCOUNT(Y.ACC.ID,'',Y.AA.ID,ERR.TEXT)

    IF Y.AA.ID ELSE
        Y.ERROR.MSG := ' Arrangement id missing'
        RETURN
    END

    IF R.NEW(FT.DEBIT.AMOUNT) THEN
        Y.CHARGE.AMT = R.NEW(FT.DEBIT.AMOUNT)
    END ELSE
        Y.CHARGE.AMT = R.NEW(FT.CREDIT.AMOUNT)
    END
    Y.EFFECTIVE.DATE = R.NEW(FT.DEBIT.VALUE.DATE)

    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ACT.ERR)

    LOCATE Y.EFFECTIVE.DATE IN R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE,1> SETTING POS.EFF THEN
        Y.ACTIVITY.REF.IDS = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,POS.EFF>
        Y.ACTIVITY.IDS     = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY,POS.EFF>
        Y.ACTIVITY.STATUS  = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS,POS.EFF>
        GOSUB CHECK.ACTIVITY.REPAY
    END ELSE
        Y.ERROR.MSG := ' Eff date not located'
    END
RETURN
*---------------------------------------------------------------------------------
CHECK.ACTIVITY.REPAY:
*---------------------------------------------------------------------------------
    Y.OFS.FLAG = ''
    Y.ACT.CNT = DCOUNT(Y.ACTIVITY.IDS,@SM)
    Y.LOOP1   = 1
    LOOP
    WHILE Y.LOOP1 LE Y.ACT.CNT
        Y.ACTIVITY = Y.ACTIVITY.IDS<1,1,Y.LOOP1>
        Y.ACT.ID   = Y.ACTIVITY.REF.IDS<1,1,Y.LOOP1>
        IF Y.ACTIVITY MATCHES Y.CHG.REPAY.ACTIVITY THEN
            CALL F.READ(FN.AAA,Y.ACT.ID,R.AAA,F.AAA,AAA.ERR)
            IF R.AAA ELSE
                CALL F.READ(FN.AAA.NAU,Y.ACT.ID,R.AAA,F.AAA.NAU,AAA.NAU.ERR)
            END
            IF Y.CHARGE.AMT EQ R.AAA<AA.ARR.ACT.ORIG.TXN.AMT> AND R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID> EQ 'FT' THEN
                Y.REV.ID = R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>
                Y.OFS.FLAG = 'YES'
                GOSUB POST.OFS
                Y.LOOP1 = Y.ACT.CNT + 1         ;* Break
            END
        END
        Y.LOOP1 += 1
    REPEAT
    IF Y.OFS.FLAG EQ '' THEN
        Y.ERROR.MSG := ' OFS Not posted'
    END

RETURN
*---------------------------------------------------------------------------------
REVERSE.DISB.FT:
*---------------------------------------------------------------------------------

    Y.ACC.ID = R.NEW(FT.CREDIT.ACCT.NO)
    Y.AA.ID  = ''
    CALL REDO.CONVERT.ACCOUNT(Y.ACC.ID,'',Y.AA.ID,ERR.TEXT)
    IF Y.AA.ID ELSE
        Y.ERROR.MSG := ' Arrangement id missing'
        RETURN
    END

    IF R.NEW(FT.DEBIT.AMOUNT) THEN
        Y.CHARGE.AMT = R.NEW(FT.DEBIT.AMOUNT)
    END ELSE
        Y.CHARGE.AMT = R.NEW(FT.CREDIT.AMOUNT)
    END
    Y.EFFECTIVE.DATE = R.NEW(FT.CREDIT.VALUE.DATE)

    CALL F.READ(FN.AA.ACTIVITY.HISTORY,Y.AA.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ACT.ERR)

    LOCATE Y.EFFECTIVE.DATE IN R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE,1> SETTING POS.EFF THEN
        Y.ACTIVITY.REF.IDS = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,POS.EFF>
        Y.ACTIVITY.IDS     = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY,POS.EFF>
        Y.ACTIVITY.STATUS  = R.AA.ACTIVITY.HISTORY<AA.AH.ACT.STATUS,POS.EFF>
        GOSUB CHECK.ACTIVITY.DISB
    END ELSE
        Y.ERROR.MSG := ' Eff date not located'
    END

RETURN
*---------------------------------------------------------------------------------
CHECK.ACTIVITY.DISB:
*---------------------------------------------------------------------------------

    Y.OFS.FLAG = ''
    Y.ACT.CNT = DCOUNT(Y.ACTIVITY.IDS,@SM)
    Y.LOOP1   = 1
    LOOP
    WHILE Y.LOOP1 LE Y.ACT.CNT
        Y.ACTIVITY = Y.ACTIVITY.IDS<1,1,Y.LOOP1>
        Y.ACT.ID   = Y.ACTIVITY.REF.IDS<1,1,Y.LOOP1>
        IF Y.ACTIVITY MATCHES Y.CHG.DISB.ACTIVITY THEN
            CALL F.READ(FN.AAA,Y.ACT.ID,R.AAA,F.AAA,AAA.ERR)
            IF R.AAA ELSE
                CALL F.READ(FN.AAA.NAU,Y.ACT.ID,R.AAA,F.AAA.NAU,AAA.NAU.ERR)
            END
            IF Y.CHARGE.AMT EQ R.AAA<AA.ARR.ACT.ORIG.TXN.AMT> AND R.AAA<AA.ARR.ACT.TXN.SYSTEM.ID> EQ 'FT' THEN
                Y.REV.ID = R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>
                Y.OFS.FLAG = 'YES'
                GOSUB POST.OFS
                Y.LOOP1 = Y.ACT.CNT + 1         ;* Break

            END
        END
        Y.LOOP1 += 1
    REPEAT
    IF Y.OFS.FLAG EQ '' THEN
        Y.ERROR.MSG := ' OFS Not posted'
    END

RETURN
*---------------------------------------------------------------------------------
POST.OFS:
*---------------------------------------------------------------------------------
* Here we will post the required OFS messages.

    CALL F.READ(FN.FUNDS.TRANSFER,Y.REV.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FT.ERR)

    IF R.FUNDS.TRANSFER ELSE
        Y.REV.ID = Y.REV.ID:";1"  ;* String ';1' has been append to the id for history reversal.
    END

    APP.NAME        = 'FUNDS.TRANSFER'
    OFSFUNCTION     = 'R'
    PROCESS         = 'PROCESS'
    OFS.SOURCE.ID   = 'FT.CHG.DISB.DUM'
    OFSVERSION      = 'FUNDS.TRANSFER,CHG.REVERSE'
    GTSMODE         = ''
    NO.OF.AUTH      = 0
    TRANSACTION.ID  = ''
    OFSSTRING       = ''
    OFS.ERR         = ''
    R.FT            = ''
    GTS.MODE        = ''
    Y.GEN.USER.NAME = ''
    CALL OFS.BUILD.RECORD(APP.NAME,OFSFUNCTION,PROCESS,OFSVERSION,GTS.MODE,NO.OF.AUTH,Y.REV.ID,R.FT,OFSSTR)
    CALL OFS.POST.MESSAGE(OFSSTR,OFS.MSG.ID,OFS.SOURCE.ID,Y.GEN.USER.NAME)
    Y.ERROR.MSG := 'OFS posted Sucessfully':' - ':OFS.MSG.ID
RETURN
END
