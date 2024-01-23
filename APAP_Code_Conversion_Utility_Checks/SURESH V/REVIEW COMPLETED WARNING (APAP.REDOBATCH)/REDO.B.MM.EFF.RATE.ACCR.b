* @ValidationCode : MjotNTEzNjcwODU1OkNwMTI1MjoxNzA0MzY1MzMwMjU4OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 16:18:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.MM.EFF.RATE.ACCR(MM.MONEY.MARKET.ID)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.MM.EFF.RATE.ACCR
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.B.MM.EFF.RATE.ACCR is the main process routine
*               This routine is used to update the required values in the local file REDO.APAP.L.CONTRACT.BALANCES and also raise necessary entries
*Linked With  : REDO.B.MM.EFF.RATE.ACCR
*In Parameter : MM.MONEY.MARKET.ID- This is MONEY.MARKET ID
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date           Who                  Reference           Description
* ------         ------               -------------       -------------
* 12 FEB 2013    Balagurunathan B     RTC-553577          Initial Creation
* 04-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, SM to @SM, ++ to +=, -- to -=
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*18/01/2024         Suresh          R22 AUTO Conversion   CALL routine Modified, Change F.READ to F.READU
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.LMM.INSTALL.CONDS
    $INSERT I_F.LMM.ACCOUNT.BALANCES
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.INTEREST.BASIS
    $INSERT I_F.EB.ACCRUAL.PARAM
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.DATES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.H.PRODUCT.DEFINE
    $INSERT I_REDO.B.MM.EFF.RATE.ACCR.COMMON
    $INSERT I_F.REDO.APAP.L.CONTRACT.BALANCES
    $USING AC.API ;*R22 Manual Conversion 

*--------------------------------------------------------------------------------------------------------
MAIN.PARA:
*--------------------------------------------------------------------------------------------------------

    GOSUB PROCESS.PARA

RETURN

*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------

    R.MM.MONEY.MARKET = ''
    MM.MONEY.MARKET.ERR = ''
    CALL F.READ(FN.MM.MONEY.MARKET,MM.MONEY.MARKET.ID,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,MM.MONEY.MARKET.ERR)

    GOSUB PRE.PROCESS

    IF PROCESS.GOHAEAD ELSE
        RETURN
    END

    GOSUB CALC.INT.EFFECTIVE.RATE

    GOSUB CALC.MAT.DEALS

RETURN

*--------------------------------------------------------------------------------------------------------
CALC.INT.EFFECTIVE.RATE:
*--------------------------------------------------------------------------------------------------------

    Y.FV = R.MM.MONEY.MARKET<MM.PRINCIPAL>
    GOSUB GET.RATE
    GOSUB GET.BASE
    GOSUB GET.COUPON.TENOR

    Y.LAST.WORK.DAY = TODAY
    Y.TODAY.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    Y.REGION = ''
    Y.CAL.DIFF.DAYS = 'C'
    CALL CDD(Y.REGION,Y.LAST.WORK.DAY,Y.TODAY.DATE,Y.CAL.DIFF.DAYS)
    Y.INT.COUNT = 1
    Y.ACCRUE.AMT = 0
    LOOP
    WHILE Y.INT.COUNT LE Y.CAL.DIFF.DAYS
        GOSUB GET.DAYS
        IF Y.TODAY EQ R.MM.MONEY.MARKET<MM.INT.PERIOD.END> THEN
            Y.CAL.DIFF.DAYS = Y.INT.COUNT-1
            Y.DAYS = Y.COUPON.TENOR
            GOSUB CALCULATE.VALUE
            GOSUB UPDATE.CONTRACT.BALANCES
        END ELSE
            GOSUB CALCULATE.VALUE
            GOSUB UPDATE.CONTRACT.BALANCES
        END
        Y.INT.COUNT+=1
    REPEAT


    IF Y.TODAY NE R.MM.MONEY.MARKET<MM.INT.PERIOD.END> THEN
        GOSUB PRE.CALC

        GOSUB CALCULATE.VALUE
    END

    GOSUB GET.LINEAR.INT.AMT.TODATE

    GOSUB RAISE.ENTRIES

RETURN

