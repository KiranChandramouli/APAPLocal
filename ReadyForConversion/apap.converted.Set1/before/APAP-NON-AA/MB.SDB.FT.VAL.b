*-----------------------------------------------------------------------------
* <Rating>167</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.SDB.FT.VAL

* Modification history
* NSCU20090904 - A.VINOTH KUMAR - Fix done for the issue HD0930989
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.STATUS
    $INSERT I_F.MB.SDB.TYPE

    IF MESSAGE = 'VAL' THEN RETURN

    SDB.NO = COMI

    GOSUB INITIALISE

    GOSUB READ.SDB.STATUS

    CALL REBUILD.SCREEN

    GOTO PROGRAM.END

******************************************************************************************
INITIALISE:

*
    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'
    F.MB.SDB.PARAM = ''
    CALL OPF(FN.MB.SDB.PARAM,F.MB.SDB.PARAM)
*
    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'
    F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)
*
    FN.MB.SDB.TYPE = 'F.MB.SDB.TYPE'
    F.MB.SDB.TYPE = ''
    CALL OPF(FN.MB.SDB.TYPE,F.MB.SDB.TYPE)

    MB.SDB.PARAM.ID = ID.COMPANY; R.MB.SDB.PARAM = ''; YERR = ''
    CALL F.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,F.MB.SDB.PARAM,YERR)
*
    RETURN

******************************************************************************************
READ.SDB.STATUS:

    MB.SDB.STATUS.ID = ID.COMPANY:'.':SDB.NO; R.MB.SDB.STATUS = '' ; RERR = ''
    CALL F.READ(FN.MB.SDB.STATUS,MB.SDB.STATUS.ID,R.MB.SDB.STATUS,F.MB.SDB.STATUS,RERR)
    IF RERR THEN
        ETEXT = 'Safe Deposit does not exist in this branch'
        CALL STORE.END.ERROR
        RETURN
    END

    IF R.MB.SDB.STATUS<SDB.STA.STATUS> NE 'RENTED' THEN
        ETEXT = 'Safe Deposit Box is not rented'
        CALL STORE.END.ERROR
        RETURN
    END

    IF R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON> GE TODAY THEN
        ETEXT = 'Safe Deposit Box Renewal is not yet due'
        CALL STORE.END.ERROR
        RETURN
    END

    RENEW.FREQUENCY = R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY>
    NBR.AMT = 0; SV.COMI = COMI
    LOOP UNTIL RENEW.FREQUENCY[1,8] GT TODAY
        COMI = RENEW.FREQUENCY; CALL CFQ
        RENEW.FREQUENCY = COMI
        NBR.AMT += 1
    REPEAT
    COMI = SV.COMI

    IF NBR.AMT GE 1 THEN
*     R.NEW(FT.CREDIT.AMOUNT) = R.MB.SDB.STATUS<SDB.STA.RENT.AMT> * (NBR.AMT -1) + R.MB.SDB.STATUS<SDB.STA.PERIODIC.RENT>
*NSCU20090904 - S
        R.NEW(FT.CREDIT.AMOUNT) = (NBR.AMT) * R.MB.SDB.STATUS<SDB.STA.PERIODIC.RENT>
*NSCU20090904 - E
    END ELSE
        R.NEW(FT.CREDIT.AMOUNT) = R.MB.SDB.STATUS<SDB.STA.PERIODIC.RENT>
    END

    R.NEW(FT.CREDIT.THEIR.REF) = SDB.NO
    R.NEW(FT.DEBIT.ACCT.NO) = R.MB.SDB.STATUS<SDB.STA.CUSTOMER.ACCT>

    RETURN

******************************************************************************************
PROGRAM.END:

    RETURN

END



