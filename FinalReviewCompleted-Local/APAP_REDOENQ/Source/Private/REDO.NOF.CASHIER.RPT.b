$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.NOF.CASHIER.RPT(Y.OUT.ARRAY)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.NOF.CASHIER.RPT
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.NOF.CASHIER.RPT is an No-file enquiry routine, this routine will select the
*                    teller transactions of OVERAGE and SHORTAGE record Entries of TELLER and fetch the
*                    values from the selected by CASHIER  records for display
*Linked With       : Enquiry - REDO.CASHIER.RPT.ENQ
*In  Parameter     : NA
*Out Parameter     : Y.OUT.ARRAY - Output array for display
*Files  Used       : ACCOUNT                          As              I               Mode
*                    USER                             As              I               Mode
*                    TELLER.PARAMETER                 As              I               Mode
*                    TELLER.ID                        As              I               Mode
*                    STMT.ENTRY                       As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                 Description
*   ------             -----                       -------------              -------------
* 03 Dec 2010       Sakthi Sellappillai /      ODR-2009-12-0294 C.12         Initial Creation
*                   Shiva Prasad Y
* 16-06-2011        BHARATH G                   PACS00071554              MODIFICATION
* 13-APRIL-2023      Harsha                R22 Auto Conversion  - F.READ to CACHE.READ , VM to @VM , FM to @FM  and SM to @SM
* 13-APRIL-2023      Harsha                R22 Manual Conversion - No changes
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.TELLER.PARAMETER
    $INSERT I_F.TELLER.ID
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.COMPANY
*   $INCLUDE GLOBUS.BP I_F.TELLER.USER

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.USER = 'F.USER'
    F.USER  = ''
    CALL OPF(FN.USER,F.USER)
*!PACS
*PACS00071554
    FN.TELLER.USER = 'F.TELLER.USER'
    F.TELLER.USER  = ''
    CALL OPF(FN.TELLER.USER,F.TELLER.USER)