********
GET.DAYS:
********

    Y.VAL.DATE = R.MM.MONEY.MARKET<MM.VALUE.DATE>
    Y.N.DAYS = Y.INT.COUNT - 1
    Y.N.DAYS = Y.N.DAYS:'C'
    Y.REGION=""
    Y.TODAY = TODAY
    CALL CDT(Y.REGION,Y.TODAY,Y.N.DAYS)

    Y.REGION = ''
    Y.DIFF.DAYS = 'C'
    IF Y.VAL.DATE AND Y.TODAY THEN
        CALL CDD(Y.REGION,Y.VAL.DATE,Y.TODAY,Y.DIFF.DAYS)
    END
    Y.DAYS = Y.DIFF.DAYS+1

RETURN

*--------------------------------------------------------------------------------------------------------
**********
PRE.CALC:
**********

    Y.NXT.CAL.DAY = TODAY
    CALL CDT('', Y.NXT.CAL.DAY, '+1C')

    YDAY.TYPE = ''
    CALL AWD('',Y.NXT.CAL.DAY,YDAY.TYPE)
    IF YDAY.TYPE EQ 'W' THEN
        Y.DAYS = 'C'
        CALL CDD(REGION.CODE,Y.INT.PERIOD.START,TODAY,Y.DAYS)
    END ELSE
        Y.CALC.DAY = R.DATES(EB.DAT.NEXT.WORKING.DAY)
        GOSUB CALC.LAST.DAY.OF.MONTH
        Y.DAYS = 'C'
        CALL CDD(REGION.CODE,Y.INT.PERIOD.START,Y.CALC.DAY,Y.DAYS)
    END
    Y.DAYS += 1

RETURN
*--------------------------------------------------------------------------------------------------------

************************
CALC.LAST.DAY.OF.MONTH:
************************

    Y.V.DATE.POSN = ''
    Y.NXT.MONTH = Y.CALC.DAY[5,2]
    Y.CUR.MONTH = TODAY[5,2]
    IF Y.CUR.MONTH NE Y.NXT.MONTH THEN
        COMI = TODAY
        CALL LAST.DAY.OF.THIS.MONTH
        Y.CALC.DAY = COMI
        Y.DAYS.DATE = R.DATES(EB.DAT.NEXT.WORKING.DAY)
        CALL CDT('',Y.DAYS.DATE,'-1C')
*GOSUB CALC.NEXT.DAY.ACCR
*Y.V.DATE.POSN = INT.ACCRUAL.VAL
    END ELSE
        CALL CDT('', Y.CALC.DAY, '-1C')
    END

RETURN
*--------------------------------------------------------------------------------------------------------

********
GET.RATE:
********
    IF R.MM.MONEY.MARKET<MM.INTEREST.RATE> THEN
        Y.RATE.MM = R.MM.MONEY.MARKET<MM.INTEREST.RATE>
        RETURN
    END
    BASIC.INTEREST.ID = R.MM.MONEY.MARKET<MM.INTEREST.KEY>
    CALL CACHE.READ(FN.BASIC.INTEREST,BASIC.INTEREST.ID,R.BASIC.INTEREST,BASIC.INTEREST.ERR)
    Y.RATE.MM = R.BASIC.INTEREST<EB.BIN.INTEREST.RATE> + R.MM.MONEY.MARKET<MM.INTEREST.SPREAD.1>

RETURN
*--------------------------------------------------------------------------------------------------------
********
GET.BASE:
********

    Y.BASE = ''
    INTEREST.BASIS.ID = R.MM.MONEY.MARKET<MM.INTEREST.BASIS>
    CALL F.READ(FN.INTEREST.BASIS,INTEREST.BASIS.ID,R.INTEREST.BASIS,F.INTEREST.BASIS,INTEREST.BASIS.ERR)
    Y.BASE = R.INTEREST.BASIS<IB.INT.BASIS>
    Y.BASE = FIELD(Y.BASE,'/',2)

