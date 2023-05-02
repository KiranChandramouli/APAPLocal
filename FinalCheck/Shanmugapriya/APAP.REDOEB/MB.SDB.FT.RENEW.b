* @ValidationCode : MjoyNjc2ODIwODY6Q3AxMjUyOjE2ODE5Nzk1OTYwNjM6SVRTUzotMTotMToxODQ2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1846
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.FT.RENEW

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-APR-2023     Conversion tool    R22 Auto conversion       -- to -=
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.DATES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDING.ORDER
    $INSERT I_F.MB.SDB.TYPE
    $INSERT I_F.MB.SDB.POST
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.CHARGES
    $INSERT I_F.MB.SDB.STATUS

    GOSUB INITIALISE

    SDB.COMPANY = R.NEW(FT.CO.CODE)
    SDB.NO = R.NEW(FT.CREDIT.THEIR.REF)
    GOSUB READ.SDB.PARAM

    MB.SDB.STATUS.ID = SDB.COMPANY:'.':SDB.NO
    R.MB.SDB.STATUS = ''; STATUS.YERR = '';  RETRY = 'P'
    CALL F.READU(FN.MB.SDB.STATUS,MB.SDB.STATUS.ID,R.MB.SDB.STATUS,F.MB.SDB.STATUS,STATUS.YERR,RETRY)

    IF NOT(STATUS.YERR) THEN

        GOSUB PROCESS.SDB.AMT.FREQ.CHANGES

        R.MB.SDB.STATUS<SDB.STA.LAST.RENEWAL.DATE> = R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>
        R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON> = R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY>[1,8]
        R.MB.SDB.STATUS<SDB.STA.RENT.AMT> = R.NEW(FT.CREDIT.AMOUNT)
        COMM.AMT = R.NEW(FT.COMMISSION.AMT)<1,1>
        COMM.AMT = COMM.AMT[4, LEN(COMM.AMT)-3] + 0
        R.MB.SDB.STATUS<SDB.STA.RENT.VAT> = COMM.AMT
        R.MB.SDB.STATUS<SDB.STA.TOTAL.CHARGE.AMT> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT> + R.MB.SDB.STATUS<SDB.STA.RENT.VAT>

        AMORT.AMT = 0; AMORT1.AMT = 0; AMORT2.AMT = 0
        IF R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> GT 0 THEN
            AMORT1.AMT = R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT>
        END

        Y.END.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
        CALL CDT('', Y.END.DATE, '-1C')

        START.DATE = R.MB.SDB.STATUS<SDB.STA.LAST.RENEWAL.DATE>
        IF START.DATE LE Y.END.DATE THEN
            TOTAL.RENT = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
            RENEW.DATE = R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>

            TOT.DAYS = 'C'
            CALL CDD("",START.DATE, RENEW.DATE, TOT.DAYS)

            NO.DAYS = 'C'
            CALL CDD("",START.DATE, Y.END.DATE, NO.DAYS)
            NO.DAYS += 1

            AMOUNT.TO.AMORT = (TOTAL.RENT / TOT.DAYS) * NO.DAYS
            CALL EB.ROUND.AMOUNT(LCCY, AMOUNT.TO.AMORT, '2', '')

            AMORT2.AMT = AMOUNT.TO.AMORT
        END

        AMORT.AMT = AMORT1.AMT + AMORT2.AMT
        IF AMORT.AMT GT 0 AND RENT.PL AND RENT.ACCT AND SDB.OFS.SOURCE THEN
            GOSUB AMORTISE.CHARGES
        END

        IF AMORT2.AMT GT 0 THEN
            R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> = AMORT2.AMT
            R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT> - AMORT2.AMT
        END ELSE
            R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> = 0
            R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
        END


        CALL F.WRITE(FN.MB.SDB.STATUS,MB.SDB.STATUS.ID,R.MB.SDB.STATUS)

        MB.SDB.CHARGES.ID = MB.SDB.STATUS.ID
        R.MB.SDB.CHARGES = ''; YERR = ''; RETRY = 'P'
        CALL F.READU(FN.MB.SDB.CHARGES,MB.SDB.CHARGES.ID,R.MB.SDB.CHARGES,F.MB.SDB.CHARGES,YERR,RETRY)

        R.MB.SDB.CHARGES<SDB.CHG.TXN.REF,-1> = 'Manual renew-':ID.NEW
        R.MB.SDB.CHARGES<SDB.CHG.PERIODIC.RENT,-1> = 0
        R.MB.SDB.CHARGES<SDB.CHG.DISCOUNT.AMT,-1> = 0
        R.MB.SDB.CHARGES<SDB.CHG.VAT.AMOUNT,-1> = 0
        R.MB.SDB.CHARGES<SDB.CHG.DEPOSIT.AMT,-1> = 0
        R.MB.SDB.CHARGES<SDB.CHG.INITIAL.OFFER.AMT,-1> = 0
        R.MB.SDB.CHARGES<SDB.CHG.VAT.OFFER.AMT,-1> = 0
        R.MB.SDB.CHARGES<SDB.CHG.TOTAL.CHARGE.AMT,-1> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT> + R.MB.SDB.STATUS<SDB.STA.RENT.VAT>
        R.MB.SDB.CHARGES<SDB.CHG.REFUND.AMT,-1> = 0
        R.MB.SDB.CHARGES<SDB.CHG.PAY.REASON,-1> = 'Manual Rent Renewal'
        R.MB.SDB.CHARGES<SDB.CHG.RENT.AMT,-1> = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
        R.MB.SDB.CHARGES<SDB.CHG.RENT.VAT,-1> = R.MB.SDB.STATUS<SDB.STA.RENT.VAT>

        CALL F.WRITE(FN.MB.SDB.CHARGES,MB.SDB.CHARGES.ID,R.MB.SDB.CHARGES)
    END

