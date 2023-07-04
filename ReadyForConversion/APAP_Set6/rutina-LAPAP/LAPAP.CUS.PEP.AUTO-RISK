*========================================================================
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.CUS.PEP.AUTO-RISK
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
*========================================================================
* Content summary :
* =================
* Table name     : CUSTOMER
* Auto Increment : N/A
* Views/versions : ALL VERSION IN CUSTOMER
* EB record      : LAPAP.CUS.PEP.AUTO-RISK
* Routine        : LAPAP.CUS.PEP.AUTO-RISK
*========================================================================


    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.CUSTOMER

    FN.CUS = "CUSTOMER"
    F.CUS = ""

    CALL GET.LOC.REF("CUSTOMER","L.CU.PEPS",POS)
    PEPS = R.NEW(LOCAL.REF.FIELD)<1,POS>

    IF PEPS EQ "SI" THEN

        R.NEW(EB.CUS.CALC.RISK.CLASS) = "ALTO"

    END

    RETURN
