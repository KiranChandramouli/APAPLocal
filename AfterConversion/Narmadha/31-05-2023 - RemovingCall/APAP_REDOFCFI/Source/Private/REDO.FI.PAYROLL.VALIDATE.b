* @ValidationCode : Mjo2NzU5NzY1NDc6Q3AxMjUyOjE2ODA2MDcxMzQ0OTM6SVRTUzotMTotMToxMzkwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 04 Apr 2023 16:48:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1390
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FI.PAYROLL.VALIDATE(IN.TXT.MSG,OUT.VAR.WORK,OUT.TXT.MSG,OUT.ERR.MSG)
******************************************************************************************************
*    Routine that validate TXT file for PayRoll
*    Parameters:
*        IN.TXT.MSG:    Input parameter to receive the TXT message
*        OUT.VAR.WORK:  Output parameter to send some values to the principal process
*              Pos<1>:  Indicate the Id to save in REDO.FI.CONTROL
*        OUT.TXT.MSG:   Output parameter to send the NEW TXT message
*        OUT.ERR.MSG:   Output parameter to send the ERROR message get in the process
*
*=====================================================================================================
*
*    First Release : Ana Noriega
*    Developed for : APAP
*    Developed by  : Ana Noriega
*    Date          : 2010/Nov/08
*
*=====================================================================================================
* Modifications:
* 20/04/2012 - cherrera@temenos.com
*              APAP C18 Issues:
*                                BUG-C18-NOMINAS-20120201-1359, BUG-C18-NOMINAS-20120229-1942,
*                                BUG-C18-NOMINAS-20120302-1619, BUG-C18-NOMINAS-20120307-0938
*                                BUG-C18-NOMINAS-20120603-1627, BUG-C18-NOMINAS-20120603-1914,
*                                MANTIS0002302, MANTIS0002303
*              Modifications:
*               - @ID for REDO.FI.CONTROL record is calculated in REDO.FI.PAYROLL.VALIDATE
*               - Control for duplicate files
*               - Change corporate debit account using REDO.INTERFACE.PARAM which the same Company ID

*  DATE             WHO                   REFERENCE             
* 05-APRIL-2023      Harsha                R22 Auto Conversion  - VM to @VM , FM to @FM , I to I.VAR , = to EQ , CHAR to CHARX and K to K.VAR
* 05-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*----------------------------------------------------------------------------
*=====================================================================================================
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $INSERT I_REDO.FI.VARIABLES.COMMON
    $INSERT I_F.REDO.FI.CONTROL
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.CARD.ISSUE
*
*******************************************************************************************************
*
    GOSUB INITIALISE
    GOSUB OPEN.FILES

    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS
    END
*
RETURN
*
* ======
PROCESS:
* ======
*
*   Process and validate each record from TXT message
*

    GOSUB PROCESS.DATA
    GOSUB VALIDATE.DATA
*
RETURN
*
* -----------
PROCESS.DATA:
* -----------
*
*   Paragraph that control the error in the subroutine
*
*
    FOR I.VAR = 1 TO Y.COUNT
*       RECORD
        Y.DATA = R.TXT.MSG<I.VAR>
        CHANGE CHARX(09) TO '' IN Y.DATA
        CHANGE CHARX(13) TO '' IN Y.DATA
        CHANGE CHARX(10) TO '' IN Y.DATA
        Y.DATA = TRIM(Y.DATA)

        IF Y.DATA EQ Y.EOL OR Y.DATA EQ Y.CH13 OR Y.DATA EQ "" THEN
            Y.ERR.MSG = "Invalid.Blank.Lines.In.File"
            BREAK
        END

*       HEADER
        IF I.VAR EQ 1 THEN
*           Validate Information Head
            GOSUB VALIDATE.HEAD

            IF Y.ERR.MSG NE "" THEN
                BREAK
            END
*       DETAIL
        END ELSE
*           Validate Detail
            GOSUB VALIDATE.DETAIL
