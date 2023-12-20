* @ValidationCode : MjoxMTUzMDA4ODcxOkNwMTI1MjoxNzAyOTkyNDYxOTk4OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjIwMi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:57:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202202.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA;*MANUAL R22 CODE CONVERSION
SUBROUTINE REDO.NOFILE.AA.OVERVIEW.PAYSCH(SCHED.ARR)
    
*-----------------------------------------------------------------------------------
* Modification History:
*DATE              WHO                REFERENCE                        DESCRIPTION
*29-03-2023      CONVERSION TOOL   AUTO R22 CODE CONVERSION     FM TO @FM,VM TO @VM,++ TO +=1
*29-03-2023      MOHANRAJ R        MANUAL R22 CODE CONVERSION         Package name added APAP.AA, CALL method format changed
*19/12/2023         Arun               R22 Manual Conversion             Changed to AA.PaymentSchedule.ScheduleProjector
*-----------------------------------------------------------------------------------

    
*----------------------------------------------------------------
*Description: This is the nofile enquiry routine to display the payment details
*              in the Overview screen.
*----------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $USING AA.PaymentSchedule
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------

    LOCATE 'ARRANGEMENT.ID' IN D.FIELDS<1> SETTING POS1 THEN
        Y.ARR.ID = D.RANGE.AND.VALUE<POS1>
    END
    GOSUB GET.DATE
    IF Y.DATE THEN
        GOSUB GET.DETAILS
    END
RETURN
*---------------------------------------------------------------
GET.DATE:
*---------------------------------------------------------------
    ARR.ID = Y.ARR.ID
    SIMULATION.REF = ''
    NO.RESET       = '1'

    DATE.RANGE     = ''
*CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)
    AA.PaymentSchedule.ScheduleProjector(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS);*MANUAL R22 CODE CONVERSION
    Y.DATE = ''
    Y.DATES.CNT = DCOUNT(PAYMENT.DATES,@FM) ;*AUTO R22 CODE CONVERSION
    Y.VAR1=1
    LOOP

    WHILE Y.VAR1 LE Y.DATES.CNT

        Y.PAY.DATE = PAYMENT.DATES<Y.VAR1>
        Y.PAY.AMT  = TOT.PAYMENT<Y.VAR1>
        IF Y.PAY.DATE GT TODAY THEN
            Y.DATE = Y.PAY.DATE
            Y.VAR1 = Y.DATES.CNT+1
        END
        IF Y.PAY.AMT THEN
            Y.LAST.DATE.AMT = Y.PAY.DATE
        END

        Y.VAR1 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
    IF Y.DATE ELSE    ;* Last payment date has been assigned
        Y.DATE = Y.PAY.DATE
    END
    IF Y.PAY.AMT ELSE
        Y.DATE = Y.LAST.DATE.AMT  ;* This is for the payoff case where amt is zero for next schedule.
    END

RETURN
*---------------------------------------------------------------
GET.DETAILS:
*---------------------------------------------------------------

    BACKUP.ENQ.SELECTION = ENQ.SELECTION
    ENQ.SELECTION<2>   = "ARRANGEMENT.ID":@VM:"DATE.DUE" ;*AUTO R22 CODE CONVERSION
    ENQ.SELECTION<4>   = Y.ARR.ID:@VM:Y.DATE ;*AUTO R22 CODE CONVERSION

    APAP.AA.redoEAaFullScheduleProjector(SCHED.ARR);* R22 Manual conversion
    ENQ.SELECTION = BACKUP.ENQ.SELECTION

    GOSUB GET.PAYMENT.SCHEDULE
    IF R.CONDITION ELSE
        RETURN
    END
    Y.VAR2 = 1
    Y.ARRAY.CNT = DCOUNT(SCHED.ARR,@FM) ;*AUTO R22 CODE CONVERSION
    LOOP
    WHILE Y.VAR2 LE Y.ARRAY.CNT
        Y.ARRAY = SCHED.ARR<Y.VAR2>
        Y.PAY.TYPE = FIELD(Y.ARRAY,"*",1)

        IF Y.PAY.TYPE THEN
            LOCATE Y.PAY.TYPE IN R.CONDITION<AA.PaymentSchedule.PaymentSchedule.PsEndDate,1> SETTING POS2 THEN
                Y.FREQ = R.CONDITION<AA.PaymentSchedule.PaymentSchedule.PsEndDate,POS2>
                SCHED.ARR<Y.VAR2>:='*':Y.FREQ
            END
        END
        Y.VAR2 += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT
RETURN
*----------------------------------------------
GET.PAYMENT.SCHEDULE:
*----------------------------------------------

    EFF.DATE   = ''
    PROP.CLASS ='PAYMENT.SCHEDULE'
    PROPERTY   = ''
    R.CONDITION= ''
    ERR.MSG    = ''
    APAP.AA.redoCrrGetConditions(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG);* R22 Manual conversion


RETURN
END