RETURN

********************************************************************************************
INITIALISE:


    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'
    F.MB.SDB.PARAM = ''
    CALL OPF(FN.MB.SDB.PARAM,F.MB.SDB.PARAM)

    FN.MB.SDB.TYPE = 'F.MB.SDB.TYPE'
    F.MB.SDB.TYPE = ''
    CALL OPF(FN.MB.SDB.TYPE,F.MB.SDB.TYPE)

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'
    F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)

    FN.MB.SDB.CHARGES = 'F.MB.SDB.CHARGES'
    F.MB.SDB.CHARGES = ''
    CALL OPF(FN.MB.SDB.CHARGES,F.MB.SDB.CHARGES)

    FN.STANDING.ORDER = 'F.STANDING.ORDER'; F.STANDING.ORDER = ''
    CALL OPF(FN.STANDING.ORDER, F.STANDING.ORDER)


RETURN

********************************************************************************************
PROCESS.SDB.AMT.FREQ.CHANGES:

    SV.COMI = COMI

    LAST.RENEWAL.DATE = R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>
    LAST.RENEW.FREQUENCY = R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY>
    IF NOT(RENEW.FREQUENCY) AND ((FREQ.TYPE EQ 'YEARLY' AND LAST.RENEW.FREQUENCY[9,3] NE 'M12') OR  (FREQ.TYPE EQ 'MONTHLY' AND LAST.RENEW.FREQUENCY[9,3] NE 'M01')) THEN
        IF FREQ.TYPE EQ 'YEARLY' THEN
            COMI = LAST.RENEWAL.DATE:'M12':LAST.RENEWAL.DATE[7,2]
        END ELSE
            COMI = LAST.RENEWAL.DATE:'M01':LAST.RENEWAL.DATE[7,2]
        END
        CALL CFQ
        RENEW.FREQUENCY = COMI
    END

    IF NOT(RENEW.FREQUENCY) THEN
        COMI = LAST.RENEW.FREQUENCY
        CALL CFQ
        RENEW.FREQUENCY = COMI
    END


    IF LAST.RENEW.FREQUENCY NE RENEW.FREQUENCY THEN
        R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY> = RENEW.FREQUENCY
    END

    GOSUB GET.CUST.GROUP

    CUST.DISC.AMT = 0
    IF DISCOUNT.FLAT OR DISCOUNT.PERCENT THEN
        IF DISCOUNT.PERCENT THEN
            CUST.DISC.AMT = PERIODIC.RENT * (DISCOUNT.PERCENT/100)
            CALL EB.ROUND.AMOUNT(LCCY, CUST.DISC.AMT, '2', '')
            PERIODIC.RENT -= CUST.DISC.AMT
        END ELSE
            CUST.DISC.AMT = DISCOUNT.FLAT
            PERIODIC.RENT -= CUST.DISC.AMT
            IF PERIODIC.RENT LT 0 THEN
                PERIODIC.RENT = 0
            END
        END
    END

    LAST.PERIODIC.RENT = R.MB.SDB.STATUS<SDB.STA.PERIODIC.RENT> + 0
    LAST.DISCOUNT.AMT = R.MB.SDB.STATUS<SDB.STA.DISCOUNT.AMT> + 0
    IF LAST.PERIODIC.RENT  NE PERIODIC.RENT OR LAST.DISCOUNT.AMT NE CUST.DISC.AMT THEN
        UPDATE.SDB.STATUS = 'YES'
        R.MB.SDB.STATUS<SDB.STA.PERIODIC.RENT> = PERIODIC.RENT
        R.MB.SDB.STATUS<SDB.STA.DISCOUNT.AMT> = CUST.DISC.AMT + 0
    END

    IF (LAST.PERIODIC.RENT NE PERIODIC.RENT) OR (LAST.RENEW.FREQUENCY NE RENEW.FREQUENCY) THEN
        GOSUB PROCESS.STANDING.ORDER
    END



    COMI = SV.COMI

