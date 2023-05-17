SUBROUTINE REDO.NOF.LOANS.DAILY.REPORT(Y.LOAN.ARR)
*-------------------------------------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Natchimuthu.P
* Program Name  : REDO.NOF.LOANS.DAILY.REPORT
* ODR NUMBER    : ODR-2010-03-0110
*-------------------------------------------------------------------------------------------------------------
* Description   : This is a Nofile routine for the Enquiry REDO.ENQ.LOAN.ENTRY.RPT
*                 to display shows all loans transactions affecting accounting balances,
*                 useful as the proof of automatic and manual accounting records
* In parameter  : None
* out parameter : None
*-------------------------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 21-10-2010      Natchimuthu.P    ODR-2010-03-0110   Initial Creation
* 18-11-2010      Akthar Rasool S  ODR-2010-03-0110     Modification
* 24-11-2010      MARIMUTHU S      ODR-2010-03-0110     Modification
* 31-01-2012      Jeeva T           PACS00153533        Cob Performance
* ------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.BILL.DETAILS
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TRANSACTION
    $INSERT I_F.TELLER
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.RE.STAT.REP.LINE
    $INSERT I_F.STMT.ENTRY
*   $INSERT I_F.TELLER
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.ARRANGEMENT.ACTIVITY
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.AA.ACTIVITY.HISTORY
    $INSERT I_F.AA.PROPERTY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.PRODUCT


    GOSUB MAIN.PARA
    GOSUB GOEND
RETURN
*-------------------------------------------------------------------------------------------------------------
MAIN.PARA:
*-------------------------------------------------------------------------------------------------------------
    GOSUB OPEN.PARA
    GOSUB LOCATE.PARA
    GOSUB PROCESS.PARA
