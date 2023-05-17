SUBROUTINE REDO.POST.PAYOFF.REM.PAYSCH.INT
*-------------------------------------------------
* Description: This POST ACTIVITY API routine is to update the payment schedule property
*              by removing the scheduled charges after the payoff payment.
*              This is done to avoid the scheduled charges to be issued as bill after
*              payoff repayment because we are using applypayment instead of settle payment.
*-------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.APP.COMMON
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.REDO.APAP.PROPERTY.PARAM

    IF c_aalocActivityStatus MATCHES 'UNAUTH':@VM:'UNAUTH-CHG' THEN
        GOSUB PROCESS
    END
RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------
    Y.AA.ID = c_aalocArrId
    Y.ACCOUNT.PROP  = ''
    Y.INTEREST.PROP = ''
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'ACCOUNT',R.OUT.AA.RECORD,Y.ACCOUNT.PROP,OUT.ERR)
    CALL REDO.GET.PROPERTY.NAME(Y.AA.ID,'INTEREST',R.OUT.AA.RECORD,Y.INTEREST.PROP,OUT.ERR)

    Y.IMPORTANT.PROPERTY     = Y.ACCOUNT.PROP:@FM:Y.INTEREST.PROP
    Y.IMPORTANT.PROPERTY.CNT = DCOUNT(Y.IMPORTANT.PROPERTY,@FM)
    Y.DELETE.PAYPOS          = ''
    Y.SUB.ARRAY              = ''

    Y.PAYMENT.TYPE     = R.NEW(AA.PS.PAYMENT.TYPE)
    Y.PAYMENT.TYPE.CNT = DCOUNT(Y.PAYMENT.TYPE,@VM)
    Y.VAR1 = 1
    LOOP
    WHILE Y.VAR1 LE Y.PAYMENT.TYPE.CNT
        Y.PROPERTIES     = R.NEW(AA.PS.PROPERTY)<1,Y.VAR1>
        CHANGE @SM TO @VM IN Y.PROPERTIES
        Y.VAR2 = 1
        LOOP
        WHILE Y.VAR2 LE Y.IMPORTANT.PROPERTY.CNT
            IF Y.IMPORTANT.PROPERTY<Y.VAR2> MATCHES Y.PROPERTIES THEN
                Y.VAR2 = Y.IMPORTANT.PROPERTY.CNT+1       ;* Instead of break.
            END ELSE
                IF Y.VAR2 EQ Y.IMPORTANT.PROPERTY.CNT THEN
                    Y.DELETE.PAYPOS<-1> = Y.VAR1
                    Y.SUB.ARRAY<-1>     = 1       ;* This array is used to decreament the pos by one.
                END
            END
            Y.VAR2 += 1
        REPEAT
        Y.VAR1 += 1
    REPEAT

    IF Y.DELETE.PAYPOS THEN
        GOSUB DELETE.PAYMENT.TYPE
    END
RETURN
*---------------------------------------------------------------
DELETE.PAYMENT.TYPE:
*---------------------------------------------------------------
* Here we will delete the unwanted pay sch payment types and associated fields.

    Y.DELETE.CNT = DCOUNT(Y.DELETE.PAYPOS,@FM)
    Y.LOOP1 = 1
    LOOP
    WHILE Y.LOOP1 LE Y.DELETE.CNT
        GOSUB PROCESS.DEL.COMMAND
        Y.DELETE.PAYPOS = SUBS(Y.DELETE.PAYPOS,Y.SUB.ARRAY)     ;* Since we are using DEL, Old position of payment type will be decreased by one.
        Y.LOOP1 += 1
    REPEAT

RETURN
*-------------------------------------------------------
PROCESS.DEL.COMMAND:
*-------------------------------------------------------

    DEL R.NEW(AA.PS.PAYMENT.TYPE)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.PAYMENT.METHOD)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.PAYMENT.FREQ)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.PROPERTY)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.DUE.FREQ)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.PERCENTAGE)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.START.DATE)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.END.DATE)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.NUM.PAYMENTS)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.CALC.AMOUNT)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.ACTUAL.AMT)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.20)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.19)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.18)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.17)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.16)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.BILL.TYPE)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.BILL.PRODUCED)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.15)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.14)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.13)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.12)<1,Y.DELETE.PAYPOS<Y.LOOP1>>
    DEL R.NEW(AA.PS.RESERVED.11)<1,Y.DELETE.PAYPOS<Y.LOOP1>>

RETURN
END
