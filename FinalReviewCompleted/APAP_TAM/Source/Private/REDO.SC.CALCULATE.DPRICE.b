$PACKAGE APAP.TAM
SUBROUTINE REDO.SC.CALCULATE.DPRICE(SETTLEMENT, MATURITY.DATE, YLD, YEAR.DAYS.BASIS, PRICE, RESERVED.2, RESERVED.1)
*-----------------------------------------------------------------------------------------------
* Company Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed by    : Temenos Application Management
* Program Name    : REDO.SC.CALCULATE.DPRICE
*-----------------------------------------------------------------------------------------------
* Description   : This routine is used to calculate the APAP price when Calculation method is 'DPRICE'
*                 in the PRICE.TYPE record & YIELD is inputted for bond securities using the formula
* In  Parameter : SETTLEMENT
*                 MATURITY.DATE
*                 YLD
*                 YEAR.DAYS.BASIS
*
* Out Parameter : PRICE - holds the calculated Amount according to the formula defined in the requirement
*
* ODR Number    : ODR-2010-07-0083
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* 16.11.2010      Riyas Ahamad Basha J          SC006         INITIAL CREATION
*
** 17-04-2023 R22 Auto Conversion 
** 17-04-2023 Skanda R22 Manual Conversion - No changes
*-------------------------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON

    IF SETTLEMENT AND MATURITY.DATE AND YLD AND YEAR.DAYS.BASIS THEN
        YLD = YLD/100
        DATE1=SETTLEMENT
        DATE2=MATURITY.DATE
        GOSUB CALC.NO.OF.DAYS
        GOSUB CALC.PRICE
    END
RETURN
*---------------
CALC.NO.OF.DAYS:
*---------------
*Calculates the difference between the given dates DATE1 & DATE2
    BEGIN CASE
        CASE YEAR.DAYS.BASIS[1,1] EQ 'A' OR YEAR.DAYS.BASIS[1,1] EQ 'D' OR YEAR.DAYS.BASIS[1,1] EQ 'F' ;* R22 Auto conversion
            Y1 = DATE1[1,4] ; M1 = DATE1[5,2] ; D1 = DATE1[7,2]
            Y2 = DATE2[1,4] ; M2 = DATE2[5,2] ; D2 = DATE2[7,2]
            GOSUB GET.NO.OF.DAYS
        CASE 1
            D1 = '' ; D2 = ''
            D1 = DATE1[7,2]:'/':DATE1[5,2]:'/':DATE1[1,4]
            D2 = DATE2[7,2]:'/':DATE2[5,2]:'/':DATE2[1,4]
            NO.OF.DAYS = ICONV(D2,'D2/E') - ICONV(D1,'D2/E')
    END CASE

RETURN
*---------------
CALC.PRICE:
*---------------

    Y.PRICE = 360/(360+(YLD*NO.OF.DAYS))
    PRICE=Y.PRICE*100
RETURN

*--------------
GET.NO.OF.DAYS:
*--------------
* Alter the Dates according to the requirement for A3 Basis
    IF YEAR.DAYS.BASIS[1,2] EQ 'A3' THEN ;* R22 Auto conversion
        IF D1 EQ 31 THEN ;* R22 Auto conversion
            D1 = 30
        END
        IF D2 EQ 31 THEN ;* R22 Auto conversion
            BEGIN CASE
                CASE D1 LT 30 ;* R22 Auto conversion
                    CALL CDT(DUMMY,DATE2,"+1C")
                    Y2 = DATE2[1,4] ; M2 = DATE2[5,2] ;D2 = DATE2[7,2]
                CASE OTHERWISE
                    D2 = 30
            END CASE
        END
    END
    IF YEAR.DAYS.BASIS[1,1] EQ 'A' THEN ;* R22 Auto conversion

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
