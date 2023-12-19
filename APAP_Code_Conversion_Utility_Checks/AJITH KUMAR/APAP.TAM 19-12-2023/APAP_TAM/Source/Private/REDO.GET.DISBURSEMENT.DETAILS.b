* @ValidationCode : MjoxMDkxMDU3ODk1OkNwMTI1MjoxNzAyOTcwNDg0NjE2OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 12:51:24
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
SUBROUTINE REDO.GET.DISBURSEMENT.DETAILS(Y.IDS.DETAILS,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)
*------------------------------------------------------------------------------------------------
* Description: This is call routine which will return the disbursement details of the loans.
* Incoming  Argument:  Y.IDS.DETAILS<1>  -> Arrangement ID.
*                      Y.IDS.DETAILS<2>  -> Indicator to skip getting the disb date.
* Outcoming Argument:  R.DISB.DETAILS<1> -> Disbursement Date.
*                      R.DISB.DETAILS<2> -> Disbursement amount.
*                      R.DISB.DETAILS<3> -> Total Disb amount.
*                      R.DISB.DETAILS<4> -> Migration indicator.
*                      R.DISB.DETAILS<5> -> Disb reference i.e - AAA.REF*FT.ID or MIGRATE.
*                      Y.COMMITED.AMT    -> Total Commited Amount.
*                      Y.PEND.DISB       -> Pending Disb Amount.

** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_AA.ID.COMPONENT
    $USING APAP.AA
*$USING AA.Interest

    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------
INIT:
*------------------------------------------------------------------------------------------------
    R.DISB.DETAILS = ''
    Y.COMMITED.AMT = ''
    Y.PEND.DISB    = ''

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY  = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.AAA = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AAA  = ''
    CALL OPF(FN.AAA,F.AAA)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

*FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
*F.AA.ARR.TERM.AMOUNT  = ''
*CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

RETURN
*------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------

    ARR.ID      = Y.IDS.DETAILS<1>
    Y.INDICATOR = Y.IDS.DETAILS<2>

    IF ARR.ID ELSE
        RETURN
    END
    CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    GOSUB GET.TERM.AMOUNT.PROP
    GOSUB GET.ACCOUNT.NO
    BALANCE.TO.CHECK = 'CUR':TERM.AMOUNT.PROPERTY
    GOSUB GET.BALANCE
    Y.CURCOMMIT.AMT  = Y.AMOUNT
    BALANCE.TO.CHECK = 'TOT':TERM.AMOUNT.PROPERTY
    GOSUB GET.BALANCE
    Y.TOTCOMMIT.AMT  = Y.AMOUNT
    IF Y.TOTCOMMIT.AMT ELSE     ;* Incase of migrated loans which are fully disbursed in legacy. For partially disb loan in legacy then we will have value in tot&cur commitment bal type.
        GOSUB GET.TOT.COMMITMENT
    END
    Y.PEND.DISB      = Y.CURCOMMIT.AMT    ;* Pending amount to disburse.
    Y.COMMITED.AMT   = Y.TOTCOMMIT.AMT    ;* Total Commitment amount.
    Y.TOTAL.DISB.AMT = Y.TOTCOMMIT.AMT - Y.CURCOMMIT.AMT
    IF Y.INDICATOR EQ '' THEN
        GOSUB GET.DISB.DETAILS
    END
    R.DISB.DETAILS<3>   = Y.TOTAL.DISB.AMT
RETURN
*------------------------------------------------------------------------------------------------
GET.TERM.AMOUNT.PROP:
*------------------------------------------------------------------------------------------------
* Here we get the Term amount property for the loan

    IN.PROPERTY.CLASS         = 'TERM.AMOUNT'
    R.OUT.AA.RECORD           = ''
    TERM.AMOUNT.PROPERTY      = ''
*    CALL REDO.GET.PROPERTY.NAME(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,TERM.AMOUNT.PROPERTY,OUT.ERR)
    APAP.TAM.redoGetPropertyName(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,TERM.AMOUNT.PROPERTY,OUT.ERR) ;*R22 Manual Converison

RETURN
*------------------------------------------------------------------------------------------------
GET.ACCOUNT.NO:
*------------------------------------------------------------------------------------------------
* Here we get the account no. of that arrangement.

    IN.ACC.ID = ''
    OUT.ID    = ''
*   CALL REDO.CONVERT.ACCOUNT(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT)
    APAP.TAM.redoConvertAccount(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT) ;*R22 Manual Conversion
    Y.ARR.ACC.ID = OUT.ID

RETURN
*------------------------------------------------------------------------------------------------
GET.BALANCE:
*------------------------------------------------------------------------------------------------

    Y.TODAY    = TODAY
    CUR.AMOUNT = ''
    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ARR.ACC.ID,BALANCE.TO.CHECK,Y.TODAY,CUR.AMOUNT,RET.ERROR)
    Y.AMOUNT = ABS(CUR.AMOUNT)

