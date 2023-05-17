SUBROUTINE REDO.GET.REPORT.LOAN.PAYAMT(Y.AA.ID,Y.REPAY.AMT,Y.DUMMY.VAR1,Y.DUMMY.VAR2)
*----------------------------------------------------------------------------------------------
*Description: This routine is to get the repayment amount of loan using the concat table
*             REDO.AA.SCHEDULE.
* Incoming Variable:
*                  Y.AA.ID     -  Arrangement ID.
* Outgoing Variable:
*                  Y.REPAY.AMT<1> - Next repayment amount from today's date else last date of pay schedule.
*                  Y.REPAY.AMT<2> - Associated date of the repayment amount - Y.REPAY.AMT<1>.
*                  Y.DUMMY.VAR1- Dummy variable for future use(May be used to get next immediate payment bill amt by checking account or interest bill)
*                  Y.DUMMY.VAR2- Dummy variable for future use
*----------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE


    GOSUB INIT
    GOSUB PROCESS

RETURN
*----------------------------------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------------------------------
* Initialise the variable.

    Y.REPAY.AMT      = 0
    Y.LAST.REPAY.AMT = 0
    IF Y.AA.ID ELSE   ;* If arrangement id is blank.
        GOSUB END1
    END
    Y.ACCOUNT.PROPERTY = ''
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROPERTY,OUT.ERR)

    FN.REDO.AA.SCHEDULE = 'F.REDO.AA.SCHEDULE'
    F.REDO.AA.SCHEDULE  = ''
    CALL OPF(FN.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE)

RETURN
*----------------------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------------------
    CALL F.READ(FN.REDO.AA.SCHEDULE,Y.AA.ID,R.REDO.AA.SCHEDULE,F.REDO.AA.SCHEDULE,SCH.ERR)
    IF R.REDO.AA.SCHEDULE THEN
        TOT.PAYMENT = RAISE(R.REDO.AA.SCHEDULE<1>)
        DUE.DATES   = RAISE(R.REDO.AA.SCHEDULE<2>)
        DUE.PROPS   = RAISE(R.REDO.AA.SCHEDULE<6>)
    END ELSE
        GOSUB END1
    END
    Y.VAR1 = 1
    Y.DATES.CNT = DCOUNT(DUE.DATES,@FM)
    LOOP
    WHILE Y.VAR1 LE Y.DATES.CNT
        Y.DATE = DUE.DATES<Y.VAR1>
        IF Y.DATE GE TODAY THEN

            LOCATE Y.ACCOUNT.PROPERTY IN DUE.PROPS<Y.VAR1,1,1> SETTING ACC.POS THEN
                Y.REPAY.AMT = TOT.PAYMENT<Y.VAR1>:@FM:DUE.DATES<Y.VAR1>
                Y.VAR1 = Y.DATES.CNT+1          ;* Break
            END ELSE
                Y.LAST.REPAY.AMT = TOT.PAYMENT<Y.VAR1>:@FM:DUE.DATES<Y.VAR1>   ;* In case of matured or ZPI loans.
            END
        END ELSE
            LOCATE Y.ACCOUNT.PROPERTY IN DUE.PROPS<Y.VAR1,1,1> SETTING ACC.POS THEN
                Y.LAST.REPAY.AMT = TOT.PAYMENT<Y.VAR1>:@FM:DUE.DATES<Y.VAR1>   ;* In case of matured or ZPI loans.
            END
        END
        Y.VAR1 += 1
    REPEAT
    IF Y.REPAY.AMT ELSE         ;* Incase of matured loans.
        Y.REPAY.AMT = Y.LAST.REPAY.AMT
    END

RETURN
*----------------------------------------------------------------------------------------------
END1:
END
