SUBROUTINE REDO.BUILD.ACCT.LAST.FIVE.TRANSFER(Y.FINAL.ARRAY)

*-------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.BUILD.TRANS.PERIOD
*-------------------------------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display From.date and Until.date
*In Parameter : N/A
*Out Parameter: O.DATA
*Linked File  : REDO.E.BUILD.TRANS.PERIOD
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*     Date            Who                              Reference               Description
*    ------          ------                            -----------             --------------
*  19-09-2011       PRABHUN             PACS00125978                MODIFICATION
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_System
    $INSERT I_F.AI.REDO.ARCIB.PARAMETER
    $INSERT I_F.ENQUIRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.CR.CONTACT.LOG
    $INSERT I_EB.EXTERNAL.COMMON
*---------------------------------------------------------------------------------------------------------

    GOSUB INITIALISE.GET.VALUES
    GOSUB PROCESS
    GOSUB SORT.DETAILS
RETURN

*----------------------------------------
INITIALISE.GET.VALUES:
*---------------------------------------

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY  = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.FUNDS.TRANSFER.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.FUNDS.TRANSFER.HIS  = ''
    CALL OPF(FN.FUNDS.TRANSFER.HIS,F.FUNDS.TRANSFER.HIS)

    FN.ARCIB.PARAM = 'F.AI.REDO.ARCIB.PARAMETER'
    F.ARCIB.PARAM = ''
    CALL OPF(FN.ARCIB.PARAM,F.ARCIB.PARAM)

    FN.ACCT.STMT.PRINT= 'F.ACCT.STMT.PRINT'
    F.ACCT.STMT.PRINT=''
    CALL OPF(FN.ACCT.STMT.PRINT,F.ACCT.STMT.PRINT)

    FN.STMT.PRINTED='F.STMT.PRINTED'
    F.STMT.PRINTED =''
    CALL OPF(FN.STMT.PRINTED,F.STMT.PRINTED)

    F.CUSTOMER.ACCOUNT = ''
    FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
    CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

    Y.SORT.ARR   = ''
    Y.SORT.COUNT = ''
    Y.SORT.START = ''
    Y.STMT.ID.LIST = ''
    Y.ARR = ''


    SYSTEM.ID = 'SYSTEM'
    TRANSFER.CODE = ''

    CALL CACHE.READ(FN.ARCIB.PARAM,SYSTEM.ID,R.ARCIB.PARAM,ARC.ERR)
    IF NOT(ARC.ERR) THEN
        AI.PARAM.PROD =R.ARCIB.PARAM<AI.PARAM.PRODUCT>
        AI.PARAM.TYPE=R.ARCIB.PARAM<AI.PARAM.TRANSACTION.TYPE>
    END
    GOSUB ARCIB.PARAM.TRAN.DETAILS

    DAYS = ''
    Y.BOOK.DATE.LEN = ''
    Y.FROM.DATE.VAL = ''
    Y.CURRENT.DAY = ''
    ST.RG.DATE=''
    END.RG.DATE=''
    END.TO.DATE=''
    Y.ID.LIST = ''
    START.FRM.DATE=''
    FLAG.ENQ = ''
    CR.DB.FLG=''
    CR.FLG=''
    DB.FLG=''
    Y.FINAL.ARRAY=''

RETURN
************************
ARCIB.PARAM.TRAN.DETAILS:
************************

    LOCATE 'STANDING.ORDER' IN AI.PARAM.PROD<1,1> SETTING AI.PARAM.PROD.POS THEN
        LOCATE 'OWN-TRANSFER' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            OWN.TRANSFER.CODE = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>

        END
        LOCATE 'APAP-TRANSFER' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            APAP.TRANSFER.CODE = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END

        LOCATE 'THIRD-TRANSFER' IN AI.PARAM.TYPE<1,1> SETTING AI.PARAM.TYPE.POS THEN
            OTHER.TRANSFER.CODE = R.ARCIB.PARAM<AI.PARAM.TRANSACTION.CODE,AI.PARAM.TYPE.POS>
        END
        Y.TRANSFER.CODES = OWN.TRANSFER.CODE:@FM:APAP.TRANSFER.CODE:@FM:OTHER.TRANSFER.CODE

    END

RETURN

*---------------------------------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------------------------------

    CUSTOMER.ID = System.getVariable('EXT.SMS.CUSTOMERS')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        CUSTOMER.ID = ""
    END

    CALL F.READ(FN.CUSTOMER.ACCOUNT,CUSTOMER.ID,R.ACCT.REC,F.CUSTOMER.ACCOUNT,CUST.ERR)
    LOOP
        REMOVE Y.ACCT.ID FROM R.ACCT.REC SETTING ACCT.POS
    WHILE Y.ACCT.ID:ACCT.POS
        GOSUB ACCT.STATEMENT.READING
    REPEAT
RETURN
***********************
ACCT.STATEMENT.READING:
***********************
    R.ACCT.STMT.PRINT.SIZE = ''
    R.ACCT.STMT.PRINT.LIST =''
    Y.CNT     = 0
    Y.MAX.CNT = 0

    CALL F.READ(FN.ACCT.STMT.PRINT,Y.ACCT.ID,R.ACCT.STMT.PRINT,F.ACCT.STMT.PRINT,ERR)
    Y.MAX.CNT=DCOUNT(R.ACCT.STMT.PRINT,@FM)
    Y.ACCT.STMT.POS = ''
    R.ACCT.STMT.PRINT.LIST = R.ACCT.STMT.PRINT
    GOSUB STMT.PRINTED.READING