*           Get new TXT record
            OUT.TXT.MSG<I.VAR-1> = Y.ACCOUNT:",":Y.TOTAL.AMOUNT:",":Y.CURRENCY:",":Y.SING
        END
*       Process for every record in the TXT file
        IF PROCESS.GOAHEAD EQ 0 THEN
            I.VAR = Y.COUNT + 1
        END
    NEXT

*   Get more values to validate
    GOSUB GET.VALUES.DATA
*
RETURN
*
* ------------
VALIDATE.HEAD:
* ------------
*
*   Paragraph to validate HEAD
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
*   Take each element of the Head
    Y.COMPANY.HEAD         = FIELD(Y.DATA,",",1)
    Y.PAYMENT.DATE.HEAD    = FIELD(Y.DATA,",",2)
    Y.SEQ.FILE.HEAD        = FIELD(Y.DATA,",",3)
    Y.TOTAL.AMOUNT.HEAD    = FIELD(Y.DATA,",",4)
    Y.TOTAL.RECORDS.HEAD   = FIELD(Y.DATA,",",5)

    Y.TOTALHEAD.1 = FIELD(Y.TOTAL.AMOUNT.HEAD,".",1)
    Y.TOTALHEAD.2 = FIELD(Y.TOTAL.AMOUNT.HEAD,".",2)

    Y.TOTALHEAD = Y.TOTALHEAD.1 : Y.TOTALHEAD.2


    Y.UNIQUE.PART.HEAD = Y.COMPANY.HEAD:Y.PAYMENT.DATE.HEAD:Y.SEQ.FILE.HEAD:Y.TOTALHEAD:Y.TOTAL.RECORDS.HEAD
    Y.REDO.FI.CON.ID   = FI.INTERFACE:".":Y.UNIQUE.PART.HEAD:Y.SEQ.FILE

* Validate HEAD data

* Marcelo Gudino
* Validation to verify if the company is register

    GOSUB VALIDATE.COMPANY.EXIST


    GOSUB VALIDATE.UNIQUE.FILE  ;*   Validate the file is unique

    IF Y.ERR.MSG NE "" THEN
        RETURN
    END

    GOSUB VALIDATE.DEBIT.ACCOUNT          ;* Validate DebitAccount

    GOSUB CONTROL.MSG.ERROR


RETURN
*
* -------------------
VALIDATE.UNIQUE.FILE:
* -------------------
*
*   Paragraph that validate the file is unique
*   A file should not run more than once, the same company on the same date you can apply more than one file
*
*   Set ID file


*   Validate the parts of Id is no blank
    IF Y.COMPANY.HEAD EQ "" OR Y.PAYMENT.DATE.HEAD EQ "" OR Y.SEQ.FILE.HEAD EQ "" THEN
        Y.ERR.MSG = 'Header.No.Correct.&':@FM:Y.UNIQUE.PART.HEAD
    END

    GOSUB VALIDATE.ID

RETURN
*

*===========
VALIDATE.ID:
*===========
    SEL.LIST = ''
    RET.CODE = ''
    F.NAME = FIELD(Y.REDO.FI.CON.ID,".",1)
    F.CODE = FIELD(Y.REDO.FI.CON.ID,".",2)
    F.KEY = F.NAME:".":F.CODE

    SEL.CMD  = "SELECT ":FN.REDO.FI.CON
    SEL.CMD := " WITH @ID LIKE '":F.KEY:"...'"

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    POS.BI = ""
    F.SEQ  = 0
    IF NO.OF.REC GT 0 THEN
        F.SEQ = NO.OF.REC + 1
        IF F.SEQ LT 10 THEN
            F.SEQ ="0":F.SEQ
        END
    END ELSE
        F.SEQ ="01"
    END

    LOOP REMOVE Y.SEL.ID FROM SEL.LIST SETTING POS
    WHILE Y.SEL.ID:POS
        CALL F.READU(FN.REDO.FI.CON,Y.SEL.ID,R.REDO.FI.CON,F.REDO.FI.CON,Y.ERR.MSG,'')
        IF R.REDO.FI.CON<REDO.FI.CON.PROC.STATUS> EQ 'PROCESADO' THEN
            Y.EXISTE = "TRUE"
            Y.ERR.MSG    = 'File.Already.Exists.&':@FM:Y.SEL.ID    ;*Indicate sequential file duplicated
            BREAK
        END ELSE
            Y.EXISTE = "FALSE"
        END
    REPEAT

    Y.REDO.FI.CON.ID = F.KEY:".":F.SEQ
    OUT.VAR.WORK<1>  = Y.REDO.FI.CON.ID

