* @ValidationCode : MjoxNzg1MTAwMjkwOkNwMTI1MjoxNjkwMTY3NTQxMTgwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
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
SUBROUTINE LAPAP.CHECK.DAYLY.CUS.USD.LIMITE
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.CHECK.DAYLY.CUS.USD.LIMITE
* Date           : 2019-10-17
* Item ID        :
*========================================================================
* Brief description :
* -------------------
* Validation
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
*                 Richard HC               Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :
* Auto Increment :
* Views/versions :
* EB record      :
* Routine        :
*========================================================================

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 20-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 20-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts 

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.TELLER
    $INSERT I_F.ST.LAPAP.LIMITE.CURRENCY.PARAM
    $INSERT I_F.ST.LAPAP.DAYLY.LIMITE.CUSTOMER

    FN.TELLER = "F.TELLER"
    F.TELLER = ""
    CALL OPF(FN.TELLER,F.TELLER)

    FN.LIMITE = "F.ST.LAPAP.LIMITE.CURRENCY.PARAM"
    F.LIMITE = ""
    CALL OPF(FN.LIMITE,F.LIMITE)

    FN.DAYLY = "F.ST.LAPAP.DAYLY.LIMITE.CUSTOMER"
    F.DAYLY = ""
    CALL OPF(FN.DAYLY,F.DAYLY)

    IF V$FUNCTION EQ 'R' THEN
        RETURN
    END

    CALL GET.LOC.REF("TELLER","L.TT.CLIENT.COD",POS)
    LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS>
    CURRENCY = R.NEW(TT.TE.CURRENCY.1)
    TELLER.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.1)

    CALL F.READ(FN.DAYLY,LEGAL.ID,R.DAYLY,F.DAYLY,ERR.DAYLY)
    LIMITE.AMOUNT = R.DAYLY<ST.LAP66.AMOUNT> + TELLER.AMOUNT
    LAST.UPD.DATE = R.DAYLY<ST.LAP66.LAST.UPDATE>

    IF LAST.UPD.DATE EQ "" THEN
        LAST.UPD.DATE = TODAY
    END

    CALL F.READ(FN.LIMITE,CURRENCY,R.LIMITE,F.LIMITE,ERR.LIMITE)
    LIMITE.PARAM = R.LIMITE<ST.LAP65.LIMITE.AMOUNT>

    IF CURRENCY EQ "USD" AND LIMITE.AMOUNT GT LIMITE.PARAM AND LAST.UPD.DATE EQ TODAY THEN

        TEXT = "TELLER-LAPAP.LIMITE.CURRENCY.PARAM"
        CURR.NO = 1
        CALL STORE.OVERRIDE(CURR.NO)
    END

    IF CURRENCY EQ "USD" AND TELLER.AMOUNT GT LIMITE.PARAM AND LAST.UPD.DATE NE TODAY THEN

        TEXT = "TELLER-LAPAP.LIMITE.CURRENCY.PARAM"
        CURR.NO = 1
        CALL STORE.OVERRIDE(CURR.NO)
    END

RETURN

END
