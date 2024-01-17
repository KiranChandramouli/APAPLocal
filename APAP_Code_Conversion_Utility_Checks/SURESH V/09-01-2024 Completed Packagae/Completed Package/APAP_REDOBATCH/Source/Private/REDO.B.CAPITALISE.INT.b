* @ValidationCode : MjoxNzMzNTM0NTY0OkNwMTI1MjoxNzAzMjQyNjM2NzE3OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 22 Dec 2023 16:27:16
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
SUBROUTINE REDO.B.CAPITALISE.INT(INCOME.PAR)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Arulprakasam P
* Program Name  : REDO.B.CAPITALISE.INT
*-------------------------------------------------------------------------
* Description: This routine is a load routine used to load the variables
*
*----------------------------------------------------------
* Linked with:
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 17-dec-2010        ODR-2010-09-0251                 Initial Creation
* Date                   who                   Reference
* 10-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION VM TO @VM AND = TO EQ AND F.READ TO CACHE.READ AND REMOVED F.GROUP.CAPITALISATION
* 10-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*20/12/2023         Suresh             R22 Manual Conversion     CALL routine modified, Change F.READ to F.READU
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DATES
    $INSERT I_F.ACCT.CAPITALISATION
    $INSERT I_F.GROUP.CAPITALISATION
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.USER
    $INSERT I_REDO.B.CAPITALISE.COMMON
    $INSERT I_F.REDO.INTEREST.REVERSE
    
    $USING AC.API



    REV.INT.ID = FIELD(INCOME.PAR,@VM,1)
    ACCOUNT.VAL = FIELD(REV.INT.ID,"-",1)

    CALL F.READ(FN.ACCOUNT,ACCOUNT.VAL,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    GOSUB GET.FREQ

    GOSUB CHECK.FREQ

    IF DISPLACEMENT EQ R.DATES(EB.DAT.LAST.WORKING.DAY) THEN

        GOSUB PROCESS
        GOSUB PURGE.TABLE

    END

RETURN
*-------------------------------------------------------------------------
GET.FREQ:

    MAIN.GROUP.KEY = R.ACCOUNT<AC.CONDITION.GROUP>
    R.MAIN.CAP = "" ; ER = ""
    CHECK.CAP = ""
    FN.ACCT.CAPITALISATION='F.ACCT.CAPITALISATION'
    
*   CALL F.READ("F.ACCT.CAPITALISATION",ACCOUNT.VAL,R.MAIN.CAP,F.ACCT.CAPITALISATION,ER)
    CALL F.READ(FN.ACCT.CAPITALISATION,ACCOUNT.VAL,R.MAIN.CAP,F.ACCT.CAPITALISATION,ER) ;*R22 Manual Conversion
    IF R.MAIN.CAP THEN
        DR.CAP.FREQUENCY = R.MAIN.CAP<IC.ACCAP.DR.CAP.FREQUENCY>
    END ELSE
        GOSUB CAPIT.GRP.FETCH

    END

RETURN
*-----------------------------

CAPIT.GRP.FETCH:

    ER = ""
    FN.GROUP.CAPITALISATION='F.GROUP.CAPITALISATION' ;*R22 Manual Conversion
*    CALL CACHE.READ("F.GROUP.CAPITALISATION", MAIN.GROUP.KEY, R.MAIN.CAP, ER) ;*R22 AUTO CONVERSTION F.READ TO CACHE.READ AND REMOVED F.GROUP.CAPITALISATION
    CALL CACHE.READ(FN.GROUP.CAPITALISATION, MAIN.GROUP.KEY, R.MAIN.CAP, ER) ;*R22 Manual Conversion
      
    IF R.MAIN.CAP EQ "" THEN
        DR.CAP.FREQUENCY = R.MAIN.CAP<IC.GCP.DR.CAP.FREQUENCY>
    END


RETURN
*-----------------------------------------------------
PROCESS:

    TOTAL.INT = ''
    REV.INT.ID = ''

    LOOP
        REMOVE REV.INT.ID FROM INCOME.PAR SETTING FILE.POS
    WHILE REV.INT.ID:FILE.POS

        GOSUB PROCESS.RECORDS

    REPEAT

    GOSUB RAISE.ENTRY

RETURN
*-------------------------------------------------------------------------
PROCESS.RECORDS:

    ACCOUNT.VAL =  ''
    ACCT.OFF.VAL = ''
    CUSTOMER.VAL = ''
    PROD.CATEGORY = ''
    Y.CURRENCY = ''
    INT.AMOUNT = ''


*    CALL F.READ(FN.INT.REVERSE,REV.INT.ID,R.INT.REVERSE,F.INT.REVERSE,INT.ERR)
    CALL F.READU(FN.INT.REVERSE,REV.INT.ID,R.INT.REVERSE,F.INT.REVERSE,INT.ERR,"") ;*R22 Manual Conversion
    IF R.INT.REVERSE THEN

        ACCOUNT.VAL = FIELD(REV.INT.ID,"-",1)
        GOSUB READ.ACCT.REC
        GOSUB CALC.TOTAL.INT
    END

    GOSUB PURGE.TABLE

RETURN
*------------------------------------------
READ.ACCT.REC:

    CALL F.READ(FN.ACCOUNT,ACCOUNT.VAL,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    IF R.ACCOUNT THEN
        ACCT.OFF.VAL = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        CUSTOMER.VAL = R.ACCOUNT<AC.CUSTOMER>
        PROD.CATEGORY = R.ACCOUNT<AC.CATEGORY>
        Y.CURRENCY = R.ACCOUNT<AC.CURRENCY>
    END

RETURN
*--------------------------------------------------------------------------------
CALC.TOTAL.INT:

    INT.AMOUNT = R.INT.REVERSE<INT.REV.INT.ACCRUED>

    LOOP

        REMOVE FETCH.INT.AMT FROM INT.AMOUNT SETTING INT.POS
    WHILE FETCH.INT.AMT:INT.POS

        TOTAL.INT += FETCH.INT.AMT

    REPEAT

RETURN
*---------------------------------------------------------------------------------
RAISE.ENTRY:

    Y.ACCOUNT.NO = ''
    Y.CHEQUE.AMT = ''
    Y.TXN.CODE = ''
    ACCT.CURRENCY = ''

    TOTAL.INT = DROUND(TOTAL.INT,2)

    Y.ACCOUNT.NO = CAPITALISE.ACCT
    Y.CHEQUE.AMT = -1 * TOTAL.INT
    Y.TXN.CODE = CAPITAL.DR.CODE

    IF Y.ACCOUNT.NO EQ CAPITALISE.ACCT THEN
        ACCT.CURRENCY = "DOP"
    END ELSE
        ACCT.CURRENCY = Y.CURRENCY
    END

    GOSUB GET.STMT.DETAILS

    Y.ACCOUNT.NO = ''
    Y.CHEQUE.AMT = ''
    Y.TXN.CODE = ''
    ACCT.CURRENCY = ''

    Y.ACCOUNT.NO = ACCOUNT.VAL
    Y.CHEQUE.AMT = TOTAL.INT
    Y.TXN.CODE = CAPITAL.CR.CODE

    IF Y.ACCOUNT.NO EQ CAPITALISE.ACCT THEN
        ACCT.CURRENCY = LCCY
    END ELSE
        ACCT.CURRENCY = Y.CURRENCY
    END

    GOSUB GET.STMT.DETAILS

RETURN
*-----------------------------------------------------------------------------------
GET.STMT.DETAILS:


    STMT.ENTRY.REC = ''
    Y.CLEARING.ARR = ''

    Y.TRANS.REF = ACCOUNT.VAL:"-":R.DATES(EB.DAT.LAST.WORKING.DAY)

    STMT.ENTRY.REC<AC.STE.ACCOUNT.NUMBER> = Y.ACCOUNT.NO

    IF ACCT.CURRENCY EQ "DOP" THEN
        STMT.ENTRY.REC<AC.STE.AMOUNT.LCY> = Y.CHEQUE.AMT
    END ELSE
        STMT.ENTRY.REC<AC.STE.AMOUNT.FCY> = Y.CHEQUE.AMT
    END

    GOSUB STMT.ARRAY

RETURN
*-----------------
STMT.ARRAY:

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
    STMT.ENTRY.REC<AC.STE.NARRATIVE>         = "Capitalise Interest - B.132"
    STMT.ENTRY.REC<AC.STE.BOOKING.DATE>      = R.DATES(EB.DAT.LAST.WORKING.DAY)
    STMT.ENTRY.REC<AC.STE.COMPANY.CODE>      = ID.COMPANY

    Y.CLEARING.ARR<-1> = LOWER(STMT.ENTRY.REC)
    V = 11
*    CALL EB.ACCOUNTING("CLEARING.OUT","SAO",Y.CLEARING.ARR,'')
    AC.API.EbAccounting("CLEARING.OUT","SAO",Y.CLEARING.ARR,'') ;*R22 Manual Conversion
*    CALL EB.ACCOUNTING.WRAPPER('CLEARING.OU',"SAO",Y.CLEARING.ARR,'',EB.ACCT.ERR)

RETURN
*-------------------------
PURGE.TABLE:

    CALL F.DELETE(FN.INT.REVERSE,REV.INT.ID)

    CALL F.WRITE(FN.INT.REVERSE.HIS,REV.INT.ID,R.INT.REVERSE)

RETURN
*-------------------------
CHECK.FREQ:
*----------
*Gets the Frequency details

    TO.CNTR = LEN(DR.CAP.FREQUENCY)
    Y.FREQ = DR.CAP.FREQUENCY
    FREQ = DR.CAP.FREQUENCY[9,1]
    Y.FREQ.MTHS = DR.CAP.FREQUENCY[10,2]
    CAL.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    SIGN = "+"

    GOSUB NEXT.PARA.PROC

RETURN
*---------------------
NEXT.PARA.PROC:

    BEGIN CASE
        CASE FREQ EQ 'D'
            DISPLACEMENT = '1D'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
        CASE FREQ EQ 'W'
            GOSUB GET.WEEK
        CASE FREQ EQ 'T'
            Y.DATE = CAL.DATE
            CALL CDT('',Y.DATE,'+15C')
            DISPLACEMENT = Y.DATE
            Y.PERIOD = Y.FREQ[9,99]
        CASE FREQ EQ 'M'
            GOSUB GET.MONTHS
    END CASE

RETURN
*---------------------------------------------------------------------------
GET.WEEK:
*--------
*Gets the Week Details
    WEEK.PERIOD = Y.FREQ[9,99]
    BEGIN CASE
        CASE WEEK.PERIOD EQ 'WEEK1'
            DISPLACEMENT = '1W'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
        CASE WEEK.PERIOD EQ 'WEEK2'
            DISPLACEMENT = '2W'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
        CASE WEEK.PERIOD EQ 'WEEK3'
            DISPLACEMENT = '3W'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
        CASE WEEK.PERIOD EQ 'WEEK4'
            DISPLACEMENT = '4W'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
        CASE WEEK.PERIOD EQ 'WEEK5'
            DISPLACEMENT = '5W'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
        CASE WEEK.PERIOD EQ 'WEEK6'
            DISPLACEMENT = '6W'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
        CASE WEEK.PERIOD EQ 'WEEK7'
            DISPLACEMENT = '7W'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
        CASE WEEK.PERIOD EQ 'WEEK8'
            DISPLACEMENT = '8W'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
        CASE WEEK.PERIOD EQ 'WEEK9'
            DISPLACEMENT = '9W'
            CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
            Y.PERIOD = Y.FREQ[9,99]
    END CASE

RETURN
*---------------------------------------------------------------------------
GET.MONTHS:
*----------
*Gets the details for different period of time specified in months

    BEGIN CASE
        CASE  Y.FREQ.MTHS EQ '01'
            Y.PERIOD = 'M01'
            DISPLACEMENT = '1M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '02'
            Y.PERIOD = 'M02'
            DISPLACEMENT = '2M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '03'
            Y.PERIOD = 'M03'
            DISPLACEMENT = '3M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '04'
            Y.PERIOD = 'M04'
            DISPLACEMENT = '4M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '05'
            Y.PERIOD = 'M05'
            DISPLACEMENT = '5M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '06'
            Y.PERIOD = 'M06'
            DISPLACEMENT = '6M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '07'
            Y.PERIOD = 'M07'
            DISPLACEMENT = '7M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '08'
            Y.PERIOD = 'M08'
            DISPLACEMENT = '8M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '09'
            Y.PERIOD = 'M09'
            DISPLACEMENT = '9M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '10'
            Y.PERIOD = 'M10'
            DISPLACEMENT = '10M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '11'
            Y.PERIOD = 'M11'
            DISPLACEMENT = '11M'
            GOSUB CALL.CALEN.DAY

        CASE  Y.FREQ.MTHS EQ '12'
            Y.PERIOD = 'M12'
            DISPLACEMENT = '12M'
            GOSUB CALL.CALEN.DAY

    END CASE

RETURN
*------------
CALL.CALEN.DAY:

    CALL CALENDAR.DAY(CAL.DATE,SIGN,DISPLACEMENT)
    Y.PERIOD.DAY = DISPLACEMENT[7,2]

RETURN


END