*!PACS00071554
    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID  = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)

    FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
    F.TELLER.PARAMETER  = ''
    CALL OPF(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY  = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY  = ''
    CALL OPF(FN.COMPANY,F.COMPANY)
    Y.EMPLOYER.NO=''
    Y.ENTRY.DATE=''
    Y.SUB.LIST=''
    Y.AC.SORT.VAL=''
    Y.SORT.ARR=''
    Y.DATA=''
    Y.SD.AGENCY=''
    Y.SRD.DATE=''
    Y.SRD.AMOUNT=''
    Y.SD.ANTIQUITY=''

    SEL.CMD.COMP = 'SELECT F.COMPANY'
    CALL EB.READLIST(SEL.CMD.COMP,SEL.LIST.COMP,'',NO.OF.REC.COMP,SEL.ERR.COMP)
*PACS00071554
    C$SPARE(210)=SEL.LIST.COMP
*PACS00071554
RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB FORM.SEL.CMD
    IF NOT(SEL.LIST) THEN
        RETURN
    END
    GOSUB GET.DETAILS
    GOSUB SORT.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
*************
FORM.SEL.CMD:
*************

    SEL.CMD = 'SELECT ':FN.TELLER.USER

    LOCATE 'USER.NAME' IN D.FIELDS<1> SETTING Y.USR.POS THEN
        Y.USER.ID.SEL      = D.RANGE.AND.VALUE<Y.USR.POS>
        SEL.CMD := ' WITH @ID EQ ':Y.USER.ID.SEL
    END
    Y.COMPANY.CODE = ''
    LOCATE 'COMPANY.CODE' IN D.FIELDS<1> SETTING Y.COMP.POS  THEN
        Y.COMPANY.CODE   = D.RANGE.AND.VALUE<Y.COMP.POS>
        GOSUB GET.SUB.DIV.CODE
    END
    LOCATE "DATE.RANGE" IN D.FIELDS<1> SETTING DATE.POS THEN
        Y.DATE  = D.RANGE.AND.VALUE<DATE.POS>
        GOSUB CHECK.DATE
    END

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
****************
CHECK.DATE:
****************
    Y.COUNT =DCOUNT(Y.DATE,@SM)
    Y.TXN.DATE1 = FIELD(Y.DATE,@SM,1)
    Y.TXN.DATE2 = FIELD(Y.DATE,@SM,2)
    IF Y.TXN.DATE2 THEN
        IF NOT(NUM(Y.TXN.DATE1)) OR LEN(Y.TXN.DATE1) NE '8' OR NOT(NUM(Y.TXN.DATE2)) OR LEN(Y.TXN.DATE2) NE '8' THEN
            ENQ.ERROR = "EB-REDO.DATE.RANGE"
        END ELSE
            IF Y.TXN.DATE1[5,2] GT '12' OR Y.TXN.DATE2[5,2] GT '12' OR Y.TXN.DATE1[7,2] GT '31' OR Y.TXN.DATE2[7,2] GT '31' OR Y.TXN.DATE1 GT Y.TXN.DATE2 THEN
                ENQ.ERROR = "EB-REDO.DATE.RANGE"
            END
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------------
************
GET.DETAILS:
************

    LOOP
        REMOVE USER.ID FROM SEL.LIST SETTING Y.USR.POS
    WHILE USER.ID : Y.USR.POS


*GOSUB GET.USER.DETAILS
        GOSUB GET.TELLER.ID

        IF NOT(USER.ERR) THEN
            GOSUB READ.USER
            GOSUB GET.USER.DETAILS
*GOSUB LOOP.COMPANY
            LOOP
                REMOVE TELLER.ID FROM R.TELLER.ID SETTING Y.TELLER.POS
            WHILE TELLER.ID : Y.TELLER.POS
*GOSUB GET.USER.DETAILS
                GOSUB LOOP.COMPANY
            REPEAT
        END
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.USER.DETAILS:
*****************
*GOSUB READ.USER
    Y.CASHIER.NAME = ''
    Y.CASHIER.NAME = R.USER.REC<EB.USE.USER.NAME>
    Y.EMPLOYER.NO  = ''
    Y.EMPLOYER.NO  = USER.ID
    Y.ENTRY.DATE   = ''
    Y.ENTRY.DATE   = R.USER.REC<EB.USE.START.DATE.PROFILE>
    Y.TOT.CREDIT   = 0

RETURN
*--------------------------------------------------------------------------------------------------------
**************
GET.TELLER.ID:
**************
    TELLER.ID = ''
*PACS00071554
*SEL.CMD.TT = 'SELECT ':FN.TELLER.ID:' WITH USER EQ ':USER.ID
*PACS00071554
    CALL F.READ(FN.TELLER.USER,USER.ID,R.TELLER.ID,F.TELLER.USER,USER.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
LOOP.COMPANY:
*************

*PACS00071554
*SEL.CMD.COMP = 'SELECT F.COMPANY'
*CALL EB.READLIST(SEL.CMD.COMP,SEL.LIST.COMP,'',NO.OF.REC.COMP,SEL.ERR.COMP)
*PACS00071554
    IF Y.COMPANY.CODE THEN
        Y.COMP.LIST = Y.COMPANY.CODE
    END ELSE
        Y.COMP.LIST = C$SPARE(210)
    END

    LOOP
        REMOVE COMPANY.ID FROM Y.COMP.LIST SETTING Y.COMP.POS
    WHILE COMPANY.ID : Y.COMP.POS
        TELLER.PARAMETER.ID = COMPANY.ID

        GOSUB READ.TELLER.PARAMETER
        IF NOT(R.TELLER.PARAMETER) THEN
            CONTINUE
        END
        GOSUB GET.ENTRY.DETAILS

    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.ENTRY.DETAILS:
******************


    Y.SHORT.CATEGORY  = R.TELLER.PARAMETER<TT.PAR.SHORT.CATEGORY>
*PACS00071554-S
*    SEL.CMD.SHORT = 'SELECT ':FN.ACCOUNT:' WITH @ID LIKE ...':Y.SHORT.CATEGORY:TELLER.ID:'... BY OPENING.DATE BY CURRENCY'
*!PACS
*PACS00071554-E
    SEL.CMD.SHORT = 'SELECT ':FN.ACCOUNT:' WITH @ID LIKE ...':Y.SHORT.CATEGORY:TELLER.ID:'...'
*!PACS
    CALL EB.READLIST(SEL.CMD.SHORT,SEL.LIST.SHORT,'',NO.OF.REC.SHORT,SEL.ERR.SHORT)

    Y.OVER.CATEGORY  = R.TELLER.PARAMETER<TT.PAR.OVER.CATEGORY>
*PACS00071554-S
*SEL.CMD.OVER = 'SELECT ':FN.ACCOUNT:' WITH @ID LIKE ...':Y.OVER.CATEGORY:TELLER.ID:'... BY OPENING.DATE BY CURRENCY'
*PACS00071554-E
    SEL.CMD.OVER = 'SELECT ':FN.ACCOUNT:' WITH @ID LIKE ...':Y.OVER.CATEGORY:TELLER.ID:'...'

    CALL EB.READLIST(SEL.CMD.OVER,SEL.LIST.OVER,'',NO.OF.REC.OVER,SEL.ERR.OVER)

    IF NOT(SEL.LIST.SHORT) AND NOT(SEL.LIST.OVER) THEN
        RETURN
    END

*    GOSUB GET.FIRST.DATE
*    IF NOT(Y.FIRST.DATE) THEN
*        RETURN
*    END

    GOSUB GET.STMT.ENTRY

RETURN
*--------------------------------------------------------------------------------------------------------
***************
GET.FIRST.DATE:
***************
    ACCOUNT.ID = SEL.LIST.SHORT<1>
    GOSUB READ.ACCOUNT
    Y.SHORT.DATE = R.ACCOUNT<AC.OPENING.DATE>

    ACCOUNT.ID = SEL.LIST.OVER<1>
    GOSUB READ.ACCOUNT
    Y.OVER.DATE = R.ACCOUNT<AC.OPENING.DATE>

    IF Y.SHORT.DATE AND NOT(Y.OVER.DATE) THEN
        Y.FIRST.DATE = Y.SHORT.DATE
        RETURN
    END

    IF NOT(Y.SHORT.DATE) AND Y.OVER.DATE THEN
        Y.FIRST.DATE = Y.OVER.DATE
        RETURN
    END

    IF Y.SHORT.DATE LE Y.OVER.DATE THEN
        Y.FIRST.DATE = Y.SHORT.DATE
    END ELSE
        Y.FIRST.DATE = Y.OVER.DATE
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.SUB.DIV.CODE:
*****************
    CHANGE @SM TO @FM IN Y.COMPANY.CODE
    CHANGE @VM TO @FM IN Y.COMPANY.CODE
    LOOP
        REMOVE COMPANY.ID FROM Y.COMPANY.CODE SETTING Y.COMP.POS
    WHILE COMPANY.ID : Y.COMP.POS
        GOSUB READ.COMPANY
        Y.SUB.LIST<-1> = R.COMPANY.REC<EB.COM.SUB.DIVISION.CODE>
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
***************
GET.STMT.ENTRY:
***************
    Y.ACC.OPEN.DATE = Y.TXN.DATE1
    Y.TODAY         = Y.TXN.DATE2
    Y.REGION        = ''
    Y.DAYS.DIFF     = 'C'
    CALL CDD(Y.REGION,Y.ACC.OPEN.DATE,Y.TODAY,Y.DAYS.DIFF)

    Y.DAYS.START = 0
    LOOP
        Y.BOOK.DATE = Y.ACC.OPEN.DATE
        Y.FLAG = ''
        ACCOUNT.ID = ''
        Y.SHORT.POS = ''
        Y.OVER.POS = ''
    WHILE Y.DAYS.START LE Y.DAYS.DIFF
        Y.ADD.DAYS = '+':Y.DAYS.START:'C'
        CALL CDT(Y.REGION,Y.BOOK.DATE,Y.ADD.DAYS)

        D.FIELDS = 'ACCOUNT':@FM:'BOOKING.DATE'
        D.LOGICAL.OPERANDS = '1':@FM:'1'
        Y.TOT.CREDIT = 0
        Y.SHORT = 1

        Y.SHORT.COUNT = DCOUNT(SEL.LIST.SHORT,@FM)
        Y.SHORT.START = 1
        LOOP
        WHILE Y.SHORT.START LE Y.SHORT.COUNT
            ACCOUNT.ID = SEL.LIST.SHORT<Y.SHORT.START>
            IF Y.SUB.LIST THEN
                LOCATE ACCOUNT.ID[4] IN Y.SUB.LIST<1> SETTING Y.SUB.POS ELSE
                    Y.SHORT.START += 1
                    CONTINUE
                END
            END
            D.RANGE.AND.VALUE = ACCOUNT.ID:@FM:Y.BOOK.DATE
            CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)
            IF NOT(Y.ID.LIST) THEN
                CONTINUE
            END
            GOSUB LOOP.ID.LIST
            Y.SHORT.START += 1
        REPEAT
        Y.SHORT = ''
        Y.OVER.COUNT = DCOUNT(SEL.LIST.OVER,@FM)
        Y.OVER.START = 1
        LOOP
        WHILE Y.OVER.START LE Y.OVER.COUNT
            ACCOUNT.ID = SEL.LIST.OVER<Y.OVER.START>
            IF Y.SUB.LIST THEN
                LOCATE ACCOUNT.ID[4] IN Y.SUB.LIST<1> SETTING Y.SUB.POS ELSE
                    Y.OVER.START += 1
                    CONTINUE
                END
            END
            D.RANGE.AND.VALUE = ACCOUNT.ID:@FM:Y.BOOK.DATE
            CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)
            IF NOT(Y.ID.LIST) THEN
                CONTINUE
            END
            GOSUB LOOP.ID.LIST
            Y.OVER.START += 1
        REPEAT