RETURN
*--------------------------------------------------------------------------------------------------------
****************
GET.COUPON.TENOR:
****************

    Y.EB.ACCRUAL.PARAM = R.MM.MONEY.MARKET<MM.ACCRUAL.PARAM>
    Y.INT.PERIOD.START = R.MM.MONEY.MARKET<MM.VALUE.DATE>
    Y.INT.PERIOD.END = R.MM.MONEY.MARKET<MM.MATURITY.DATE>
    Y.REGION = ''
    Y.DIFF.DAYS = 'C'
    IF Y.INT.PERIOD.END AND Y.INT.PERIOD.START THEN
        CALL CDD(Y.REGION,Y.INT.PERIOD.START,Y.INT.PERIOD.END,Y.DIFF.DAYS)
    END

    Y.COUPON.TENOR = Y.DIFF.DAYS
    BEGIN CASE
        CASE Y.EB.ACCRUAL.PARAM MATCHES "FIRST":@VM:"LAST"
            Y.COUPON.TENOR = Y.DIFF.DAYS
        CASE Y.EB.ACCRUAL.PARAM EQ "BOTH"
            Y.COUPON.TENOR = Y.DIFF.DAYS+1
    END CASE

RETURN
*--------------------------------------------------------------------------------------------------------
***************
CALCULATE.VALUE:
***************

    Y.RATE = Y.RATE.MM
    Y.RATE = Y.RATE / 100
    Y.INT.EFF.RATE = Y.RATE / Y.BASE
    Y.INT.EFF.RATE = Y.INT.EFF.RATE * Y.COUPON.TENOR
    Y.INT.EFF.RATE = Y.INT.EFF.RATE * Y.FV
    Y.INT.EFF.RATE = Y.INT.EFF.RATE / Y.FV
    Y.INT.EFF.RATE += 1

    Y.POWER = Y.DAYS / Y.COUPON.TENOR
    Y.INT.EFF.RATE = PWR(Y.INT.EFF.RATE,Y.POWER)
    Y.INT.EFF.RATE -= 1
    Y.INT.EFF.RATE = Y.INT.EFF.RATE * 100
*Y.INT.EFF.RATE = DROUND(Y.INT.EFF.RATE,4)

    Y.ACCRUE.TO.DATE.AMT = Y.INT.EFF.RATE * Y.FV
    Y.ACCRUE.TO.DATE.AMT = Y.ACCRUE.TO.DATE.AMT/100

RETURN  ;* Return from CALCULATE.VALUE

*--------------------------------------------------------------------------------------------------------
GET.LINEAR.INT.AMT.TODATE:
*--------------------------------------------------------------------------------------------------------

    R.LMM.ACC.BAL = ''
    LMM.ACC.BAL.ERR = ''
    LMM.ID = MM.MONEY.MARKET.ID:'00'
    CALL F.READ(FN.LMM.ACCOUNT.BALANCES,LMM.ID,R.LMM.ACC.BAL,F.LMM.ACCOUNT.BALANCES,LMM.ACC.BAL.ERR)
    LMM.INT.AMT = ABS(R.LMM.ACC.BAL<LD27.OUTS.ACCRUED.INT>)

    LMM.INT.AMT = Y.FV * Y.COUPON.TENOR * ((Y.RATE.MM / 100) / Y.BASE ) ;* PNR/100
    LMM.INT.AMT = (LMM.INT.AMT / Y.COUPON.TENOR ) * Y.DAYS


RETURN  ;* Return from GET.LINEAR.INT.AMT.TODATE

*--------------------------------------------------------------------------------------------------------
UPDATE.CONTRACT.BALANCES:
*--------------------------------------------------------------------------------------------------------

    Y.RAISE.ACC.ENTRIES = 1
    REDO.APAP.L.CONTRACT.BALANCES.ID = MM.MONEY.MARKET.ID
    R.REDO.APAP.L.CONTRACT.BALANCES = ''
    REDO.APAP.L.CONTRACT.BALANCES.ERR = ''
*CALL F.READ(FN.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ID,R.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ERR)
    CALL F.READU(FN.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ID,R.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ERR,'');* R22 AUTO CONVERSION
    IF R.REDO.APAP.L.CONTRACT.BALANCES THEN
        GOSUB UPDATE.DETAILS
    END ELSE
        GOSUB ADD.DETAILS
    END
RETURN
*--------------------------------------------------------------------------------------------------------
UPDATE.DETAILS:
*--------------------------------------------------------------------------------------------------------

    Y.AV.POS = DCOUNT(R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.ACC.DATE>,@VM)
    Y.AV.POS +=1
    GOSUB WRITE.CONTRACT.BALANCES
