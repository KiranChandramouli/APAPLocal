* @ValidationCode : MjotNjY4MzY0NzE5OkNwMTI1MjoxNjgxOTc5NTk1NDgzOklUU1M6LTE6LTE6NDA1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 14:03:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 405
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.E.SDB.GET.AMORT.AMT
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MB.SDB.STATUS

    IF O.DATA THEN

        FN.MB.SDB.STATUS = 'F.MB.SDB.STATUS'; F.MB.SDB.STATUS = ''
        CALL OPF(FN.MB.SDB.STATUS, F.MB.SDB.STATUS)

        COMPANY.CODE = FIELD(O.DATA,'.',1,1)
        MB.SDB.STATUS.ID = O.DATA
        MB.SDB.STATUS.ID = FIELD(MB.SDB.STATUS.ID,'*',1,1)
        R.MB.SDB.STATUS = '' ; YERR = ''
        CALL F.READ(FN.MB.SDB.STATUS, MB.SDB.STATUS.ID, R.MB.SDB.STATUS, F.MB.SDB.STATUS, YERR)

        TOTAL.RENT = R.MB.SDB.STATUS<SDB.STA.RENT.AMT>
        RENEW.DATE = R.MB.SDB.STATUS<SDB.STA.RENEWAL.DUE.ON>

        ONE.DAY = 0
        START.DATE = R.MB.SDB.STATUS<SDB.STA.LAST.RENEWAL.DATE>
        IF START.DATE EQ '' THEN
            ONE.DAY = 1
            START.DATE = R.MB.SDB.STATUS<SDB.STA.OPENING.DATE>
        END

        LAST.MTH.END = TODAY; LAST.MTH.END[7,2] = '01'
        CALL CDT('', LAST.MTH.END, '-1C')
        SAVE.COMI = COMI; COMI = LAST.MTH.END:'M0131'
        CALL CFQ; NEXT.MTH.END = COMI[1,8]; COMI = SAVE.COMI

        TOT.DAYS = 'C'
        CALL CDD("",START.DATE, RENEW.DATE, TOT.DAYS)
        TOT.DAYS += ONE.DAY

        NO.DAYS = 'C'
        CALL CDD("",START.DATE, NEXT.MTH.END, NO.DAYS)
        NO.DAYS += 1

        IF RENEW.DATE LE NEXT.MTH.END THEN
            THIS.MTH.AMORT = TOTAL.RENT
        END ELSE
            THIS.MTH.AMORT = (TOTAL.RENT / TOT.DAYS) * NO.DAYS
            CALL EB.ROUND.AMOUNT(LCCY, THIS.MTH.AMORT, '2', '')
        END

        AMORTISED.AMT = R.MB.SDB.STATUS<SDB.STA.AMORT.AMT>
        UNAMORTISED.AMT = R.MB.SDB.STATUS<SDB.STA.UNAMORT.AMT>

        THIS.MTH.UNAMORT = TOTAL.RENT - THIS.MTH.AMORT

        O.DATA = TOTAL.RENT:'*':AMORTISED.AMT:'*':UNAMORTISED.AMT:'*':THIS.MTH.AMORT:'*':THIS.MTH.UNAMORT
    END

RETURN

END
