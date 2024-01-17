* @ValidationCode : Mjo0NzUxNjM4MjA6Q3AxMjUyOjE3MDQ0NDU0NDMwMDE6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2024 14:34:03
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
SUBROUTINE REDO.B.TRANSIT.CAP(INCOME.PAR)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : KAVITHA
* Program Name  : REDO.B.TRANSIT.CAP
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to calculate and
* debit intransit interest for the account which has utilised
* the intransit amount
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 02-04-2012          ODR-2010-09-0251                 Initial Creation
* Date                  who                   Reference
* 13-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 13-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DATES
    $INSERT I_F.ACCT.CAPITALISATION
    $INSERT I_F.GROUP.CAPITALISATION
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.USER
    $INSERT I_REDO.B.TRANSIT.CAP.COMMON
    $INSERT I_F.REDO.TRANUTIL.INTAMT
    $USING AC.API

*Prcoess paragraph to get the required information and capitalise interest

    NEXT.DATE = TODAY

    CALL F.READ(FN.ACCOUNT,INCOME.PAR,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    IF R.ACCOUNT THEN
        GOSUB READ.ACCT.REC
    END

    GOSUB CHECK.FREQ

    IF NEXT.DATE EQ TODAY THEN
        GOSUB PROCESS
        GOSUB PURGE.TABLE
    END

RETURN
*-------------------------------------------------------------------------
READ.ACCT.REC:
*Read account record and fetch necessary information

    MAIN.GROUP.KEY = R.ACCOUNT<AC.CONDITION.GROUP>
    ACCT.OFF.VAL = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    CUSTOMER.VAL = R.ACCOUNT<AC.CUSTOMER>
    PROD.CATEGORY = R.ACCOUNT<AC.CATEGORY>
    Y.CURRENCY = R.ACCOUNT<AC.CURRENCY>
    GROUP.NUMBER = R.ACCOUNT<AC.CONDITION.GROUP>

RETURN
*----------------------
PROCESS:

    TOTAL.INT = ''
    REV.INT.ID = ''

* Read REDO.TRANUTIL.INTAMT with incoming parameter and get the interest amt and sum it up

*    CALL F.READ(FN.REDO.TRANUTIL.INTAMT,INCOME.PAR,R.REDO.TRANUTIL.INTAMT,F.REDO.TRANUTIL.INTAMT,INT.ERR)
    CALL F.READU(FN.REDO.TRANUTIL.INTAMT,INCOME.PAR,R.REDO.TRANUTIL.INTAMT,F.REDO.TRANUTIL.INTAMT,INT.ERR,'');* R22 UTILITY AUTO CONVERSION
    IF R.REDO.TRANUTIL.INTAMT THEN
        INT.AMOUNT = R.REDO.TRANUTIL.INTAMT<TRAN.INT.CALC.INTEREST>
        TOTAL.INT = SUM(INT.AMOUNT)
    END

    GOSUB RAISE.ENTRY

RETURN
*------------------------------------------
RAISE.ENTRY:
*Accounting entries raised
    Y.CLEARING.ARR = ''
    Y.ACCOUNT.NO = ''
    Y.CHEQUE.AMT = ''
    Y.TXN.CODE = ''
    ACCT.CURRENCY = ''
    Y.TRANS.REF = INCOME.PAR:"-":R.DATES(EB.DAT.LAST.WORKING.DAY)
    TOTAL.INT = DROUND(TOTAL.INT,2)
    Y.ACCOUNT.NO = TRANCAP.ACCT
    Y.CHEQUE.AMT = TOTAL.INT
    Y.TXN.CODE = TRANCAP.CR.CODE
    GOSUB GET.CATEG.DETAILS

    Y.ACCOUNT.NO = ''
    Y.CHEQUE.AMT = ''
    Y.TXN.CODE = ''
    ACCT.CURRENCY = ''
    Y.ACCOUNT.NO = INCOME.PAR
    Y.CHEQUE.AMT = -1 * TOTAL.INT
    Y.TXN.CODE = TRANCAP.DR.CODE
    GOSUB GET.STMT.DETAILS
    V = 11
*    CALL EB.ACCOUNTING("CLEARING.OUT","SAO",Y.CLEARING.ARR,'')
    AC.API.EbAccounting("CLEARING.OUT","SAO",Y.CLEARING.ARR,'');* R22 UTILITY AUTO CONVERSION

RETURN
*-----------------------------------------------------------------------------------
GET.STMT.DETAILS:
*STMT.ENTRY raised for debit to customer account
* Transaction code fetched from REDO.APAP.CLEAR.PARAM

    STMT.ENTRY.REC = ''

    STMT.ENTRY.REC<AC.STE.ACCOUNT.NUMBER> = Y.ACCOUNT.NO
    IF Y.CURRENCY EQ "DOP" THEN
        STMT.ENTRY.REC<AC.STE.AMOUNT.LCY> = Y.CHEQUE.AMT
    END ELSE
        STMT.ENTRY.REC<AC.STE.AMOUNT.FCY> = Y.CHEQUE.AMT
    END
    STMT.ENTRY.REC<AC.STE.TRANSACTION.CODE> = Y.TXN.CODE
    STMT.ENTRY.REC<AC.STE.THEIR.REFERENCE>   = Y.TRANS.REF
    STMT.ENTRY.REC<AC.STE.CUSTOMER.ID>       = CUSTOMER.VAL
    STMT.ENTRY.REC<AC.STE.ACCOUNT.OFFICER>   = ACCT.OFF.VAL
    STMT.ENTRY.REC<AC.STE.PRODUCT.CATEGORY>  = PROD.CATEGORY
    STMT.ENTRY.REC<AC.STE.VALUE.DATE>        = R.DATES(EB.DAT.LAST.WORKING.DAY)
    STMT.ENTRY.REC<AC.STE.CURRENCY>          = ACCT.CURRENCY
    STMT.ENTRY.REC<AC.STE.POSITION.TYPE>     = 'TR'
    STMT.ENTRY.REC<AC.STE.OUR.REFERENCE>     = Y.TRANS.REF
    STMT.ENTRY.REC<AC.STE.EXPOSURE.DATE>     = R.DATES(EB.DAT.LAST.WORKING.DAY)
    STMT.ENTRY.REC<AC.STE.CURRENCY.MARKET>   = '1'
    STMT.ENTRY.REC<AC.STE.DEPARTMENT.CODE>   = R.USER<EB.USE.DEPARTMENT.CODE>
    STMT.ENTRY.REC<AC.STE.TRANS.REFERENCE>   = Y.TRANS.REF
    STMT.ENTRY.REC<AC.STE.SYSTEM.ID>         = 'AC'
    STMT.ENTRY.REC<AC.STE.NARRATIVE>         = "Capitalise Transit Interest"
    STMT.ENTRY.REC<AC.STE.BOOKING.DATE>      = R.DATES(EB.DAT.LAST.WORKING.DAY)
    STMT.ENTRY.REC<AC.STE.COMPANY.CODE>      = ID.COMPANY

    Y.CLEARING.ARR<-1> = LOWER(STMT.ENTRY.REC)

RETURN
*-------------------------
GET.CATEG.DETAILS:
*Raise CATEG.ENTRY to credit PL Category for Interest amount
* Get PL CATEGORY , TRANSACTION CODE from REDO.APAP.CLEAR.PARAM

    CATEG.ENTRY.REC = ''
    CATEG.ENTRY.REC<AC.CAT.AMOUNT.LCY>       = Y.CHEQUE.AMT
    CATEG.ENTRY.REC<AC.CAT.TRANSACTION.CODE> = Y.TXN.CODE
    CATEG.ENTRY.REC<AC.CAT.PL.CATEGORY>      = Y.ACCOUNT.NO
    CATEG.ENTRY.REC<AC.CAT.CUSTOMER.ID>      = CUSTOMER.VAL
    CATEG.ENTRY.REC<AC.CAT.ACCOUNT.OFFICER>  = ACCT.OFF.VAL
    CATEG.ENTRY.REC<AC.CAT.PRODUCT.CATEGORY> = PROD.CATEGORY
    CATEG.ENTRY.REC<AC.CAT.VALUE.DATE>       = TODAY
    CATEG.ENTRY.REC<AC.CAT.CURRENCY>         = "DOP"
    CATEG.ENTRY.REC<AC.CAT.POSITION.TYPE>    = 'TR'
    CATEG.ENTRY.REC<AC.CAT.OUR.REFERENCE>    = Y.TRANS.REF
    CATEG.ENTRY.REC<AC.CAT.EXPOSURE.DATE>    = TODAY
    CATEG.ENTRY.REC<AC.CAT.CURRENCY.MARKET>  = '1'
    CATEG.ENTRY.REC<AC.CAT.DEPARTMENT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
    CATEG.ENTRY.REC<AC.CAT.TRANS.REFERENCE>  = Y.TRANS.REF
    CATEG.ENTRY.REC<AC.CAT.SYSTEM.ID>        = 'AC'
    CATEG.ENTRY.REC<AC.CAT.BOOKING.DATE>     = TODAY
    CATEG.ENTRY.REC<AC.CAT.NARRATIVE>        = "Capitalise Transit Interest"
    CATEG.ENTRY.REC<AC.CAT.COMPANY.CODE>     = ID.COMPANY

    Y.CLEARING.ARR<-1> = LOWER(CATEG.ENTRY.REC)

RETURN
*-------------------
PURGE.TABLE:
* After raising accounting entries delete the table entries.

    CALL F.DELETE(FN.REDO.TRANUTIL.INTAMT,INCOME.PAR)

RETURN
*-------------------------
CHECK.FREQ:
*Gets the Frequency details

    INTEREST.TYPE = "DR"

    CALL AC.NEXT.CAP.DATE(NEXT.DATE,INCOME.PAR, GROUP.NUMBER, INTEREST.TYPE)

RETURN

END