RETURN
*-------------------------------------------------------------------------------------------------------------
OPEN.PARA:
*-------------------------------------------------------------------------------------------------------------
    FN.AA.BILL.DETAILS  =  'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS   =   ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.FUNDS.TRANSFER   = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER    =  ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.TELLER  = 'F.TELLER'
    F.TELLER   = ''
    CALL OPF(FN.TELLER,F.TELLER)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'
    F.RE.STAT.REP.LINE  = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)

    FN.STMT.ENTRY     = 'F.STMT.ENTRY'
    F.STMT.ENTRY      = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.TRANSACTION    = 'F.TRANSACTION'
    F.TRANSACTION     = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.AA.ARRANGEMENT    = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT     =  ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.CUSTOMER  = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.AA.ARRANGEMENT.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ARRANGEMENT.ACTIVITY = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY)

    FN.AA.ARRANGEMENT.ACTIVITY.HIS = 'F.AA.ARRANGEMENT.ACTIVITY$HIS'
    F.AA.ARRANGEMENT.ACTIVITY.HIS = ''
    CALL OPF(FN.AA.ARRANGEMENT.ACTIVITY.HIS,F.AA.ARRANGEMENT.ACTIVITY.HIS)

    FN.AA.ACCOUNT.DETAILS= 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ACTIVITY.HISTORY = 'F.AA.ACTIVITY.HISTORY'
    F.AA.ACTIVITY.HISTORY = ''
    CALL OPF(FN.AA.ACTIVITY.HISTORY,F.AA.ACTIVITY.HISTORY)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.TELLER.HIS = 'F.TELLER$HIS'
    F.TELLER.HIS = ''
    CALL OPF(FN.TELLER.HIS,F.TELLER.HIS)

    FN.AA.PROPERTY = 'F.AA.PROPERTY'
    F.AA.PROPERTY = ''
    CALL OPF(FN.AA.PROPERTY,F.AA.PROPERTY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.PRODUCT = 'F.AA.PRODUCT'
    F.AA.PRODUCT = ''
    CALL OPF(FN.AA.PRODUCT,F.AA.PRODUCT)

    Y.FROM.DATE         = '' ; Y.TO.DATE           = '' ; Y.TRANSACTION.DATE  = '' ; Y.TXN.VALUE.DATE    = '' ; Y.CURRENCY          = ''
    Y.AGENCY            = '' ; Y.TXN.USER          = '' ; Y.DEBIT             = '' ; Y.CREDIT            = '' ; Y.AGENCY            = ''
    Y.TXN.USER          = '' ; Y.TRANS.ID          = '' ; Y.TXN.USER          = '' ; SEL.LIST1           = '' ; Y.SUPER.CUR.ACCT.NO = ''
    Y.CURR.ACCT.DESC    = '' ; Y.CURR.ACCT.NO      = '' ; Y.LOAN.NO           = '' ; Y.RE.REQ.ASSET.VALUES = '' ; Y.RE.STAT.REP.VAL.ARRAY = '' ; Y.NON.BILL.IDS=''
    FLG = '' ; FLG.TO = '' ; CHECK.FLG.CLS = '' ; DUP.DATE = ''

RETURN
*-------------------------------------------------------------------------------------------------------------
LOCATE.PARA:
*-------------------------------------------------------------------------------------------------------------
*    SEL.CMD = "SELECT ":FN.AA.ACCOUNT.DETAILS
    SEL.CMD = "SELECT ":FN.AA.ARRANGEMENT:' WITH ARR.STATUS NE AUTH AND WITH ARR.STATUS NE UNAUTH '
    LOCATE 'TXN.DATE.FROM' IN D.FIELDS SETTING Y.TXN.DATE.POS THEN
        Y.FROM.DATE = D.RANGE.AND.VALUE<Y.TXN.DATE.POS>
        FLG = 1
    END

    LOCATE 'TXN.DATE.TO' IN D.FIELDS SETTING Y.TXN.DATE.POS THEN
        Y.TO.DATE = D.RANGE.AND.VALUE<Y.TXN.DATE.POS>
        IF FLG EQ 1 THEN
            FLG.TO = 1
        END ELSE
            ENQ.ERROR = 'FROM.DATE is mandatory'
        END
    END ELSE
        IF FLG EQ 1 THEN
            ENQ.ERROR = 'TO.DATE is mandatory'
        END
    END

    IF FLG.TO EQ 1 THEN
        IF Y.TO.DATE LT Y.FROM.DATE THEN
            ENQ.ERROR = 'FROM.DATE should be Less than TO.DATE'
        END
    END

    LOCATE 'LOAN.NUMBER' IN D.FIELDS SETTING Y.LOAN.POS THEN
        Y.LOAN.NO = D.RANGE.AND.VALUE<Y.LOAN.POS>
        SEL.CMD = 'SELECT ':FN.AA.ARRANGEMENT:' WITH @ID EQ ':Y.LOAN.NO
    END

    GOSUB SELECT.STMT

RETURN
*-------------------------------------------------------------------------------------------------------------
SELECT.STMT:
*-------------------------------------------------------------------------------------------------------------
    IF FLG.TO EQ 1 THEN
        D.FIELDS = 'ACCOUNT':@FM:'BOOKING.DATE'
        D.LOGICAL.OPERANDS = '1':@FM:'9'
    END ELSE
        D.FIELDS = 'ACCOUNT':@FM:'BOOKING.DATE'
        D.LOGICAL.OPERANDS = '1':@FM:'9'
        Y.FROM.DATE = '00000000'
        Y.TO.DATE = '100000000'

    END

RETURN
*-------------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*-------------------------------------------------------------------------------------------------------------


    Y.SEL.LIST.ARRAY = Y.FROM.DATE:"*":Y.TO.DATE:"*":Y.LOAN.NO

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',Y.NO.OF.REC,Y.SEL.ERR)

    IF SEL.LIST THEN
        Y.INIT.REP.COUNT = 1
        LOOP
            REMOVE Y.AA.ID FROM SEL.LIST SETTING Y.AA.POS
        WHILE Y.AA.ID:Y.AA.POS
            Y.BILL.IDS = ''
            CALL F.READ(FN.AA.ACCOUNT.DETAILS,Y.AA.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,Y.AA.ARRANGE.ERR)
            GOSUB FETCH.MAIN.DETAILS
            Y.INIT.REP.COUNT += 1
        REPEAT
    END

RETURN
*-------------------------------------------------------------------------------------------------------------
FETCH.MAIN.DETAILS:

*-------------------------------------------------------------------------------------------------------------
    GOSUB ARR.ACCOUNT.PROCESS
*GOSUB RE.STAT.LINE.PROCESS
    GOSUB AA.ARRANGE.PROCESS

    IF FLG.TO EQ 1 THEN
        D.RANGE.AND.VALUE = Y.ACCT.NO:@FM:Y.FROM.DATE
        GOSUB STMT.ENTRY.PROCESS
    END ELSE
        D.RANGE.AND.VALUE = Y.ACCT.NO:@FM:Y.AA.START.DATE

        GOSUB STMT.ENTRY.PROCESS
    END

RETURN

*-------------------------------------------------------------------------------------------------------------
RE.STAT.LINE.PROCESS:
*-------------------------------------------------------------------------------------------------------------
    IF Y.INIT.REP.COUNT EQ 1 THEN
        Y.SEL.RE.STAT.CMD = "SELECT ":FN.RE.STAT.REP.LINE
        CALL EB.READLIST(Y.SEL.RE.STAT.CMD,Y.RE.STAT.SEL.LIST,'',Y.NO.OF.RE.STAT.REC,Y.RE.STAT.SEL.ERR)
        IF Y.RE.STAT.SEL.LIST THEN
            LOOP
                REMOVE Y.RE.STAT.ID.VAL FROM Y.RE.STAT.SEL.LIST SETTING Y.RE.STAT.SEL.POS
            WHILE Y.RE.STAT.ID.VAL : Y.RE.STAT.SEL.POS
                CALL F.READ(FN.RE.STAT.REP.LINE,Y.RE.STAT.ID.VAL,R.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE,Y.RE.STAT.REP.ERR)

                IF R.RE.STAT.REP.LINE THEN
                    Y.RE.STAT.REP.VAL = R.RE.STAT.REP.LINE<RE.SRL.DESC>
                    IF Y.RE.STAT.REP.VAL THEN
                        Y.RE.CUR.ACCT.DUM.VAL = FIELD(Y.RE.STAT.REP.VAL,@VM,2)
                        Y.RE.CUR.ACCT.DUM.DESC = FIELD(Y.RE.STAT.REP.VAL,@VM,3)
                        Y.RE.SUPER.ACCT.DUM.VAL = FIELD(Y.RE.STAT.REP.VAL,@VM,1)
                    END
                    Y.RE.STAT.REP.ASSET1 = R.RE.STAT.REP.LINE<RE.SRL.ASSET1>
                    Y.RE.STAT.REP.ASSET2 = R.RE.STAT.REP.LINE<RE.SRL.ASSET2>
                    Y.RE.STAT.REP.ASSET.TYPE = R.RE.STAT.REP.LINE<RE.SRL.ASSET.TYPE>
                END
                Y.RE.STAT.REP.VAL.ARRAY<-1> =Y.RE.STAT.REP.ASSET1:"*":Y.RE.STAT.REP.ASSET2:"*":Y.RE.STAT.REP.ASSET.TYPE:"*":Y.RE.CUR.ACCT.DUM.VAL:"*"
                Y.RE.STAT.REP.VAL.ARRAY:=Y.RE.CUR.ACCT.DUM.DESC:"*":Y.RE.SUPER.ACCT.DUM.VAL
            REPEAT
        END
    END
RETURN

*-----------------------------------------------------------------------------------------------------------
ARR.ACCOUNT.PROCESS:
*-------------------------------------------------------------------------------------------------------------
    ARR.ID1      = Y.AA.ID
    PROP.CLASS1  = 'ACCOUNT' ; RETURN.IDS1  = '' ; RETURN.COND1 = '' ; RETURN.ERR1  = ''
    CALL AA.GET.ARRANGEMENT.CONDITIONS(ARR.ID1,PROP.CLASS1,"","",RETURN.IDS1,RETURN.COND1,RETURN.ERR1)
    R.CONDITION = ''
    R.CONDITION=RAISE(RETURN.COND1)
    IF R.CONDITION THEN
        Y.PREV.LOAN.NO   = R.CONDITION<AA.AC.ALT.ID>
        Y.ACCT.NO        = R.CONDITION<AA.AC.ACCOUNT.REFERENCE>
    END

RETURN
*-------------------------------------------------------------------------------------------------------------
AA.ARRANGE.PROCESS:
*-------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.AA.ARRANGEMENT,Y.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARRANGEMENT.ERR)
    IF R.AA.ARRANGEMENT THEN
        Y.LINKED.APPL      = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL>
        Y.LINKED.APPL.ID   = R.AA.ARRANGEMENT<AA.ARR.LINKED.APPL.ID>
        Y.CUST             = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
        Y.PRODUCT.TY = R.AA.ARRANGEMENT<AA.ARR.PRODUCT>
        Y.AA.START.DATE = R.AA.ARRANGEMENT<AA.ARR.START.DATE>
        CALL CACHE.READ(FN.AA.PRODUCT, Y.PRODUCT.TY, R.PRODUCT, PR.ERR)

        Y.PRODUCT.TYPE = R.PRODUCT<AA.PDT.DESCRIPTION,2>
        IF Y.PRODUCT.TYPE EQ '' THEN
            Y.PRODUCT.TYPE = R.PRODUCT<AA.PDT.DESCRIPTION,1>
        END
    END
    IF Y.CUST THEN
        CALL F.READ(FN.CUSTOMER,Y.CUST,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
        Y.SECTOR = R.CUSTOMER<EB.CUS.SECTOR>
    END
RETURN
*-------------------------------------------------------------------------------------------------------------
STMT.ENTRY.PROCESS:
*-------------------------------------------------------------------------------------------------------------
    Y.ID.LIST = ''

    CALL F.READ(FN.ACCOUNT,Y.ACCT.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    Y.COMP.ID = R.ACCOUNT<AC.CO.CODE>
    IF R.ACCOUNT THEN

        CALL E.STMT.ENQ.BY.CONCAT(Y.ID.LIST)

        Y.ID.INIT.VAL = 1
        Y.ID.LISTS.COUNT = DCOUNT(Y.ID.LIST,@FM)
        LOOP
            REMOVE Y.KEY.ID FROM Y.ID.LIST SETTING Y.KEY.POS
        WHILE Y.ID.INIT.VAL LE Y.ID.LISTS.COUNT
            Y.TRANS.ID = ''
            Y.TXN.USER = ''
            Y.TXN.USER1 = ''
            Y.AGENCY = ''
            Y.TRANSACTION.DATE = '' ; Y.TXN.VALUE.DATE = '' ; Y.CURRENCY = ''
            Y.DTE = FIELD(Y.KEY.ID,'*',4)

            Y.CREDIT = ''
            Y.DEBIT = ''

            GOSUB SUB.CHECK.DTE

            Y.ID.INIT.VAL += 1
        REPEAT
    END

RETURN
*-------------------------------------------------------------------------------------------------------------
SUB.CHECK.DTE:
*-------------------------------------------------------------------------------------------------------------
    IF Y.DTE GE Y.FROM.DATE AND Y.DTE LE Y.TO.DATE THEN
        Y.STMT.ID = FIELD(Y.KEY.ID,"*",2)
        Y.DB.CR.AMT = FIELD(Y.KEY.ID,"*",7)
        CALL F.READ(FN.STMT.ENTRY,Y.STMT.ID,R.STMT.REC,F.STMT.ENTRY,Y.STMT.ERR)
        Y.TXN.CODE        = R.STMT.REC<AC.STE.TRANSACTION.CODE>
        Y.CONSOL.KEY      = R.STMT.REC<AC.STE.CONSOL.KEY>
        Y.CATEG           = R.STMT.REC<AC.STE.PRODUCT.CATEGORY>
        Y.BAL.TYPE        = R.STMT.REC<AC.STE.BALANCE.TYPE>
        Y.TRANSACTION.REF = R.STMT.REC<AC.STE.TRANS.REFERENCE>
        Y.CURRENCY = R.STMT.REC<AC.STE.CURRENCY>
        Y.DB.CR.AMT.VAL = ''
        Y.DB.CR.AMT.VAL = R.STMT.REC<AC.STE.AMOUNT.LCY>
        IF NOT(Y.DB.CR.AMT.VAL) THEN
            Y.DB.CR.AMT.VAL = R.STMT.REC<AC.STE.AMOUNT.FCY>
        END


        IF Y.DB.CR.AMT.VAL GE 0 THEN
*           Y.CREDIT = Y.DB.CR.AMT
            Y.CREDIT = Y.DB.CR.AMT.VAL
            SET.DATE = 'Y'
        END ELSE
*            Y.DEBIT = Y.DB.CR.AMT[2,-1]
            Y.DEBIT = Y.DB.CR.AMT.VAL[2,-1]
            SET.DATE = 'N'
        END

        CALL CACHE.READ(FN.TRANSACTION, Y.TXN.CODE, R.TRANSACTION, Y.TRANS.ERR)
        Y.TXN.DESC    =  R.TRANSACTION<AC.TRA.NARRATIVE,2>
        CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.TRANSACTION.REF,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,Y.AA.ARRANGEMENT.ERR)

        Y.TRANS.ID = ''
        IF R.AA.ARRANGEMENT.ACTIVITY THEN
            Y.TRANS.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
        END ELSE
            CALL EB.READ.HISTORY.REC(F.AA.ARRANGEMENT.ACTIVITY.HIS,Y.TRANSACTION.REF,R.AA.ARRANGEMENT.ACTIVITY,AA.ARR.AC.ERR)
            Y.TRANS.ID = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
        END
        IF Y.TRANS.ID THEN
            Y.TXN.ID      =  Y.TRANS.ID[1,2]
            GOSUB CHECK.FT.REC

            IF Y.TXN.ID EQ 'TT'  THEN
                GOSUB CHECK.TT.REC
            END
            IF Y.TXN.ID EQ 'AA' THEN
                GOSUB CHECK.AA.REC
            END
        END
    END


RETURN
*-------------------------------------------------------------------------------------------------------------
CHECK.AA.REC:
*-------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.AA.ARRANGEMENT.ACTIVITY,Y.TRANS.ID,R.AA.ARRANGEMENT.ACTIVITY,F.AA.ARRANGEMENT.ACTIVITY,Y.AA.ARRANGEMENT.ERR)
    IF R.AA.ARRANGEMENT.ACTIVITY THEN
        Y.TRANS.ID.1 = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
    END ELSE
        CALL EB.READ.HISTORY.REC(F.AA.ARRANGEMENT.ACTIVITY.HIS,Y.TRANS.ID,R.AA.ARRANGEMENT.ACTIVITY,AA.ARR.ACERR)
        Y.TRANS.ID.1 = R.AA.ARRANGEMENT.ACTIVITY<AA.ARR.ACT.TXN.CONTRACT.ID>
    END
    IF Y.TRANS.ID.1 THEN
        Y.TXN.ID      =  Y.TRANS.ID.1[1,2]
        Y.TRANS.ID = Y.TRANS.ID.1
        GOSUB CHECK.FT.REC

        IF Y.TXN.ID EQ 'TT'  THEN
            Y.TRANS.ID = Y.TRANS.ID.1
            GOSUB CHECK.TT.REC
        END
        IF Y.TXN.ID EQ 'AA' THEN
            Y.TRANS.ID = Y.TRANS.ID.1
            GOSUB CHECK.AA.REC
        END
    END