*    GOSUB FORM.OUT.ARRAY

        Y.DAYS.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
***************
FORM.OUT.ARRAY:
***************
*                       1                2                3
    Y.OUT.ARR  = Y.CASHIER.NAME:'*':Y.EMPLOYER.NO:'*':Y.ENTRY.DATE:'*'

    CHANGE @FM TO @VM IN Y.SD.DATE
    CHANGE @FM TO @VM IN Y.SD.AMOUNT
    CHANGE @FM TO @VM IN Y.SD.CCY
    CHANGE @FM TO @VM IN Y.SD.ANTIQUITY
    CHANGE @FM TO @VM IN Y.SD.AGENCY
*                   4              5             6              7                8
    Y.OUT.ARR := Y.SD.AGENCY:'*':Y.SD.DATE:'*':Y.SD.CCY:'*':Y.SD.AMOUNT:'*':Y.SD.ANTIQUITY:'*'

    CHANGE @FM TO @VM IN Y.SRD.DATE
    CHANGE @FM TO @VM IN Y.SRD.AMOUNT
*                   9               10
    Y.OUT.ARR := Y.SRD.DATE:'*':Y.SRD.AMOUNT:'*'

    CHANGE @FM TO @VM IN Y.OD.AMOUNT
    CHANGE @FM TO @VM IN Y.OD.ANTIQUITY
