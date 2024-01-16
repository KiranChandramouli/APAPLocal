* @ValidationCode : MjoxNDI0NTQ1Mzg2OkNwMTI1MjoxNjg0MjIyODA2NzgxOklUU1M6LTE6LTE6MjAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   No changes
SUBROUTINE LAPAP.CUSTOMER.ID(ID,RS)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
   $USING EB.LocalReferences


    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF (FN.CUS,F.CUS)


    CALL F.READ(FN.CUS,ID,R.CUS,F.CUS,CUS.ERR)

*    CALL GET.LOC.REF("CUSTOMER","L.CU.CIDENT",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.CIDENT",POS);* R22 UTILITY AUTO CONVERSION
    CARD.ID = R.CUS<EB.CUS.LOCAL.REF,POS>

*    CALL GET.LOC.REF("CUSTOMER","L.CU.NOUNICO",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.NOUNICO",POS);* R22 UTILITY AUTO CONVERSION
    NO.UNIC = R.CUS<EB.CUS.LOCAL.REF,POS>

*    CALL GET.LOC.REF("CUSTOMER","L.CU.ACTANAC",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.ACTANAC",POS);* R22 UTILITY AUTO CONVERSION
    B.CERT = R.CUS<EB.CUS.LOCAL.REF,POS>

*    CALL GET.LOC.REF("CUSTOMER","L.CU.PASS.NAT",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.PASS.NAT",POS);* R22 UTILITY AUTO CONVERSION
    PASS.N = R.CUS<EB.CUS.LOCAL.REF,POS>

*    CALL GET.LOC.REF("CUSTOMER","L.CU.RNC",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.RNC",POS);* R22 UTILITY AUTO CONVERSION
    RNC.NO = R.CUS<EB.CUS.LOCAL.REF,POS>



    BEGIN CASE
        CASE CARD.ID NE ''
            RS = CARD.ID

        CASE NO.UNIC NE ''
            RS = NO.UNIC

        CASE B.CERT NE ''
            RS = B.CERT

        CASE PASS.N NE ''
            RS = PASS.N

        CASE RNC.NO NE ''
            RS = RNC.NO

    END CASE



END
