SUBROUTINE REDO.E.NOF.ST.COUP.INT.ACCR(Y.ARR)
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This NOFILE routine should be attached to the below ENQUIRY REDO.SEC.TRADE.COUP.INT.ACCR
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : NAVEENKUMAR N
* PROGRAM NAME : REDO.E.NOF.ST.COUP.INT.ACCR
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference           Description
* 19 Oct 2010      Naveen Kumar N     ODR-2010-07-0081    Initial creation
* 03 May 2011      Pradeep S          PACS00056287        Invalid records are not allowed
*---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.SEC.TRADE
    $INSERT I_F.SECURITY.MASTER
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS


    Y.ARR := Y.ACCRUAL.START.DATE:"*":EFFECTIVE.RATE:"*":ACCUMULATED.VALUE:"*":Y.MARGINAL.VALUE:"*":Y.PENDING.VALUE:"*":Y.COUPON
RETURN
*--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*****
INIT:
*****
    FN.SEC.TRADE       = "F.SEC.TRADE"
    F.SEC.TRADE        = ""
    R.SEC.TRADE        = ""
    E.SEC.TRADE        = ""
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
*
    FN.SECURITY.MASTER = "F.SECURITY.MASTER"
    F.SECURITY.MASTER  = ""
    R.SECURITY.MASTER  = ""
    E.SECURITY.MASTER  = ""
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)
*
    TO.DATE            = "" ; FROM.DATE         = "" ; SEC.TRADE.ID    = "" ; REGION.CODE        = "" ; COUPON.TENOR      = "" ; Y.ACCRUAL.START.DATE   = "" ; INT.PAYMENT.DATE = "" ;
    CALC5              = "" ; PART.2            = "" ; EFFECTIVE.RATE1 = "" ; EFFECTIVE.RATE     = "" ; ACCUMULATED.VALUE = "" ; ACCUMULATED.TEMP.VALUE = "" ; Y.MARGINAL.VALUE1  = "" ;
    FACE.VALUE         = "" ; INT.RATE          = "" ; SEC.CODE        = "" ; EFFECTIVE.RATE1    = "" ; EFFECTIVE.RATE    = "" ; ACCUMULATED.VALUE1     = "" ;
    Y.MARGINAL.VALUE   = "" ; Y.PENDING.VALUE1  = "" ; Y.PENDING.VALUE = "" ; ACCUMULATED.VALUE1 = "0"
RETURN
*-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
*********
PROCESS:
*********
    LOCATE "SEC.TRADE.ID" IN D.FIELDS<1> SETTING POSITION.ONE THEN
        SEC.TRADE.ID   = D.RANGE.AND.VALUE<POSITION.ONE>
    END
    LOCATE "FROM.DATE" IN D.FIELDS<1> SETTING FROM.DATE.POS THEN
        Y.FROM.DATE      = D.RANGE.AND.VALUE<FROM.DATE.POS>
    END
    LOCATE "TO.DATE" IN D.FIELDS<1> SETTING TO.DATE.POS THEN
        Y.TO.DATE        = D.RANGE.AND.VALUE<TO.DATE.POS>
    END

*PACS00056287 - S
    LOCATE "TILL.MAT" IN D.FIELDS<1> SETTING MAT.POS THEN
        Y.TILL.MAT   = D.RANGE.AND.VALUE<MAT.POS>
    END
*PACS00056287 - E

*
    CALL F.READ(FN.SEC.TRADE,SEC.TRADE.ID,R.SEC.TRADE,F.SEC.TRADE,E.SEC.TRADE)

*PACS00056287 - S
    IF NOT(R.SEC.TRADE) THEN
        RETURN
    END
*PACS00056287 - E

    Y.CUST.INTR.AMT    = R.SEC.TRADE<SC.SBS.CUST.INTR.AMT>
    Y.CCY              = R.SEC.TRADE<SC.SBS.SECURITY.CURRENCY>
*
    IF FROM.DATE NE "" AND TO.DATE NE "" THEN
        FROM.DATE.VAL  = FROM.DATE
        TO.DATE.VAL    = TO.DATE
    END ELSE
        FROM.DATE.VAL  = R.SEC.TRADE<SC.SBS.VALUE.DATE>
        TO.DATE.VAL    = TODAY
    END
*
    FACE.VALUE                = R.SEC.TRADE<SC.SBS.CUST.NO.NOM>
    INT.RATE                  = R.SEC.TRADE<SC.SBS.INTEREST.RATE>
    INT.RATE                  = INT.RATE/100
    SEC.CODE                  = R.SEC.TRADE<SC.SBS.SECURITY.CODE>
    CALL F.READ(FN.SECURITY.MASTER,SEC.CODE,R.SECURITY.MASTER,F.SECURITY.MASTER,E.SECURITY.MASTER)
    BASE.1                    = R.SECURITY.MASTER<SC.SCM.INTEREST.DAY.BASIS>
    BASE                      = BASE.1[7,3]
    ACTUAL.START.DATE         = R.SECURITY.MASTER<SC.SCM.ACCRUAL.START.DATE>
    INT.PAYMENT.DATE          = R.SECURITY.MASTER<SC.SCM.INT.PAYMENT.DATE>

*PACS00056287 - S
    GOSUB CHECK.DATES
    GOSUB SET.FROM.TO.DATE