RETURN
*--------------------------------------------------------------------------------------------------------
ADD.DETAILS:
*--------------------------------------------------------------------------------------------------------

    Y.AV.POS = 1
    GOSUB WRITE.CONTRACT.BALANCES
RETURN

*--------------------------------------------------------------------------------------------------------
WRITE.CONTRACT.BALANCES:
*--------------------------------------------------------------------------------------------------------

    Y.CURRENCY = R.MM.MONEY.MARKET<MM.CURRENCY>

    Y.ACC.AMT = Y.ACCRUE.TO.DATE.AMT - R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE>
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.ACC.DATE,Y.AV.POS> = Y.TODAY
    Y.INT.EFF.RATE = DROUND(Y.INT.EFF.RATE,4)
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.EFF.RATE,Y.AV.POS> = Y.INT.EFF.RATE
    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.ACC.AMT,"","")
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.AMT,Y.AV.POS>   = Y.ACC.AMT
    Y.ACCRUE.AMT += Y.ACC.AMT
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE> = Y.ACCRUE.TO.DATE.AMT
    CALL F.WRITE(FN.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ID,R.REDO.APAP.L.CONTRACT.BALANCES)

RETURN
*--------------------------------------------------------------------------------------------------------
RAISE.ENTRIES:
*--------------------------------------------------------------------------------------------------------

    REDO.APAP.L.CONTRACT.BALANCES.ID = MM.MONEY.MARKET.ID
    R.REDO.APAP.L.CONTRACT.BALANCES = ''
    REDO.APAP.L.CONTRACT.BALANCES.ERR = ''
*CALL F.READ(FN.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ID,R.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ERR)
    CALL F.READU(FN.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ID,R.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ERR,'');* R22 AUTO CONVERSION

    MM.EFF.ADJ.TOT = R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.EFF.ADJ.TOT>

    DIFF.AMT = LMM.INT.AMT - Y.ACCRUE.TO.DATE.AMT - MM.EFF.ADJ.TOT

    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.EFF.ADJ.TOT> += DIFF.AMT

    CALL F.WRITE(FN.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ID,R.REDO.APAP.L.CONTRACT.BALANCES)

    GOSUB CCY.CONV

    FINAL.ENTRY.REC = ''
    Y.ACCOUNT.ID = R.MM.MONEY.MARKET<MM.INT.LIQ.ACCT>
    Y.RAISE.ENTRY.FLAG = 0

**CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
***CALL CACHE.READ(FN.LMM.INSTALL.CONDS,ID.COMPANY,R.LMM.INSTALL.CONDS,LMM.INSTALL.CONDS.ERR)      ;* 29-Jan-2012 - E

    GOSUB CHECK.INT.PAY.ENTRY

**IF Y.RAISE.ENTRY.FLAG THEN
    GOSUB INTEREST.PAYMENT.ENTRIES
**END

**IF Y.RAISE.ACC.ENTRIES THEN
    GOSUB INTEREST.ACCRUAL.ENTRIES
**END

    IF FINAL.ENTRY.REC THEN
*CALL EB.ACCOUNTING('MM','SAO',FINAL.ENTRY.REC,'')
        AC.API.EbAccounting('MM','SAO',FINAL.ENTRY.REC,'') ;* R22 AUTO CONVERSION
    END

RETURN
*--------------------------------------------------------------------------------------------------------
INTEREST.PAYMENT.ENTRIES:
*--------------------------------------------------------------------------------------------------------

