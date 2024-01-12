* @ValidationCode : MjotMjU2MTAyNjk6Q3AxMjUyOjE3MDQzNzExNDkyOTA6dmlnbmVzaHdhcmk6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:55:49
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
* <Rating>-81</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.POST.PRINC.INTEREST
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This Routine used as the Post Routine for the activity LENDING-CHANGE-PRINCIPALINT
* The sum of that values is assigned to new amount
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who           Reference            Description
* 01-JUL-2010    Kishore.SP    ODR-2009-10-0325      Initial Creation
* 12-Jun-2023  Santosh      Manual R22 conversion   New argument added in AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES
*03-01-2024     VIGNESHWARI S      R22 MANUAL CONVERSION                AA.PaymentSchedule IS CHANGED, CALL RTN MODIFIED,AA.FRAMEWORK IS CHANGED
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
*$INSERT I_F.AA.ACCOUNT.DETAILS
$USING APAP.TAM
$USING AA.PaymentSchedule
*TUS END
*-----------------------------------------------------------------------------
*IF c_aalocActivityStatus EQ 'AUTH' THEN
IF AA.Framework.getC_aalocactivitystatus() EQ 'AUTH' THEN    
GOSUB GET.LOC.VALUES
GOSUB GET.ARRNG.ID
!
IF Y.CHK.EFF.FLAG NE '1' THEN
GOSUB CHECK.DIFF.AMT
END
!

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
!
RETURN
*-----------------------------------------------------------------------------
GET.ARRNG.ID:
*-----------
*Get the Arrangement ID
!
*Y.ARRANGEMENT.ID = c_aalocArrId
Y.ARRANGEMENT.ID = AA.Framework.getC_aalocarrid()  ;*R22 MANUAL CONVERSION-AA.FRAMEWORK IS CHANGED
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

!
Y.EFFECTIVE.RATE.NEW = R.NEW(AA.INT.EFFECTIVE.RATE)
Y.EFFECTIVE.RATE.OLD = R.OLD(AA.INT.EFFECTIVE.RATE)

IF Y.EFFECTIVE.RATE.NEW EQ Y.EFFECTIVE.RATE.OLD THEN
R.NEW(AA.INT.LOCAL.REF)<1,Y.AMT.NEW.POS>  = R.NEW(AA.INT.LOCAL.REF)<1,Y.AMT.OLD.POS>
R.NEW(AA.INT.LOCAL.REF)<1,Y.DIFF.AMT.POS> = '0'
Y.CHK.EFF.FLAG = '1'
RETURN
END
!
GOSUB GET.TOT.INT.PAYMENT
!
* Assigning the sum of TOT.INT.PAYMENT
* for this particular arrangement to old Amt
!
R.ARR.COND = ''
*   CALL REDO.CRR.GET.CONDITIONS(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.ARR.COND,ERR.MSG)
APAP.AA.redoCrrGetConditions(Y.ARRG.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.ARR.COND,ERR.MSG) ;* Manual R22 conversion
IF INT.AMT NE '' THEN
R.NEW(AA.INT.LOCAL.REF)<1,Y.AMT.NEW.POS> = INT.AMT
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
SimulationRef = ""
NoReset = ''
DateRange = ''
!
*TUS AA Changes - 20161019
FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
F.AA.ACCOUNT.DETAILS=''
CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

*CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.ACC.DET,F.AA.ACCOUNT.DETAILS,ACC.DET.ERR)
R.ACC.DET = AA.PaymentSchedule.AccountDetails.Read(Y.AA.ID, ACC.DET.ERR);*R22 MANUAL CONVERSION- Read value is modified
*  END.DATE = R.PAY.SCHED<1,AA.PS.PAYMENT.END.DATE>
*END.DATE   = R.ACC.DET<AA.AD.PAYMENT.END.DATE>
END.DATE   = R.ACC.DET<AA.PaymentSchedule.AccountDetails.AdPaymentEndDate> ;*R22 MANUAL CONVERSION-AA.PaymentSchedule IS CHANGED
*TUS END
!
* Get the schedules for the Arrangement
!
*AA PARAM CHANGES - 20161024
*   CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO,END.DATE,'', '1', PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, OS.AMT, RET.ERR)
*   CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO,END.DATE,'', '1', PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, TAX.DETAILS, OS.AMT, FINAL.PRINCIPAL.POS, PAYMENT.PERCENTAGES, RET.ERR)
*   CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO,END.DATE,'', '1', PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, TAX.DETAILS, OS.AMT, FINAL.PRINCIPAL.POS, PAYMENT.PERCENTAGES, PAYMENT.MIN.AMOUNTS, PAYMENT.DEFER.DATES, PAYMENT.BILL.TYPES, RET.ERR)
CHARGE.CALC.INFO = '' ;*Manual R22 conversion
*CALL AA.BUILD.PAYMENT.SCHEDULE.SCHEDULES(SCHEDULE.INFO,END.DATE,'', '1', PAYMENT.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, TAX.DETAILS, OS.AMT, FINAL.PRINCIPAL.POS, PAYMENT.PERCENTAGES, PAYMENT.MIN.AMOUNTS, PAYMENT.DEFER.DATES, PAYMENT.BILL.TYPES, CHARGE.CALC.INFO, RET.ERROR)   ;*Manual R22 conversion - CHARGE.CALC.INFO argument added
AA.PaymentSchedule.ScheduleProjector(Y.ARRANGEMENT.ID, SimulationRef, NoReset, DateRange, TotPayment, PAYMENT.DATES, DueDeferDates, PAYMENT.TYPES, DueMethods, DueTypeAmts, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DueOuts) ;*R22 MANUAL CODE CONVERSION-CALL RTN MODIFIED
*TUS END
!
GOSUB CALCULATE.TOTAL.INTEREST
RETURN
*--------------------------------------------------------------------------------------------------------------------------
CALCULATE.TOTAL.INTEREST:
*--------------------------
* Get the total interest
!
NO.OF.DATES = DCOUNT(PAYMENT.DATES,@FM)          ;* Count the number of schedule dates
!
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

LOCATE PROPERTY IN PROP.LIST<1,1,1> SETTING INT.PROP.POS THEN     ;* Locate the interest Property and get the property amount
INT.AMT += PROP.AMT<1,1,INT.PROP.POS>
END
!
NEXT TYPE.CNT
!
RETURN
*------------------------------------------------------------------------------
CHECK.DIFF.AMT:
*--------------
!
* Get the Diff between Old and New Amount
* The Old Amount is subtracted from new amount
!
Y.OLD.AMT = R.NEW(AA.INT.LOCAL.REF)<1,Y.AMT.OLD.POS>
Y.NEW.AMT = INT.AMT
Y.DIF.AMT =  Y.OLD.AMT - Y.NEW.AMT
R.NEW(AA.INT.LOCAL.REF)<1,Y.DIFF.AMT.POS> = Y.DIF.AMT
!
RETURN
*-------------------------------------------------------------------------------------------------------------------------------
END