*                   11               12
    Y.OUT.ARR := Y.OD.AMOUNT:'*':Y.OD.ANTIQUITY:'*'

    CHANGE @FM TO @VM IN Y.ORD.DATE
    CHANGE @FM TO @VM IN Y.ORD.AMOUNT
*                    13             14
    Y.OUT.ARR := Y.ORD.DATE:'*':Y.ORD.AMOUNT:'*'
    IF NOT(Y.FLAG) THEN
        RETURN
    END
    Y.VAL.DATE = Y.BOOK.DATE
    GOSUB GET.ANTIQUITY
    Y.ANTIQUITY = Y.DIFF.DAYS
*                    15               16
    Y.OUT.ARR := Y.TOT.CREDIT:'*':Y.ANTIQUITY

    IF Y.SD.CCY THEN
        Y.DATE.LIST.VALUE<-1> = Y.SD.DATE
        Y.CUR.LIST.VALUE<-1> = Y.SD.CCY
    END
    IF NOT(Y.SD.AMOUNT) AND NOT(Y.OD.AMOUNT) AND NOT(Y.SRD.AMOUNT) AND NOT(Y.ORD.AMOUNT) THEN
        Y.SD.AGENCY = ''
        Y.SD.CCY = ''
        Y.TOT.CREDIT = ''
        Y.ANTIQUITY = ''
    END
    IF Y.OUT.ARR THEN
        Y.OUT.ARRAY<-1> = Y.OUT.ARR
    END
    IF NOT(Y.SD.AMOUNT) AND NOT(Y.OD.AMOUNT) AND NOT(Y.SRD.AMOUNT) AND NOT(Y.ORD.AMOUNT) THEN
        Y.SD.AGENCY = ''
        Y.SD.CCY = ''
    END
    Y.SD.DATE = ''; Y.SD.AMOUNT = ''; Y.SD.ANTIQUITY = ''; Y.SRD.DATE = ''; Y.SRD.AMOUNT = ''; Y.ORD.AMOUNT = '';
    Y.OD.AMOUNT = ''; Y.OD.ANTIQUITY = ''; Y.ORD.DATE = ''; Y.TOT.CREDIT = '' ; Y.ANTIQUITY = '' ;Y.SD.AGENCY = ''; Y.SD.CCY = ''

