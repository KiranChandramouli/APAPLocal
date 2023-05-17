*-----------------------------------------------------------------------------
* <Rating>-35</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.GET.NEXT.CYCLEDATE(ARR.ID,FREQ,Y.DATE,Y.OUT.DATE)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ACCOUNT.DETAILS

    GOSUB GET.PAYMENT.SCHEDULE
    GOSUB CHECK.FREQ
    GOSUB GET.NEXT.PAYMENT.DATE

    RETURN
*---------------------------------------------------
GET.PAYMENT.SCHEDULE:
*---------------------------------------------------

*TUS AA Changes - 20161019
    PROPERTY.CLASS = 'PAYMENT.SCHEDULE'
    PROPERTY  = ''
    EFF.DATE  = ''
    ERR.MSG   = ''
    R.PAY.SCH = ''
    R.PAYMENT.SCHEDULE = ''
    CALL REDO.UPGRD.GET.CONDITIONS(ARR.ID,EFF.DATE,PROPERTY.CLASS,PROPERTY,R.PAYMENT.SCHEDULE,ERR.MSG)
*TUS END
* PACS00585816 - Start
    R.PAY.SCH = R.PAYMENT.SCHEDULE
    R.PAYMENT.SCHEDULE = RAISE(R.PAYMENT.SCHEDULE)
    Y.PAYMENT.TYPE = R.PAYMENT.SCHEDULE<AA.PS.PAYMENT.TYPE,1>
* PACS00585816 - End
    CALL REDO.GET.PROPERTY.NAME(ARR.ID,PROPERTY.CLASS,R.OUT.AA.RECORD,OUT.PROPERTY,OUT.ERR)

    RETURN
*---------------------------------------------------
CHECK.FREQ:
*---------------------------------------------------

    Y.FREQ = FREQ
    CALL CALENDAR.DAY(Y.DATE,'+',Y.FREQ)
    Y.DATE = Y.FREQ
    RETURN
*---------------------------------------------------
GET.NEXT.PAYMENT.DATE:
*---------------------------------------------------

    SCHEDULE.INFO    = ''
    SCHEDULE.INFO<1> = ARR.ID
    SCHEDULE.INFO<2> = TODAY
    SCHEDULE.INFO<3> = OUT.PROPERTY
    SCHEDULE.INFO<4> = R.PAY.SCH
*TUS AA Changes - 20161019
    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.ACC.DET,F.AA.ACCOUNT.DETAILS,ACC.DET.ERR)

    START.DATE = ""
    END.DATE = R.ACC.DET<AA.AD.PAYMENT.END.DATE>
    START.DATE = R.ACC.DET<AA.AD.START.DATE>
*TUS END
    NO.CYCLES = ''
    TERM.RECALC.DETAILS = ''
    PAYMENT.TYPES = ""
    PAYMENT.DATES = ""
    PAYMENT.AMOUNTS = ""
    PAYMENT.PROPERTIES = ""
    PAYMENT.METHODS = ""
*TUS START AA PARAM CHANGES - 20161020 - Raju
    PAYMENT.DEFER.DATES = ''

    CALL AA.BUILD.PAYMENT.SCHEDULE.DATES(SCHEDULE.INFO, START.DATE, END.DATE, NO.CYCLES, TERM.RECALC.DETAILS, PAYMENT.DATES, PAYMENT.ACTUAL.DATES, PAYMENT.FIN.DATES, PAYMENT.TYPES, PAYMENT.METHODS, PAYMENT.AMOUNTS, PAYMENT.PROPERTIES, PAYMENT.PERCENTAGES, PAYMENT.MIN.AMOUNT, PAYMENT.DEFER.DATES, PAYMENT.BILL.TYPE, RET.ERROR)
*TUS END

    NO.OF.DATES = DCOUNT(PAYMENT.DATES,FM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE NO.OF.DATES
        Y.LOAN.PAYMENT.TYPES = PAYMENT.TYPES<Y.VAR1>
        CHANGE FM TO VM IN Y.LOAN.PAYMENT.TYPES
        CHANGE SM TO VM IN Y.LOAN.PAYMENT.TYPES
        IF Y.DATE LE PAYMENT.DATES<Y.VAR1> AND Y.PAYMENT.TYPE MATCHES Y.LOAN.PAYMENT.TYPES THEN
            Y.OUT.DATE = PAYMENT.DATES<Y.VAR1>
            Y.VAR1 = NO.OF.DATES+1
        END
        Y.VAR1++
    REPEAT
    RETURN
END
