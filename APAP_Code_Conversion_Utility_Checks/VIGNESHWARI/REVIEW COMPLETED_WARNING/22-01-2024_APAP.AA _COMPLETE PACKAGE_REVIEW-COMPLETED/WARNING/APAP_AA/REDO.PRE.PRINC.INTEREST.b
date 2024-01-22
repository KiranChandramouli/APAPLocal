* @ValidationCode : MjoxMTI1MDk1OTAwOkNwMTI1MjoxNzA0NDM3OTkzNTkxOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Jan 2024 12:29:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
*-----------------------------------------------------------------------------
* <Rating>-70</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.PRE.PRINC.INTEREST
*-----------------------------------------------------------------------------


*DESCRIPTION:
*------------
* This Routine used as the Pre Routine for the activity LENDING-CHANGE-PRINCIPALINT
* * The sum of that values is assigned to old amount
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who            Reference            Description
* 01-JUL-2010    Kishore.SP     ODR-2009-10-0325      Initial Creation
* 12-Jun-2023  Santosh      Manual R22 conversion   New argument added in AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES
*05-01-2024     VIGNESHWARI     R22 MANUAL CODE CONVERSION    AA.FRAMWORK IS CHANGED
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
*$INSERT I_AA.LOCAL.COMMON
$INSERT I_F.AA.INTEREST
$INSERT I_GTS.COMMON
*$INSERT I_AA.ACTION.CONTEXT
$INSERT I_F.AA.PAYMENT.SCHEDULE
   $USING AA.Framework
*TUS AA Changes - 20161019
$INSERT I_F.AA.ACCOUNT.DETAILS
$USING APAP.TAM
*TUS END
*-----------------------------------------------------------------------------
*IF c_aalocActivityStatus EQ 'UNAUTH' THEN
IF AA.Framework.getC_aalocactivitystatus() EQ 'UNAUTH' THEN    ;*R22 MANUAL CODE CONVERSION-AA.FRAMWORK IS CHANGED
GOSUB GET.LOC.VALUES
GOSUB GET.ARRNG.ID
END
RETURN
*-----------------------------------------------------------------------------
GET.LOC.VALUES:
*----------------
* Get the Needed Local table position
!
LOC.REF.APPL="AA.PRD.DES.INTEREST"
LOC.REF.FIELDS="L.AA.INT.AMTOLD":@VM:"L.AA.INT.AMTNEW":@VM:"L.AA.DIFF.AMT"
LOC.REF.POS=" "
CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
Y.AMT.OLD.POS   =  LOC.REF.POS<1,1>
Y.AMT.NEW.POS   =  LOC.REF.POS<1,2>
Y.DIFF.AMT.POS  =  LOC.REF.POS<1,3>
Y.TEMP = 0
!
RETURN
*-----------------------------------------------------------------------------
GET.ARRNG.ID:
*-----------
*Get the Arrangement ID
!
*Y.ARRANGEMENT.ID = c_aalocArrId
Y.ARRANGEMENT.ID = AA.Framework.getC_aalocarrid() ;*R22 MANUAL CODE CONVERSION-AA.FRAMWORK IS CHANGED
PROP.NAME='PRINCIPAL'       ;* Interest Property to obtain
*   CALL REDO.GET.INTEREST.PROPERTY(Y.ARRANGEMENT.ID,PROP.NAME,OUT.PROP,ERR)
APAP.TAM.redoGetInterestProperty(Y.ARRANGEMENT.ID,PROP.NAME,OUT.PROP,ERR) ;*R22 Manual Code Conversion
Y.PRIN.PROP=OUT.PROP        ;* This variable hold the value of principal interest property


Y.ARRG.ID = Y.ARRANGEMENT.ID
PROPERTY.CLASS = 'INTEREST'
PROPERTY = Y.PRIN.PROP
EFF.DATE = ''
ERR.MSG = ''
R.ARR.COND = ''

GOSUB GET.TOT.INT.PAYMENT
!
* Assigning the sum of TOT.INT.PAYMENT
* for this particular arrangement to old Amt
!
*   CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.ARR.COND,ERR.MSG)
APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.ARR.COND,ERR.MSG) ;* R22 Manual Conversion

