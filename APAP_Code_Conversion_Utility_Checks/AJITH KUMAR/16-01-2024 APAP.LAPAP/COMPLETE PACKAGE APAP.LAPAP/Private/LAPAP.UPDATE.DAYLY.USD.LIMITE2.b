* @ValidationCode : MjotMTYzNDQ1NTI2NjpVVEYtODoxNjkwMTY3NTUyOTQ5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Jul 2023 08:29:12
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
$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.UPDATE.DAYLY.USD.LIMITE2
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.UPDATE.DAYLY.USD.LIMITE2
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
* 14-07-2023    Conversion Tool        R22 Auto Conversion     No Changes
* 17-07-2023    Narmadha V             R22 Manual Conversion   BP is Removed in insert file,Call routine format modified
*========================================================================
* Content summary :
* =================
* Table name     :
* Auto Increment :
* Views/versions :
* EB record      :
* Routine        :
*========================================================================


    $INSERT  I_COMMON ;* R22 Manual Conversion - START
    $INSERT  I_EQUATE
    $INSERT  I_F.DATES
    $INSERT  I_F.TELLER
    $INSERT  I_F.ST.LAPAP.LIMITE.CURRENCY.PARAM
    $INSERT  I_F.ST.LAPAP.DAYLY.LIMITE.CUSTOMER ;* R22 Manual Conversion - END
   $USING EB.LocalReferences

    FN.TELLER = "F.TELLER"
    F.TELLER = ""
    CALL OPF(FN.TELLER,F.TELLER)

    FN.LIMITE = "F.ST.LAPAP.LIMITE.CURRENCY.PARAM"
    F.LIMITE = ""
    CALL OPF(FN.LIMITE,F.LIMITE)

    FN.DAYLY = "F.ST.LAPAP.DAYLY.LIMITE.CUSTOMER"
    F.DAYLY = ""
    CALL OPF(FN.DAYLY,F.DAYLY)

*    CALL GET.LOC.REF("TELLER","L.TT.CLIENT.COD",POS)
EB.LocalReferences.GetLocRef("TELLER","L.TT.CLIENT.COD",POS);* R22 UTILITY AUTO CONVERSION
    LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS>
    CURRENCY = R.NEW(TT.TE.CURRENCY.2)
    TELLER.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.2)

    CALL F.READ(FN.DAYLY,LEGAL.ID,R.DAYLY,F.DAYLY,ERR.DAYLY)
    AMOUNT = R.DAYLY<ST.LAP66.AMOUNT>
    LAST.UPD.DAY = R.DAYLY<ST.LAP66.LAST.UPDATE>

    R.DAY<ST.LAP66.CURRENCY> = CURRENCY

    IF V$FUNCTION EQ 'R' THEN
        R.DAY<ST.LAP66.AMOUNT> = AMOUNT-TELLER.AMOUNT
    END ELSE
        R.DAY<ST.LAP66.AMOUNT> = AMOUNT+TELLER.AMOUNT
    END

    R.DAY<ST.LAP66.LAST.UPDATE> = TODAY
    CUSTOMER = LEGAL.ID

    IF ERR.DAYLY NE "RECORD NOT FOUND" THEN
        IF  LAST.UPD.DAY EQ TODAY THEN
            APAP.LAPAP.lapapBuildOfsFromVersion("ST.LAPAP.DAYLY.LIMITE.CUSTOMER","I",CUSTOMER,R.DAY); ;*R22 Manual Conversion
        END ELSE

            IF V$FUNCTION NE 'R' THEN
                R.DAY2<ST.LAP66.CURRENCY> = CURRENCY
                R.DAY2<ST.LAP66.AMOUNT> = TELLER.AMOUNT
                R.DAY2<ST.LAP66.LAST.UPDATE> = TODAY
                CUSTOMER = LEGAL.ID
                APAP.LAPAP.lapapBuildOfsFromVersion("ST.LAPAP.DAYLY.LIMITE.CUSTOMER","I",CUSTOMER,R.DAY2); ;*R22 Manual Conversion
            END
        END
    END ELSE

        IF V$FUNCTION NE 'R' THEN
            R.DAYLY<ST.LAP66.CURRENCY> = CURRENCY
            R.DAYLY<ST.LAP66.AMOUNT> = TELLER.AMOUNT
            R.DAYLY<ST.LAP66.LAST.UPDATE> = TODAY
            CUSTOMER = LEGAL.ID
            IF R.DAYLY<ST.LAP66.LAST.UPDATE> EQ TODAY THEN
                APAP.LAPAP.lapapBuildOfsFromVersion("ST.LAPAP.DAYLY.LIMITE.CUSTOMER","I",CUSTOMER,R.DAYLY); ;*R22 Manual Conversion
            END
        END
    END

RETURN

END
