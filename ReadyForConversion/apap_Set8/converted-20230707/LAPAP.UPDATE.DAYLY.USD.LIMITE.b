*========================================================================
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.UPDATE.DAYLY.USD.LIMITE
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.UPDATE.DAYLY.USD.LIMITE
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



    $INSERT T24.BP I_COMMON
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.DATES
    $INSERT T24.BP I_F.TELLER
    $INSERT BP I_F.ST.LAPAP.LIMITE.CURRENCY.PARAM
    $INSERT BP I_F.ST.LAPAP.DAYLY.LIMITE.CUSTOMER

    FN.TELLER = "F.TELLER"
    F.TELLER = ""
    CALL OPF(FN.TELLER,F.TELLER)

    FN.LIMITE = "F.ST.LAPAP.LIMITE.CURRENCY.PARAM"
    F.LIMITE = ""
    CALL OPF(FN.LIMITE,F.LIMITE)

    FN.DAYLY = "F.ST.LAPAP.DAYLY.LIMITE.CUSTOMER"
    F.DAYLY = ""
    CALL OPF(FN.DAYLY,F.DAYLY)

    CALL GET.LOC.REF("TELLER","L.TT.CLIENT.COD",POS)
    LEGAL.ID = R.NEW(TT.TE.LOCAL.REF)<1,POS>
    CURRENCY = R.NEW(TT.TE.CURRENCY.1)
    TELLER.AMOUNT = R.NEW(TT.TE.AMOUNT.FCY.1)

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
            CALL LAPAP.BUILD.OFS.FROM.VERSION("ST.LAPAP.DAYLY.LIMITE.CUSTOMER","I",CUSTOMER,R.DAY);
        END ELSE
            IF V$FUNCTION NE 'R' THEN
                R.DAY2<ST.LAP66.CURRENCY> = CURRENCY
                R.DAY2<ST.LAP66.AMOUNT> = TELLER.AMOUNT
                R.DAY2<ST.LAP66.LAST.UPDATE> = TODAY
                CUSTOMER = LEGAL.ID
                CALL LAPAP.BUILD.OFS.FROM.VERSION("ST.LAPAP.DAYLY.LIMITE.CUSTOMER","I",CUSTOMER,R.DAY2);
            END
        END
    END ELSE
        IF V$FUNCTION NE 'R' THEN
            R.DAYLY<ST.LAP66.CURRENCY> = CURRENCY
            R.DAYLY<ST.LAP66.AMOUNT> = TELLER.AMOUNT
            R.DAYLY<ST.LAP66.LAST.UPDATE> = TODAY
            CUSTOMER = LEGAL.ID
            IF R.DAYLY<ST.LAP66.LAST.UPDATE> EQ TODAY THEN
                CALL LAPAP.BUILD.OFS.FROM.VERSION("ST.LAPAP.DAYLY.LIMITE.CUSTOMER","I",CUSTOMER,R.DAYLY);
            END 
        END
    END

    RETURN

END
