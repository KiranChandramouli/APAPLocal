* @ValidationCode : MjotMTI4NjQ1MDA2NDpDcDEyNTI6MTcwNDc5MTk2NDk1NDphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Jan 2024 14:49:24
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
SUBROUTINE L.APAP.COL.EXTRACT.CREDIT.READ(AA.ID,R.AA,R.ACT.HIST,R.PRINCIPALINT,R.MORAINT,R.AA.ACCOUNT.DETAILS)
*-----------------------------------------------------------------------------
* Name : REDO.COLLECTOR.EXTRACT.CREDIT.READ
*      : Allows to read files to use in REDO.COLLECTOR.EXTRACT.CREDIT routine
*
* @Parameters:
* ----------------------------------------------------------------------------
*                AA.ID                 (in)    Arrangement id
*                R.AA                  (out)   AA.ARRANGEMENT record
*                R.ACT.HIST            (out)   AA.ACTIVITY.HISTORY record
*                R.PRINCIPALINT        (out)   AA.INTEREST.ACCRUAL record for PRINCIPALINT
*                R.PENALTYINT          (out)   AA.INTEREST.ACCRUAL record for PENALTYINT
*                R.AA.ACCOUNT.DETAILS  (out)   AA.ACCOUNT.DETAILS record
* ----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     TAM.BP is Removed,FM ,VM to @FM,@VM
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*---------------------------------------------------------------------------------------	-
    $INSERT I_COMMON
    $INSERT I_EQUATE
  *  $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_L.APAP.COL.CUSTOMER.COMMON
    $INSERT I_REDO.COL.EXTRACT.CREDIT.COMMON
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM
   $USING AA.Framework
*
    GOSUB PROCESS
RETURN
* --------------------------------------------------------------------------------------------
PROCESS:
* --------------------------------------------------------------------------------------------
* Read Main Files

    CALL F.READ(FN.AA, AA.ID,R.AA, F.AA, YERR)
    IF YERR THEN
        E = yRecordNotFound : @FM : AA.ID : @VM : "F.AA.ARRANGEMENT"
        RETURN
    END

   * REQD.MODE = ''; EFF.DATE =R.AA<AA.ARR.START.DATE>; 
     REQD.MODE = ''; EFF.DATE =R.AA<AA.Framework.Arrangement.ArrStartDate>;*RAA MANUAL CONVERSION
    R.AA.ACTIVITY.HISTORY = ''
*    CALL AA.READ.ACTIVITY.HISTORY(AA.ID, REQD.MODE, EFF.DATE, R.ACT.HIST)
AA.Framework.ReadActivityHistory(AA.ID, REQD.MODE, EFF.DATE, R.ACT.HIST);* R22 UTILITY AUTO CONVERSION

    IF NOT(R.ACT.HIST) THEN
        E = yRecordNotFound : @FM : AA.ID : @VM : "F.AA.ACTIVITY.HISTORY"
        RETURN
    END

    Y.PRIN.INT.RATE.ID = AA.ID : "-PRINCIPALINT"
    R.PRINCIPALINT = ""
    CALL F.READ(FN.AA.INTEREST.ACCRUALS, Y.PRIN.INT.RATE.ID ,R.PRINCIPALINT, F.AA.INTEREST.ACCRUALS, YERR)

   * Y.PRODUCT.GROUP=R.AA<AA.ARR.PRODUCT.GROUP>
     Y.PRODUCT.GROUP=R.AA<AA.Framework.Arrangement.ArrProductGroup>

    CALL CACHE.READ(FN.REDO.APAP.PROPERTY.PARAM,Y.PRODUCT.GROUP,R.REDO.APAP.PROPERTY.PARAM,ERR)

    PROP.CLASS = ''
    PROP.NAME  = R.REDO.APAP.PROPERTY.PARAM<PROP.PARAM.PENALTY.ARREAR>
    returnConditions = ''
    RET.ERR = ''

*    CALL AA.GET.ARRANGEMENT.CONDITIONS(AA.ID,PROP.CLASS,PROP.NAME,'','',R.MORAINT,ERR.COND)
AA.Framework.GetArrangementConditions(AA.ID,PROP.CLASS,PROP.NAME,'','',R.MORAINT,ERR.COND);* R22 UTILITY AUTO CONVERSION

    CALL F.READ(FN.AA.DETAILS, AA.ID,R.AA.ACCOUNT.DETAILS, F.AA.DETAILS, YERR)
    IF YERR THEN
        E = yRecordNotFound : @FM : AA.ID : @VM : "F.AA.ACCOUNT.DETAILS"
    END

RETURN
* ------------------------------------------------------------------------------------
END