RETURN


* ---------------------
VALIDATE.COMPANY.EXIST:
* ---------------------
*
*   Paragraph that validate DebitAccount.
*   - Validates the company existence
*


    CALL CACHE.READ(FN.REDO.INTERFACE.PARAM, Y.COMPANY.HEAD, R.REDO.INTERFACE.PARAM, Y.REDO.INTERFACE.PARAM.ERR)
    IF R.REDO.INTERFACE.PARAM EQ "" THEN
        Y.ERR.MSG = 'Company.NotExists.&':@FM:Y.COMPANY.HEAD
        RETURN

    END
    Y.TO.MAIL.VALUE  = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.MAIL.ADDRESS>
    Y.CTA.INTER = 'CTA.INTER'
    Y.ACC.VALUE = ''

    LOCATE Y.CTA.INTER IN R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE,1> SETTING PARAM.POS THEN
        Y.ACC.VALUE  = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE,PARAM.POS>
        IF NOT(Y.ACC.VALUE) THEN
            Y.ERR.MSG = 'Internal.Debit.Account.NotExists.&':@FM:Y.ACC.VALUE
            RETURN
        END
    END

    OUT.VAR.WORK<2> = Y.ACC.VALUE
    OUT.VAR.WORK<3> = Y.TO.MAIL.VALUE

RETURN
*

* ---------------------
VALIDATE.DEBIT.ACCOUNT:
* ---------------------
*
*   Paragraph that get the available amount from Debit Account
*
*   Read ACCOUT, for Debit Account
    Y.ACCOUNT.ID           =  Y.ACC.VALUE ;*Cuenta a Debitar

    CALL F.READ(FN.ACCOUNT, Y.ACCOUNT.ID, R.ACCOUNT, F.ACCOUNT, Y.ERR.MSG )
    IF R.ACCOUNT THEN
*       Available Amount DebitAccount
        Y.AVAILABLE.AMOUNT  = R.ACCOUNT<Y.POS.LF.ACC,Y.POS.AV.BAL>        ;*L.AC.AV.BAL EQ R.ACCOUNT<AC.WORKING.BALANCE> - R.ACCOUNT<AC.LOCKED.AMOUNT>
*       Overdraft for DebitAccount - for future use
        Y.OVERDRAFT         = 0
*       Currency Debit Account
        Y.CURRENCY          = R.ACCOUNT<Y.POS.CCY.ACC>
*       Validate Available Amount with Total Debit Amount from de Header
        IF Y.AVAILABLE.AMOUNT LT Y.TOTAL.AMOUNT.HEAD AND R.ACCOUNT<AC.CUSTOMER> NE '' THEN
            Y.ERR.MSG = "Available.Balance.&.Debit.Amount.&":@FM:Y.AVAILABLE.AMOUNT:@VM:Y.TOTAL.AMOUNT.DATA
        END
    END ELSE
        Y.ERR.MSG = 'Debit.Acc.NotExists.&':@FM:FI.INTERFACE
    END
*
RETURN
*

* --------------
VALIDATE.DETAIL:
* --------------
*
*   Paragraph to validate HEAD
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*
*   Sum amount from the detail
    Y.TOTAL.AMOUNT.DATA   += FIELD(Y.DATA,",",3)
*   Amount by record
    Y.TOTAL.AMOUNT         = FIELD(Y.DATA,",",3)
