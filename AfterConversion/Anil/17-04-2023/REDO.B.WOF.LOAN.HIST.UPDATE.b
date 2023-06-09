* @ValidationCode : MjotMjMzNzA4ODEyOkNwMTI1MjoxNjgxNzA4MjcyNDEzOklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 17 Apr 2023 10:41:12
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.WOF.LOAN.HIST.UPDATE(ARR.ID)
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.WOF.LOAN.HIST.UPDATE
*-----------------------------------------------------------------
* Description : This routine is used to update the outstanding and paid interest and principal amt
*               in the local table REDO.ACCT.MRKWOF.HIST.
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017   21-Nov-2011          Initial draft
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - FM TO @FM AND VM TO @VM AND SM TO @SM AND ++ TO += 1 AND VAR1- TO -= 
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
* ----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.WOF.LOAN.HIST.UPDATE.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.REDO.ACCT.MRKWOF.HIST
    $INSERT I_F.REDO.ACCT.MRKWOF.PARAMETER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.OVERDUE
    $INSERT I_F.REDO.AA.NAB.HISTORY
    $INSERT I_F.AA.SCHEDULED.ACTIVITY

MAIN:


    CALL F.READ(FN.REDO.AA.NAB.HISTORY,ARR.ID,R.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY,NA.ERR)
    IF NOT(R.REDO.AA.NAB.HISTORY) THEN
        GOSUB PROCESS
    END ELSE
        GOSUB PROC.NAB.WOF
    END
    GOSUB PGM.END

PROC.NAB.WOF:

    CALL F.READ(FN.REDO.ACCT.MRKWOF.HIST,ARR.ID,R.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST,WOF.ERR)

    Y.BISL = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.BILL.ID>
    Y.CN.BL = DCOUNT(Y.BISL,@VM); FLG.S = ''
    LOOP
    WHILE Y.CN.BL GT 0 DO
        FLG.S += 1
        R.REDO.ACCT.MRKWOF.HIST<REDO.WH.BILL.ID,FLG.S> = FIELD(R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.BILL.ID,FLG.S>,'-',1)
        R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.AMT,FLG.S> = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.INT.AMT,FLG.S>
        R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.PAID,FLG.S> = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.INT.PAID,FLG.S>
        R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.BALANCE,FLG.S> = R.REDO.AA.NAB.HISTORY<REDO.NAB.HIST.INT.BALANCE,FLG.S>
        Y.CN.BL -= 1
    REPEAT

    CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARR,F.AA.ARRANGEMENT,AA.ERR)
    Y.AC.ID = R.AA.ARR<AA.ARR.LINKED.APPL.ID>

    GOSUB GET.OUTS.PRIN

    CALL F.WRITE(FN.REDO.ACCT.MRKWOF.HIST,ARR.ID,R.REDO.ACCT.MRKWOF.HIST)

RETURN

GET.ACCRUED.INTEREST:

    BAL.TYPES = 'ACCPRINCIPALINT'
    START.DATE = TODAY ; END.DATE = '' ; SYSTEM.DATE = ''
    REQUEST.TYPE    = ''
    REQUEST.TYPE<4>  = 'ECB'
    BAL.DETAILS = ''
    CALL AA.GET.PERIOD.BALANCES(Y.AC.ID, BAL.TYPES, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERROR.MESSAGE)
    Y.TOT.ACC.AMT = ABS(BAL.DETAILS<4>)

    BAL.TYPES = 'ACCPRINCIPALINTSP'
    START.DATE = TODAY ; END.DATE = '' ; SYSTEM.DATE = ''
    REQUEST.TYPE    = ''
    REQUEST.TYPE<4>  = 'ECB'
    BAL.DETAILS = ''
    CALL AA.GET.PERIOD.BALANCES(Y.AC.ID, BAL.TYPES, REQUEST.TYPE, START.DATE, END.DATE, SYSTEM.DATE, BAL.DETAILS, ERROR.MESSAGE)

    Y.TOT.ACC.AMT.SP = ABS(BAL.DETAILS<4>)

    Y.TOT.ACC.AMT -= Y.TOT.ACC.AMT.SP

    CALL F.READ(FN.AA.SCH.ACT,ARR.ID,R.AA.SCH.ACT,F.AA.SCH.ACT,SCH.ERR)

    FINDSTR 'LENDING-MAKEDUE-REPAYMENT.SCHEDULE' IN R.AA.SCH.ACT<AA.SCH.ACTIVITY.NAME,1> SETTING POS.NEX THEN
        Y.NEX.BL.DATE = R.AA.SCH.ACT<AA.SCH.NEXT.DATE,POS.NEX>
    END ELSE
        Y.NEX.BL.DATE = BAL.DETAILS<1>
    END
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.ACC.INT.AMT> = Y.TOT.ACC.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.ACC.INT.DATE> = Y.NEX.BL.DATE
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.ACC.INT.YN> = 'NO'