RETURN
*--------------------------------------------------------------------------------------------------------
*************
LOOP.ID.LIST:
*************
    Y.PROCESSED.LIST = ''
    LOOP
        REMOVE STMT.ENTRY.REC FROM Y.ID.LIST SETTING Y.REC.POS
    WHILE STMT.ENTRY.REC : Y.REC.POS
        STMT.ENTRY.ID = FIELD(STMT.ENTRY.REC,'*',2)
        IF NOT(STMT.ENTRY.ID) THEN
            CONTINUE
        END
        LOCATE STMT.ENTRY.ID IN Y.PROCESSED.LIST<1> SETTING Y.P.POS THEN
            CONTINUE
        END ELSE
            Y.PROCESSED.LIST<-1> = STMT.ENTRY.ID
        END
        GOSUB READ.STMT.ENTRY
        GOSUB GET.CO.CCY.DATE
        IF Y.SHORT THEN
            GOSUB GET.SHORT.DETAIL
        END ELSE
            GOSUB GET.OVER.DETAILS
        END
        GOSUB FORM.OUT.ARRAY
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
****************
GET.CO.CCY.DATE:
****************
*    IF R.STMT.ENTRY<AC.STE.OUR.REFERENCE> EQ TELLER.ID AND R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.SHORT.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> LT 0 THEN
    IF R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.SHORT.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> LT 0 THEN
        Y.SD.AGENCY    = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
        Y.SD.DATE<-1>  = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        Y.SD.CCY       = R.STMT.ENTRY<AC.STE.CURRENCY>
    END

*    IF R.STMT.ENTRY<AC.STE.OUR.REFERENCE> EQ TELLER.ID AND R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.OVER.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> GT 0 THEN
    IF R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.OVER.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> GT 0 THEN
        Y.SD.AGENCY    = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
        Y.SD.DATE<-1>  = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        Y.SD.CCY       = R.STMT.ENTRY<AC.STE.CURRENCY>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.SHORT.DETAIL:
*****************
    IF R.STMT.ENTRY<AC.STE.AMOUNT.LCY> GT 0 THEN
        Y.TOT.CREDIT = Y.TOT.CREDIT + R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
    END

*    IF R.STMT.ENTRY<AC.STE.OUR.REFERENCE> EQ TELLER.ID AND R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.SHORT.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> LT 0 THEN
    IF R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.SHORT.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> LT 0 THEN
        Y.FLAG = 1
        Y.SD.AMOUNT<-1>= R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        Y.VAL.DATE     = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        Y.SD.AGENCY    = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
        Y.SD.CCY       = R.STMT.ENTRY<AC.STE.CURRENCY>
        GOSUB GET.ANTIQUITY
        Y.SD.ANTIQUITY<-1> = Y.DIFF.DAYS
    END

    IF R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.SHORT.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> GT 0 THEN
        Y.FLAG = 1
        Y.SRD.DATE<-1>      = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        Y.SRD.AMOUNT<-1>    = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        Y.SD.AGENCY    = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
        Y.SD.CCY       = R.STMT.ENTRY<AC.STE.CURRENCY>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.OVER.DETAILS:
*****************
*    IF R.STMT.ENTRY<AC.STE.OUR.REFERENCE> EQ TELLER.ID AND R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.OVER.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> GT 0 THEN
    IF R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.OVER.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> GT 0 THEN
        Y.FLAG = 1
        Y.OD.AMOUNT<-1>    = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        Y.VAL.DATE         = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        Y.SD.AGENCY    = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
        Y.SD.CCY       = R.STMT.ENTRY<AC.STE.CURRENCY>
        GOSUB GET.ANTIQUITY
        Y.OD.ANTIQUITY<-1> = Y.DIFF.DAYS
    END

    IF R.STMT.ENTRY<AC.STE.PRODUCT.CATEGORY> EQ Y.OVER.CATEGORY AND R.STMT.ENTRY<AC.STE.AMOUNT.LCY> LT 0 THEN
        Y.FLAG = 1
        Y.ORD.DATE<-1>      = R.STMT.ENTRY<AC.STE.VALUE.DATE>
        Y.ORD.AMOUNT<-1>    = R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        Y.SD.AGENCY    = R.STMT.ENTRY<AC.STE.COMPANY.CODE>
        Y.SD.CCY      = R.STMT.ENTRY<AC.STE.CURRENCY>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
