* @ValidationCode : MjoyMDA5MjM1NzE5OkNwMTI1MjoxNjgyNTAyNjIyNTQxOklUU1M6LTE6LTE6NTQ1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Apr 2023 15:20:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 545
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.B.EFF.RATE.ACCRUALS(MM.MONEY.MARKET.ID)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.EFF.RATE.ACCRUALS
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.APAP.B.EFF.RATE.ACCRUALS is the main process routine
*               This routine is used to update the required values in the local file REDO.APAP.L.CONTRACT.BALANCES and also raise necessary entries
*Linked With  : REDO.APAP.B.EFF.RATE.ACCRUALS
*In Parameter : MM.MONEY.MARKET.ID- This is MONEY.MARKET ID
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 30 SEP 2010    Mohammed Anies K      ODR-2010-07-0077        Initial Creation
* 29-Jan-2012 Gangadhar.S.V.  Performance Tuning Changed F.READ to CACHE.READ
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   FM to @FM, Y.INT.EFF.RATE - 1 to  Y.INT.EFF.RATE -= 1
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.MM.MONEY.MARKET
    $INSERT I_F.LMM.INSTALL.CONDS
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.INTEREST.BASIS
    $INSERT I_F.EB.ACCRUAL.PARAM
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.DATES
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.H.PRODUCT.DEFINE
    $INSERT I_REDO.APAP.B.EFF.RATE.ACCRUALS.COMMON
    $INSERT I_F.REDO.APAP.L.CONTRACT.BALANCES

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    CALL F.READ(FN.MM.MONEY.MARKET,MM.MONEY.MARKET.ID,R.MM.MONEY.MARKET,F.MM.MONEY.MARKET,MM.MONEY.MARKET.ERR)
    IF TODAY LE R.MM.MONEY.MARKET<MM.INT.PERIOD.END> ELSE
        RETURN
    END

    GOSUB CALC.INT.EFFECTIVE.RATE

RETURN

*--------------------------------------------------------------------------------------------------------
***********************
CALC.INT.EFFECTIVE.RATE:
***********************

    Y.FV = R.MM.MONEY.MARKET<MM.PRINCIPAL>
    GOSUB GET.RATE
    GOSUB GET.BASE
    GOSUB GET.COUPON.TENOR

    REDO.APAP.L.CONTRACT.BALANCES.ID = MM.MONEY.MARKET.ID
    CALL F.READ(FN.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ID,R.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ERR)
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
            Y.INT.COUNT +=1
*CONTINUE
        END ELSE
            GOSUB CALCULATE.VALUE
            GOSUB UPDATE.CONTRACT.BALANCES

            Y.INT.COUNT+=1
        END
    REPEAT

    GOSUB RAISE.ENTRIES

RETURN
*--------------------------------------------------------------------------------------------------------
********
GET.RATE:
********
    IF R.MM.MONEY.MARKET<MM.INTEREST.RATE> THEN
        Y.RATE = R.MM.MONEY.MARKET<MM.INTEREST.RATE>
        RETURN
    END
    BASIC.INTEREST.ID = R.MM.MONEY.MARKET<MM.INTEREST.KEY>
*    CALL F.READ(FN.BASIC.INTEREST,BASIC.INTEREST.ID,R.BASIC.INTEREST,F.BASIC.INTEREST,BASIC.INTEREST.ERR) ;* 29-Jan-2012 - S
    CALL CACHE.READ(FN.BASIC.INTEREST,BASIC.INTEREST.ID,R.BASIC.INTEREST,BASIC.INTEREST.ERR)          ;* 29-Jan-2012 - E
    Y.RATE = R.BASIC.INTEREST<EB.BIN.INTEREST.RATE> + R.MM.MONEY.MARKET<MM.INTEREST.SPREAD.1>
RETURN
*--------------------------------------------------------------------------------------------------------
********
GET.BASE:
********
    INTEREST.BASIS.ID = R.MM.MONEY.MARKET<MM.INTEREST.BASIS>
    CALL F.READ(FN.INTEREST.BASIS,INTEREST.BASIS.ID,R.INTEREST.BASIS,F.INTEREST.BASIS,INTEREST.BASIS.ERR)
    Y.BASE = R.INTEREST.BASIS<IB.INT.BASIS>
    Y.BASE = FIELD(Y.BASE,'/',2)
RETURN
*--------------------------------------------------------------------------------------------------------
****************
GET.COUPON.TENOR:
****************
    Y.INT.PERIOD.END = R.MM.MONEY.MARKET<MM.INT.PERIOD.END>
    Y.INT.PERIOD.START = R.MM.MONEY.MARKET<MM.INT.PERIOD.START>
    Y.REGION = ''
    Y.DIFF.DAYS = 'C'
    CALL CDD(Y.REGION,Y.INT.PERIOD.START,Y.INT.PERIOD.END,Y.DIFF.DAYS)

    IF NO.OF.REC.EAP EQ 1 THEN
        Y.COUPON.TENOR = Y.DIFF.DAYS
    END
    IF NO.OF.REC.EAP EQ 2 THEN
        Y.COUPON.TENOR = Y.DIFF.DAYS+1
    END

