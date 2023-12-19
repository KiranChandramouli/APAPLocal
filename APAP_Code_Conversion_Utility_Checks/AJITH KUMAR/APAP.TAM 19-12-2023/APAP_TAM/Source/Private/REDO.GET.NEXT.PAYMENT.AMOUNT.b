* @ValidationCode : MjotMzYxNTM3MjgxOkNwMTI1MjoxNzAyODgyNDAzNzcwOmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Dec 2023 12:23:23
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
SUBROUTINE REDO.GET.NEXT.PAYMENT.AMOUNT(ARR.ID,Y.DATE,Y.AMT)

*---------------------------------------------------------
* Description: This routine calculates the next payment amount using the schedule projector routine.
*
* In Param  : NA
* Out Param : NA

*--------------------------------------------------------------------------------
*Modification History:
*   DATE            WHO           REFERENCE                  DESCRIPTION
* 05-Sep-2011      H Ganesh      PACS00113076 - B.16         Initial Draft
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - FM TO @FM, ++ TO += 1
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - Add call routine prefix
*
*----------------------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING APAP.AA
    $USING AA.PaymentSchedule


    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

    Y.AMT = ''
    
*CALL REDO.TEMP.STORE.COMMON('STORE')
** R22 Manual conversion
    APAP.AA.redoTempStoreCommon('STORE')
    NO.RESET='1'
    DATE.RANGE=''
    SIMULATION.REF=''
*CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
*AA.PaymentScheule.ScheduleProjector(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
    AA.PaymentSchedule.ScheduleProjector(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
   
*CALL REDO.TEMP.STORE.COMMON('RESTORE')
** R22 Manual conversion
    APAP.AA.redoTempStoreCommon('RESTORE')
    GOSUB GET.NEXT.AMOUNT

RETURN
*----------------------------------------------------------------------------------
GET.NEXT.AMOUNT:
*----------------------------------------------------------------------------------
    Y.DATES.CNT = DCOUNT(PAYMENT.DATES,@FM)
    Y.VAR1=1
    LOOP

    WHILE Y.VAR1 LE Y.DATES.CNT
        Y.PAY.DATE = PAYMENT.DATES<Y.VAR1>
        IF Y.PAY.DATE GT Y.DATE THEN
            Y.NEXT.PAY.AMT = TOT.PAYMENT<Y.VAR1>
            Y.VAR1 = Y.DATES.CNT+1
        END
        Y.VAR1 += 1                         ;** R22 Auto conversion - ++ to += 1
    REPEAT
    Y.AMT = Y.NEXT.PAY.AMT
RETURN
END