**************
GET.ANTIQUITY:
**************
    IF NOT(Y.VAL.DATE) THEN
        Y.DIFF.DAYS = ''
        RETURN
    END
    Y.REGION = ''
    Y.DIFF.DAYS = 'C'
    CALL CDD(Y.REGION,Y.VAL.DATE,TODAY,Y.DIFF.DAYS)
    Y.DIFF.DAYS = ABS(Y.DIFF.DAYS)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
SORT.DETAILS:
*************
    Y.DUM.ARRAY = Y.OUT.ARRAY

    Y.LINE.COUNT = DCOUNT(Y.DUM.ARRAY,@FM)
    Y.LINE.START = 1
    LOOP
    WHILE Y.LINE.START LE Y.LINE.COUNT
        Y.ARR = Y.DUM.ARRAY<Y.LINE.START>
        Y.AGENCY = FIELD(FIELD(Y.ARR,'*',4),@VM,1)
        Y.USER   = FIELD(FIELD(Y.ARR,'*',1),@VM,1)
        Y.DATE   = FIELD(FIELD(Y.ARR,'*',5),@VM,1)
        Y.CCY    = FIELD(FIELD(Y.ARR,'*',6),@VM,1)
        Y.SORT.VAL = Y.USER:Y.AGENCY:Y.DATE:Y.CCY
        Y.AC.SORT.VAL<-1> =Y.ARR:@FM:Y.SORT.VAL
        Y.SORT.ARR<-1> = Y.SORT.VAL
        Y.LINE.START += 1
    REPEAT

    Y.SORT.ARR = SORT(Y.SORT.ARR)

    Y.SORT.COUNT = DCOUNT(Y.SORT.ARR,@FM)
    Y.SORT.START = 1

    LOOP
    WHILE Y.SORT.START LE Y.SORT.COUNT
        Y.ARR.ID = Y.SORT.ARR<Y.SORT.START>
        LOCATE Y.ARR.ID IN Y.AC.SORT.VAL SETTING Y.FM.POS THEN
            Y.DATA<-1> = Y.AC.SORT.VAL<Y.FM.POS-1>
            DEL Y.AC.SORT.VAL<Y.FM.POS>
            DEL Y.AC.SORT.VAL<Y.FM.POS-1>
        END
        Y.SORT.START += 1
    REPEAT

    Y.OUT.ARRAY = Y.DATA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
READ.USER:
**********
* In this para of the code, file USER is read
    R.USER.REC  = ''
    USER.ER     = ''
    CALL CACHE.READ(FN.USER, USER.ID, R.USER.REC, USER.ER)	;*R22 Auto Conversion  - F.READ to CACHE.READ

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.TELLER.PARAMETER:
**********************
* In this para of the code, file TELLER.PARAMETER is read
    R.TELLER.PARAMETER  = ''
    TELLER.PARAMETER.ER  = ''
    CALL CACHE.READ(FN.TELLER.PARAMETER, TELLER.PARAMETER.ID, R.TELLER.PARAMETER, TELLER.PARAMETER.ER)	;*R22 Auto Conversion  - F.READ to CACHE.READ

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.COMPANY:
*************
* In this para of the code, file COMPANY is read
    R.COMPANY.REC  = ''
    COMPANY.ER  = ''
    CALL CACHE.READ(FN.COMPANY, COMPANY.ID, R.COMPANY.REC, COMPANY.ER)	;*R22 Auto Conversion  - F.READ to CACHE.READ

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
    R.ACCOUNT  = ''
    ACCOUNT.ER  = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
****************
READ.STMT.ENTRY:
****************
* In this para of the code, file STMT.ENTRY is read
    R.STMT.ENTRY  = ''
    STMT.ENTRY.ER  = ''
    CALL F.READ(FN.STMT.ENTRY,STMT.ENTRY.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
