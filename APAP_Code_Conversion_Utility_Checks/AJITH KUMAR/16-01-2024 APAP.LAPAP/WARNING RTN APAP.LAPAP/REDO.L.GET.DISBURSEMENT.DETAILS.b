* @ValidationCode : MjotMTkwODEzOTMzMDpDcDEyNTI6MTcwNTM4NTYwNzMxNDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 Jan 2024 11:43:27
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
$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                         DESCRIPTION
*02/05/2023      CONVERSION TOOL            AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, SM TO @SM,++ TO +=
*02/05/2023      SURESH                     MANUAL R22 CODE CONVERSION       CALL routine format modified
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.L.GET.DISBURSEMENT.DETAILS(Y.IDS.DETAILS,R.DISB.DETAILS,Y.COMMITED.AMT,Y.PEND.DISB)
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
*------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
 *   $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.TERM.AMOUNT
 *   $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
  *  $INSERT I_F.AA.ACTIVITY.HISTORY
   * $INSERT I_AA.ID.COMPONENT
   $USING AA.Framework

    $USING APAP.TAM
    $USING APAP.AA

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

    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT  = ''
    CALL OPF(FN.AA.ARR.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT)

RETURN
*------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------

    ARR.ID      = Y.IDS.DETAILS<1>
    Y.INDICATOR = Y.IDS.DETAILS<2>

    IF ARR.ID ELSE
        RETURN
    END
  *  CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,ARR.ERR)
    R.AA.ARRANGEMENT=AA.Framework.Arrangement.Read(ARR.ID, ARR.ERR)
    GOSUB GET.TERM.AMOUNT.PROP
    GOSUB GET.ACCOUNT.NO
    BALANCE.TO.CHECK = 'CUR':TERM.AMOUNT.PROPERTY
    GOSUB GET.BALANCE
    Y.CURCOMMIT.AMT  = Y.AMOUNT
    BALANCE.TO.CHECK = 'TOT':TERM.AMOUNT.PROPERTY
    GOSUB GET.BALANCE
    Y.TOTCOMMIT.AMT  = Y.AMOUNT
    IF Y.TOTCOMMIT.AMT ELSE   ;* Incase of migrated loans which are fully disbursed in legacy. For partially disb loan in legacy then we will have value in tot&cur commitment bal type.
        GOSUB GET.TOT.COMMITMENT
    END
    Y.PEND.DISB      = Y.CURCOMMIT.AMT  ;* Pending amount to disburse.
    Y.COMMITED.AMT   = Y.TOTCOMMIT.AMT  ;* Total Commitment amount.
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
    APAP.TAM.redoGetPropertyName(ARR.ID,IN.PROPERTY.CLASS,R.OUT.AA.RECORD,TERM.AMOUNT.PROPERTY,OUT.ERR) ;*MANUAL R22 CODE CONVERSION

RETURN
*------------------------------------------------------------------------------------------------
GET.ACCOUNT.NO:
*------------------------------------------------------------------------------------------------
* Here we get the account no. of that arrangement.

    IN.ACC.ID = ''
    OUT.ID    = ''
    APAP.TAM.redoConvertAccount(IN.ACC.ID,ARR.ID,OUT.ID,ERR.TEXT) ;*MANUAL R22 CODE CONVERSION
    Y.ARR.ACC.ID = OUT.ID

RETURN
*------------------------------------------------------------------------------------------------
GET.BALANCE:
*------------------------------------------------------------------------------------------------

    Y.TODAY    = TODAY
    CUR.AMOUNT = ''
*    CALL AA.GET.ECB.BALANCE.AMOUNT(Y.ARR.ACC.ID,BALANCE.TO.CHECK,Y.TODAY,CUR.AMOUNT,RET.ERROR)
AA.Framework.GetEcbBalanceAmount(Y.ARR.ACC.ID,BALANCE.TO.CHECK,Y.TODAY,CUR.AMOUNT,RET.ERROR);* R22 UTILITY AUTO CONVERSION
    Y.AMOUNT = ABS(CUR.AMOUNT)

RETURN
*------------------------------------------------------------------------------------------------
GET.DISB.DETAILS:
*------------------------------------------------------------------------------------------------

    Y.DISB.ACTIVITY = 'LENDING-DISBURSE-':TERM.AMOUNT.PROPERTY
    REQD.MODE = ''; EFF.DATE = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrStartDate>; R.AA.ACTIVITY.HISTORY = ''