RETURN

*-------------------------------------------------------------------------------------------------------------
CHECK.FT.REC:
*-------------------------------------------------------------------------------------------------------------
    IF Y.TXN.ID EQ 'FT'  THEN
        CALL F.READ(FN.FUNDS.TRANSFER,Y.TRANS.ID,R.FUNDS.TRANSFER.REC,F.FUNDS.TRANSFER,Y.FUNDS.ERR)

        IF R.FUNDS.TRANSFER.REC EQ '' THEN
            CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.TRANS.ID,R.FUNDS.TRANSFER.REC,ERR.HIS)
        END
        IF R.FUNDS.TRANSFER.REC THEN
            Y.AGENCY   = R.FUNDS.TRANSFER.REC<FT.CO.CODE>
            Y.TXN.USER1 = R.FUNDS.TRANSFER.REC<FT.INPUTTER>
            Y.TXN.USER = FIELD(Y.TXN.USER1,'_',2,1)
            Y.TRANSACTION.DATE = R.FUNDS.TRANSFER.REC<FT.PROCESSING.DATE>

            BEGIN CASE
                CASE SET.DATE EQ 'Y'
                    Y.TXN.VALUE.DATE = R.FUNDS.TRANSFER.REC<FT.CREDIT.VALUE.DATE>
                CASE SET.DATE EQ 'N'
                    Y.TXN.VALUE.DATE = R.FUNDS.TRANSFER.REC<FT.DEBIT.VALUE.DATE>
            END CASE