RETURN
*------------------------------------------------------------------------------------------------
GET.DISB.DETAILS:
*------------------------------------------------------------------------------------------------

    Y.DISB.ACTIVITY = 'LENDING-DISBURSE-':TERM.AMOUNT.PROPERTY
    CALL F.READ(FN.AA.ACTIVITY.HISTORY,ARR.ID,R.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY,ACT.ERR)
    Y.EFFECTIVE.DATES = R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE>
    Y.EFF.CNT  = DCOUNT(Y.EFFECTIVE.DATES,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.EFF.CNT
        Y.ACTIVITIES = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY,Y.VAR1>
        CHANGE @SM TO @FM IN Y.ACTIVITIES
        Y.ACT.CNT    = DCOUNT(Y.ACTIVITIES,@FM)
        Y.VAR2 = 1
        LOOP
        WHILE Y.VAR2 LE Y.ACT.CNT
            LOCATE Y.DISB.ACTIVITY IN Y.ACTIVITIES,Y.VAR2 SETTING POS1 THEN
                Y.AAA.ID = R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY.REF,Y.VAR1,POS1>
                CALL F.READ(FN.AAA,Y.AAA.ID,R.AAA,F.AAA,AAA.ERR)
                IF R.AAA THEN
                    R.DISB.DETAILS<1,-1> = R.AAA<AA.ARR.ACT.EFFECTIVE.DATE>
                    R.DISB.DETAILS<2,-1> = R.AAA<AA.ARR.ACT.TXN.AMOUNT>
                    R.DISB.DETAILS<5,-1> = Y.AAA.ID:"*":R.AAA<AA.ARR.ACT.TXN.CONTRACT.ID>
                END
                Y.VAR2 = POS1+1
            END ELSE
                Y.VAR2 = Y.ACT.CNT+1
            END

        REPEAT
        Y.VAR1 += 1 ;* R22 Auto conversion
    REPEAT

    IF R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE> THEN       ;*This gosub to handle, Migrated loan with current status.
        BALANCE.INFO   = "CUR"
        START.DATE     = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
        END.DATE       = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
        AMOUNT.TYPE = "ADJUST"
        SUB.TYPE = ''

        CALL AA.GET.BALANCE.ADJUSTMENT.AMOUNT(ARR.ID, TERM.AMOUNT.PROPERTY, BALANCE.INFO, START.DATE, END.DATE, AMOUNT.TYPE, '', ADJUSTMENT.DETAILS, REPAYMENT.DETAILS, RET.ERROR)
* AA.Interest.GetBalanceAdjustmentAmount(ARR.ID, TERM.AMOUNT.PROPERTY, BALANCE.INFO, START.DATE, END.DATE, AMOUNT.TYPE, '', ADJUSTMENT.DETAILS, REPAYMENT.DETAILS, RET.ERROR)
        
        IF ABS(REPAYMENT.DETAILS<2>) THEN
            INS START.DATE BEFORE R.DISB.DETAILS<1,1>
            INS ABS(REPAYMENT.DETAILS<2>) BEFORE R.DISB.DETAILS<2,1>
            R.DISB.DETAILS<4>    = 'MIGRATE'
            INS 'MIGRATE' BEFORE R.DISB.DETAILS<5,1>
        END

    END
    IF R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE>  AND R.DISB.DETAILS EQ '' THEN ;* Migrated loan with expired status. because commitment balances will not be adjusted for expired loans.
        Y.TAKEOVER.ACTIVITY = 'LENDING-TAKEOVER-ARRANGEMENT'
        FINDSTR Y.TAKEOVER.ACTIVITY IN R.AA.ACTIVITY.HISTORY<AA.AH.ACTIVITY> SETTING POS.AF,POS.AV,POS.AS THEN
            Y.TAKEOVER.EFF = R.AA.ACTIVITY.HISTORY<AA.AH.EFFECTIVE.DATE,POS.AV>
            R.DISB.DETAILS<1,-1> = Y.TAKEOVER.EFF
            R.DISB.DETAILS<2,-1> = Y.TOTCOMMIT.AMT
            R.DISB.DETAILS<4>    = 'MIGRATE'
            R.DISB.DETAILS<5,-1> = 'MIGRATE'
        END
    END


RETURN
*---------------------------------------------------------
GET.TOT.COMMITMENT:
*---------------------------------------------------------
* For migrated loans,


    Y.START.DATE = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
    Y.ORIG.DATE  = R.AA.ARRANGEMENT<AA.ARR.ORIG.CONTRACT.DATE>

    EFF.DATE         = Y.START.DATE
    PROP.CLASS       = 'TERM.AMOUNT'
    PROPERTY         = ''
    R.TERM.CONDITION = ''
    ERR.MSG          = ''
*    CALL REDO.CRR.GET.CONDITIONS(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.TERM.CONDITION,ERR.MSG)
    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.TERM.CONDITION,ERR.MSG) ;*R22 Manual Conversion
    Y.TOTCOMMIT.AMT  = R.TERM.CONDITION<AA.AMT.AMOUNT>

    IF Y.TOTCOMMIT.AMT ELSE     ;* For migrated contracts which are expired in legacy. then we will takeover with amount as 0. then we will do amend history with original contract date.

        OPTION                           = "PREVIOUS.DATE"      ;*
        PROPERTY.CLASS                   = "TERM.AMOUNT"
        ARR.PROPERTY.ID                  = ""
        ARR.PROPERTY.ID<AA.IDC.ARR.NO>   = ARR.ID
        ARR.PROPERTY.ID<AA.IDC.PROPERTY> = TERM.AMOUNT.PROPERTY
        ARR.PROPERTY.ID<AA.IDC.EFF.DATE> = Y.START.DATE
        EFFECTIVE.DATE                   = Y.START.DATE
        CALL AA.GET.PREVIOUS.PROPERTY.RECORD(OPTION, PROPERTY.CLASS, ARR.PROPERTY.ID, EFFECTIVE.DATE, R.PROPERTY, RET.ERROR)
        Y.TOTCOMMIT.AMT =  R.PROPERTY<AA.AMT.AMOUNT>
    END

RETURN
END