RETURN
*********************
STMT.PRINTED.READING:
*********************
    Y.STMT.PRINTED.SIZE = ''
    Y.FIVE.STOP.FLAG = ''
    Y.TEMP.LIST = ''
    Y.CNT=0
    LOOP
    WHILE Y.MAX.CNT GT Y.CNT
        Y.STMT.PRINT.ID = R.ACCT.STMT.PRINT.LIST<Y.MAX.CNT>
        IF Y.STMT.PRINT.ID THEN
            Y.STMT.PRINT.ID = FIELD(Y.STMT.PRINT.ID,'/',1)
            Y.STMT.PRINT.ID=Y.ACCT.ID:'-':Y.STMT.PRINT.ID
            CALL F.READ(FN.STMT.PRINTED,Y.STMT.PRINT.ID,R.STMT.PRINTED,F.STMT.PRINTED,ERR)
            Y.STMT.PRINTED.SIZE=DCOUNT(R.STMT.PRINTED,@FM)
            GOSUB STMT.ENTRY.READING
            Y.STMT.PRINT.ID = ''
            IF Y.FIVE.STOP.FLAG THEN
                RETURN
            END
        END ELSE
            RETURN
        END
        Y.MAX.CNT -= 1
    REPEAT
RETURN
*******************
STMT.ENTRY.READING:
*******************
    Y.STMT.ENTRY.ID = ''
    Y.YEAR.PART = ''
    Y.TIME.PART=''
    Y.SORT.PART = ''
    LOOP
    WHILE Y.STMT.PRINTED.SIZE GT Y.CNT
        Y.CONTINUE = ''
        Y.STMT.ENTRY.ID = R.STMT.PRINTED<Y.STMT.PRINTED.SIZE>
        Y.YEAR.PART = Y.STMT.ENTRY.ID[1,5]
        Y.TIME.PART = Y.STMT.ENTRY.ID[11,5]
        Y.SORT.PART = Y.YEAR.PART:Y.TIME.PART
        CALL F.READ(FN.STMT.ENTRY,Y.STMT.ENTRY.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ENTRY.ERR)
        Y.STMT.FT.REF = R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
        Y.STMT.FT.REF = FIELD(Y.STMT.FT.REF,'\',1)
        Y.STE.AMOUNT.LCY  =  R.STMT.ENTRY<AC.STE.AMOUNT.LCY>
        CALL F.READ(FN.FUNDS.TRANSFER,Y.STMT.FT.REF,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
        Y.TXN.CODE =  R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
        Y.DEBIT.CURRENCY = R.FUNDS.TRANSFER<FT.DEBIT.CURRENCY>
        Y.DEBIT.ACCT.NO = R.FUNDS.TRANSFER<FT.DEBIT.ACCT.NO>
        IF NOT(Y.TXN.CODE) THEN
            CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.STMT.FT.REF,R.FUNDS.TRANSFER.HIS,FUNDS.TRANSFER.HIS.ERR)
            Y.TXN.CODE = R.FUNDS.TRANSFER.HIS<FT.TRANSACTION.TYPE>
            Y.DEBIT.CURRENCY = R.FUNDS.TRANSFER.HIS<FT.DEBIT.CURRENCY>
            Y.DEBIT.ACCT.NO  = R.FUNDS.TRANSFER.HIS<FT.DEBIT.ACCT.NO>
        END
        LOCATE Y.TXN.CODE IN Y.TRANSFER.CODES SETTING TXN.CODE.POS THEN
        END ELSE
            Y.CONTINUE = 1
        END

        IF NOT(Y.CONTINUE) AND Y.STE.AMOUNT.LCY LT 0 THEN
            Y.STMT.ID.LIST<-1> = Y.DEBIT.ACCT.NO:'*':Y.STMT.ENTRY.ID:'*':'0':'*':'':'*':'':'*':Y.STE.AMOUNT.LCY:'*':'':'*':'RD$':@FM:Y.SORT.PART
            Y.SORT.ARR<-1>     = Y.SORT.PART
            Y.TEMP.LIST<-1> = Y.STMT.ENTRY.ID
        END
        Y.COUNT.ID.LIST = DCOUNT(Y.TEMP.LIST,@FM)
        IF Y.COUNT.ID.LIST EQ 5 THEN
            Y.FIVE.STOP.FLAG = 1
            RETURN
        END
        Y.STMT.PRINTED.SIZE -= 1
    REPEAT
RETURN
*************
SORT.DETAILS:
*************

    Y.SORT.ARR = SORT(Y.SORT.ARR)
    Y.SORT.COUNT = DCOUNT(Y.SORT.ARR,@FM)
    Y.SORT.START = 1
    LOOP
    WHILE Y.SORT.START LE Y.SORT.COUNT
        Y.ARR.ID = Y.SORT.ARR<Y.SORT.COUNT>
        IF Y.ARR.ID THEN
            LOCATE Y.ARR.ID IN Y.STMT.ID.LIST SETTING Y.FM.POS THEN
                Y.DATA<-1> = Y.STMT.ID.LIST<Y.FM.POS-1>
                DEL Y.STMT.ID.LIST<Y.FM.POS>
                DEL Y.STMT.ID.LIST<Y.FM.POS-1>
            END
        END
        Y.SORT.COUNT -= 1
    REPEAT

    Y.FINAL.ARRAY = FIELD(Y.DATA,@FM,1,5)
RETURN
END