RETURN

PROCESS:

    Y.OR.AC.AMT = '' ; Y.OR.AC.AMT = ''; Y.OS.PI.AMT = ''; Y.OR.PI.AMT = '' ; RE.PRIN.AMT = ''; RE.IN.AMT = ''
    CALL F.READ(FN.REDO.ACCT.MRKWOF.HIST,ARR.ID,R.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST,WOF.ERR)
    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACC,F.AA.ACCOUNT.DETAILS,AA.ACC.ERR)
    Y.BILL.IDS = R.AA.ACC<AA.AD.BILL.ID>
    Y.BILL.IDS = CHANGE(Y.BILL.IDS,@VM,@FM)
    Y.BILL.IDS = CHANGE(Y.BILL.IDS,@SM,@FM)
    Y.CNT = DCOUNT(Y.BILL.IDS,@FM)
    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.BILL = Y.BILL.IDS<FLG>
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BILL,R.AA.BILL,F.AA.BILL.DETAILS,BILL.ERR)
        IF R.AA.BILL<AA.BD.PAYMENT.DATE> LE R.REDO.ACCT.MRKWOF.HIST<REDO.WH.WOF.CHANGE.DATE> THEN
            IF R.AA.BILL<AA.BD.SETTLE.STATUS,1> EQ 'UNPAID' THEN
                IF R.AA.BILL<AA.BD.BILL.TYPE,1> EQ 'PAYMENT' THEN
                    GOSUB CAPITAL.UPDATE
                    GOSUB INTEREST.UPDATE
                    GOSUB HIS.UPDATE
                    Y.OR.AC.AMT = '' ; Y.OR.AC.AMT = ''; Y.OS.PI.AMT = ''; Y.OR.PI.AMT = '' ; RE.PRIN.AMT = ''; RE.IN.AMT = ''
                END
            END ELSE
                GOSUB SETTLE.BILLS
                Y.OR.AC.AMT = '' ; Y.OR.AC.AMT = ''; Y.OS.PI.AMT = ''; Y.OR.PI.AMT = '' ; RE.PRIN.AMT = ''; RE.IN.AMT = ''
            END
        END
        Y.CNT -= 1
    REPEAT

    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.OS.INT> = Y.TOT.OS.PI
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.OS.PRINCIPAL> = Y.TOT.OS.AC
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.TOT.INT.PAID> = Y.TOT.PAID.PI
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.TOT.PRINCIPAL.PAID> = Y.TOT.PAID.AC

    CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARR,F.AA.ARRANGEMENT,AA.ERR)
    Y.AC.ID = R.AA.ARR<AA.ARR.LINKED.APPL.ID>

    GOSUB GET.OUTS.PRIN

    IF R.REDO.ACCT.MRKWOF.HIST<REDO.WH.ACC.INT.YN> EQ 'YES' THEN
        GOSUB GET.ACCRUED.INTEREST
    END

    CALL F.WRITE(FN.REDO.ACCT.MRKWOF.HIST,ARR.ID,R.REDO.ACCT.MRKWOF.HIST)

RETURN

GET.OUTS.PRIN:

    GOSUB GET.OVERDUE.STATUS

    Y.ACCOUNT.PROPERTY = ''
    OUT.ERR = ''
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)

    BALANCE.TYPE = Y.OVERDUE.STATUS:@FM:'DUE':@FM:'CUR'
    Y.BAL.PROPERTY = Y.ACCOUNT.PROPERTY

    GOSUB GET.OUTSTANDING

    Y.PRINCIPAL.BAL = Y.BALANCE.AMOUNT

    BALANCE.TYPE = 'UNC'
    Y.BAL.PROPERTY = Y.ACCOUNT.PROPERTY
    GOSUB GET.OUTSTANDING
    Y.PRINCIPLE.UNC = Y.BALANCE.AMOUNT
    Y.PRINCIPAL.BAL -= Y.PRINCIPLE.UNC

    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.OUT.AMT.REP> = Y.PRINCIPAL.BAL

RETURN

GET.OVERDUE.STATUS:

    EFF.DATE = ''
    PROP.CLASS='OVERDUE'
    PROPERTY = ''
    R.CONDITION.OVERDUE = ''
    ERR.MSG = ''
    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION.OVERDUE,ERR.MSG)
    Y.BILL.TYPE = R.CONDITION.OVERDUE<AA.OD.BILL.TYPE>
    LOCATE 'PAYMENT' IN Y.BILL.TYPE<1,1> SETTING YPOSN THEN
        Y.OVERDUE.STATUS = R.CONDITION.OVERDUE<AA.OD.OVERDUE.STATUS,YPOSN>
    END
