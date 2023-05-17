SUBROUTINE REDO.GET.NEXT.PAYMENT.AMOUNT.OLD(Y.AA.ID,Y.DATE,Y.AMT)

*---------------------------------------------------------
* Description: This routine gets the payment amount for the date passed from the concat table
*              REDO.AA.SCHEDULE.
* In Param  : Y.AA.ID -> Arrangement ID.
*             Y.DATE  -> Effective date.
* Out Param : Y.AMT   -> Payment Amount.
*---------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE


    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------
INIT:
*---------------------------------------------------------

    Y.AMT = 0
    IF Y.AA.ID ELSE
        GOSUB ENG.PGM
    END
    IF Y.DATE ELSE
        Y.DATE = TODAY
    END

    FN.REDO.AA.SCHEDULE = 'F.REDO.AA.SCHEDULE'
    F.REDO.AA.SCHEDULE  = ''
    CALL OPF(FN.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE)

RETURN
*---------------------------------------------------------
PROCESS:
*---------------------------------------------------------

    CALL F.READ(FN.REDO.AA.SCHEDULE,Y.AA.ID,R.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE,SCH.ERR)

    Y.PAYMENT.DATES     = RAISE(R.REDO.AA.SCHEDULE<2>)
    Y.DUE.AMTS          = RAISE(R.REDO.AA.SCHEDULE<7>)
    Y.PAYMENT.DATES.CNT = DCOUNT(Y.PAYMENT.DATES,@FM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.PAYMENT.DATES.CNT
        Y.PAYMENT.DAY = Y.PAYMENT.DATES<Y.VAR1>
        Y.DUE.AMT     = Y.DUE.AMTS<Y.VAR1>
        CHANGE @VM TO @FM IN Y.DUE.AMT
        CHANGE @SM TO @FM IN Y.DUE.AMT
        IF Y.PAYMENT.DAY GT Y.DATE THEN

            Y.AMT =  SUM(Y.DUE.AMT)
            Y.VAR1 = Y.PAYMENT.DATES.CNT + 1  ;* Break
        END ELSE
            Y.LAST.AMT = SUM(Y.DUE.AMT)
        END
        Y.VAR1 += 1
    REPEAT

    IF Y.AMT ELSE
        Y.AMT = Y.LAST.AMT
    END

RETURN
*---------------------------------------------------------
ENG.PGM:
END