*   Type Producto
    Y.TYP.PRODUCT          = FIELD(Y.DATA,",",1)
*   ID product
    Y.ID.PRODUCT           = FIELD(Y.DATA,",",2)
*   BIN number
    Y.BIN.NUMBER           = SUBSTRINGS(Y.ID.PRODUCT,1,6)

*   Validate DETAIL data
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1        ;*   Validate type product
                GOSUB VALIDATE.TYPE.PRODUCT

            CASE LOOP.CNT EQ 2        ;* Validate card type
                IF  Y.TYP.PRODUCT EQ C.TYP.D.CARD  THEN
                    GOSUB GET.CARD.TYPE
                END

            CASE LOOP.CNT EQ 3        ;* Validate Account
                IF  Y.TYP.PRODUCT EQ C.TYP.D.CARD  THEN
                    GOSUB GET.ACCOUNT
                END ELSE
                    Y.ACCOUNT = Y.ID.PRODUCT
                END

        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT +=1
    REPEAT
*
RETURN
*
* --------------------
VALIDATE.TYPE.PRODUCT:
* --------------------
*
*   Paragraph that validate TypeProduct is T-DebitCard or C-Account
*
    IF NOT(Y.TYP.PRODUCT MATCHES C.TYP.D.CARD:@VM:C.TYP.ACC) THEN
        Y.ERR.MSG = "Type.Product.&.Id.&":@FM:Y.TYP.PRODUCT:@VM:Y.ID.PRODUCT
    END
*
RETURN
*
* ------------
GET.CARD.TYPE:
* ------------
*
*   Paragraph that get the ID CardType from R.CARD.TYPE.BIN
*
*   Validate leng of the Id Debit Card
    IF LEN(Y.ID.PRODUCT) NE 16 THEN
        Y.ERR.MSG = "Card.Issue.Id.&.Incorrect":@FM:Y.ID.PRODUCT
    END ELSE
        GOSUB GET.CARD.ISSUE.ID
    END
*
RETURN
*
* ----------------
GET.CARD.ISSUE.ID:
* ----------------
*
*   Paragraph that get the ID CardIssue
*
*   Get CardTypeId using the to get BIN number
    K.POS = 1
    LOOP
    WHILE K.POS GT 0 DO
        LOCATE Y.BIN.NUMBER IN R.CARD.TYPE.BIN<1,K.POS> SETTING K.VAR THEN
            Y.CARD.TYPE     = R.CARD.TYPE.CT<K.VAR>
            Y.CARD.ISSUE.ID = Y.CARD.TYPE:".":Y.ID.PRODUCT
            K.POS           = K.VAR + 1
        END ELSE
            K.POS           = 0
        END
    REPEAT

    IF Y.CARD.TYPE EQ "" THEN
        Y.ERR.MSG = "CardTypeBIN.&.NotExists":@FM:Y.BIN.NUMBER
    END

*
RETURN
*
* ----------
GET.ACCOUNT:
* ----------
*
*   Paragraph that get the ID Account using CardTypeID
*
    CALL F.READ(FN.CARD.ISSUE, Y.CARD.ISSUE.ID, R.CARD.ISSUE, F.CARD.ISSUE, Y.CARD.ISSUE.ERR)
    IF Y.CARD.ISSUE.ERR EQ "" THEN
        Y.ACCOUNT = R.CARD.ISSUE<Y.POS.ACC>
    END ELSE
        Y.ERR.MSG = "CardIssue.&.NotExists":@FM:Y.CARD.ISSUE.ID
    END
*
RETURN
*
* --------------
GET.VALUES.DATA:
* --------------
*
*   Paragraph that get data for validate
*

    IF PROCESS.GOAHEAD EQ 0 THEN
        RETURN
    END
*   Total records from Detail
    Y.TOTAL.RECORDS.DATA   = Y.COUNT - 1  ;*Less the header record