*PACS00056287 - E

    COUPON.TENOR = 'C'
    IF ACTUAL.START.DATE NE '' AND INT.PAYMENT.DATE NE '' THEN
        CALL CDD(REGION.CODE,ACTUAL.START.DATE,INT.PAYMENT.DATE,COUPON.TENOR)
    END
*
*PACS00056287 - S
*CALC1  = (BASE*COUPON.TENOR)
*CALC2  = (INT.RATE/CALC1)
    GOSUB CALC.COUPON
    CALC1 = (INT.RATE/BASE)
    CALC2 = (CALC1*COUPON.TENOR)
    CALC3  = (FACE.VALUE*CALC2)/FACE.VALUE
    CALC4  = (1 + CALC3)
    PART.1 = CALC4
*
    Y.CNT  = "1"
    LOOP
    WHILE Y.CNT LE COUPON.TENOR

        IF Y.CNT GT "1" THEN
            NEXT.DATE               = '1D'
            CALL CALENDAR.DAY(ACTUAL.START.DATE,'+',NEXT.DATE)
            ACTUAL.START.DATE       = NEXT.DATE
        END
*
*

        CALC5                   = (Y.CNT/COUPON.TENOR)
*PART.2 = PWR(CALC5,-1)
        PART.2                  = PWR(PART.1,CALC5)
*
*EFFECTIVE.RATE1 = PWR(PART.1,PART.2)
        EFFECTIVE.RATE1         = PART.2 - 1
*
        ACCUMULATED.TEMP.VALUE  = ACCUMULATED.VALUE1
*
        ACCUMULATED.VALUE1      = (FACE.VALUE*EFFECTIVE.RATE1)
*
        Y.MARGINAL.VALUE1       = (ACCUMULATED.VALUE1 - ACCUMULATED.TEMP.VALUE)
*
*Y.PENDING.VALUE1 = (FACE.VALUE - ACCUMULATED.VALUE1)
        Y.PENDING.VALUE1        = (ACCUMULATED.VALUE1 - Y.COUPON)
*
        IF ACTUAL.START.DATE GE Y.FROM.DATE AND NEXT.DATE LE Y.TO.DATE THEN
            Y.ACCRUAL.START.DATE<1,-1> = ACTUAL.START.DATE
            EFFECTIVE.RATE<1,-1>       = EFFECTIVE.RATE1 * 100
            ACCUMULATED.VALUE<1,-1>    = ACCUMULATED.VALUE1
            Y.MARGINAL.VALUE<1,-1>     = Y.MARGINAL.VALUE1
            Y.PENDING.VALUE<1,-1>      = Y.PENDING.VALUE1
        END

        Y.CNT += 1
    REPEAT
*PACS00056287 - E
RETURN

*************
CALC.COUPON:
*************

    FACTOR.1 = FACE.VALUE
    FACTOR.2 = INT.RATE/BASE
    FACTOR.3 = COUPON.TENOR

    Y.COUPON = FACTOR.1 * FACTOR.2 * FACTOR.3

RETURN

************
CHECK.DATES:
************

    IF Y.TO.DATE AND Y.TO.DATE GT INT.PAYMENT.DATE THEN
        ENQ.ERROR = "EB-TO.DATE.GT.INT.PAY.DATE"
    END

    IF Y.TO.DATE AND Y.TO.DATE LT ACTUAL.START.DATE THEN
        ENQ.ERROR = "EB-TO.DATE.LT.ACT.ST.DATE"
    END

    IF Y.FROM.DATE AND Y.FROM.DATE GT INT.PAYMENT.DATE THEN
        ENQ.ERROR = "EB-FROM.DATE.GT.INT.PAY.DATE"
    END

    IF Y.FROM.DATE AND Y.FROM.DATE LT ACTUAL.START.DATE THEN
        ENQ.ERROR = "EB-FROM.DATE.LT.ACT.ST.DATE"
    END

RETURN

******************
SET.FROM.TO.DATE:
******************

    BEGIN CASE

        CASE Y.FROM.DATE NE '' AND Y.TO.DATE EQ ''

            IF Y.TILL.MAT EQ "YES" THEN
                Y.TO.DATE = INT.PAYMENT.DATE
            END ELSE
                IF Y.FROM.DATE LT TODAY THEN
                    Y.TO.DATE = TODAY
                END ELSE
                    Y.TO.DATE = INT.PAYMENT.DATE
                END
            END

        CASE Y.FROM.DATE EQ '' AND Y.TO.DATE NE ''
            IF Y.TILL.MAT EQ "YES" THEN
                Y.FROM.DATE = ACTUAL.START.DATE
            END ELSE
                IF Y.TO.DATE LT TODAY THEN
                    Y.FROM.DATE = ACTUAL.START.DATE
                END ELSE
                    Y.FROM.DATE = TODAY
                END
            END

        CASE Y.FROM.DATE EQ ''  AND Y.TO.DATE EQ ''

            IF Y.TILL.MAT EQ "YES" THEN
                Y.FROM.DATE = ACTUAL.START.DATE
                Y.TO.DATE = INT.PAYMENT.DATE
            END ELSE
                Y.FROM.DATE = ACTUAL.START.DATE
                Y.TO.DATE = TODAY
            END

    END CASE

RETURN

*-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
END
