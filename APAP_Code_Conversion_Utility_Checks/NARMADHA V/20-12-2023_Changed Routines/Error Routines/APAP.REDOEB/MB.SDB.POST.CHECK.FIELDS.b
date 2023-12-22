* @ValidationCode : MjotNzI3NTk2NDg3OlVURi04OjE3MDI4ODU5NDY4NDk6QWRtaW46LTE6LTE6MDowOnRydWU6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Dec 2023 13:22:26
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.POST.CHECK.FIELDS
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-APR-2023     Conversion tool    R22 Auto conversion       = to EQ, FM to @FM, X to X.VAR
* 13-APR-2023      Harishvikram C   Manual R22 conversion      CALL routine format modified
* 15-12-2023      Narmadha V        Manual R22 Conversion      Call Routine format Modified, F.READ to CACHE.READ
*-----------------------------------------------------------------------------
*    $INCLUDE GLOBUS.BP I_COMMON        ;*/ TUS START
*    $INCLUDE GLOBUS.BP I_EQUATE
*    $INCLUDE GLOBUS.BP I_F.CUSTOMER
*    $INCLUDE GLOBUS.BP I_F.ACCOUNT
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.POST
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.PARAM
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.TYPE
*    $INCLUDE CAPLATFORM.BP I_F.MB.SDB.STATUS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.MB.SDB.POST
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_F.MB.SDB.TYPE
    $INSERT I_F.MB.SDB.STATUS        ;*/ TUS END
    $USING EB.Display
    GOSUB INITIALISE

    GOSUB CHECK.FIELDS

*CALL REBUILD.SCREEN
    EB.Display.RebuildScreen() ;*Manual R22 Conversion - Call Routine format Modified

    GOSUB PROGRAM.END ;* R22 Manual conversion - GOTO to GOSUB

************************************************************************
INITIALISE:

    E = ''
    ETEXT = ''

    MB.SDB.TYPE.ID = ''

    FN.MB.SDB.TYPE = 'F.MB.SDB.TYPE'
    F.MB.SDB.TYPE = ''
    CALL OPF(FN.MB.SDB.TYPE,F.MB.SDB.TYPE)

    FN.MB.SDB.PARAM = 'F.MB.SDB.PARAM'
    F.MB.SDB.PARAM = ''
    CALL OPF(FN.MB.SDB.PARAM,F.MB.SDB.PARAM)

    FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'
    F.MB.SDB.STATUS = ''
    CALL OPF(FN.MB.SDB.STATUS,F.MB.SDB.STATUS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    GOSUB READ.SDB.TYPE

RETURN

************************************************************************
READ.SDB.TYPE:

    IF NOT(MB.SDB.TYPE.ID) THEN
        MB.SDB.TYPE.ID = FIELD(R.NEW(SDB.POST.SDB.NUMBER),'.',1)
    END

    R.MB.SDB.TYPE = ''; YERR = ''
    CALL F.READ(FN.MB.SDB.TYPE,MB.SDB.TYPE.ID,R.MB.SDB.TYPE,F.MB.SDB.TYPE,YERR)
     
    MB.SDB.PARAM.ID = R.NEW(SDB.POST.SDB.COMPANY); R.MB.SDB.PARAM = ''; YERR = ''
*CALL F.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,F.MB.SDB.PARAM,YERR)
    CALL CACHE.READ(FN.MB.SDB.PARAM,MB.SDB.PARAM.ID,R.MB.SDB.PARAM,YERR) ;*Manual R22 Conversion - Call Routine format modified
    DISC.GROUP = R.MB.SDB.PARAM<SDB.PAR.DISC.GROUP>
    DISC.FLAT.AMT = R.MB.SDB.PARAM<SDB.PAR.DISC.FLAT.AMT>
    DISC.PERCENT = R.MB.SDB.PARAM<SDB.PAR.DISC.PERCENT>
    STAFF.GROUP = R.MB.SDB.PARAM<SDB.PAR.STAFF.GROUP>
    FREQ.TYPE = R.MB.SDB.PARAM<SDB.PAR.FREQ.TYPE>
    VAT.PERCENT = R.MB.SDB.PARAM<SDB.PAR.VAT.PERCENT>

    RENEW.FREQUENCY = R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY>

    SV.COMI = ''; SV.COMI = COMI
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

    R.MB.SDB.STATUS = ''; YERR.MSG = ''; SDB.STATUS = ''
    MB.SDB.STATUS.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)
    CALL F.READ(FN.MB.SDB.STATUS,MB.SDB.STATUS.ID,R.MB.SDB.STATUS,F.MB.SDB.STATUS,YERR.MSG)
    IF R.MB.SDB.STATUS THEN
        SDB.STATUS = 1
    END ELSE
        SDB.STATUS = 0
    END