*   Date parts - PAYMENT.DATE.HEAD's format ddMMyyyy buy TODAY's format is yyyyMMdd
    Y.DAY.HEAD             = SUBSTRINGS(Y.PAYMENT.DATE.HEAD,1,2)
    Y.MONTH.HEAD           = SUBSTRINGS(Y.PAYMENT.DATE.HEAD,3,2)
    Y.YEAR.HEAD            = SUBSTRINGS(Y.PAYMENT.DATE.HEAD,5,4)
    Y.PAYMENT.DATE.HEAD    = Y.YEAR.HEAD:Y.MONTH.HEAD:Y.DAY.HEAD
*   Set Common Variables
    FI.BATCH.ID            = Y.UNIQUE.PART.HEAD
    FI.DATO.NUM.REG        += Y.TOTAL.RECORDS.HEAD
    FI.DATO.MONTO.TOTAL    += Y.TOTAL.AMOUNT.HEAD
    FI.CALC.NUM.REG        += Y.TOTAL.RECORDS.DATA
    FI.CALC.MONTO.TOTAL    += Y.TOTAL.AMOUNT.DATA

    FI.DATO.NUM.REG        = FMT(FI.DATO.NUM.REG,"R,#15")
    FI.DATO.MONTO.TOTAL    = FMT(FI.DATO.MONTO.TOTAL,"R2,#15")
    FI.CALC.NUM.REG        = FMT(FI.CALC.NUM.REG,"R,#15")
    FI.CALC.MONTO.TOTAL    = FMT(FI.CALC.MONTO.TOTAL,"R2,#15")
*
RETURN
*
* ------------
VALIDATE.DATA:
* ------------
*
*   Paragraph that get data for validate
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 3
*

    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1        ;* Validate Total Record between Header and Detail
                IF Y.TOTAL.RECORDS.HEAD NE Y.TOTAL.RECORDS.DATA THEN
                    Y.ERR.MSG = "Records.Data.&.Calc.&":@FM:Y.TOTAL.RECORDS.HEAD:@VM:Y.TOTAL.RECORDS.DATA
                END

            CASE LOOP.CNT EQ 2        ;* Validate Total Amount between Header and Detail
                IF Y.TOTAL.AMOUNT.HEAD NE Y.TOTAL.AMOUNT.DATA THEN
                    Y.ERR.MSG = "Amount.Data.&.Calc.&":@FM:Y.TOTAL.AMOUNT.HEAD:@VM:Y.TOTAL.AMOUNT.DATA
                END

            CASE LOOP.CNT EQ 3        ;* Validate Deposit Date with Current Date
                IF Y.PAYMENT.DATE.HEAD NE TODAY THEN
                    Y.ERR.MSG = "Deposit.Date.&.Calc.&":@FM:TODAY:@VM:Y.PAYMENT.DATE.HEAD
                END
        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT +=1
    REPEAT
*
RETURN
*

* ----------------
CONTROL.MSG.ERROR:
* ----------------
*
*   Paragraph that control the error in the subroutine
*
    IF Y.ERR.MSG THEN
        ETEXT           = Y.ERR.MSG
        OUT.ERR.MSG     = ""
        PROCESS.GOAHEAD = 0
        CALL TXT(Y.ERR.MSG)
        CALL STORE.END.ERROR
        OUT.ERR.MSG     = Y.ERR.MSG
        ETEXT           = ""
    END
*
RETURN
*
* ----------------
GET.ALL.CARD.TYPE:
* ----------------
*
*   Paragraph that get all the Id from the Card.Type and populated an array ussing BIN number like index
*
    Y.SEL.CMD = "SELECT ":FN.CARD.TYPE
    CALL EB.READLIST(Y.SEL.CMD ,Y.BIN.LIST,'',Y.NO.OF.REG,Y.RET.CODE)
    LOOP
        REMOVE Y.BIN.CODE FROM Y.BIN.LIST SETTING Y.POS
    WHILE Y.BIN.CODE:Y.POS
        CALL F.READ(FN.CARD.TYPE,Y.BIN.CODE ,R.CARD.TYPE,F.CARD.TYPE,Y.CARD.TYPE.ERR)
        IF Y.CARD.TYPE.ERR EQ "" THEN
            Y.COUNT.CARD.TYPE += 1
            R.CARD.TYPE.BIN<Y.COUNT.CARD.TYPE,-1> = R.CARD.TYPE<CARD.TYPE.LOCAL.REF,L.CT.BIN.POS>
            R.CARD.TYPE.CT<Y.COUNT.CARD.TYPE,-1>  = Y.BIN.CODE

        END
    REPEAT
