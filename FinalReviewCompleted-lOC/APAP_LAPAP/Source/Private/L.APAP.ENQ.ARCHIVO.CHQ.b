* @ValidationCode : MjotNDc5Nzc5NzcyOkNwMTI1MjoxNjgyMzMxMzIxNjI2OklUU1M6LTE6LTE6Mzk3OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 397
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.ARCHIVO.CHQ
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion       BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER ;*R22 Auto conversion - END
    Y.CTA.COD = O.DATA
    FN.TT = "F.TELLER"
    FV.TT = ""
    CALL OPF(FN.TT, FV.TT)
    R.TT = ""
    TT.ERR = ""
    FN.FT = "F.FUNDS.TRANSFER"
    FV.FT = ""
    CALL OPF(FN.FT, FV.FT)
    R.FT = ""
    FT.ERR = ""
    CTA.CONTABLE = " "
    CTA.MONEDA = " "
*DEBUG
    IF (Y.CTA.COD[1,2] EQ "TT") THEN
        CALL F.READ(FN.TT,Y.CTA.COD,R.TT, FV.TT, TT.ERR)
        CTA.CONTABLE = R.TT<TT.TE.ACCOUNT.1>
        CTA.MONEDA = R.FT<TT.TE.CURRENCY.1>
    END
    IF (Y.CTA.COD[1,2] EQ "FT") THEN
        CALL F.READ(FN.FT,Y.CTA.COD,R.FT, FV.FT, FT.ERR)
        CTA.CONTABLE = R.FT<FT.CREDIT.ACCT.NO>
        CTA.MONEDA = R.FT<FT.DEBIT.CURRENCY>

    END

    Y.ARCHIVO.CHEQUE = ""

    Y.ARCHIVO.CHEQUE = "PAGE=PRINT.CHQ.SINGLE.xsl"
*DEBUG

    IF CTA.MONEDA EQ "USD" THEN
        Y.ARCHIVO.CHEQUE = "PAGE=PRINT.CHQ.SINGLE.USD.xsl"
    END

    IF CTA.CONTABLE EQ "DOP1500500010017" THEN
        Y.ARCHIVO.CHEQUE = "PAGE=PRINT.CHQ.SINGLE.xsl"
    END


    IF CTA.CONTABLE EQ "DOP1500600010017" THEN
        Y.ARCHIVO.CHEQUE = "PAGE=PRINT.CHQ.SINGLE.GOB.xsl"
    END
*DEBUG
    O.DATA = Y.ARCHIVO.CHEQUE

RETURN
END