*para of code for reversal of core entries

    MM.CATEG = R.MM.MONEY.MARKET<MM.CATEGORY>
    DIFF.AMT.LCY = DROUND(DIFF.AMT.LCY,2)
    DIFF.AMT.FCY = DROUND(DIFF.AMT.FCY,2)

    IF DIFF.AMT.LCY EQ 0 OR DIFF.AMT.LCY EQ '' THEN
        RETURN
    END

    ACC.CATEG = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.LOAN.CATEG>

    STMT.ENTRY.REC = ''
    STMT.ENTRY.REC<AC.STE.ACCOUNT.NUMBER>    = MM.CCY:ACC.CATEG:'0001'
    STMT.ENTRY.REC<AC.STE.AMOUNT.LCY>        = DIFF.AMT.LCY
    STMT.ENTRY.REC<AC.STE.TRANSACTION.CODE> =  Y.INT.PAY.TXN.CODE
    STMT.ENTRY.REC<AC.STE.AMOUNT.FCY> = DIFF.AMT.FCY
    STMT.ENTRY.REC<AC.STE.EXCHANGE.RATE> = EX.RATE
    GOSUB GET.STMT.DETAILS

    FINAL.ENTRY.REC<-1> = LOWER(STMT.ENTRY.REC)

RETURN

* para of code for raising new entries

**STMT.ENTRY.REC = ''
**STMT.ENTRY.REC<AC.STE.ACCOUNT.NUMBER>    = R.MM.MONEY.MARKET<MM.INT.LIQ.ACCT>
**STMT.ENTRY.REC<AC.STE.AMOUNT.LCY>        = R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE>
**STMT.ENTRY.REC<AC.STE.TRANSACTION.CODE>  = Y.INT.PAY.TXN.CODE
**GOSUB GET.STMT.DETAILS

**FINAL.ENTRY.REC<-1> = LOWER(STMT.ENTRY.REC)

RETURN
*--------------------------------------------------------------------------------------------------------
************************
INTEREST.ACCRUAL.ENTRIES:
************************
* para for reveral of core entries for interest accrual

    PL.CATEG = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.ACC.PL.CATEG>
    DIFF.AMT.LCY = DROUND(DIFF.AMT.LCY,2)
    DIFF.AMT.FCY = DROUND(DIFF.AMT.FCY,2)

    IF DIFF.AMT.LCY EQ 0 OR DIFF.AMT.LCY EQ '' THEN
        RETURN
    END

    CATEG.ENTRY.REC = ''
    CATEG.ENTRY.REC<AC.CAT.TRANSACTION.CODE> = Y.INT.ACC.TXN.CODE
    CATEG.ENTRY.REC<AC.CAT.PL.CATEGORY>      = PL.CATEG
    CATEG.ENTRY.REC<AC.CAT.AMOUNT.LCY> = (-1) * DIFF.AMT.LCY
    CATEG.ENTRY.REC<AC.CAT.AMOUNT.FCY> = (-1) * DIFF.AMT.FCY
    CATEG.ENTRY.REC<AC.CAT.EXCHANGE.RATE> = EX.RATE
    GOSUB GET.CATEG.DETAILS

    FINAL.ENTRY.REC<-1> = LOWER(CATEG.ENTRY.REC)

RETURN

*para of code for posting new entries

**CATEG.ENTRY.REC = ''
**CATEG.ENTRY.REC<AC.CAT.AMOUNT.LCY> = -1 * Y.ACCRUE.AMT
**CATEG.ENTRY.REC<AC.CAT.TRANSACTION.CODE> = Y.INT.ACC.TXN.CODE
**CATEG.ENTRY.REC<AC.CAT.PL.CATEGORY>      = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.ACC.PL.CATEG>
**GOSUB GET.CATEG.DETAILS

*8FINAL.ENTRY.REC<-1> = LOWER(CATEG.ENTRY.REC)

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.STMT.DETAILS:
*****************

    STMT.ENTRY.REC<AC.STE.THEIR.REFERENCE>   = MM.MONEY.MARKET.ID
    STMT.ENTRY.REC<AC.STE.CUSTOMER.ID>       = R.MM.MONEY.MARKET<MM.CUSTOMER.ID>
    STMT.ENTRY.REC<AC.STE.ACCOUNT.OFFICER>   = R.MM.MONEY.MARKET<MM.MIS.ACCT.OFFICER>
    STMT.ENTRY.REC<AC.STE.PRODUCT.CATEGORY>  = ACC.CATEG