RETURN

********************************************************************************************
AMORTISE.CHARGES:

    FT.OFS.STR = ''
    FT.OFS.HEADER = 'FUNDS.TRANSFER,MB.SDB.TRF,//':SDB.COMPANY
    FT.OFS.STR = ',,TRANSACTION.TYPE::="AC"'
    FT.OFS.STR := ',CREDIT.ACCT.NO::=':DQUOTE(RENT.PL)
    FT.OFS.STR := ',DEBIT.THEIR.REF::=':DQUOTE(SDB.NO)
    FT.OFS.STR := ',CREDIT.THEIR.REF::=':DQUOTE(SDB.NO)
    FT.OFS.STR := ',DEBIT.CURRENCY::=':DQUOTE(LCCY)
    FT.OFS.STR := ',CREDIT.CURRENCY::=':DQUOTE(LCCY)
    FT.OFS.STR := ',DEBIT.ACCT.NO::=':DQUOTE(RENT.ACCT)
    FT.OFS.STR := ',DEBIT.AMOUNT::=':DQUOTE(AMORT.AMT)
    FT.OFS.STR := ',ORDERING.CUST::="999999"'
    SDB.OFS.STR = FT.OFS.HEADER:FT.OFS.STR
    GOSUB CALL.OGM
    IF OFS.ERR.MSG THEN
        TEXT = OFS.ERR.MSG
        CALL FATAL.ERROR('MB.SDB.FT.RENEW')
    END

RETURN

********************************************************************************************
CALL.OGM:

    OFS.SRC.ID = SDB.OFS.SOURCE; OFS.TXN.ID = ''; OFS.ERROR = ''; OFS.ERR.MSG = ''

    CALL OFS.POST.MESSAGE(SDB.OFS.STR, '', OFS.SRC.ID, '')


RETURN

********************************************************************************************
READ.SDB.PARAM:

    MB.SDB.PARAM.ID = SDB.COMPANY; R.MB.SDB.PARAM = ''; PARAM.YERR = ''
    CALL F.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,F.MB.SDB.PARAM,PARAM.YERR)

    MB.SDB.TYPE.ID = FIELD(SDB.NO,'.',1); R.MB.SDB.TYPE = ''; TYPE.YERR = ''
    CALL F.READ(FN.MB.SDB.TYPE,MB.SDB.TYPE.ID,R.MB.SDB.TYPE,F.MB.SDB.TYPE,TYPE.YERR)

    SDBVAT = R.MB.SDB.PARAM<SDB.PAR.FT.COMM.1>
    SAFEDEP = R.MB.SDB.PARAM<SDB.PAR.FT.COMM.2>
    FT.TXN.RENT = R.MB.SDB.PARAM<SDB.PAR.FT.TXN.TYPE.RENT>
    FT.TXN.REFUND = R.MB.SDB.PARAM<SDB.PAR.FT.TXN.TYPE.REFUND>
    RENT.ACCT = R.MB.SDB.PARAM<SDB.PAR.ADV.RENT.ACCT>
    RENT.PL = 'PL':R.MB.SDB.PARAM<SDB.PAR.RENT.PL>
    RENEW.ADV = R.MB.SDB.PARAM<SDB.PAR.RENEW.ADV>
    SDB.OFS.SOURCE = R.MB.SDB.PARAM<SDB.PAR.OFS.SOURCE>
    DISC.GROUP = R.MB.SDB.PARAM<SDB.PAR.DISC.GROUP>
    DISC.FLAT.AMT = R.MB.SDB.PARAM<SDB.PAR.DISC.FLAT.AMT>
    DISC.PERCENT = R.MB.SDB.PARAM<SDB.PAR.DISC.PERCENT>
    STAFF.GROUP = R.MB.SDB.PARAM<SDB.PAR.STAFF.GROUP>
    FREQ.TYPE = R.MB.SDB.PARAM<SDB.PAR.FREQ.TYPE>
    VAT.PERCENT = R.MB.SDB.PARAM<SDB.PAR.VAT.PERCENT>
    RENEW.FREQUENCY = R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY>

    SDB.AVAIL.COMP = R.MB.SDB.TYPE<SDB.TYP.BRANCH.CODE>; PERIODIC.RENT = ''
    LOCATE SDB.COMPANY IN SDB.AVAIL.COMP<1,1> SETTING SDB.COMP.POS THEN
        PERIODIC.RENT = R.MB.SDB.TYPE<SDB.TYP.PERIODIC.RENT,SDB.COMP.POS> + 0
    END

    SV.COMI = ''; SV.COMI = COMI
    IF RENEW.FREQUENCY AND RENEW.FREQUENCY[1,8] LE TODAY THEN
        LOOP UNTIL RENEW.FREQUENCY[1,8] GT TODAY
            COMI = RENEW.FREQUENCY; CALL CFQ
            RENEW.FREQUENCY = COMI
        REPEAT
        R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY> = RENEW.FREQUENCY
        CALL F.WRITE(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM)
    END

    COMI = SV.COMI

    AC.ID = RENT.ACCT; AC.REC = ''; AC.ERR = ''
    CALL F.READ(FN.ACCOUNT, AC.ID, AC.REC, F.ACCOUNT, AC.ERR)
    RENT.CCY = AC.REC<AC.CURRENCY>

