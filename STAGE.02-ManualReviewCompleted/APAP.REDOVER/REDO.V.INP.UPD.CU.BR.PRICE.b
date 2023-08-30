* @ValidationCode : MjotNDg0NjM3MTg2OkNwMTI1MjoxNjgxMzAxODgyNjkwOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 17:48:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.UPD.CU.BR.PRICE
*-----------------------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed by : Temenos Application Management
* Program Name : REDO.V.INP.UPD.CU.BR.PRICE
*-----------------------------------------------------------------------------------------------
* Description : This routine will take the yield price entered in the Local reference
* filed(L.SC.TRN.YIELD) and calculates the PRICE using the formula and
* updates in the CUST.PRICE & BR.PRICE fields in the SEC.TRADE record
*
* In Parameter : --na--
* Out Parameter : --na--
* ODR Number : ODR-2010-07-0083
*--------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*
* 15.11.2010 Riyas Ahamad Basha J ODR-2010-07-0083(SC006) INITIAL CREATION
* 01.04.2011 Pradeep S PACS00052348 Fix
* 02.05.2011 Pradeep S PACS00056285 Price value rounded to 6
* decimals
* 15.07.2011 Pradeep S PACS00056285(KB) Price calculation logic changed
* 13.07.2012 Gassali S K PACS00206989 Condition for Price calculation changed
* Issue date also passed to REDO.SC.CALCULATE.PRICE
*-------------------------------------------------------------------------------------------------
 
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion               VM TO @VM,F.READ TO CACHE.READ
*12-04-2023              Samaran T                R22 Manual Code conversion                       Call Routine Format Modified
*------------------------------------------------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.SEC.TRADE
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

    FN.SECURITY.MASTER='F.SECURITY.MASTER'
    F.SECURITY.MASTER=''
    R.SECURITY.MASTER=''
    Y.SM.ERR=''
    CALL OPF(FN.SECURITY.MASTER,F.SECURITY.MASTER)

    FN.SEC.TRADE='F.SEC.TRADE'
    F.SEC.TRADE=''
    R.SEC.TRADE=''
    Y.ST.ERR=''
    CALL OPF(FN.SEC.TRADE,F.SEC.TRADE)
    Y.TRN.POS = ''
    CALL GET.LOC.REF('SEC.TRADE','L.SC.TRN.YIELD',Y.TRN.POS)
    Y.REDEM = 100
    Y.CNTR = 0
    Y.BR.CNTR = 0
    Y.TODAY = R.NEW(SC.SBS.VALUE.DATE)
    Y.ROUNDING = ''
    Y.SEC.NO = R.NEW(SC.SBS.SECURITY.CODE)
    Y.ST.LOC.REF.LIST = R.NEW(SC.SBS.LOCAL.REF)
    Y.CU.NO.NOM.LIST = R.NEW(SC.SBS.CUST.NO.NOM)
    Y.BR.NO.NOM.LIST = R.NEW(SC.SBS.BR.NO.NOM)
RETURN

*-------
PROCESS:
*-------
    CALL F.READ(FN.SECURITY.MASTER,Y.SEC.NO,R.SECURITY.MASTER,F.SECURITY.MASTER,Y.SM.ERR)
    Y.MAT.DATE = R.SECURITY.MASTER<SC.SCM.MATURITY.DATE>
    Y.INT.RATE.LIST = R.SECURITY.MASTER<SC.SCM.INTEREST.RATE>
    Y.FREQ = R.SECURITY.MASTER<SC.SCM.NO.OF.PAYMENTS>
    Y.INT.BASIS = R.SECURITY.MASTER<SC.SCM.INTEREST.DAY.BASIS>
    Y.PRICE.TYPE = R.SECURITY.MASTER<SC.SCM.PRICE.TYPE>
    Y.ACCR.ST.DATE = R.SECURITY.MASTER<SC.SCM.ACCRUAL.START.DATE>
    Y.INT.CNT = DCOUNT(Y.INT.RATE.LIST,@VM)
    Y.INT.RATE = Y.INT.RATE.LIST<1,Y.INT.CNT>
    Y.YLD = Y.ST.LOC.REF.LIST<1,Y.TRN.POS>

*PACS00206989 -S
    Y.YR.BASIS = Y.INT.BASIS[3,9]
    Y.YR.DENOM = FIELD(Y.YR.BASIS,'/',2)
    Y.ISSUE.DATE = R.NEW(SC.SBS.ISSUE.DATE)
*PACS00206989 -E

    IF Y.MAT.DATE AND (Y.INT.RATE NE '') AND Y.YLD AND Y.REDEM AND Y.FREQ AND Y.INT.BASIS AND Y.ACCR.ST.DATE THEN
        CALL CACHE.READ(FN.PRICE.TYPE, Y.PRICE.TYPE, R.PRICE.TYPE, Y.PT.ERR)      ;*R22 AUTO CODE CONVERSION
        Y.CALC.METHOD = R.PRICE.TYPE<SC.PRT.CALCULATION.METHOD>
        BEGIN CASE
            CASE Y.CALC.METHOD EQ 'DPRICE' AND Y.YR.DENOM EQ '365' OR Y.YR.DENOM EQ '366' ;* PACS00206989
                CALL APAP.TAM.REDO.SC.CALCULATE.PRICE(Y.TODAY,Y.MAT.DATE,Y.INT.RATE,Y.YLD,Y.REDEM,Y.FREQ,Y.INT.BASIS,Y.PRICE,Y.ROUNDING,Y.ACCR.ST.DATE,Y.ISSUE.DATE)    ;*R22 MANUAL CODE CONVERSION
                GOSUB UPD.PRICE
            CASE Y.CALC.METHOD EQ 'DPRICE' AND Y.YR.DENOM EQ '360' ;* PACS00206989
                CALL APAP.TAM.REDO.SC.CALCULATE.DPRICE(Y.TODAY,Y.MAT.DATE,Y.YLD,Y.INT.BASIS,Y.PRICE,RESERVED.2,RESERVED.1)    ;*R22 MANUAL CODE CONVERSION
                GOSUB UPD.PRICE
        END CASE
    END
