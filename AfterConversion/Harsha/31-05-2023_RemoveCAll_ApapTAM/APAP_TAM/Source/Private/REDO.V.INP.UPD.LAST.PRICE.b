* @ValidationCode : Mjo5OTIwMjk4NTA6Q3AxMjUyOjE2ODQ0OTEwNDQ3ODk6SVRTUzotMTotMTo2NjoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:44
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 66
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.V.INP.UPD.LAST.PRICE
*-----------------------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed by : Temenos Application Management
* Program Name : REDO.V.INP.UPD.LAST.PRICE
*-----------------------------------------------------------------------------------------------
* Description : This is the Input routine attached to SECURITY.MASTER versions which will take the
* yield price entered in the Local reference field(L.SC.TRN.YIELD) and calculates the
* PRICE using the formula and updates in the LAST.PRICE field of the SECURITY.MASTER record
*
* In Parameter : --na--
* Out Parameter : --na--
* ODR Number : ODR-2010-07-0083
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* 15.11.2010 Krishna Murthy T.S SC006 INITIAL CREATION
* 15.07.2011 Pradeep S PACS00056285(KB) Price calcualtion logic changed
* 13.07.2012 Gassali S K PACS00206989 Condition for price calculation changed
* Issue date also passed to REDO.SC.CALCULATE.PRICE
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     F.READ TO CACHE.READ, VM TO @VM
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   CALL ROUTINE ADDED
*----------------------------------------------------------------------------------------
*-------------------------------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.SECURITY.MASTER
    $INSERT I_F.PRICE.TYPE

    GOSUB INIT
    GOSUB PROCESS
RETURN

*----
INIT:
*----
*Initialising and opening necesseary files

    FN.PRICE.TYPE = 'F.PRICE.TYPE'
    F.PRICE.TYPE = ''
    R.PRICE.TYPE = ''
    Y.PT.ERR = ''
    CALL OPF(FN.PRICE.TYPE,F.PRICE.TYPE)

    Y.TRN.POS = ''
    CALL GET.LOC.REF('SECURITY.MASTER','L.SC.TRN.YIELD',Y.TRN.POS)
    Y.REDEM = 100
    Y.TODAY = TODAY
    Y.ROUNDING = ''
    RESERVED.2 = ''
    RESERVED.1 = ''
    Y.MAT.DATE = R.NEW(SC.SCM.MATURITY.DATE)
    Y.INT.RATE.LIST = R.NEW(SC.SCM.INTEREST.RATE)
    Y.SM.LOC.REF.LIST = R.NEW(SC.SCM.LOCAL.REF)

    Y.ACCR.ST.DATE = R.NEW(SC.SCM.ACCRUAL.START.DATE)
    Y.FREQ = R.NEW(SC.SCM.NO.OF.PAYMENTS)
    Y.INT.BASIS = R.NEW(SC.SCM.INTEREST.DAY.BASIS)
    Y.PRICE.TYPE = R.NEW(SC.SCM.PRICE.TYPE)
    Y.YLD = Y.SM.LOC.REF.LIST<1,Y.TRN.POS>
    Y.INT.CNT = DCOUNT(Y.INT.RATE.LIST,@VM) ;*R22 AUTO CONVERSION
    Y.INT.RATE = Y.INT.RATE.LIST<1,Y.INT.CNT>

RETURN

*-------
PROCESS:
*-------
*Updating the LAST.PRICE field depending on the local refernce field value

    CALL CACHE.READ(FN.PRICE.TYPE, Y.PRICE.TYPE, R.PRICE.TYPE, Y.PT.ERR) ;*R22 AUTO CONVERSION
    Y.CALC.METHOD = R.PRICE.TYPE<SC.PRT.CALCULATION.METHOD>
    Y.PERC = R.PRICE.TYPE<SC.PRT.PERCENTAGE>

*PACS00206989 -S
    Y.YR.BASIS = Y.INT.BASIS[3,9]
    Y.YR.DENOM = FIELD(Y.YR.BASIS,'/',2)
    Y.ISSUE.DATE = R.NEW(SC.SCM.ISSUE.DATE)
*PACS00206989 -E

    IF Y.YLD AND Y.MAT.DATE AND Y.INT.RATE NE '' AND Y.FREQ AND Y.INT.BASIS AND Y.ACCR.ST.DATE THEN
        BEGIN CASE
            CASE Y.CALC.METHOD EQ 'DPRICE' AND Y.YR.DENOM EQ '365' OR Y.YR.DENOM EQ '366' ;* PACS00206989
*CALL REDO.SC.CALCULATE.PRICE(Y.TODAY,Y.MAT.DATE,Y.INT.RATE,Y.YLD,Y.REDEM,Y.FREQ,Y.INT.BASIS,Y.PRICE,Y.ROUNDING,Y.ACCR.ST.DATE,Y.ISSUE.DATE)
*R22 MANUAL CONVERSION
*APAP.TAM.REDO.SC.CALCULATE.PRICE(Y.TODAY,Y.MAT.DATE,Y.INT.RATE,Y.YLD,Y.REDEM,Y.FREQ,Y.INT.BASIS,Y.PRICE,Y.ROUNDING,Y.ACCR.ST.DATE,Y.ISSUE.DATE);*R22 MANUAL CODE CONVERSION
                APAP.TAM.redoScCalculatePrice(Y.TODAY,Y.MAT.DATE,Y.INT.RATE,Y.YLD,Y.REDEM,Y.FREQ,Y.INT.BASIS,Y.PRICE,Y.ROUNDING,Y.ACCR.ST.DATE,Y.ISSUE.DATE) ;*R22 MANUAL CODE CONVERSION
            CASE Y.CALC.METHOD EQ 'DPRICE' AND Y.YR.DENOM EQ '360' ;* PACS00206989
*APAP.TAM.REDO.SC.CALCULATE.DPRICE(Y.TODAY,Y.MAT.DATE,Y.YLD,Y.INT.BASIS,Y.PRICE,RESERVED.2,RESERVED.1)
*R22 MANUAL CONVERSION
*APAP.TAM.REDO.SC.CALCULATE.DPRICE(Y.TODAY,Y.MAT.DATE,Y.YLD,Y.INT.BASIS,Y.PRICE,RESERVED.2,RESERVED.1) ;*R22 MANUAL CODE CONVERSION
                APAP.TAM.redoScCalculateDprice(Y.TODAY,Y.MAT.DATE,Y.YLD,Y.INT.BASIS,Y.PRICE,RESERVED.2,RESERVED.1) ;*R22 MANUAL CODE CONVERSION
        END CASE

*PACS00056285 - KB - S
        IF Y.PERC NE 'Y' THEN
            Y.PRICE = Y.PRICE/100
        END
        R.NEW(SC.SCM.LAST.PRICE)= DROUND(Y.PRICE,6)
*PACS00056285 - KB - E

    END
RETURN
END