RETURN

************************************************************************
GET.CUST.GROUP:

    CUST.GROUP = ''
    DISCOUNT.FLAT = ''; DISCOUNT.PERCENT = ''; STAFF.FLAG = ''

    IF R.MB.SDB.STATUS<SDB.STA.CUSTOMER.NO> THEN
        APPL.R = ''
        APPL.ID = MB.SDB.STATUS.ID

        APPL.R = R.MB.SDB.STATUS

        CALL APPL.GRP.CONDITION('MB.SDB.STATUS', APPL.ID, APPL.R, CUST.GROUP)
        IF CUST.GROUP THEN
            LOCATE CUST.GROUP IN STAFF.GROUP<1,1> SETTING POS THEN
                STAFF.FLAG = '1'
            END
        END

        IF CUST.GROUP THEN
            LOCATE CUST.GROUP IN DISC.GROUP<1,1> SETTING POS THEN
                DISCOUNT.FLAT = DISC.FLAT.AMT<1,POS>
                DISCOUNT.PERCENT = DISC.PERCENT<1,POS>
            END
        END

    END

RETURN

********************************************************************************************
PROCESS.STANDING.ORDER:

    OFS.STO.ID = ''
    STO.ID = R.MB.SDB.STATUS<SDB.STA.STO.REF>
    IF STO.ID THEN
        OFS.STO.ID = STO.ID
        STO.REC = ''; STO.ERR = ''
        CALL F.READ(FN.STANDING.ORDER, STO.ID, STO.REC, F.STANDING.ORDER, STO.ERR)
        IF NOT(STO.ERR) THEN
            IF (LAST.PERIODIC.RENT NE PERIODIC.RENT) OR RENEW.FREQUENCY NE STO.REC<STO.CURRENT.FREQUENCY> THEN
                GOSUB UPDATE.STANDING.ORDER
            END
        END
    END


RETURN

********************************************************************************************
UPDATE.STANDING.ORDER:

    OFS.ERR.MSG = ''
    ACCT.ID = R.MB.SDB.STATUS<SDB.STA.CUSTOMER.ACCT>; ACCT.REC = ''; ACCT.ERR = ''
    CALL F.READ(FN.ACCOUNT, ACCT.ID, ACCT.REC, F.ACCOUNT, ACCT.ERR)
    YOFS.COMPANY = ACCT.REC<AC.CO.CODE>

    IF STO.ID AND PERIODIC.RENT EQ 0 THEN
        STO.END.DATE = ''
        STO.OFS.HEADER = 'STANDING.ORDER,MB.SDB,//':YOFS.COMPANY
        STO.OFS.HEADER := ",":OFS.STO.ID
        STO.OFS.STR := ',CURRENT.END.DATE::=':DQUOTE(STO.REC<STO.CURRENT.FREQUENCY>[1,8])
        SDB.OFS.STR = STO.OFS.HEADER:STO.OFS.STR
        GOSUB CALL.OGM
    END

    IF STO.ID AND PERIODIC.RENT GT 0 THEN
        STO.END.DATE = ''
        STO.OFS.HEADER = 'STANDING.ORDER,MB.SDB,//':YOFS.COMPANY
        STO.OFS.HEADER := ",":OFS.STO.ID
        STO.OFS.STR := ',CURRENT.AMOUNT.BAL::=':DQUOTE(PERIODIC.RENT)
        STO.OFS.STR := ',CURRENT.END.DATE::=':DQUOTE(STO.REC<STO.CURRENT.FREQUENCY>[1,8])
        STO.OFS.STR := ',FUT.AMOUNT.BAL::=':DQUOTE(PERIODIC.RENT)
        STO.OFS.STR := ',FUT.FREQUENCY::=':DQUOTE(RENEW.FREQUENCY)
        SDB.OFS.STR = STO.OFS.HEADER:STO.OFS.STR
        GOSUB CALL.OGM
    END

    IF OFS.ERR.MSG THEN
        TEXT = OFS.ERR.MSG
        CALL FATAL.ERROR('MB.SDB.STO.RENEW')
    END

RETURN

********************************************************************************************

PROGRAM.END:

RETURN

END