RETURN
*----------
UPD.PRICE:
*---------
*Updating Customer price field
*PACS00052348 - S

    Y.PRICE.PREC = R.PRICE.TYPE<SC.PRT.PERCENTAGE>

    LOOP
        REMOVE Y.NO.NOM FROM Y.CU.NO.NOM.LIST SETTING Y.NOM.POS
        Y.CNTR += 1
    WHILE Y.NO.NOM:Y.NOM.POS
*PACS00056285 - KB - S
        IF Y.PRICE.PREC NE "Y" THEN
            Y.CU.PRICE = Y.PRICE/100
        END ELSE
            Y.CU.PRICE = Y.PRICE
        END
*Y.CU.PRICE = Y.PRICE*Y.FACTOR
*Y.CU.PRICE = Y.CU.PRICE/Y.NO.NOM
*PACS00056285 - KB - E
*PACS00056285 - S
        Y.CU.PRICE = FMT(Y.CU.PRICE,"L4#10")
        Y.CU.PRICE = TRIM(Y.CU.PRICE,' ',"B")
*PACS00056285 - E
        R.NEW(SC.SBS.CUST.PRICE)<1,Y.CNTR> = Y.CU.PRICE

        R.NEW(SC.SBS.CU.GROSS.AM.TRD)<1,Y.CNTR> = Y.CU.PRICE * Y.NO.NOM

        IF Y.PRICE.PREC EQ "Y" THEN
            Y.CU.GROSS.AM.TRD = Y.CU.PRICE * Y.NO.NOM
            Y.CU.GROSS.AM.TRD = Y.CU.GROSS.AM.TRD / 100
        END ELSE
            Y.CU.GROSS.AM.TRD = Y.CU.PRICE * Y.NO.NOM
        END

        Y.CU.INT.AM.TRD = R.NEW(SC.SBS.CUST.INTR.AMT)<1,Y.CNTR>
        R.NEW(SC.SBS.CU.GROSS.AM.TRD)<1,Y.CNTR> = Y.CU.GROSS.AM.TRD
        R.NEW(SC.SBS.CU.GROSS.ACCR)<1,Y.CNTR> = Y.CU.GROSS.AM.TRD + Y.CU.INT.AM.TRD
        R.NEW(SC.SBS.CU.NET.AM.TRD)<1,Y.CNTR> = Y.CU.GROSS.AM.TRD + Y.CU.INT.AM.TRD
        R.NEW(SC.SBS.CU.AMOUNT.DUE)<1,Y.CNTR> = Y.CU.GROSS.AM.TRD + Y.CU.INT.AM.TRD

    REPEAT

*Updating Broker Price field
    LOOP
        REMOVE Y.BR.NOM FROM Y.BR.NO.NOM.LIST SETTING Y.BR.POS
        Y.BR.CNTR += 1
    WHILE Y.BR.NOM:Y.BR.POS
*PACS00056285 - KB - S
        IF Y.PRICE.PREC NE "Y" THEN
            Y.BR.PRICE = Y.PRICE/100
        END ELSE
            Y.BR.PRICE = Y.PRICE
        END
*Y.BR.PRICE = Y.PRICE*Y.FACTOR
*Y.BR.PRICE = Y.BR.PRICE/Y.BR.NOM
*PACS00056285 - KB - E

*PACS00056285 - S
        Y.BR.PRICE = FMT(Y.BR.PRICE,"L4#10")
        Y.BR.PRICE = TRIM(Y.BR.PRICE,' ',"B")
*PACS00056285 - E
        R.NEW(SC.SBS.BR.PRICE)<1,Y.BR.CNTR> = Y.BR.PRICE

        IF Y.PRICE.PREC EQ "Y" THEN
            Y.BR.GROSS.AM.TRD = Y.BR.PRICE * Y.BR.NOM
            Y.BR.GROSS.AM.TRD = Y.BR.GROSS.AM.TRD / 100
        END ELSE
            Y.BR.GROSS.AM.TRD = Y.BR.PRICE * Y.BR.NOM
        END

        Y.BR.INT.AM.TRD = R.NEW(SC.SBS.BR.INTR.AM.TRD)<1,Y.BR.CNTR>

        R.NEW(SC.SBS.BR.GROSS.AM.TRD)<1,Y.BR.CNTR> = Y.BR.GROSS.AM.TRD
        R.NEW(SC.SBS.BR.GROSS.ACCR)<1,Y.BR.CNTR> = Y.BR.GROSS.AM.TRD + Y.BR.INT.AM.TRD
        R.NEW(SC.SBS.BR.NET.AM.TRD)<1,Y.BR.CNTR> = Y.BR.GROSS.AM.TRD + Y.BR.INT.AM.TRD
        R.NEW(SC.SBS.BR.AMOUNT.DUE)<1,Y.BR.CNTR> = Y.BR.GROSS.AM.TRD + Y.BR.INT.AM.TRD

*PACS00052348 - E
    REPEAT

RETURN


*-----------------------------------------------------------
END