RETURN
*--------------------------------------------------------------------------------------------------------
********
GET.DAYS:
********

    Y.VAL.DATE = R.MM.MONEY.MARKET<MM.INT.PERIOD.START>
    Y.N.DAYS = Y.INT.COUNT - 1
    Y.N.DAYS = Y.N.DAYS:'C'
    Y.REGION=""
    Y.TODAY = TODAY
    CALL CDT(Y.REGION,Y.TODAY,Y.N.DAYS)

    Y.REGION = ''
    Y.DIFF.DAYS = 'C'
    CALL CDD(Y.REGION,Y.VAL.DATE,Y.TODAY,Y.DIFF.DAYS)
    Y.DAYS = Y.DIFF.DAYS+1

RETURN
*--------------------------------------------------------------------------------------------------------
***************
CALCULATE.VALUE:
***************

    Y.INT.EFF.RATE = (Y.RATE/100) / Y.BASE
    Y.INT.EFF.RATE = Y.INT.EFF.RATE * Y.COUPON.TENOR
    Y.INT.EFF.RATE = Y.INT.EFF.RATE * Y.FV / Y.FV
    Y.INT.EFF.RATE += 1

    Y.POWER = Y.DAYS / Y.COUPON.TENOR

    Y.INT.EFF.RATE = PWR(Y.INT.EFF.RATE,Y.POWER)
    Y.INT.EFF.RATE -= 1 ;*R22 AUTO CODE CONVERSION
    Y.INT.EFF.RATE = Y.INT.EFF.RATE * 100
RETURN
*--------------------------------------------------------------------------------------------------------
************************
UPDATE.CONTRACT.BALANCES:
************************
    Y.RAISE.ACC.ENTRIES = 1
    REDO.APAP.L.CONTRACT.BALANCES.ID = MM.MONEY.MARKET.ID
    CALL F.READ(FN.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ID,R.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ERR)
    IF R.REDO.APAP.L.CONTRACT.BALANCES THEN
        GOSUB UPDATE.DETAILS
    END ELSE
        GOSUB ADD.DETAILS
    END
RETURN
*--------------------------------------------------------------------------------------------------------
**************
UPDATE.DETAILS:
**************
    Y.AV.POS = DCOUNT(R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.ACC.DATE>,@VM)
    Y.AV.POS +=1
    GOSUB WRITE.CONTRACT.BALANCES
RETURN
*--------------------------------------------------------------------------------------------------------
***********
ADD.DETAILS:
***********
    Y.AV.POS = 1
    GOSUB WRITE.CONTRACT.BALANCES
RETURN
*--------------------------------------------------------------------------------------------------------
***********************
WRITE.CONTRACT.BALANCES:
***********************

    Y.ACCRUE.TO.DATE.AMT = Y.INT.EFF.RATE * Y.FV
    Y.ACCRUE.TO.DATE.AMT = Y.ACCRUE.TO.DATE.AMT/100
    Y.INT.EFF.RATE = DROUND(Y.INT.EFF.RATE,4)
    Y.CURRENCY = R.MM.MONEY.MARKET<MM.CURRENCY>
    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.ACCRUE.TO.DATE.AMT,"","")

    Y.ACC.AMT = Y.ACCRUE.TO.DATE.AMT - R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE>
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.ACC.DATE,Y.AV.POS> = Y.TODAY
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.INT.EFF.RATE,Y.AV.POS> = Y.INT.EFF.RATE
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.AMT,Y.AV.POS>   = Y.ACC.AMT
    Y.ACCRUE.AMT += Y.ACC.AMT
    R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE> = Y.ACCRUE.TO.DATE.AMT
    CALL F.WRITE(FN.REDO.APAP.L.CONTRACT.BALANCES,REDO.APAP.L.CONTRACT.BALANCES.ID,R.REDO.APAP.L.CONTRACT.BALANCES)