**STMT.ENTRY.REC<AC.STE.VALUE.DATE>        = R.MM.MONEY.MARKET<MM.INT.PERIOD.END>
    STMT.ENTRY.REC<AC.STE.CURRENCY>          = R.MM.MONEY.MARKET<MM.CURRENCY>
    STMT.ENTRY.REC<AC.STE.POSITION.TYPE>     = 'TR'
    STMT.ENTRY.REC<AC.STE.OUR.REFERENCE>     = MM.MONEY.MARKET.ID
    STMT.ENTRY.REC<AC.STE.CURRENCY.MARKET>   = '1'
    STMT.ENTRY.REC<AC.STE.DEPARTMENT.CODE>   = R.MM.MONEY.MARKET<MM.DEPT.CODE>
    STMT.ENTRY.REC<AC.STE.TRANS.REFERENCE>   = MM.MONEY.MARKET.ID
    STMT.ENTRY.REC<AC.STE.SYSTEM.ID>         = 'MM'
    STMT.ENTRY.REC<AC.STE.BOOKING.DATE>      = TODAY
    STMT.ENTRY.REC<AC.STE.COMPANY.CODE>      = ID.COMPANY

RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.CATEG.DETAILS:
******************

    CATEG.ENTRY.REC<AC.CAT.CUSTOMER.ID>      = R.MM.MONEY.MARKET<MM.CUSTOMER.ID>
    CATEG.ENTRY.REC<AC.CAT.ACCOUNT.OFFICER>  = R.MM.MONEY.MARKET<MM.MIS.ACCT.OFFICER>
    CATEG.ENTRY.REC<AC.CAT.PRODUCT.CATEGORY> = R.MM.MONEY.MARKET<MM.CATEGORY>
