* @ValidationCode : Mjo1NjYyOTI4MDQ6Q3AxMjUyOjE3MDI5NjUyODY5MDk6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 Dec 2023 11:24:46
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
SUBROUTINE REDO.GET.NEXT.IMMEDIATE.PAYMENT.AMT

*---------------------------------------------------------
* Description: This conversion routine calculates the next payment amount using the schedule projector routine
*
* In Param  : NA
* Out Param : NA

*--------------------------------------------------------------------------------
*Modification History:
*   DATE            WHO                 REFERENCE                  DESCRIPTION
* 23-Nov-2012      H Ganesh          AA Overview Screen         Initial Draft
* 06.04.2023       Conversion Tool       R22                    Auto Conversion     - FM TO @FM
* 06.04.2023       Shanmugapriya M       R22                    Manual Conversion   - No changes
*
*----------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*$INSERT I_F.AA.ACCOUNT.DETAILS
    $USING AA.PaymentSchedule

    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)



    Y.ID = O.DATA
    ARR.ID = FIELD(Y.ID,'-',1)

    IF ARR.ID ELSE
        O.DATA = ''
    END
* CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACC.DET,F.AA.ACCOUNT.DETAILS,ACT.ERR)
    R.AA.ACC.DET=AA.PaymentSchedule.AccountDetails.Read(ARR.ID, ACT.ERR)
* Y.PAY.START.DATE = R.AA.ACC.DET<AA.AD.PAYMENT.START.DATE>
    Y.PAY.START.DATE = R.AA.ACC.DET<AA.PaymentSchedule.AccountDetails.AdPaymentStartDate>
    IF Y.PAY.START.DATE ELSE
        Y.PAY.START.DATE = TODAY
    END
    Y.AMT = ''
    SIMULATION.REF = ''
    NO.RESET = '1'
    YREGION = ''
    YDATE = TODAY
    Y.YEAR = YDATE[1,4] + 1
    YDAYS.ORIG = Y.YEAR:TODAY[5,4]
    DATE.RANGE = Y.PAY.START.DATE:@FM:YDAYS.ORIG     ;* Date range is passed for 1 years to avoid building schedule for whole loan term

* CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
* AA.PaymentScheule.ScheduleProjector(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
    AA.PaymentSchedule.ScheduleProjector(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
    GOSUB GET.NEXT.AMOUNT
    IF Y.AMT THEN
        O.DATA = 'Total Cuota: ':FMT(Y.AMT,'R2,#15')
    END ELSE
        O.DATA = ''
    END

RETURN
*----------------------------------------------------------------------------------
GET.NEXT.AMOUNT:
*----------------------------------------------------------------------------------
    Y.DATES.CNT = DCOUNT(PAYMENT.DATES,@FM)
    Y.VAR1=1
    LOOP

    WHILE Y.VAR1 LE Y.DATES.CNT
        Y.PAY.DATE = PAYMENT.DATES<Y.VAR1>
        IF Y.PAY.DATE GT TODAY THEN
            Y.NEXT.PAY.AMT = TOT.PAYMENT<Y.VAR1>
            Y.VAR1 = Y.DATES.CNT+1
        END
        Y.VAR1 += 1
    REPEAT
    Y.AMT = Y.NEXT.PAY.AMT
RETURN
END
