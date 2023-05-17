SUBROUTINE REDO.SC.CALCULATE.PRICE(SETTLEMENT, MATURITY.DATE, RATE, YLD, REDEMPTION, FREQ, YEAR.DAYS.BASIS, PRICE, ROUNDING, ACCR.ST.DATE, Y.ISSUE.DATE)
*-----------------------------------------------------------------------------------------------
* Company Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed by    : Temenos Application Management
* Program Name    : REDO.SC.CALCULATE.PRICE
*-----------------------------------------------------------------------------------------------
* Description   : This routine is used to calculate the APAP price when CALCULATION.METHOD is PRICE
*                 in PRICE.TYPE record & YIELD is inputted for bond securities using the formula
*
* In  Parameter : SETTLEMENT
*                 MATURITY.DATE
*                 RATE
*                 YLD
*                 REDEMPTION
*                 FREQ
*                 YEAR.DAYS.BASIS
*
* Out Parameter : PRICE - holds the calculated Amount according to the formula defined in the requirement
*
* ODR Number    : ODR-2010-07-0083
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* 15.11.2010      Krishna Murthy T.S     SC006          INITIAL CREATION
* 13.07.2012      Gassali S K            PACS00206989   Price Calculation method for leap year is modified
*-------------------------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON

    IF SETTLEMENT AND MATURITY.DATE AND YLD AND REDEMPTION AND FREQ AND YEAR.DAYS.BASIS AND RATE AND ACCR.ST.DATE THEN
        RATE = RATE/100
        YLD = YLD/100
        GOSUB CALCULATE.DAYS
        GOSUB CALC.PRICE
    END
RETURN

*-----------------------------------------------------------------------------------------------------
CALCULATE.DAYS:
*---------------
*Calculates the first Coupon date from the Maturity date and total number of Payments

    N1 = 1
    Y.LD = YLD/FREQ
    TDATE = MATURITY.DATE
    PREV.CPN.DATE = MATURITY.DATE

    IS.LEAP.YEAR = 0
    LEAP.YEAR = MATURITY.DATE[1,4]/4
    IF MOD(LEAP.YEAR,1) EQ 0 THEN
        IS.LEAP.YEAR = 1
    END

    LOOP
        GOSUB GET.DAYS.IN.MONTH
        TDATE = PREV.CPN.DATE[1,6]:MAT.DATE
        Y4.ARG = 'L'
        CALL SC.INCREMENT.DATE2(TDATE,YEAR.DAYS.BASIS,FREQ,Y4.ARG,PREV.CPN.DATE)
        NEXT.CPN.DATE = TDATE
    WHILE PREV.CPN.DATE > SETTLEMENT
        N1 += 1
        TDATE = PREV.CPN.DATE
    REPEAT
RETURN

*----------
CALC.PRICE:
*----------
*Calculates the Actual Price according to the formula

    DATE2 = SETTLEMENT ;DATE1 = ACCR.ST.DATE
    GOSUB CALC.NO.OF.DAYS
    A = NO.OF.DAYS

    Y.AMT = 0
    Y.AMT2 = 0
    Y.AMT3 = 0
    Y.AMT4 = 0
    Y.CNTR = 1
    Y.W = 0
    DATE1 = ACCR.ST.DATE
    CALL SC.INCREMENT.DATE2(DATE1,YEAR.DAYS.BASIS,FREQ,'N',NEXT.CPN.DATE)
    DATE2 = NEXT.CPN.DATE
    Y.CCY = LCCY
    Y.YR.BASIS = YEAR.DAYS.BASIS[3,9]
*Y.LP.DAYS = FIELD(Y.YR.BASIS,'/',1)
*Y.NON.LP.DAYS = FIELD(Y.YR.BASIS,'/',2)
    Y.LP.DAYS = 366
    Y.NON.LP.DAYS = 365
    Y.FLAG = 0

    LOOP
    WHILE Y.CNTR LE N1
        GOSUB CALC.NO.OF.DAYS
        TEMP = NO.OF.DAYS
        GOSUB CALC.ACTUAL.AMT
        GOSUB CALC.COUP.ADJ.AMT
    REPEAT

    Y.MAT.PRICE = REDEMPTION/((1+Y.LD)^(N1+Y.W-1))
    Y.AMT += Y.MAT.PRICE
    Y.DC = FIELD(Y.AMT,'.',2)
    Y.DC = Y.DC[1,9]
    Y.AMT = FIELD(Y.AMT,'.',1):".":Y.DC
    PRICE = Y.AMT
RETURN

*---------------
CALC.NO.OF.DAYS:
*---------------
*Calculates the difference between the given dates DATE1 & DATE2

    PREV.CPN.NO.OF.DAYS = NO.OF.DAYS      ;* PACS00206989 -S/E
    BEGIN CASE
        CASE YEAR.DAYS.BASIS[1,1] EQ 'A' OR YEAR.DAYS.BASIS[1,1] EQ 'D' OR YEAR.DAYS.BASIS[1,1] EQ 'F'
            Y1 = DATE1[1,4] ; M1 = DATE1[5,2] ; D1 = DATE1[7,2]
            Y2 = DATE2[1,4] ; M2 = DATE2[5,2] ; D2 = DATE2[7,2]
            GOSUB GET.NO.OF.DAYS
        CASE 1
            D1 = '' ; D2 = ''
            D1 = DATE1[7,2]:'/':DATE1[5,2]:'/':DATE1[1,4]
            D2 = DATE2[7,2]:'/':DATE2[5,2]:'/':DATE2[1,4]
            NO.OF.DAYS = ICONV(D2,'D2/E') - ICONV(D1,'D2/E')
    END CASE