*
    IF R.CARD.TYPE.BIN EQ "" THEN
        Y.ERR.MSG = "CardType.Bin.NotExists"
    END
*
RETURN
*
* -----------------
VALIDATE.FILE.INFO:
* -----------------
*   Validate the file has detail's records
    IF Y.COUNT LT 2 THEN
        Y.ERR.MSG = "File.Without.Detail"
    END

*   Validate that exists the field L.AC.AV.BAL in ACCOUNT
    IF Y.POS.AV.BAL EQ "" THEN
        Y.ERR.MSG = "Av.Balance.In.Account.NotExists"
    END

*   Validate that exists the field ACCOUNT in CARD.ISSUE
    IF Y.POS.ACC EQ "" THEN
        Y.ERR.MSG = "Account.In.CardIssue.NotExists"
    END
*
RETURN
*
* ---------
INITIALISE:
* ---------
*
    PROCESS.GOAHEAD        = 1  ;*No problems
*
    LOOP.CNT               = 1
    MAX.LOOPS              = 2
    Y.ERR.MSG              = ""
*   Message
    Y.END.OF.FILE          = ""
*   Records TXT message
    R.TXT.MSG              = IN.TXT.MSG
    Y.COUNT                = DCOUNT(R.TXT.MSG,@FM)
    Y.DATA                 = ""
    OUT.TXT.MSG            = ""
*  FOR READ RECORDS
    FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
    F.REDO.INTERFACE.PARAM  = ""
    R.REDO.INTERFACE.PARAM  = ""
*   Head Variables
    Y.COMPANY.HEAD         = ""
    Y.PAYMENT.DATE.HEAD    = ""
    Y.SEQ.FILE.HEAD        = ""
    Y.TOTAL.AMOUNT.HEAD    = 0
    Y.TOTAL.RECORDS.HEAD   = 0
    Y.UNIQUE.PART.HEAD     = ""
*   Detail
    Y.TOTAL.RECORDS.DATA   = 0
    Y.TOTAL.AMOUNT.DATA    = 0
    Y.TOTAL.AMOUNT         = 0
    C.TYP.D.CARD           = "T"
    C.TYP.ACC              = "C"
    Y.TYP.PRODUCT          = ""
    Y.ID.PRODUCT           = ""
    Y.BIN.NUMBER           = ""
    Y.ACCOUNT              = ""
    Y.CURRENCY             = ""
    Y.SING                 = "+"
    Y.ERR.TYP.PROC         = 0  ;*Values: 0-NoError, 1-Error
*   Redo.Fi.Control
    Y.SEQ.FILE             = ".01"
    Y.SEQ.ERR              = ".02"
    FN.REDO.FI.CON         = "F.REDO.FI.CONTROL"
    F.REDO.FI.CON          = ""
    Y.REDO.FI.CON.ID       = ""
    Y.REDO.FI.CON.ERR      = ""
    R.REDO.FI.CON          = ""
*   Work Variables
    OUT.VAR.WORK           = ""
    OUT.VAR.WORK<1>        = ""
    OUT.VAR.WORK<2>        = ""
    OUT.VAR.WORK<3>        = ""
    Y.TOTALHEAD            = ""
    Y.TOTALHEAD.1          = ""
    Y.TOTALHEAD.2          = ""
    FI.DATO.NUM.REG      = 0
    FI.DATO.MONTO.TOTAL  = 0
    FI.CALC.NUM.REG      = 0
    FI.CALC.MONTO.TOTAL  = 0

