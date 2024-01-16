* @ValidationCode : MjotNTk0MzEzMzA1OkNwMTI1MjoxNjg0MjIyODA2NDc1OklUU1M6LTE6LTE6MTAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
SUBROUTINE LAPAP.CUS.PEP.AUTO
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.CUS.PEP.AUTO
* Date           : 2019-08-13
* Item ID        :
*========================================================================
* Brief description :
* -------------------
* This program validate Pep's status
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2019-08-13     Richard HC                Initial Development
*Modification history
*Date                Who               Reference                  Description
*21-04-2023      conversion tool     R22 Auto code conversion     No changes
*21-04-2023      Mohanraj R          R22 Manual code conversion   No changes
*========================================================================
* Content summary :
* =================
* Table name     : CUSTOMER
* Auto Increment : N/A
* Views/versions : ALL VERSION IN CUSTOMER
* EB record      : LAPAP.CUS.PEP.AUTO
* Routine        : LAPAP.CUS.PEP.AUTO
*========================================================================

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
   $USING EB.LocalReferences

    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)


*    CALL GET.LOC.REF("CUSTOMER","L.CU.PEPS",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.PEPS",POS);* R22 UTILITY AUTO CONVERSION

    PEPS = R.NEW(EB.CUS.LOCAL.REF)<1,POS>

    IF PEPS EQ "" THEN

        R.NEW(EB.CUS.LOCAL.REF)<1,POS> = "NO"

    END



RETURN

END