IF INT.AMT NE '' THEN
R.NEW(AA.INT.LOCAL.REF)<1,Y.AMT.OLD.POS> = INT.AMT
END ELSE
R.NEW(AA.INT.LOCAL.REF)<1,Y.AMT.OLD.POS> = Y.TEMP
END
!
RETURN
*-----------------------------------------------------------------------------
GET.TOT.INT.PAYMENT:
*-------------------
!
R.PAY.SCHED = ''
*CALL AA.GET.ARRANGEMENT.CONDITIONS(Y.ARRANGEMENT.ID, 'PAYMENT.SCHEDULE','','', RET.IDS, R.PAY.SCHED, RET.ERR)
AA.Framework.GetArrangementConditions(Y.ARRANGEMENT.ID, 'PAYMENT.SCHEDULE','','', RET.IDS, R.PAY.SCHED, RET.ERR);* R22 AUTO CONVERSION
!
SCHEDULE.INFO<1> = Y.ARRANGEMENT.ID
SCHEDULE.INFO<2> = TODAY
SCHEDULE.INFO<3> = 'REPAYMENT.SCHEDULE'
SCHEDULE.INFO<4> = R.PAY.SCHED
!
*TUS AA Changes - 20161019
FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
F.AA.ACCOUNT.DETAILS=''
CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.ACC.DET,F.AA.ACCOUNT.DETAILS,ACC.DET.ERR)

*  END.DATE = R.PAY.SCHED<1,AA.PS.PAYMENT.END.DATE>
END.DATE   = R.ACC.DET<AA.AD.PAYMENT.END.DATE>
*TUS END
!
*Get the schedules for the Arrangement
!
*TUS AA CHANGES - 20161024
*   CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO,END.DATE,'', '1', PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, OS.AMT, RET.ERR)  ;*Tus Start
*   CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO,END.DATE,'', '1', PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, TAX.DETAILS, OS.AMT, FINAL.PRINCIPAL.POS, PAYMENT.PERCENTAGES, RET.ERR) ; * Tus End
*   CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO,END.DATE,'', '1', PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, TAX.DETAILS, OS.AMT, FINAL.PRINCIPAL.POS, PAYMENT.PERCENTAGES, PAYMENT.MIN.AMOUNTS, PAYMENT.DEFER.DATES, PAYMENT.BILL.TYPES, RET.ERR)
CHARGE.CALC.INFO = '' ;*Manual R22 conversion
CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO,END.DATE,'', '1', PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, TAX.DETAILS, OS.AMT, FINAL.PRINCIPAL.POS, PAYMENT.PERCENTAGES, PAYMENT.MIN.AMOUNTS, PAYMENT.DEFER.DATES, PAYMENT.BILL.TYPES, CHARGE.CALC.INFO, RET.ERROR)   ;*Manual R22 conversion - CHARGE.CALC.INFO argument added
*TUS END
GOSUB CALCULATE.TOTAL.INTEREST
RETURN
*--------------------------------------------------------------------------------------------------------------------------
CALCULATE.TOTAL.INTEREST:
*-------------------------
* calculation of interest
!
NO.OF.DATES = DCOUNT(PAYMENT.DATES,@FM)          ;* Count the number of schedule dates
FOR DT.CNT = 1 TO NO.OF.DATES
TOT.TYPES = DCOUNT(PAYMENT.TYPES<DT.CNT>,@VM)  ;* Number of Types for this date
GOSUB GET.TOTAL.INTEREST
NEXT DT.CNT
!
RETURN
*-------------------------------------------------------------------------------------------------------------------
GET.TOTAL.INTEREST:
*------------------
FOR TYPE.CNT = 1 TO TOT.TYPES         ;*Loop thru each Payment Type
!
PROP.LIST = PAYMENT.PROPERTIES<DT.CNT,TYPE.CNT>         ;* This is the list of properties due for the current date
PROP.AMT = PAYMENT.PROPERTIES.AMT<DT.CNT,TYPE.CNT>      ;* This is the list of property amt for each property
!
LOCATE PROPERTY IN PROP.LIST<1,1,1> SETTING INT.PROP.POS THEN     ;* Locate the interest Property and get the property amount
INT.AMT += PROP.AMT<1,1,INT.PROP.POS>
END
!
NEXT TYPE.CNT
RETURN
*------------------------------------------------------------------------------
END