*   Account
    FN.ACCOUNT             = "F.ACCOUNT"
    F.ACCOUNT              = ""
    Y.ACCOUNT.ID           = ""
    Y.ACCOUNT.ERR          = ""
    R.ACCOUNT              = ""
*   Card Type
    FN.CARD.TYPE           = "F.CARD.TYPE"          ;* AlternateId of F.CARD.TYPE
    F.CARD.TYPE            = ""
    Y.BIN.CODE             = ""
    Y.CARD.TYPE.ERR        = ""
    R.CARD.TYPE            = ""
    R.CARD.TYPE.BIN        = ""
    R.CARD.TYPE.CT         = ""
    Y.COUNT.CARD.TYPE      = 0
*   Card Issue
    FN.CARD.ISSUE          = "F.CARD.ISSUE"
    F.CARD.ISSUE           = ""
    Y.CARD.ISSUE.ID        = ""
    Y.CARD.ISSUE.ERR       = ""
    R.CARD.ISSUE           = ""
*   Possition local field L.AC.AV.BAL
    Y.POS.LF.ACC           = AC.LOCAL.REF
    Y.POS.CCY.ACC          = AC.CURRENCY
    Y.POS.AV.BAL           = ""
*    CALL GET.LOC.REF('ACCOUNT','L.AC.AV.BAL',Y.POS.AV.BAL)

    P.APPLICATION = "CARD.TYPE" : @FM : 'ACCOUNT'
    P.FIELD.NAME<1> = "L.CT.BIN" : @FM : 'L.AC.AV.BAL'
    CALL MULTI.GET.LOC.REF(P.APPLICATION,P.FIELD.NAME,P.FIELD.NO)
    L.CT.BIN.POS = P.FIELD.NO<1,1>
    Y.POS.AV.BAL = P.FIELD.NO<2,1>

*   Possition field ACCOUNT from CARD.ISSUE
    Y.POS.ACC              = CARD.IS.ACCOUNT
*   Possition field CURRENCY from ACCOUNT
    Y.POS.CCY              = AC.CURRENCY
*   Get Card.Type
    Y.SEL.CMD              = ""
    Y.LIST                 = ""
    Y.NO.OF.REG            = ""
    Y.RET.CODE             = ""
    Y.POS                  = ""
    Y.EXISTE               = ""
    F.NAME                 = ""
    F.KEY                  = ""
    F.CODE                 = ""
    Y.SEL.ID               = ""
    Y.EOL                  = CHARX(13):CHARX(10)      ;* Validate end of line
    Y.CH13                 = CHARX(13)
*
RETURN
*
*
* ---------
OPEN.FILES:
* ---------
*
*   Paragraph that open files
*
*   OPEN  REDO.FI.CONTROL
    CALL OPF(FN.REDO.FI.CON,F.REDO.FI.CON)
*
*   OPEN  REDO.INTERFACE.PARAM
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
*
*   OPEN  ACCOUNT
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
*
*   OPEN  CARD.TYPE
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)
*
*   OPEN  CARD.ISSUE
    CALL OPF(FN.CARD.ISSUE,F.CARD.ISSUE)
*
RETURN
*
*-----------------------
CHECK.PRELIM.CONDITIONS:
*-----------------------
*
    LOOP.CNT  = 1   ;   MAX.LOOPS = 2
*
*   Get All CardType
    GOSUB GET.ALL.CARD.TYPE
*   Validate
    LOOP
    WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
        BEGIN CASE
            CASE LOOP.CNT EQ 1        ;*    Validate TXT file exists
                IF IN.TXT.MSG EQ "" THEN
                    ETEXT = "EB-FILE.EMPTY"
                END

            CASE LOOP.CNT EQ 2        ;* Validate that exists detail in TXT message, because the first record has to be the header
                GOSUB VALIDATE.FILE.INFO

        END CASE
*       Message Error
        GOSUB CONTROL.MSG.ERROR
*       Increase
        LOOP.CNT +=1
    REPEAT
*
RETURN
*
END
