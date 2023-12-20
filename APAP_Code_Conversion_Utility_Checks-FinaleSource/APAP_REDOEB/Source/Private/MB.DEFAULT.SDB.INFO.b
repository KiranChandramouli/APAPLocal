* @ValidationCode : Mjo0MDU5NDAyNjk6VVRGLTg6MTcwMjk5MDYyNjY0OTpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:27:06
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.DEFAULT.SDB.INFO
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       = to EQ
* 12-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified, GOTO to GOSUB
* 14-12-2023       Narmadha V       Manual R22 Conversion      Change F.READ to CACHE.READ, Command the CALL OPF,Call routine format modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.MB.SDB.POST
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.TYPE
    $INSERT I_F.MB.SDB.STATUS
    $USING EB.Display

    GOSUB INITIALISE
    GOSUB PROCESS

RETURN

PROCESS:

    IF R.NEW(SDB.POST.SDB.NUMBER) AND R.NEW(SDB.POST.SDB.COMPANY) THEN

        T(SDB.POST.SDB.COMPANY)<3> = 'NOINPUT'
        T(SDB.POST.SDB.NUMBER)<3> = 'NOINPUT'

        IF INDEX(R.NEW(SDB.POST.SDB.NUMBER),'.',1) THEN
            SDB.SEQ.NO = FIELD(R.NEW(SDB.POST.SDB.NUMBER),'.',2)
            MB.SDB.TYPE.ID = FIELD(R.NEW(SDB.POST.SDB.NUMBER),'.',1)
            GOSUB READ.SDB.TYPE
            SDB.AVAIL.COMP = R.MB.SDB.TYPE<SDB.TYP.BRANCH.CODE>
            IF YERR THEN
                E = MB.SDB.TYPE.ID:' is not a valid Safe Box type'
                GOSUB PROGRAM.END
            END

            SDB.STATUS = ''
            LOCATE R.NEW(SDB.POST.SDB.COMPANY) IN SDB.AVAIL.COMP<1,1> SETTING SDB.COMP.POS ELSE SDB.COMP.POS = ''
            IF SDB.COMP.POS THEN
                MB.SDB.STATUS.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)
                R.MB.SDB.STATUS = ''
*CALL MB.SDB.READ.SDB.STATUS(MB.SDB.STATUS.ID,R.MB.SDB.STATUS) ;*Manual R22 conversion
                APAP.REDOEB.mbSdbReadSdbStatus(MB.SDB.STATUS.ID,R.MB.SDB.STATUS);
                IF R.MB.SDB.STATUS THEN
                    SDB.STATUS = 1
                END ELSE
                    SDB.STATUS = 0
                END
            END ELSE
                E = 'The Box type ':MB.SDB.TYPE.ID': is not available in this branch'
                GOSUB PROGRAM.END
            END

            IF SDB.STATUS THEN
                R.NEW(SDB.POST.CUSTOMER.NO) = R.MB.SDB.STATUS<SDB.STA.CUSTOMER.NO>
                R.NEW(SDB.POST.JOINT.HOLDER) = R.MB.SDB.STATUS<SDB.STA.JOINT.HOLDER>
                R.NEW(SDB.POST.RELATION.CODE) = R.MB.SDB.STATUS<SDB.STA.RELATION.CODE>
                R.NEW(SDB.POST.JOINT.NOTES) = R.MB.SDB.STATUS<SDB.STA.JOINT.NOTES>
                IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'OPEN' THEN
                    R.NEW(SDB.POST.RENEW.FREQUENCY) = R.MB.SDB.STATUS<SDB.STA.RENEW.FREQUENCY>
                END
                R.NEW(SDB.POST.JOINT.HOLDER) = R.MB.SDB.STATUS<SDB.STA.JOINT.HOLDER>

                R.NEW(SDB.POST.PERIODIC.RENT) = R.MB.SDB.STATUS<SDB.STA.PERIODIC.RENT>
                R.NEW(SDB.POST.VAT.AMOUNT) = R.MB.SDB.STATUS<SDB.STA.VAT.AMOUNT>
                R.NEW(SDB.POST.DEPOSIT.AMT) = R.MB.SDB.STATUS<SDB.STA.DEPOSIT.AMT>
                R.NEW(SDB.POST.INITIAL.OFFER.AMT) = R.MB.SDB.STATUS<SDB.STA.INITIAL.OFFER.AMT>
                R.NEW(SDB.POST.VAT.OFFER.AMT) = R.MB.SDB.STATUS<SDB.STA.VAT.OFFER.AMT>
                R.NEW(SDB.POST.OFFER.EXPIRY.DATE) = R.MB.SDB.STATUS<SDB.STA.OFFER.EXPIRY.DATE>
                R.NEW(SDB.POST.DISCOUNT.AMT) = R.MB.SDB.STATUS<SDB.STA.DISCOUNT.AMT>
                R.NEW(SDB.POST.TOTAL.CHARGE.AMT) = R.MB.SDB.STATUS<SDB.STA.TOTAL.CHARGE.AMT>

                R.NEW(SDB.POST.RENEW.METHOD) = R.MB.SDB.STATUS<SDB.STA.RENEW.METHOD>
                R.NEW(SDB.POST.CUSTOMER.ACCT) = R.MB.SDB.STATUS<SDB.STA.CUSTOMER.ACCT>
                R.NEW(SDB.POST.ADD.ACCESS.CUST) = R.MB.SDB.STATUS<SDB.STA.ADD.ACCESS.CUST>
                R.NEW(SDB.POST.HOLDER.NAME) = R.MB.SDB.STATUS<SDB.STA.HOLDER.NAME>
                R.NEW(SDB.POST.AMORT.Y.N) = R.MB.SDB.STATUS<SDB.STA.AMORT.Y.N>
                R.NEW(SDB.POST.NO.OF.SIGNERS) = R.MB.SDB.STATUS<SDB.STA.NO.OF.SIGNERS>
                R.NEW(SDB.POST.STATUS) = R.MB.SDB.STATUS<SDB.STA.STATUS>
                R.NEW(SDB.POST.KEY.NUMBERS) = R.MB.SDB.STATUS<SDB.STA.KEY.NUMBERS>
                R.NEW(SDB.POST.MAINT.ACTION) = R.MB.SDB.STATUS<SDB.STA.MAINT.ACTION>
                R.NEW(SDB.POST.NOTES) = R.MB.SDB.STATUS<SDB.STA.NOTES>
            END

            IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'OPEN' THEN