*PACS00206989 -S
    IF DATE1 LE TODAY THEN
        PREV.CPN.NO.OF.DAYS = ''
    END
*PACS00206989 -E
RETURN

*----------------
CALC.ACTUAL.AMT:
*---------------
*Calculates the Actual Coupon amount for the Period

    Y.AMT1 = 0
    Y.YR1 = DATE1[1,4]
    Y.YR2 = DATE2[1,4]
    Y.LEAP.DATE ='0229'

*PACS00206989 -S
    TOTAL.NO.OF.DAYS = PREV.CPN.NO.OF.DAYS + NO.OF.DAYS

    IF PREV.CPN.NO.OF.DAYS NE '' THEN
        IF TOTAL.NO.OF.DAYS EQ Y.LP.DAYS THEN
            Y.AMT1 = REDEMPTION*TEMP*RATE/Y.LP.DAYS
        END ELSE
            Y.AMT1 = REDEMPTION*TEMP*RATE/Y.NON.LP.DAYS
        END
    END

    YR.ACCR.ST.DATE = ACCR.ST.DATE[1,4]
    YR.CPN.END.DATE = NEXT.CPN.DATE[1,4]
    IF PREV.CPN.NO.OF.DAYS EQ '' AND MOD(YR.CPN.END.DATE,4) EQ 0 THEN
        IF ACCR.ST.DATE LE YR.CPN.END.DATE:Y.LEAP.DATE AND NEXT.CPN.DATE GT YR.CPN.END.DATE:Y.LEAP.DATE THEN
            Y.AMT1 = REDEMPTION*TEMP*RATE/Y.LP.DAYS
        END ELSE
            Y.AMT1 = REDEMPTION*TEMP*RATE/Y.NON.LP.DAYS
        END
    END

    IF PREV.CPN.NO.OF.DAYS EQ '' AND MOD(YR.CPN.END.DATE,4) NE 0 THEN
        IF ACCR.ST.DATE GE YR.ACCR.ST.DATE:Y.LEAP.DATE THEN
            Y.AMT1 = REDEMPTION*TEMP*RATE/Y.NON.LP.DAYS
        END ELSE
            Y.AMT1 = REDEMPTION*TEMP*RATE/Y.LP.DAYS

        END
    END

*PACS00206989 -E
RETURN

*-----------------
CALC.COUP.ADJ.AMT:
*-----------------
*Calculates the Coupon Adjusted Amount for the period
    IF Y.CNTR EQ 1 THEN
        Y.W = (TEMP-A)/TEMP
        Y.AMT2 = Y.W*Y.AMT1
        Y.AMT3 = Y.AMT2
        Y.AMT4 = Y.AMT3/((1+Y.LD)^Y.W)
    END
    ELSE
        Y.AMT3 = Y.AMT1
        Y.AMT4 = Y.AMT3/((1+Y.LD)^(Y.W+Y.CNTR-1))
    END
    Y.AMT += Y.AMT4
    DATE1 = DATE2
    CALL SC.INCREMENT.DATE2(DATE1,YEAR.DAYS.BASIS,FREQ,'N',DATE2)
    IF DATE2 GT MATURITY.DATE THEN
        IF Y.CNTR EQ N1 AND DATE1 NE MATURITY.DATE THEN
            N1 += 1
        END
        DATE2 = MATURITY.DATE
    END
    Y.CNTR += 1
RETURN

*-----------------
GET.DAYS.IN.MONTH:
*----------------
* gets the number of days in the month
    ODD.MONTH = '04':@VM:'06':@VM:'09':@VM:'11'

    BEGIN CASE
        CASE MATURITY.DATE[5,2] MATCHES ODD.MONTH AND MATURITY.DATE[7,2] EQ '30'
            MAT.DATE = '31'

        CASE MATURITY.DATE[5,2] EQ '02' AND  MATURITY.DATE[7,2] EQ '29'
            MAT.DATE = '31'

        CASE MATURITY.DATE[5,2] EQ '02' AND MATURITY.DATE[7,2] EQ '28' AND NOT(IS.LEAP.YEAR)
            MAT.DATE = '31'

        CASE OTHERWISE
            MAT.DATE = MATURITY.DATE[7,2]
    END CASE
RETURN

*-------------
GET.NO.OF.DAYS:
*-------------
* Alter the Dates according to the requirement for A3 Basis
    IF YEAR.DAYS.BASIS[1,2] EQ 'A3' THEN
        IF D1 EQ 31 THEN
            D1 = 30
        END
        IF D2 EQ 31 THEN
            BEGIN CASE
                CASE D1 LT 30
                    CALL CDT(DUMMY,DATE2,"+1C")
                    Y2 = DATE2[1,4] ; M2 = DATE2[5,2] ;D2 = DATE2[7,2]
                CASE OTHERWISE
                    D2 = 30
            END CASE
        END
    END

    IF YEAR.DAYS.BASIS[1,1] EQ 'A' THEN
        IF D2 EQ 31 THEN
            D2 = 30
        END
        IF D1 EQ 31 THEN
            D1 = 30
        END
        NO.OF.DAYS = (Y2 - Y1) * 360 + (M2 - M1) * 30 + (D2 - D1)
    END ELSE
        NO.OF.DAYS = (Y2 - Y1) * 360 + (M2 - M1) * 30 + (D2 - D1) - (D2 > 30) + (D1 > 30)
    END
RETURN
END