RETURN

************************************************************************
CHECK.FIELDS:

    BEGIN CASE

        CASE AF EQ SDB.POST.SDB.NUMBER

            IF INDEX(COMI,'.',1) THEN
                SDB.SEQ.NO = FIELD(COMI,'.',2)
                MB.SDB.TYPE.ID = FIELD(COMI,'.',1)
                GOSUB READ.SDB.TYPE
                SDB.AVAIL.COMP = R.MB.SDB.TYPE<SDB.TYP.BRANCH.CODE>
                IF YERR THEN
                    E = MB.SDB.TYPE.ID:' is not a valid Safe Box type'
                    RETURN
                END ELSE
                    LOCATE R.NEW(SDB.POST.SDB.COMPANY) IN SDB.AVAIL.COMP<1,1> SETTING SDB.COMP.POS ELSE SDB.COMP.POS = ''
                    IF SDB.COMP.POS THEN
                        MB.SDB.STATUS.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':COMI
                        R.MB.SDB.STATUS = ''
* CALL MB.SDB.READ.SDB.STATUS(MB.SDB.STATUS.ID,R.MB.SDB.STATUS)
                        APAP.REDOEB.mbSdbReadSdbStatus(MB.SDB.STATUS.ID,R.MB.SDB.STATUS);*Manual R22 conversion
                        IF R.MB.SDB.STATUS THEN
                            SDB.STATUS = 1
                        END ELSE
                            SDB.STATUS = 0
                            E = "EB-SEQ.NO.NOT.AVAILABLE" :@FM: SDB.SEQ.NO
                            RETURN
                        END
                    END ELSE
                        E = 'EB-BOX.TYPE.NOT.AVAILABLE' :@FM: MB.SDB.TYPE.ID
                        RETURN
                    END
                END
            END ELSE
                E = 'EB-INVALID.BOX.NUMBER'
                RETURN
            END

            COMI.ENRI = R.MB.SDB.TYPE<SDB.TYP.DESCRIPTION>

            IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'OPEN' THEN
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

            IF SDB.STATUS THEN

                R.NEW(SDB.POST.CUSTOMER.NO) = R.MB.SDB.STATUS<SDB.STA.CUSTOMER.NO>
                R.NEW(SDB.POST.JOINT.HOLDER) = R.MB.SDB.STATUS<SDB.STA.JOINT.HOLDER>
                R.NEW(SDB.POST.RELATION.CODE) = R.MB.SDB.STATUS<SDB.STA.RELATION.CODE>
                R.NEW(SDB.POST.JOINT.NOTES) = R.MB.SDB.STATUS<SDB.STA.JOINT.NOTES>
                R.NEW(SDB.POST.STATUS) = R.MB.SDB.STATUS<SDB.STA.STATUS>

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

                R.NEW(SDB.POST.CUSTOMER.ACCT) = R.MB.SDB.STATUS<SDB.STA.CUSTOMER.ACCT>
                R.NEW(SDB.POST.ADD.ACCESS.CUST) = R.MB.SDB.STATUS<SDB.STA.ADD.ACCESS.CUST>
                R.NEW(SDB.POST.HOLDER.NAME) = R.MB.SDB.STATUS<SDB.STA.HOLDER.NAME>
                R.NEW(SDB.POST.NO.OF.SIGNERS) = R.MB.SDB.STATUS<SDB.STA.NO.OF.SIGNERS>

                R.NEW(SDB.POST.STATUS) = R.MB.SDB.STATUS<SDB.STA.STATUS>
                R.NEW(SDB.POST.KEY.NUMBERS) = R.MB.SDB.STATUS<SDB.STA.KEY.NUMBERS>
                R.NEW(SDB.POST.MAINT.ACTION) = R.MB.SDB.STATUS<SDB.STA.MAINT.ACTION>
                R.NEW(SDB.POST.NOTES) = R.MB.SDB.STATUS<SDB.STA.NOTES>
            END

            IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'OPEN' THEN
                R.NEW(SDB.POST.CUSTOMER.NO) = ''
            END

            IF SDB.STATUS AND R.NEW(SDB.POST.SDB.OPERATE) EQ 'CLOSE' THEN
                IF R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON> NE '' THEN
                    UNAMORT.RENT = ''; AMORTISED.AMT = ''
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


        CASE AF EQ SDB.POST.REFUND.AMT

            IF SDB.STATUS AND R.NEW(SDB.POST.SDB.OPERATE) EQ 'CLOSE' THEN
                IF R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON> NE '' THEN
                    RENEW.DATE = R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>
                    OFFER.EXPIRY.DATE = R.MB.SDB.STATUS<SDB.STA.OFFER.EXPIRY.DATE>
                    RENT.AMOUNT = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>

                    UNAMORT.RENT = COMI
                    AMORTISED.AMT = RENT.AMOUNT - UNAMORT.RENT

                    IF COMI GT RENT.AMOUNT THEN
                        E = "EB-REFUND.AMT.GT.RENT.AMT"
                        RETURN
                    END

                    IF AMORTISED.AMT LT R.MB.SDB.STATUS<SDB.STA.AMORT.AMT> THEN
                        E = "EB-REFUND.AMT.NOT.GT.AMORT.AMT" :@FM: R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT>
                        RETURN
                    END

                    R.NEW(SDB.POST.NON.AMORT.AMT) = UNAMORT.RENT
                    R.NEW(SDB.POST.AMORTISED.AMT) = AMORTISED.AMT
                END
            END

        CASE AF EQ SDB.POST.CUSTOMER.NO
            IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'OPEN' THEN
                SDB.AVAIL.COMP = R.MB.SDB.TYPE<SDB.TYP.BRANCH.CODE>
                LOCATE R.NEW(SDB.POST.SDB.COMPANY) IN SDB.AVAIL.COMP<1,1> SETTING SDB.COMP.POS THEN
                    PERIODIC.RENT = R.MB.SDB.TYPE<SDB.TYP.PERIODIC.RENT,SDB.COMP.POS>
                    R.NEW(SDB.POST.DEPOSIT.AMT) = R.MB.SDB.TYPE<SDB.TYP.REFUND.DEPOSIT,SDB.COMP.POS>
                END

                R.NEW(SDB.POST.CUSTOMER.NO) = COMI

                GOSUB GET.CUST.GROUP

                IF STAFF.FLAG THEN
                    R.NEW(SDB.POST.DEPOSIT.AMT) = '0'
                END

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

                R.NEW(SDB.POST.PERIODIC.RENT) = PERIODIC.RENT
                R.NEW(SDB.POST.DISCOUNT.AMT) = CUST.DISC.AMT

                IF R.NEW(SDB.POST.COLLECT.NEXT.P) EQ 'YES' THEN
                    R.NEW(SDB.POST.RENEW.FREQUENCY) = RENEWAL.DUE.ON
                END ELSE
                    R.NEW(SDB.POST.RENEW.FREQUENCY) = RENEW.FREQUENCY
                END

                IF R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY> THEN
                    TOT.AMOUNT = R.NEW(SDB.POST.PERIODIC.RENT)

                    NO.DAYS = 'C'; END.DATE = RENEW.FREQUENCY[1,8]
                    CALL CDD("", TODAY, END.DATE, NO.DAYS)


                    START.DATE = RENEW.FREQUENCY
                    GOSUB GET.START.DATE

                    TOT.DAYS = 'C'
                    CALL CDD("", START.DATE, END.DATE, TOT.DAYS)

                    INITIAL.OFFER = (TOT.AMOUNT / TOT.DAYS) * NO.DAYS
                    CALL EB.ROUND.AMOUNT(LCCY, INITIAL.OFFER, '2', '')
                END ELSE
                    INITIAL.OFFER = R.NEW(SDB.POST.PERIODIC.RENT)
                END

                R.NEW(SDB.POST.INITIAL.OFFER.AMT) = INITIAL.OFFER

                VAT.AMOUNT = R.NEW(SDB.POST.PERIODIC.RENT) * (VAT.PERCENT/100)
                CALL EB.ROUND.AMOUNT(LCCY, VAT.AMOUNT, '2', '')

                VAT.OFFER.AMT = R.NEW(SDB.POST.INITIAL.OFFER.AMT) * (VAT.PERCENT/100)
                CALL EB.ROUND.AMOUNT(LCCY, VAT.OFFER.AMT, '2', '')

                IF R.NEW(SDB.POST.COLLECT.NEXT.P) EQ 'YES' THEN
                    TOTAL.CHARGE.AMT = R.NEW(SDB.POST.PERIODIC.RENT) + VAT.AMOUNT + R.NEW(SDB.POST.INITIAL.OFFER.AMT) + VAT.OFFER.AMT + R.NEW(SDB.POST.DEPOSIT.AMT)
                END ELSE
                    TOTAL.CHARGE.AMT = R.NEW(SDB.POST.INITIAL.OFFER.AMT) + VAT.OFFER.AMT + R.NEW(SDB.POST.DEPOSIT.AMT)
                END
                R.NEW(SDB.POST.VAT.AMOUNT) = VAT.AMOUNT
                R.NEW(SDB.POST.VAT.OFFER.AMT) = VAT.OFFER.AMT
                R.NEW(SDB.POST.TOTAL.CHARGE.AMT) = TOTAL.CHARGE.AMT
                R.NEW(SDB.POST.AMORT.Y.N) = 'Y'
            END

        CASE AF EQ SDB.POST.COLLECT.NEXT.P
            IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'OPEN' THEN

                IF COMI EQ 'YES' THEN
                    R.NEW(SDB.POST.RENEW.FREQUENCY) = RENEWAL.DUE.ON
                END ELSE
                    R.NEW(SDB.POST.RENEW.FREQUENCY) = RENEW.FREQUENCY
                END

                IF NOT(R.NEW(SDB.POST.INITIAL.OFFER.AMT)) THEN
                    IF R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY> THEN
                        TOT.AMOUNT = R.NEW(SDB.POST.PERIODIC.RENT)

                        NO.DAYS = 'C'; END.DATE = RENEW.FREQUENCY[1,8]
                        CALL CDD("", TODAY, END.DATE, NO.DAYS)

                        START.DATE = RENEW.FREQUENCY
                        GOSUB GET.START.DATE

                        TOT.DAYS = 'C'
                        CALL CDD("", START.DATE, END.DATE, TOT.DAYS)

                        INITIAL.OFFER = (TOT.AMOUNT / TOT.DAYS) * NO.DAYS
                        CALL EB.ROUND.AMOUNT(LCCY, INITIAL.OFFER, '2', '')
                    END ELSE
                        INITIAL.OFFER = R.NEW(SDB.POST.PERIODIC.RENT)
                    END
                    R.NEW(SDB.POST.INITIAL.OFFER.AMT) = INITIAL.OFFER
                END

                VAT.AMOUNT = R.NEW(SDB.POST.PERIODIC.RENT) * (VAT.PERCENT/100)
                CALL EB.ROUND.AMOUNT(LCCY, VAT.AMOUNT, '2', '')

                VAT.OFFER.AMT = R.NEW(SDB.POST.INITIAL.OFFER.AMT) * (VAT.PERCENT/100)
                CALL EB.ROUND.AMOUNT(LCCY, VAT.OFFER.AMT, '2', '')

                IF COMI EQ 'YES' THEN
                    TOTAL.CHARGE.AMT = R.NEW(SDB.POST.PERIODIC.RENT) + VAT.AMOUNT + R.NEW(SDB.POST.INITIAL.OFFER.AMT) + VAT.OFFER.AMT + R.NEW(SDB.POST.DEPOSIT.AMT)
                END ELSE
                    TOTAL.CHARGE.AMT = R.NEW(SDB.POST.INITIAL.OFFER.AMT) + VAT.OFFER.AMT + R.NEW(SDB.POST.DEPOSIT.AMT)
                END
                R.NEW(SDB.POST.VAT.AMOUNT) = VAT.AMOUNT
                R.NEW(SDB.POST.VAT.OFFER.AMT) = VAT.OFFER.AMT
                R.NEW(SDB.POST.TOTAL.CHARGE.AMT) = TOTAL.CHARGE.AMT
            END

        CASE AF EQ SDB.POST.INITIAL.OFFER.AMT
            IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'OPEN' THEN

                VAT.OFFER.AMT = COMI * (VAT.PERCENT/100)
                CALL EB.ROUND.AMOUNT(LCCY, VAT.OFFER.AMT, '2', '')

                IF R.NEW(SDB.POST.COLLECT.NEXT.P) EQ 'YES' THEN
                    TOTAL.CHARGE.AMT = R.NEW(SDB.POST.PERIODIC.RENT) + R.NEW(SDB.POST.VAT.AMOUNT) + COMI + VAT.OFFER.AMT + R.NEW(SDB.POST.DEPOSIT.AMT)
                END ELSE
                    TOTAL.CHARGE.AMT = COMI + VAT.OFFER.AMT + R.NEW(SDB.POST.DEPOSIT.AMT)
                END
                R.NEW(SDB.POST.VAT.OFFER.AMT) = VAT.OFFER.AMT
                R.NEW(SDB.POST.TOTAL.CHARGE.AMT) = TOTAL.CHARGE.AMT
                R.NEW(SDB.POST.AMORT.Y.N) = 'Y'
            END

        CASE AF EQ SDB.POST.ACCESS.TIME
            IF COMI GT 2400 THEN
                E = "EB-INVALID.TIME"
                RETURN
            END ELSE
                X.VAR = FMT(COMI,'4"0"R')
                IF X.VAR[3,2] GT 59 THEN
                    E = "EB-MINS.LT.60"
                    RETURN
                END
            END

        CASE AF EQ SDB.POST.CUSTOMER.ACCT
            IF R.NEW(SDB.POST.SDB.OPERATE) EQ 'OPEN' THEN
                SDB.AVAIL.COMP = R.MB.SDB.TYPE<SDB.TYP.BRANCH.CODE>
                LOCATE R.NEW(SDB.POST.SDB.COMPANY) IN SDB.AVAIL.COMP<1,1> SETTING SDB.COMP.POS THEN
                    PERIODIC.RENT = R.MB.SDB.TYPE<SDB.TYP.PERIODIC.RENT,SDB.COMP.POS>
                    R.NEW(SDB.POST.DEPOSIT.AMT) = R.MB.SDB.TYPE<SDB.TYP.REFUND.DEPOSIT,SDB.COMP.POS>
                END

                R.NEW(SDB.POST.CUSTOMER.ACCT) = COMI

                GOSUB GET.CUST.GROUP

                IF STAFF.FLAG THEN
                    R.NEW(SDB.POST.DEPOSIT.AMT) = '0'
                END

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

                R.NEW(SDB.POST.PERIODIC.RENT) = PERIODIC.RENT
                R.NEW(SDB.POST.DISCOUNT.AMT) = CUST.DISC.AMT

                IF R.NEW(SDB.POST.COLLECT.NEXT.P) EQ 'YES' THEN
                    R.NEW(SDB.POST.RENEW.FREQUENCY) = RENEWAL.DUE.ON
                END ELSE
                    R.NEW(SDB.POST.RENEW.FREQUENCY) = RENEW.FREQUENCY
                END

                IF R.MB.SDB.PARAM<SDB.PAR.RENEW.FREQUENCY> THEN
                    TOT.AMOUNT = R.NEW(SDB.POST.PERIODIC.RENT)

                    NO.DAYS = 'C'; END.DATE = RENEW.FREQUENCY[1,8]
                    CALL CDD("", TODAY, END.DATE, NO.DAYS)

                    START.DATE = RENEW.FREQUENCY
                    GOSUB GET.START.DATE

                    TOT.DAYS = 'C'
                    CALL CDD("", START.DATE, END.DATE, TOT.DAYS)

                    INITIAL.OFFER = (TOT.AMOUNT / TOT.DAYS) * NO.DAYS
                    CALL EB.ROUND.AMOUNT(LCCY, INITIAL.OFFER, '2', '')
                END ELSE
                    INITIAL.OFFER = R.NEW(SDB.POST.PERIODIC.RENT)
                END
                R.NEW(SDB.POST.INITIAL.OFFER.AMT) = INITIAL.OFFER

                VAT.AMOUNT = R.NEW(SDB.POST.PERIODIC.RENT) * (VAT.PERCENT/100)
                CALL EB.ROUND.AMOUNT(LCCY, VAT.AMOUNT, '2', '')

                VAT.OFFER.AMT = R.NEW(SDB.POST.INITIAL.OFFER.AMT) * (VAT.PERCENT/100)
                CALL EB.ROUND.AMOUNT(LCCY, VAT.OFFER.AMT, '2', '')

                IF R.NEW(SDB.POST.COLLECT.NEXT.P) EQ 'YES' THEN
                    TOTAL.CHARGE.AMT = R.NEW(SDB.POST.PERIODIC.RENT) + VAT.AMOUNT + R.NEW(SDB.POST.INITIAL.OFFER.AMT) + VAT.OFFER.AMT + R.NEW(SDB.POST.DEPOSIT.AMT)
                END ELSE
                    TOTAL.CHARGE.AMT = R.NEW(SDB.POST.INITIAL.OFFER.AMT) + VAT.OFFER.AMT + R.NEW(SDB.POST.DEPOSIT.AMT)
                END
                R.NEW(SDB.POST.VAT.AMOUNT) = VAT.AMOUNT
                R.NEW(SDB.POST.VAT.OFFER.AMT) = VAT.OFFER.AMT
                R.NEW(SDB.POST.TOTAL.CHARGE.AMT) = TOTAL.CHARGE.AMT
                R.NEW(SDB.POST.AMORT.Y.N) = 'Y'
            END
    END CASE