* R.NEW(SDB.POST.CUSTOMER.NO) = ''

                R.NEW(SDB.POST.PERIODIC.RENT) = R.MB.SDB.TYPE<SDB.TYP.PERIODIC.RENT,SDB.COMP.POS>
                R.NEW(SDB.POST.DEPOSIT.AMT) = R.MB.SDB.TYPE<SDB.TYP.REFUND.DEPOSIT,SDB.COMP.POS>
                R.NEW(SDB.POST.RENEW.METHOD) = 'AUTO'

                IF R.NEW(SDB.POST.COLLECT.NEXT.P) EQ 'YES' THEN
                    R.NEW(SDB.POST.RENEW.FREQUENCY) = RENEWAL.DUE.ON
                END ELSE
                    R.NEW(SDB.POST.RENEW.FREQUENCY) = RENEW.FREQUENCY
                END

                IF NOT(R.NEW(SDB.POST.OFFER.EXPIRY.DATE)) THEN
                    R.NEW(SDB.POST.OFFER.EXPIRY.DATE) = RENEW.FREQUENCY[1,8]
                END
            END

            IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'MODIFY' THEN
                IF R.NEW(SDB.POST.CUSTOMER.ACCT) EQ '' THEN
                    T(SDB.POST.JOINT.HOLDER)<3> = 'NOINPUT'
                    T(SDB.POST.RELATION.CODE)<3> = 'NOINPUT'
                    T(SDB.POST.NO.OF.SIGNERS)<3> = 'NOINPUT'
                    T(SDB.POST.CUSTOMER.ACCT)<3> = 'NOINPUT'
                END ELSE
                    T(SDB.POST.JOINT.HOLDER)<3> = ''
                    T(SDB.POST.RELATION.CODE)<3> = ''
                    T(SDB.POST.NO.OF.SIGNERS)<3> = ''
                    T(SDB.POST.CUSTOMER.ACCT)<3> = ''
                END
            END

            IF SDB.STATUS AND R.NEW(SDB.POST.SDB.OPERATE) EQ 'CLOSE' THEN
                IF R.MB.SDB.STATUS<SDB.STA.NOTES> EQ '' THEN
                    RENEW.DATE = R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>
                    OFFER.EXPIRY.DATE = R.MB.SDB.STATUS<SDB.STA.OFFER.EXPIRY.DATE>
                    RENT.AMOUNT = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>

                    UNAMORT.RENT = ''; AMORTISED.RENT = ''

                    BEGIN CASE
                        CASE TODAY GE R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>
                            UNAMORT.RENT = '0.00'
                            AMORTISED.RENT = RENT.AMOUNT

                        CASE TODAY LT R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>

                            ONE.DAY = 0
                            IF R.MB.SDB.STATUS<SDB.STA.LAST.RENEWAL.DATE> THEN
                                START.DATE = R.MB.SDB.STATUS<SDB.STA.LAST.RENEWAL.DATE>
                            END ELSE
                                ONE.DAY = 1
                                START.DATE = R.MB.SDB.STATUS<SDB.STA.OPENING.DATE>
                            END

                            TOT.DAYS = 'C'
                            CALL CDD("", START.DATE,R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>, TOT.DAYS)
                            TOT.DAYS += ONE.DAY

                            NO.DAYS = 'C'
                            CALL CDD("", START.DATE, TODAY, NO.DAYS)
                            NO.DAYS += 1

                            AMORTISED.AMT = (RENT.AMOUNT / TOT.DAYS) * NO.DAYS
                            CALL EB.ROUND.AMOUNT(LCCY, AMORTISED.AMT, '2', '')
                            UNAMORT.RENT = RENT.AMOUNT - AMORTISED.AMT
                    END CASE

                    R.NEW(SDB.POST.NON.AMORT.AMT) = UNAMORT.RENT
                    R.NEW(SDB.POST.AMORTISED.AMT) = AMORTISED.AMT
                    R.NEW(SDB.POST.REFUND.AMT) = UNAMORT.RENT

                END ELSE
                    R.NEW(SDB.POST.NOTES) = R.MB.SDB.STATUS<SDB.STA.NOTES>
                END
            END
        END
    END
