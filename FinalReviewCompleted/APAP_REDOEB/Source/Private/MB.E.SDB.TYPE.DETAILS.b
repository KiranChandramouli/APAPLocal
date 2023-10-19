* @ValidationCode : MjotOTY0NDEyMjcwOkNwMTI1MjoxNjgxMzg0NDMzOTM4OklUU1M6LTE6LTE6OTY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:53
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 96
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.E.SDB.TYPE.DETAILS
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
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
