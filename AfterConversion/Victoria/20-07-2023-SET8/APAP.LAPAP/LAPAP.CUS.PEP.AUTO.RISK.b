* @ValidationCode : MjotOTM3MDczMDUzOkNwMTI1MjoxNjg5ODM2NTM1NDk1OnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 20 Jul 2023 12:32:15
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
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
*20-07-2023    VICTORIA S          R22 MANUAL CONVERSION   INSERT FILE MODIFIED
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
    $INSERT I_F.CUSTOMER ;*R22 MANUAL CONVERSION END

    FN.CUS = "CUSTOMER"
    F.CUS = ""

    CALL GET.LOC.REF("CUSTOMER","L.CU.PEPS",POS)
    PEPS = R.NEW(LOCAL.REF.FIELD)<1,POS>

    IF PEPS EQ "SI" THEN

        R.NEW(EB.CUS.CALC.RISK.CLASS) = "ALTO"

    END

RETURN