*  CHANGE VM TO FM IN Y.OVERDUE.STATUS
    CHANGE @SM TO @FM IN Y.OVERDUE.STATUS

RETURN

GET.OUTSTANDING:

    Y.BALANCE.AMOUNT = 0
    Y.BALANCE.CNT = DCOUNT(BALANCE.TYPE,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.BALANCE.CNT

        BALANCE.TO.CHECK = BALANCE.TYPE<Y.VAR1>:Y.BAL.PROPERTY
        EFFECTIVE.DATE   = TODAY
        DATE.OPTIONS     = ''
* Start--Changed on 29/09/2016 for upgrade
        DATE.OPTIONS<4>='ECB'
*    DATE.OPTIONS<2>  = 'ALL'
* End--Changed on 29/09/2016 for upgrade
        BALANCE.AMOUNT   = ""
        CALL AA.GET.PERIOD.BALANCES(Y.AC.ID, BALANCE.TO.CHECK, DATE.OPTIONS, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
        Y.BALANCE.AMOUNT += BAL.DETAILS<4>
        Y.VAR1 += 1
    REPEAT
    Y.BALANCE.AMOUNT = ABS(Y.BALANCE.AMOUNT)

RETURN

CAPITAL.UPDATE:

    LOCATE 'ACCOUNT' IN R.AA.BILL<AA.BD.PROPERTY,1> SETTING PROP.POS THEN
        Y.OS.AC.AMT = R.AA.BILL<AA.BD.OS.PROP.AMOUNT,PROP.POS>
        Y.OR.AC.AMT = R.AA.BILL<AA.BD.OR.PROP.AMOUNT,PROP.POS>
        Y.TOT.OS.AC += Y.OS.AC.AMT
        Y.REP.REF = R.AA.BILL<AA.BD.REPAY.REF,PROP.POS>
        IF Y.REP.REF THEN
            GOSUB FIND.WOF.DATE.AMT.PR
            Y.TOT.PAID.AC += RE.PRIN.AMT
        END
    END

RETURN


INTEREST.UPDATE:

    LOCATE 'PRINCIPALINT' IN R.AA.BILL<AA.BD.PROPERTY,1> SETTING PROP2.POS THEN
        Y.OS.PI.AMT = R.AA.BILL<AA.BD.OS.PROP.AMOUNT,PROP2.POS>
        Y.OR.PI.AMT = R.AA.BILL<AA.BD.OR.PROP.AMOUNT,PROP2.POS>
        Y.TOT.OS.PI += Y.OS.PI.AMT
        Y.IN.REP.REF = R.AA.BILL<AA.BD.REPAY.REF,PROP2.POS>
        IF Y.IN.REP.REF THEN
            GOSUB FIND.WOF.DATE.AMT.IN
            Y.TOT.PAID.PI += RE.IN.AMT
        END
    END

RETURN

HIS.UPDATE:

    IF R.REDO.ACCT.MRKWOF.HIST<REDO.WH.BILL.ID> NE '' THEN
        LOCATE Y.BILL IN R.REDO.ACCT.MRKWOF.HIST<REDO.WH.BILL.ID,1> SETTING POS.BL THEN
            R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.PAID,POS.BL> = RE.IN.AMT
            R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.PAID,POS.BL> = RE.PRIN.AMT
            R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.BALANCE,POS.BL> = Y.OS.PI.AMT
            R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.BAL,POS.BL> = Y.OS.AC.AMT
        END ELSE
            Y.BL.CNT = ''
            Y.BL.CNT = DCOUNT(R.REDO.ACCT.MRKWOF.HIST<REDO.WH.BILL.ID>,@VM)
            GOSUB UPDATE.HIST.TAB.OLD
        END
    END ELSE
        GOSUB UPDATE.HIST.TAB
    END

RETURN

SETTLE.BILLS:

    IF R.AA.BILL<AA.BD.SETTLE.STATUS,1> EQ 'REPAID' THEN
        IF R.AA.BILL<AA.BD.BILL.TYPE,1> EQ 'PAYMENT' THEN
            LOCATE 'ACCOUNT' IN R.AA.BILL<AA.BD.PROPERTY,1> SETTING PROP.POS THEN
                Y.OS.AC.AMT = R.AA.BILL<AA.BD.OS.PROP.AMOUNT,PROP.POS>
                Y.OR.AC.AMT = R.AA.BILL<AA.BD.OR.PROP.AMOUNT,PROP.POS>
                Y.REP.REF = R.AA.BILL<AA.BD.REPAY.REF,PROP.POS>
                Y.TOT.OS.AC += Y.OS.AC.AMT
                GOSUB FIND.WOF.DATE.AMT.PR
                Y.TOT.PAID.AC += RE.PRIN.AMT
            END
            LOCATE 'PRINCIPALINT' IN R.AA.BILL<AA.BD.PROPERTY,1> SETTING PROP2.POS THEN
                Y.OS.PI.AMT = R.AA.BILL<AA.BD.OS.PROP.AMOUNT,PROP2.POS>
                Y.OR.PI.AMT = R.AA.BILL<AA.BD.OR.PROP.AMOUNT,PROP2.POS>
                Y.TOT.OS.PI += Y.OS.PI.AMT
                Y.IN.REP.REF = R.AA.BILL<AA.BD.REPAY.REF,PROP2.POS>
                GOSUB FIND.WOF.DATE.AMT.IN
                Y.TOT.PAID.PI += RE.IN.AMT
            END
            LOCATE Y.BILL IN R.REDO.ACCT.MRKWOF.HIST<REDO.WH.BILL.ID,1> SETTING POS.RP THEN
                R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.PAID,POS.RP> = RE.IN.AMT
                R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.PAID,POS.RP> = RE.PRIN.AMT
                R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.BALANCE,POS.RP> = Y.OS.PI.AMT
                R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.BAL,POS.RP> = Y.OS.AC.AMT
            END ELSE
                Y.BL.CNT = ''
                Y.BL.CNT = DCOUNT(R.REDO.ACCT.MRKWOF.HIST<REDO.WH.BILL.ID>,@VM)
                GOSUB UPDATE.HIST.TAB.OLD
            END
        END
    END

RETURN

FIND.WOF.DATE.AMT.PR:

    Y.CNT.REP = '' ; FLG.RE = ''
    Y.CNT.REP = DCOUNT(Y.REP.REF,@SM)
    LOOP
    WHILE Y.CNT.REP GT 0 DO
        FLG.RE += 1
        Y.RE.REP.REF = R.AA.BILL<AA.BD.REPAY.REF,PROP.POS,FLG.RE>
        Y.RE.DATE = FIELD(Y.RE.REP.REF,'-',2)
        IF NUM(Y.RE.DATE) THEN
            IF Y.RE.DATE GE R.REDO.ACCT.MRKWOF.HIST<REDO.WH.WOF.CHANGE.DATE> THEN
                RE.PRIN.AMT += R.AA.BILL<AA.BD.REPAY.AMOUNT,PROP.POS,FLG.RE>
            END
        END
        Y.CNT.REP -= 1
    REPEAT

RETURN

FIND.WOF.DATE.AMT.IN:

    Y.CNT.REP = '' ; FLG.RE = ''
    Y.CNT.REP = DCOUNT(Y.IN.REP.REF,@SM)
    LOOP
    WHILE Y.CNT.REP GT 0 DO
        FLG.RE += 1
        Y.RE.REP.REF = R.AA.BILL<AA.BD.REPAY.REF,PROP2.POS,FLG.RE>
        Y.RE.DATE = FIELD(Y.RE.REP.REF,'-',2)
        IF NUM(Y.RE.DATE) THEN
            IF Y.RE.DATE GE R.REDO.ACCT.MRKWOF.HIST<REDO.WH.WOF.CHANGE.DATE> THEN
                RE.IN.AMT += R.AA.BILL<AA.BD.REPAY.AMOUNT,PROP2.POS,FLG.RE>
            END
        END
        Y.CNT.REP -= 1
    REPEAT

RETURN

UPDATE.HIST.TAB.OLD:

    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.BILL.ID,Y.BL.CNT+1> = Y.BILL
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.AMT,Y.BL.CNT+1> = Y.OR.PI.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.BALANCE,Y.BL.CNT+1> = Y.OS.PI.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.AMT,Y.BL.CNT+1> = Y.OR.AC.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.BAL,Y.BL.CNT+1> = Y.OS.AC.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.PAID,Y.BL.CNT+1> = RE.IN.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.PAID,Y.BL.CNT+1> = RE.PRIN.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PAYMENT.DATE,Y.BL.CNT+1> = R.AA.BILL<AA.BD.PAYMENT.DATE>

RETURN

UPDATE.HIST.TAB:

    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.BILL.ID> = Y.BILL
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.AMT> = Y.OR.PI.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.BALANCE> = Y.OS.PI.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.AMT> = Y.OR.AC.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.BAL> = Y.OS.AC.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.INT.PAID> = RE.IN.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PRINCIPAL.PAID> = RE.PRIN.AMT
    R.REDO.ACCT.MRKWOF.HIST<REDO.WH.PAYMENT.DATE> = R.AA.BILL<AA.BD.PAYMENT.DATE>

RETURN

PGM.END:

END