RETURN
*--------------------------------------------------------------------------------------------------------
**************
RAISE.ENTRIES:
**************
    FINAL.ENTRY.REC = ''
    Y.ACCOUNT.ID = R.MM.MONEY.MARKET<MM.INT.LIQ.ACCT>
    Y.RAISE.ENTRY.FLAG = 0
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)
*    CALL F.READ(FN.LMM.INSTALL.CONDS,ID.COMPANY,R.LMM.INSTALL.CONDS,F.LMM.INSTALL.CONDS,LMM.INSTALL.CONDS.ERR) ;* 29-Jan-2012 - S
    CALL CACHE.READ(FN.LMM.INSTALL.CONDS,ID.COMPANY,R.LMM.INSTALL.CONDS,LMM.INSTALL.CONDS.ERR)        ;* 29-Jan-2012 - E
    GOSUB CHECK.INT.PAY.ENTRY
    IF Y.RAISE.ENTRY.FLAG THEN
        GOSUB INTEREST.PAYMENT.ENTRIES
    END

    IF Y.RAISE.ACC.ENTRIES THEN
        GOSUB INTEREST.ACCRUAL.ENTRIES
    END
    IF FINAL.ENTRY.REC THEN
        CALL EB.ACCOUNTING('MM','SAO',FINAL.ENTRY.REC,'')
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************************
INTEREST.PAYMENT.ENTRIES:
************************
*para of code for reversal of core entries

    STMT.ENTRY.REC = ''
    STMT.ENTRY.REC<AC.STE.ACCOUNT.NUMBER>    = R.MM.MONEY.MARKET<MM.INT.LIQ.ACCT>
    STMT.ENTRY.REC<AC.STE.AMOUNT.LCY>        = -1 * R.MM.MONEY.MARKET<MM.TOT.INTEREST.AMT>
    STMT.ENTRY.REC<AC.STE.TRANSACTION.CODE> =  Y.INT.PAY.TXN.CODE
    GOSUB GET.STMT.DETAILS

    FINAL.ENTRY.REC<-1> = LOWER(STMT.ENTRY.REC)

* para of code for raising new entries

    STMT.ENTRY.REC = ''
    STMT.ENTRY.REC<AC.STE.ACCOUNT.NUMBER>    = R.MM.MONEY.MARKET<MM.INT.LIQ.ACCT>
    STMT.ENTRY.REC<AC.STE.AMOUNT.LCY>        = R.REDO.APAP.L.CONTRACT.BALANCES<CRT.BAL.ACCRUE.TO.DATE>
    STMT.ENTRY.REC<AC.STE.TRANSACTION.CODE>  = Y.INT.PAY.TXN.CODE
    GOSUB GET.STMT.DETAILS

    FINAL.ENTRY.REC<-1> = LOWER(STMT.ENTRY.REC)

RETURN
*--------------------------------------------------------------------------------------------------------
************************
INTEREST.ACCRUAL.ENTRIES:
************************
* para for reveral of core entries for interest accrual

    Y.INT.ACR.AMT = R.MM.MONEY.MARKET<MM.TOT.INTEREST.AMT>/Y.COUPON.TENOR
    Y.INT.ACR.AMT = Y.INT.ACR.AMT * Y.CAL.DIFF.DAYS
    CALL EB.ROUND.AMOUNT(Y.CURRENCY,Y.INT.ACR.AMT,"","")
    CATEG.ENTRY.REC = ''
    CATEG.ENTRY.REC<AC.CAT.AMOUNT.LCY>       = Y.INT.ACR.AMT
    CATEG.ENTRY.REC<AC.CAT.TRANSACTION.CODE> = Y.INT.ACC.TXN.CODE
    CATEG.ENTRY.REC<AC.CAT.PL.CATEGORY>      = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.ACC.PL.CATEG>
    GOSUB GET.CATEG.DETAILS

    FINAL.ENTRY.REC<-1> = LOWER(CATEG.ENTRY.REC)

*para of code for posting new entries

    CATEG.ENTRY.REC = ''
    CATEG.ENTRY.REC<AC.CAT.AMOUNT.LCY> = -1 * Y.ACCRUE.AMT
    CATEG.ENTRY.REC<AC.CAT.TRANSACTION.CODE> = Y.INT.ACC.TXN.CODE
    CATEG.ENTRY.REC<AC.CAT.PL.CATEGORY>      = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.ACC.PL.CATEG>
    GOSUB GET.CATEG.DETAILS

    FINAL.ENTRY.REC<-1> = LOWER(CATEG.ENTRY.REC)

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.STMT.DETAILS:
*****************

    STMT.ENTRY.REC<AC.STE.THEIR.REFERENCE>   = MM.MONEY.MARKET.ID
    STMT.ENTRY.REC<AC.STE.CUSTOMER.ID>       = R.MM.MONEY.MARKET<MM.CUSTOMER.ID>
    STMT.ENTRY.REC<AC.STE.ACCOUNT.OFFICER>   = R.MM.MONEY.MARKET<MM.MIS.ACCT.OFFICER>
    STMT.ENTRY.REC<AC.STE.PRODUCT.CATEGORY>  = R.ACCOUNT<AC.CATEGORY>
    STMT.ENTRY.REC<AC.STE.VALUE.DATE>        = R.MM.MONEY.MARKET<MM.INT.PERIOD.END>
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
*    CATEG.ENTRY.REC<AC.CAT.VALUE.DATE>       = R.DATES(EB.DAT.LAST.WORKING.DAY)
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
*--------------------------------------------------------------------------------------------------------
END
