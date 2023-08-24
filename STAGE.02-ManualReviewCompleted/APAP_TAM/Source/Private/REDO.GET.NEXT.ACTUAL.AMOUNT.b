$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.NEXT.ACTUAL.AMOUNT
*-----------------------------------------------------------------------------

* Description: This conversion routine returns the Next Actual amount of the each payment type

** 10-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 10-04-2023 Skanda R22 Manual Conversion - No changes

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_ENQUIRY.COMMON

    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

    IF O.DATA ELSE
        RETURN
    END

    Y.PAY.TYPE = FIELD(O.DATA,'*',1)
    Y.PROP     = FIELD(O.DATA,'*',2)
    O.DATA = ''
    Y.ACT.AMT = ''
    IF Y.PAY.TYPE AND Y.PROP ELSE
        RETURN
    END
    LOCATE Y.PAY.TYPE IN R.RECORD<AA.PS.PAYMENT.TYPE,1> SETTING POS1 THEN
        Y.ACT.AMT = R.RECORD<AA.PS.ACTUAL.AMT,POS1>
    END
    IF Y.ACT.AMT ELSE
        RETURN
    END
    ARR.ID = FIELD(ID,'-',1)
    SIMULATION.REF = ''
    NO.RESET       = '1'
    YREGION        = ''
    YDATE          = TODAY
    Y.YEAR         = YDATE[1,4] + 1
    YDAYS.ORIG     = Y.YEAR:TODAY[5,4]
    DATE.RANGE     = TODAY:@FM:YDAYS.ORIG  ;* Date range is passed for 1 years to avoid building schedule for whole loan term

    CALL AA.SCHEDULE.PROJECTOR(ARR.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, PAYMENT.DATES, DUE.DEFER.DATES, PAYMENT.TYPES, DUE.METHODS,DUE.TYPE.AMTS, PAYMENT.PROPERTIES, PAYMENT.PROPERTIES.AMT, DUE.OUTS)

    Y.DATES.CNT = DCOUNT(PAYMENT.DATES,@FM)
    Y.VAR1=1
    LOOP

    WHILE Y.VAR1 LE Y.DATES.CNT
        Y.PAY.DATE = PAYMENT.DATES<Y.VAR1>
        IF Y.PAY.DATE GT TODAY THEN
            LOCATE Y.PAY.TYPE IN PAYMENT.TYPES<Y.VAR1,1> SETTING POS2 THEN
                LOCATE Y.PROP IN PAYMENT.PROPERTIES<Y.VAR1,POS2,1> SETTING POS3 THEN
*O.DATA = FMT(DUE.TYPE.AMTS<Y.VAR1,POS2>,'L2,#19')
                    O.DATA = FMT(PAYMENT.PROPERTIES.AMT<Y.VAR1,POS2,POS3>,'L2,#19')
                    Y.VAR1 = Y.DATES.CNT+1
                END
            END

        END
        Y.VAR1 += 1 ;* R22 Auto conversion
    REPEAT
RETURN
END