*  GOSUB FORM.STAT.LINE.PROCESS
            GOSUB FORM.FINAL.ARRAY
        END

    END

RETURN
*-------------------------------------------------------------------------------------------------------------
CHECK.TT.REC:
*-------------------------------------------------------------------------------------------------------------
    CALL F.READ(FN.TELLER,Y.TRANS.ID,R.TELLER.REC,F.TELLER,Y.TELLER.ERR)

    IF R.TELLER.REC EQ '' THEN
        CALL EB.READ.HISTORY.REC(F.TELLER.HIS,Y.TRANS.ID,R.TELLER.REC,ERR.HIS.TT)
    END
    IF R.TELLER.REC THEN
        Y.AGENCY    = R.TELLER.REC<TT.TE.CO.CODE>
        Y.TXN.USER1  = R.TELLER.REC<TT.TE.INPUTTER>
        Y.TXN.USER = FIELD(Y.TXN.USER1,'_',2,1)
        Y.TRANSACTION.DATE = R.TELLER.REC<TT.TE.AUTH.DATE>

        BEGIN CASE
            CASE SET.DATE EQ 'Y'
                Y.TXN.VALUE.DATE = R.TELLER.REC<TT.TE.VALUE.DATE.2>
            CASE SET.DATE EQ 'N'
                Y.TXN.VALUE.DATE = R.TELLER.REC<TT.TE.VALUE.DATE.2>
        END CASE

