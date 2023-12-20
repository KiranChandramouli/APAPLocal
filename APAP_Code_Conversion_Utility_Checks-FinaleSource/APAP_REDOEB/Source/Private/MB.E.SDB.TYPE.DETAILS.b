* @ValidationCode : MjoxOTM3MDcyMDM6VVRGLTg6MTcwMjk5MDYyNzA5NzpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Dec 2023 18:27:07
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
SUBROUTINE MB.E.SDB.TYPE.DETAILS
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 15-DEC-2023      Narmadha V       Manual R22 Conversion      Initalise FN Variable, Change Hardcoded value to FN variable
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.MB.SDB.TYPE

    IN.DATA = O.DATA
    SDB.COMP.POST = ''        ;* Initialise
    MB.SDB.TYPE.ID = FIELD(IN.DATA,'.',2)
    REC.COMPANY = FIELD(IN.DATA,'.',1)  ;* The company in which the locker exists
    FN.MB.SDB.TYPE = "F.MB.SDB.TYPE" ;*Manual R22 Conversion-Initalise FN Variable
    F.MB.SDB.TYPE = ''
*CALL CACHE.READ('F.MB.SDB.TYPE',MB.SDB.TYPE.ID,R.MB.SDB.TYPE,YERR)          ;* CACHE.READ will take care of OPEN
    CALL CACHE.READ(FN.MB.SDB.TYPE ,MB.SDB.TYPE.ID,R.MB.SDB.TYPE,'') ;*Manual R22 Conversion-Change Hardcoded value to FN variable.
    LOCATE ENQUIRY.COMPANY IN R.MB.SDB.TYPE<SDB.TYP.BRANCH.CODE,1> SETTING SDB.COMP.POS ELSE SDB.COMP.POS = ''
    IF SDB.COMP.POS THEN
        O.DATA = R.MB.SDB.TYPE<SDB.TYP.PERIODIC.RENT,1>:'*':R.MB.SDB.TYPE<SDB.TYP.VAT.ON.RENT,1>:'*':R.MB.SDB.TYPE<SDB.TYP.REFUND.DEPOSIT,1>
        TOTAL.RENT.AMT = R.MB.SDB.TYPE<SDB.TYP.PERIODIC.RENT,1> + R.MB.SDB.TYPE<SDB.TYP.VAT.ON.RENT,1>        ;*Only the rent and the vat
        O.DATA = O.DATA:'*':TOTAL.RENT.AMT
    END

RETURN
END
