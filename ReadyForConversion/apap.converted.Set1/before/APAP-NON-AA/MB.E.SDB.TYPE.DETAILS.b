*-----------------------------------------------------------------------------
* <Rating>97</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE MB.E.SDB.TYPE.DETAILS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MB.SDB.TYPE

    IN.DATA = O.DATA
    SDB.COMP.POST = ''        ;* Initialise
    MB.SDB.TYPE.ID = FIELD(IN.DATA,'.',2)
    REC.COMPANY = FIELD(IN.DATA,'.',1)  ;* The company in which the locker exists
    CALL CACHE.READ('F.MB.SDB.TYPE',MB.SDB.TYPE.ID,R.MB.SDB.TYPE,YERR)          ;* CACHE.READ will take care of OPEN
    LOCATE ENQUIRY.COMPANY IN R.MB.SDB.TYPE<SDB.TYP.BRANCH.CODE,1> SETTING SDB.COMP.POS ELSE SDB.COMP.POS = ''
    IF SDB.COMP.POS THEN
        O.DATA = R.MB.SDB.TYPE<SDB.TYP.PERIODIC.RENT,1>:'*':R.MB.SDB.TYPE<SDB.TYP.VAT.ON.RENT,1>:'*':R.MB.SDB.TYPE<SDB.TYP.REFUND.DEPOSIT,1>
        TOTAL.RENT.AMT = R.MB.SDB.TYPE<SDB.TYP.PERIODIC.RENT,1> + R.MB.SDB.TYPE<SDB.TYP.VAT.ON.RENT,1>        ;*Only the rent and the vat
        O.DATA = O.DATA:'*':TOTAL.RENT.AMT
    END

    RETURN
END