* GOSUB FORM.STAT.LINE.PROCESS
        GOSUB FORM.FINAL.ARRAY
    END

RETURN

*-------------------------------------------------------------------------------------------------------------
FORM.STAT.LINE.PROCESS:
*-------------------------------------------------------------------------------------------------------------
    IF Y.CATEG NE '' THEN
        Y.CURR.ACCT.NO = ''
        Y.CURR.ACCT.DESC= ''
        Y.SUPER.CUR.ACCT.NO= ''
        Y.RE.REQ.ASSET.VALUES = ''
        Y.RE.REQ.PROP.VAL = ''
        Y.RE.SEC.CATEG.ASSET.VAL = Y.CATEG:"*":Y.SECTOR:"*":Y.BAL.TYPE
        FINDSTR Y.RE.SEC.CATEG.ASSET.VAL IN Y.RE.STAT.REP.VAL.ARRAY SETTING Y.POS.VAL1, Y.POS.VAL2 THEN
            Y.RE.REQ.ASSET.VALUES = Y.RE.STAT.REP.VAL.ARRAY<Y.POS.VAL1,Y.POS.VAL2>
        END
        Y.RE.REQ.PROP.VAL = Y.RE.REQ.ASSET.VALUES['*',3,1]
        IF Y.BAL.TYPE EQ Y.RE.REQ.PROP.VAL THEN
            Y.CURR.ACCT.NO = Y.RE.REQ.ASSET.VALUES['*',4,1]
            Y.CURR.ACCT.DESC      = Y.RE.REQ.ASSET.VALUES['*',5,1]
            Y.SUPER.CUR.ACCT.NO = Y.RE.REQ.ASSET.VALUES['*',6,1]
        END
    END
RETURN
*-------------------------------------------------------------------------------------------------------------
FORM.FINAL.ARRAY:
*-------------------------------------------------------------------------------------------------------------
    IF Y.DEBIT NE '' OR Y.CREDIT NE '' THEN
        Y.LOAN.ARR<-1> = Y.SEL.LIST.ARRAY:"*":Y.AA.ID:"*":Y.PREV.LOAN.NO:"*":Y.PRODUCT.TYPE:"*":Y.AGENCY:"*":Y.TRANSACTION.DATE:"*"
*                                               1              2                     3              4             5
        Y.LOAN.ARR:= Y.TXN.VALUE.DATE:"*":Y.TXN.USER:"*":Y.TXN.CODE:"*":Y.TXN.DESC:"*":Y.DEBIT:"*":Y.CREDIT:"*"
*                         6                   7              8              9             10           11
        Y.LOAN.ARR:= Y.CONSOL.KEY:"*":Y.CURRENCY
*                        12                  13

    END
RETURN
*-------------------------------------------------------------------------------------------------------------
GOEND:
*-------------------------------------------------------------------------------------------------------------
END
*-----------------------------------*END OF SUBROUTINE*-------------------------------------------------------
