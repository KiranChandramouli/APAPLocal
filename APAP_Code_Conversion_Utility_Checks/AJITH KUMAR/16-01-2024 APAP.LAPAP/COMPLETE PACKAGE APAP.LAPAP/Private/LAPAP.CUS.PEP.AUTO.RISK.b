* @ValidationCode : MjotMjAxMTkyNDEyNjpDcDEyNTI6MTY4OTkxODk0MzA2NDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 21 Jul 2023 11:25:43
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CUS.PEP.AUTO.RISK
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.CUS.PEP.AUTO-RISK
* Date           : 2018-08-08
* Item ID        : CN009303
*========================================================================
* Brief description :
* -------------------
* This program validate Pep's status and update other field.
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2018-08-08     Richard HC                Initial Development
*20-07-2023    VICTORIA S          R22 MANUAL CONVERSION   Folder name removed
*========================================================================
* Content summary :
* =================
* Table name     : CUSTOMER
* Auto Increment : N/A
* Views/versions : ALL VERSION IN CUSTOMER
* EB record      : LAPAP.CUS.PEP.AUTO-RISK
* Routine        : LAPAP.CUS.PEP.AUTO-RISK
*========================================================================


    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER ;*R22 MANUAL CONVERSION END - folder name removed
   $USING EB.LocalReferences

    FN.CUS = "CUSTOMER"
    F.CUS = ""

*    CALL GET.LOC.REF("CUSTOMER","L.CU.PEPS",POS)
EB.LocalReferences.GetLocRef("CUSTOMER","L.CU.PEPS",POS);* R22 UTILITY AUTO CONVERSION
    PEPS = R.NEW(LOCAL.REF.FIELD)<1,POS>

    IF PEPS EQ "SI" THEN

        R.NEW(EB.CUS.CALC.RISK.CLASS) = "ALTO"

    END

RETURN