RETURN

************************************************************************
GET.CUST.GROUP:

    CUST.GROUP = ''
    DISCOUNT.FLAT = ''; DISCOUNT.PERCENT = ''; STAFF.FLAG = ''

    IF R.NEW(SDB.POST.CUSTOMER.NO) THEN
        APPL.R = ''
        APPL.ID = R.NEW(SDB.POST.SDB.COMPANY):'.':R.NEW(SDB.POST.SDB.NUMBER)

        APPL.R<SDB.STA.CUSTOMER.NO> = R.NEW(SDB.POST.CUSTOMER.NO)
        IF AF EQ SDB.POST.CUSTOMER.ACCT THEN
            APPL.R<SDB.STA.CUSTOMER.ACCT> = COMI
        END ELSE
            APPL.R<SDB.STA.CUSTOMER.ACCT> = R.NEW(SDB.POST.CUSTOMER.ACCT)
        END

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
************************************************************************
GET.START.DATE:

    IF FREQ.TYPE EQ 'YEARLY' THEN
        Y.YEAR = START.DATE[1,4] -1
        START.DATE = Y.YEAR : START.DATE[5,4]
    END ELSE
        Y.YEAR = START.DATE[1,4]; Y.MONTH = START.DATE[5,2]; Y.DAY = START.DATE[7,2]
        IF Y.MONTH GT 1 THEN
            Y.MONTH -= 1
            IF LEN(Y.MONTH) EQ 1 THEN
                Y.MONTH = "0":Y.MONTH
            END ;*R22 Auto conversion
            START.DATE = Y.YEAR : Y.MONTH : Y.DAY
        END ELSE
            Y.YEAR -= 1; Y.MONTH = 12
            START.DATE = Y.YEAR : Y.MONTH : Y.DAY
        END
    END

    Y.YEAR = START.DATE[1,4]; Y.MONTH = START.DATE[5,2]; Y.DAY = START.DATE[7,2]

    IF Y.MONTH EQ "02" THEN
        IF MOD(Y.YEAR,4) EQ 0 THEN
            YLAST.DAY = "29"
        END ELSE
            YLAST.DAY = "28"
        END
    END ELSE
        IF INDEX("04 06 09 11",Y.MONTH,1) GT 0 THEN
            YLAST.DAY = "30"
        END ELSE
            YLAST.DAY = "31"
        END
    END

    IF Y.DAY GT YLAST.DAY THEN
        Y.DAY = YLAST.DAY
    END ;*R22 Auto conversion

    START.DATE = Y.YEAR : Y.MONTH : Y.DAY

RETURN

************************************************************************
DEFAULT.FIELDS:

    BEGIN CASE
        CASE AF EQ SDB.POST.ACCESS.DATE AND V$FUNCTION EQ 'I'
            IF COMI EQ '' THEN
                COMI = TODAY
            END
        CASE AF EQ SDB.POST.ACCESS.TIME AND V$FUNCTION EQ 'I'
            IF COMI EQ '' THEN
                COMI = OCONV(TIME(),'MTS')[1,2]:OCONV(TIME(),'MTS')[4,2]
            END
    END CASE

*CALL REFRESH.FIELD(AF,"")
    EB.Display.RefreshField(AF,"") ;*Manual R22 Conversion - Call Routine Format Modified

RETURN

************************************************************************
PROGRAM.END:

RETURN

END