*CALL REBUILD.SCREEN
    EB.Display.RebuildScreen() ;*Manual R22 Conversion - Call routine format modified

RETURN

************************************************************************
READ.SDB.TYPE:

    R.MB.SDB.TYPE = ''; YERR = ''
    CALL F.READ(FN.MB.SDB.TYPE,MB.SDB.TYPE.ID,R.MB.SDB.TYPE,F.MB.SDB.TYPE,YERR)
    MB.SDB.PARAM.ID = R.NEW(SDB.POST.SDB.COMPANY); R.MB.SDB.PARAM = ''; YERR = ''
* CALL F.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,F.MB.SDB.PARAM,YERR)
    CALL CACHE.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,YERR);*Manual R22 Conversion - Change F.READ to CACHE.READ.
    FREQ.TYPE = R.MB.SDB.PARAM<SDB.PAR.FREQ.TYPE>
    RENEW.FREQUENCY = R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY>

    SV.COMI = COMI
    IF RENEW.FREQUENCY AND RENEW.FREQUENCY[1,8] LE TODAY THEN

        LOOP UNTIL RENEW.FREQUENCY[1,8] GT TODAY
            COMI = RENEW.FREQUENCY; CALL CFQ
            RENEW.FREQUENCY = COMI
        REPEAT

        R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY> = RENEW.FREQUENCY
    END

    IF NOT(RENEW.FREQUENCY) THEN
        IF FREQ.TYPE EQ 'YEARLY' THEN
            COMI = TODAY:'M12':TODAY[7,2]
        END ELSE
            COMI = TODAY:'M01':TODAY[7,2]
        END

        CALL CFQ
        RENEW.FREQUENCY = COMI
    END

    COMI = RENEW.FREQUENCY
    CALL CFQ; RENEWAL.DUE.ON = COMI
    COMI = SV.COMI

RETURN
************************************************************************
INITIALISE:

    E = ''
    ETEXT = ''

    FN.MB.SDB.TYPE = 'F.MB.SDB.TYPE' ; F.MB.SDB.TYPE = ''
    CALL OPF(FN.MB.SDB.TYPE,F.MB.SDB.TYPE)

    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM' ; F.MB.SDB.PARAM = ''
*CALL OPF(FN.MB.SDB.PARAM,F.MB.SDB.PARAM) ;*Manual R22 Conversion - Command the CALL OPF due to CACHE.READ.

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'; F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    GOSUB READ.SDB.TYPE

RETURN

************************************************************************
PROGRAM.END:

    IF E THEN
        MESSAGE = 'REPEAT'; CALL ERR
    END

RETURN
************************************************************************
END