*    CALL AA.READ.ACTIVITY.HISTORY(ARR.ID, REQD.MODE, EFF.DATE, R.AA.ACTIVITY.HISTORY)
AA.Framework.ReadActivityHistory(ARR.ID, REQD.MODE, EFF.DATE, R.AA.ACTIVITY.HISTORY);* R22 UTILITY AUTO CONVERSION
    Y.EFFECTIVE.DATES = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhEffectiveDate >
    Y.EFF.CNT  = DCOUNT(Y.EFFECTIVE.DATES,@VM) ;*AUTO R22 CODE CONVERSION
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.EFF.CNT
        Y.ACTIVITIES = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhActivity ,Y.VAR1>
        CHANGE @SM TO @FM IN Y.ACTIVITIES       ;*AUTO R22 CODE CONVERSION
        Y.ACT.CNT    = DCOUNT(Y.ACTIVITIES,@FM) ;*AUTO R22 CODE CONVERSION
        Y.VAR2 = 1
        LOOP
        WHILE Y.VAR2 LE Y.ACT.CNT
            LOCATE Y.DISB.ACTIVITY IN Y.ACTIVITIES,Y.VAR2 SETTING POS1 THEN
                Y.AAA.ID = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhActivityRef,Y.VAR1,POS1>
                CALL F.READ(FN.AAA,Y.AAA.ID,R.AAA,F.AAA,AAA.ERR)
                IF R.AAA THEN
                    R.DISB.DETAILS<1,-1> = R.AAA<AA.Framework.SimulationCapture.ArrActEffectiveDate >
                    R.DISB.DETAILS<2,-1> = R.AAA<AA.Framework.SimulationCapture.ArrActTxnAmount>
                    R.DISB.DETAILS<5,-1> = Y.AAA.ID:"*":R.AAA<AA.Framework.ArrangementActivity.ArrActTxnContractId>
                END
                Y.VAR2 = POS1+1
            END ELSE
                Y.VAR2 = Y.ACT.CNT+1
            END

        REPEAT
        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

    IF R.AA.ARRANGEMENT< AA.Framework.ArrangementSim.ArrOrigContractDate> THEN     ;*This gosub to handle, Migrated loan with current status.
        BALANCE.INFO   = "CUR"
        START.DATE     = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrStartDate>
        END.DATE       = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrStartDate>
        AMOUNT.TYPE = "ADJUST"
        SUB.TYPE = ''

        CALL AA.GET.BALANCE.ADJUSTMENT.AMOUNT(ARR.ID, TERM.AMOUNT.PROPERTY, BALANCE.INFO, START.DATE, END.DATE, AMOUNT.TYPE, '', ADJUSTMENT.DETAILS, REPAYMENT.DETAILS, RET.ERROR)

        IF ABS(REPAYMENT.DETAILS<2>) THEN
            INS START.DATE BEFORE R.DISB.DETAILS<1,1>
            INS ABS(REPAYMENT.DETAILS<2>) BEFORE R.DISB.DETAILS<2,1>
            R.DISB.DETAILS<4>    = 'MIGRATE'
            INS 'MIGRATE' BEFORE R.DISB.DETAILS<5,1>
        END

    END
    IF R.AA.ARRANGEMENT< AA.Framework.ArrangementSim.ArrOrigContractDate>  AND R.DISB.DETAILS EQ '' THEN         ;* Migrated loan with expired status. because commitment balances will not be adjusted for expired loans.
        Y.TAKEOVER.ACTIVITY = 'LENDING-TAKEOVER-ARRANGEMENT'
        FINDSTR Y.TAKEOVER.ACTIVITY IN R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhActivity> SETTING POS.AF,POS.AV,POS.AS THEN
            Y.TAKEOVER.EFF = R.AA.ACTIVITY.HISTORY<AA.Framework.ActivityHistoryHist.AhEffectiveDate,POS.AV>
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


    Y.START.DATE = R.AA.ARRANGEMENT< AA.Framework.ArrangementSim.ArrStartDate>
    Y.ORIG.DATE  = R.AA.ARRANGEMENT<AA.Framework.ArrangementSim.ArrOrigContractDate>

    EFF.DATE         = Y.START.DATE
    PROP.CLASS       = 'TERM.AMOUNT'
    PROPERTY         = ''
    R.TERM.CONDITION = ''
    ERR.MSG          = ''
    APAP.AA.redoCrrGetConditions(ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.TERM.CONDITION,ERR.MSG) ;*MANUAL R22 CODE CONVERSION
    Y.TOTCOMMIT.AMT  = R.TERM.CONDITION<AA.AMT.AMOUNT>

    IF Y.TOTCOMMIT.AMT ELSE   ;* For migrated contracts which are expired in legacy. then we will takeover with amount as 0. then we will do amend history with original contract date.

        OPTION                           = "PREVIOUS.DATE"  ;*
        PROPERTY.CLASS                   = "TERM.AMOUNT"
        ARR.PROPERTY.ID                  = ""
        ARR.PROPERTY.ID<AA.Framework.IdcArrNo>   = ARR.ID
        ARR.PROPERTY.ID<AA.Framework.IdcProperty> = TERM.AMOUNT.PROPERTY
        ARR.PROPERTY.ID<AA.Framework.IdcEffDate > = Y.ORIG.DATE
        EFFECTIVE.DATE                   = Y.ORIG.DATE
       * CALL AA.GET.PREVIOUS.PROPERTY.RECORD(OPTION, PROPERTY.CLASS, ARR.PROPERTY.ID, EFFECTIVE.DATE, R.PROPERTY, RET.ERROR)
  * ARR.PROPERTY.ID=AA.Framework.GetPreviousPropertyRecord( R.PROPERTY,RET.ERROR)
   R.PROPERTY=AA.Framework.GetPreviousPropertyRecord(Option, Propertyclass, ArrPropertyId, EffectiveDate, RProperty, RetError)
       * AA.Framework.GetPreviousPropertyRecord(Option, Propertyclass, ArrPropertyId, EffectiveDate, RProperty, RetError)
        Y.TOTCOMMIT.AMT =  R.PROPERTY<AA.AMT.AMOUNT>
        
    END

    IF NOT(Y.TOTCOMMIT.AMT) THEN
        TERM.AMT.ID = ARR.ID:'-COMMITMENT-':Y.ORIG.DATE:'.1'
        AA.ARR.TERM.AMOUNT.ERR = ''; R.AA.TERM.AMOUNT = ''
        CALL F.READ(FN.AA.ARR.TERM.AMOUNT,TERM.AMT.ID,R.AA.TERM.AMOUNT,F.AA.ARR.TERM.AMOUNT,AA.ARR.TERM.AMOUNT.ERR)
        Y.TOTCOMMIT.AMT =  R.AA.TERM.AMOUNT<AA.AMT.AMOUNT>
    END
RETURN
END
