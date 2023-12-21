* @ValidationCode : MjoxNzkwMjE3OTQ6VVRGLTg6MTcwMjYyMzU1MjgwMDpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 15 Dec 2023 12:29:12
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.CALC.AMORT(SDB.NO,RET.AMORT.DETAIL,RET.ERR)
*-----------------------------------------------------------------------------
* Routine will calculate the amortisation of the rents for safe deposit boxes. It will
* have two arguments
* Arguments
*-----------
* Incoming - SDB.NO - Shoul contain the safe box type and no. e.g. A1.1000
* Outgoing - AMORT.DETAIL - Array of the amortised and unamortised amts as below
*               AMORT.DETAIL<1> --> Rent amount paid (including Initial offer)
*               AMORT.DETAIL<2> -->Amortised in this month
*               AMORT.DETAIL<3> -->
*               AMORT.DETAIL<4> -->
*            RET.ERR - Error message if any.


* It will return to the RENT,AMORTISED RENT, UNAMORTISED RENT and monthly amort amt,
*
* 12-APR-2023     Conversion tool    R22 Auto conversion    IF condition added
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 15-12-2023      Narmadha V        Manual R22 Conversion    FN variable modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MB.SDB.TYPE
    $INSERT I_F.MB.SDB.CHARGES
    $INSERT I_F.MB.SDB.STATUS
*
    GOSUB INITIALISE
    IF RET.ERR NE '' THEN ;*R22 Auto conversion
        AMORT.DETAIL = ''       ;* Incomplete data is not sent
    END			  ;*R22 Auto conversion
*-----------------------------------------------------------------------------
INITIALISE:

    SDB.COMPANY = ID.COMPANY
    SDB.COMP.POST = ''        ;* Initialise
    MB.SDB.CHARGES.ID = SDB.COMPANY:'.':SDB.NO
    MB.SDB.STATUS.ID = MB.SDB.CHARGES.ID          ;* both have same id
    MB.SDB.TYPE.ID = FIELD(MB.SDB.CHARGES.ID,'.',2)
*
    R.MB.SDB.TYPE = '' ; YERR = ''
    FN.MB.SDB.TYPE ="F.MB.SDB.TYPE"
* CALL CACHE.READ('F.MB.SDB.TYPE',MB.SDB.TYPE.ID,R.MB.SDB.TYPE,YERR)          ;* CACHE.READ will take care of OPEN
    CALL CACHE.READ(FN.MB.SDB.TYPE,MB.SDB.TYPE.ID,R.MB.SDB.TYPE,YERR) ;*Manual R22 Conversion - FN variable modified
    IF YERR THEN
        RET.ERR = 'Safe box type not found'
        RETURN
    END
*
    R.MB.SDB.CHARGES = '' ; YERR = ''
    FN.MB.SDB.CHARGES = "F.MB.SDB.CHARGES"
* CALL CACHE.READ('F.MB.SDB.CHARGES',MB.SDB.CHARGES.ID,R.MB.SDB.CHARGES,YERR) ;* for initial offer amt
    CALL CACHE.READ(FN.MB.SDB.CHARGES,MB.SDB.CHARGES.ID,R.MB.SDB.CHARGES,YERR) ;*Manual R22 Conversion - FN variable modified
    IF YERR THEN
        RET.ERR = 'Box Charges details not found'
        RETURN
    END
*
    R.MB.SDB.STATUS = '' ; YERR = ''
    FN.MB.SDB.STATUS = "F.MB.SDB.STATUS"
*CALL CACHE.READ('F.MB.SDB.STATUS',MB.SDB.STATUS.ID,R.MB.SDB.STATUS,YERR)    ;* for initial offer amt
    CALL CACHE.READ(FN.MB.SDB.STATUS,MB.SDB.STATUS.ID,R.MB.SDB.STATUS,YERR) ;*Manual R22 Conversion - FN variable modified
    IF YERR THEN
        RET.ERR = 'Box Charges details not found'
        RETURN
    END
*
    LOCATE ENQUIRY.COMPANY IN R.MB.SDB.TYPE<SDB.TYP.BRANCH.CODE,1> SETTING SDB.COMP.POS ELSE SDB.COMP.POS = ''
*
    IF SDB.COMP.POS THEN
        PERIODIC.RENT = R.MB.SDB.TYPE<SDB.TYP.PERIODIC.RENT>
        INITIAL.OFFER = R.MB.SDB.CHARGES<SDB.CHG.INITIAL.OFFER.AMT,1> ;* only the first one will have the offer others are only renewal
        TOTAL.RENT = PERIODIC.RENT + INITIAL.OFFER
*
        START.DATE = R.MB.SDB.STATUS<SDB.STA.OPENING.DATE>
        RENEW.DATE = O.DATA['*',2,1]
        NO.OF.DAYS = 'C'
        CALL CDD("",START.DATE,RENEW.DATE,NO.OF.DAYS)       ;*Total month including initial offer
        RENT.FOR.MONTHS = INT(NO.OF.DAYS/30)      ;* no of months for the duration of hire till next renewal date
*
        MTH.RENT.AMT = TOTAL.RENT/RENT.FOR.MONTHS
        CALL EB.ROUND.AMOUNT(LCCY,MTH.RENT.AMT,'2','')
*
        NO.OF.DAYS = 'C'
        CALL CDD("",TODAY,RENEW.DATE,NO.OF.DAYS)
        REMAIN.MONTHS = INT(NO.OF.DAYS/30)        ;* This does not include the current month
*
        UNAMORT.RENT = (TOTAL.RENT/RENT.FOR.MONTHS) * REMAIN.MONTHS
        CALL EB.ROUND.AMOUNT(LCCY,UNAMORT.RENT,'2','')
        AMORTISED.AMT = TOTAL.RENT - UNAMORT.RENT
        IF REMAIN.MONTHS LT RENT.FOR.MONTHS THEN
* if it is 12 months then there is no amortisation has happened yet!!!
* And the remain.months cannot be greater than 12 as the system cannot accept.
            AMORT.LAST.MTH.AMT = AMORTISED.AMT - MTH.RENT.AMT
            UNAMORT.LAST.MTH.AMT = PERIODIC.RENT - AMORT.LAST.MTH.AMT
        END ELSE
            AMORT.LAST.MTH.AMT = 0
            UNAMORT.LAST.MTH.AMT = 0
        END
        O.DATA = PERIODIC.RENT:'*':AMORT.LAST.MTH.AMT:'*':UNAMORT.LAST.MTH.AMT
        O.DATA := '*':AMORTISED.AMT:'*':UNAMORT.RENT:'*':MTH.RENT.AMT
    END

RETURN
*-----------------------------------------------------------------------------
END
