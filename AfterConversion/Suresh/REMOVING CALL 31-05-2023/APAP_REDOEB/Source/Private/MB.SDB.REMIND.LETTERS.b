* @ValidationCode : MjotNTc5MjQzNDA4OkNwMTI1MjoxNjgxMzg0NDM2OTEyOklUU1M6LTE6LTE6MzAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 13 Apr 2023 16:43:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 300
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOEB
SUBROUTINE MB.SDB.REMIND.LETTERS(SDB.ID)

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 12-APR-2023     Conversion tool    R22 Auto conversion        No changes
* 12-APR-2023      Harishvikram C   Manual R22 conversion       No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.USER
    $INSERT I_F.DATES
    $INSERT I_F.MB.SDB.STATUS
    $INSERT I_F.MB.SDB.PARAM
    $INSERT I_MB.SDB.REMIND.LETTERS.COMMON


    SDB.REC = ''; SDB.ERR = ''
    CALL F.READ(FN.MB.SDB.STATUS, SDB.ID, SDB.REC, F.MB.SDB.STATUS, SDB.ERR)

    CUS.ID = SDB.REC<SDB.STA.CUSTOMER.NO>; CUS.REC = ''; CUS.ERR = ''
    CALL F.READ(FN.CUSTOMER, CUS.ID, CUS.REC, F.CUSTOMER, CUS.ERR)

    COMP.ID = FIELD(SDB.ID, '.', 1, 1); R.MB.SDB.PARAM = ''; ER.MSG = ''
    CALL F.READ(FN.MB.SDB.PARAM, COMP.ID, R.MB.SDB.PARAM, F.MB.SDB.PARAM, ER.MSG)

    DEL.REFERENCE = ''
    ARRAY.1 = ''
    ARRAY.1<1> = R.COMPANY(EB.COM.CUSTOMER.COMPANY)
    ARRAY.1<2> = COMP.ID
    ARRAY.1<3> = SDB.ID
    ARRAY.1<4> = R.USER<EB.USE.DEPARTMENT.CODE>
    ARRAY.1<5> = CUS.REC<EB.CUS.LANGUAGE>
    ARRAY.1<6> = CUS.ID
    ARRAY.1<7> = TODAY
    ARRAY.1<8> = LCCY

    SDB.MAP.KEY = R.MB.SDB.PARAM<SDB.PAR.REMINDER.LTR>
    DUE.AMT = SDB.REC<SDB.STA.PERIODIC.RENT> + SDB.REC<SDB.STA.VAT.AMOUNT>
    DUE.AMT = TRIM(FMT(DUE.AMT, '10R2'))
    SDB.REC<40> = DUE.AMT

    IF SDB.MAP.KEY THEN
        CALL APPLICATION.HANDOFF(ARRAY.1,SDB.REC,'','','','','','','',SDB.MAP.KEY,DEL.REFERENCE,ER.MSG)
    END

RETURN

END