*CATEG.ENTRY.REC<AC.CAT.VALUE.DATE>       = R.DATES(EB.DAT.LAST.WORKING.DAY)
    CATEG.ENTRY.REC<AC.CAT.CURRENCY>         = R.MM.MONEY.MARKET<MM.CURRENCY>
    CATEG.ENTRY.REC<AC.CAT.POSITION.TYPE>    = 'TR'
    CATEG.ENTRY.REC<AC.CAT.OUR.REFERENCE>    = MM.MONEY.MARKET.ID
    CATEG.ENTRY.REC<AC.CAT.CURRENCY.MARKET>  = '1'
    CATEG.ENTRY.REC<AC.CAT.DEPARTMENT.CODE>  = R.MM.MONEY.MARKET<MM.DEPT.CODE>
    CATEG.ENTRY.REC<AC.CAT.TRANS.REFERENCE>  = MM.MONEY.MARKET.ID
    CATEG.ENTRY.REC<AC.CAT.SYSTEM.ID>        = 'MM'
    CATEG.ENTRY.REC<AC.CAT.BOOKING.DATE>     = TODAY
    CATEG.ENTRY.REC<AC.CAT.COMPANY.CODE>     = ID.COMPANY

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
CHECK.INT.PAY.ENTRY:
*******************

    ENQ.SELECTION<2,1> = 'ACCOUNT'
    ENQ.SELECTION<2,1> = 'BOOKING.DATE'
    ENQ.SELECTION<3,1> = '1'
    ENQ.SELECTION<3,2> = '1'
    ENQ.SELECTION<4,1> = Y.ACCOUNT.ID
    ENQ.SELECTION<4,2> = TODAY

    D.FIELDS            = 'ACCOUNT':@FM:'BOOKING.DATE'
    D.RANGE.AND.VALUE   = Y.ACCOUNT.ID:@FM:TODAY
    D.LOGICAL.OPERANDS  = '1':@FM:'1'
    CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)
    LOOP
        REMOVE Y.RES.LIST FROM Y.ID.LIST SETTING Y.RES.POS
    WHILE Y.RES.LIST:Y.RES.POS
        Y.MM.FULL.ID = FIELD(Y.RES.LIST,'*',6,1)
        Y.MM.ID = FIELD(Y.MM.FULL.ID,';',1,1)
        IF Y.MM.ID EQ MM.MONEY.MARKET.ID THEN
            Y.SE.ID = FIELD(Y.RES.LIST,'*',2,1)
            CALL F.READ(FN.STMT.ENTRY,Y.SE.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
            Y.SE.TXN.CODE = R.STMT.ENTRY<AC.STE.TRANSACTION.CODE>
            IF Y.SE.TXN.CODE EQ Y.INT.PAY.TXN.CODE THEN
                Y.RAISE.ENTRY.FLAG = 1
            END
        END
    REPEAT

RETURN

*************
PRE.PROCESS:
*************

    PROCESS.GOHAEAD = @TRUE

* No need to consider the contracts that interest period is over
    IF TODAY LE R.MM.MONEY.MARKET<MM.INT.PERIOD.END> ELSE
        PROCESS.GOHAEAD = @FALSE
        RETURN
    END

* Considering only Placememt/Loan categorys
    MM.CATEG = R.MM.MONEY.MARKET<MM.CATEGORY>
    CATEGPOS = ''
    LOCATE MM.CATEG IN Y.MM.PLACE.CATEG SETTING CATEGPOS ELSE
        PROCESS.GOHAEAD = @FALSE
        RETURN
    END

* If the interest payment is set as daily, then effective interest calulation
* is not done. Since Customer will be always out using Linear method
    Y.INT.SCHEDULE = R.MM.MONEY.MARKET<MM.INT.SCHEDULE>
    Y.INT.SCH = INDEX(Y.INT.SCHEDULE,"DAILY",1)
    IF Y.INT.SCH THEN
        PROCESS.GOHAEAD = @FALSE
        RETURN
    END

* If the interest payment is set as daily, then effective interest calulation
* is not done. Since Customer will be always out using Linear method
    Y.INT.DUE.DATE = R.MM.MONEY.MARKET<MM.INT.DUE.DATE>
    Y.INT.DUE = INDEX(Y.INT.DUE.DATE,"DAILY",1)
    IF Y.INT.DUE THEN
        PROCESS.GOHAEAD = @FALSE
        RETURN
    END

RETURN

*--------------------------------------------------------------------------------------------------------
CCY.CONV:
*--------------------------------------------------------------------------------------------------------
    MM.CCY = R.MM.MONEY.MARKET<MM.CURRENCY>
    DIFF.AMT.FCY = ''
    DIFF.AMT.LCY = ''

    IF MM.CCY EQ LCCY THEN
        DIFF.AMT.LCY = DIFF.AMT
        DIFF.AMT.FCY = ''
        EX.RATE = ''
    END

    IF MM.CCY NE LCCY THEN
        DIFF.AMT.FCY = DIFF.AMT
        CCY.MARKET = 1
        FCY.TXN.CCY = MM.CCY
        FCY.TXN.AMOUNT = DIFF.AMT
        AML.CCY = LCCY
        SELL.AMT = ""
        DIFF.AMT = ''
        LCCY.AMT = ''
        RET.ERR = ''
        EX.RATE = ''
        CALL EXCHRATE(CCY.MARKET,FCY.TXN.CCY,FCY.TXN.AMOUNT,AML.CCY,SELL.AMT,'',EX.RATE,DIFF.AMT,LCCY.AMT,RET.ERR)
        DIFF.AMT.LCY = LCCY.AMT
    END

RETURN

*--------------------------------------------------------------------------------------------------------
CALC.MAT.DEALS:
*--------------------------------------------------------------------------------------------------------


    Y.MM.INT.PERIOD.END = R.MM.MONEY.MARKET<MM.INT.PERIOD.END>
    Y.NXT.WDAY = R.DATES(EB.DAT.NEXT.WORKING.DAY)
    FINAL.ENTRY.REC = ''

    IF Y.MM.INT.PERIOD.END GE TODAY AND Y.MM.INT.PERIOD.END LT Y.NXT.WDAY THEN

        LIN.AMT = LMM.INT.AMT
        EIA = R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE>
        DIFF.AMT = DROUND((LIN.AMT - EIA),2)
        DIFF.AMT = (-1) * DIFF.AMT

        GOSUB CCY.CONV

        IF DIFF.AMT NE 0 THEN
            GOSUB INTEREST.PAYMENT.ENTRIES
            GOSUB INTEREST.ACCRUAL.ENTRIES
        END

        IF FINAL.ENTRY.REC THEN
*CALL EB.ACCOUNTING('MM','SAO',FINAL.ENTRY.REC,'')
            AC.API.EbAccounting('MM','SAO',FINAL.ENTRY.REC,'');* R22 AUTO CONVERSION
        END

    END

RETURN

*--------------------------------------------------------------------------------------------------------
END
