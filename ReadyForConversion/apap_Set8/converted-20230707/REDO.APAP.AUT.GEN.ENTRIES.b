SUBROUTINE REDO.APAP.AUT.GEN.ENTRIES
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.GEN.ENTRIES
*--------------------------------------------------------------------------------------------------------
*Description       : This is an AUTHORISATION routine, the routine is used to generate entries on admin cheques
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*                    REDO.ADMIN.CHQ.PARAM                As          I       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date              Who                  Reference                 Description
*   ------            -----               -------------              -------------
* 22 Dec 2010     Shiva Prasad Y       ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.USER
*--------------------------------------------------------------------------------------------------------
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
    FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM  = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

    FN.CATEG.INT.ACCT = 'F.CATEG.INT.ACCT'
    F.CATEG.INT.ACCT  = ''
    CALL OPF(FN.CATEG.INT.ACCT,F.CATEG.INT.ACCT)

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE  = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    Y.TXN.LIST = 'ADMCHQGOVWITTAX':@FM:'ADMCHQOTHERS'

    Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
    CHANGE @VM TO @FM IN Y.TXN.CODES

    Y.TXN.COUNT = DCOUNT(Y.TXN.CODES,@VM)
    Y.TXN.START = 1

    LOOP
    WHILE Y.TXN.START LE Y.TXN.COUNT
        LOCATE R.NEW(TFS.TRANSACTION)<1,Y.TXN.START> IN Y.TXN.LIST SETTING Y.TX.POS THEN
            GOSUB CHECK.WAIVE.CHARGE
        END
        Y.TXN.START += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
CHECK.WAIVE.CHARGE:
*******************
    IF R.NEW(TFS.WAIVE.CHARGE)<1,Y.TXN.START> ELSE
        RETURN
    END

    REDO.ADMIN.CHQ.PARAM.ID = 'SYSTEM'
    GOSUB READ.REDO.ADMIN.CHQ.PARAM

    Y.ACCT.LIST = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT>

    LOCATE R.NEW(TFS.SURROGATE.AC)<1,Y.TXN.START> IN Y.ACCT.LIST<1,1> SETTING Y.ACC.POS ELSE
        RETURN
    END

    CATEG.INT.ACCT.ID = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.CATEGORY,Y.ACC.POS>
    GOSUB READ.CATEG.INT.ACCT
    Y.INT.ACCOUNT = R.CATEG.INT.ACCT<1>

    IF NOT(Y.INT.ACCOUNT) THEN
        RETURN
    END
    GOSUB GET.AMOUNT

    IF R.NEW(TFS.WAIVE.CHARGE)<1,Y.TXN.START> EQ 'YES' THEN
        GOSUB RAISE.IA.IA.ENTRIES
    END ELSE
        GOSUB RAISE.CUS.IA.ENTRIES
    END
    Y.LOCAL.FIELDS = R.NEW(TFS.LOCAL.REF)
    Y.TYPE='SAO'
    CALL EB.ACCOUNTING.WRAPPER('CHQ',Y.TYPE,YENTRY.REC,'',EB.ACCT.ERR.MSG)
    R.NEW(TFS.LOCAL.REF) = Y.LOCAL.FIELDS

RETURN
*--------------------------------------------------------------------------------------------------------
***********
GET.AMOUNT:
***********
    FT.COMMISSION.TYPE.ID = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.TAX.KEY,Y.ACC.POS>
    GOSUB READ.FT.COMMISSION.TYPE
    Y.PERC = R.FT.COMMISSION.TYPE<FT4.PERCENTAGE,1>

    Y.AMT = (R.NEW(TFS.AMOUNT)<1,Y.TXN.START> * Y.PERC) / 100

RETURN
*--------------------------------------------------------------------------------------------------------
********************
RAISE.IA.IA.ENTRIES:
********************

    ACCOUNT.ID = Y.INT.ACCOUNT
    GOSUB READ.ACCOUNT

    ENTRY.REC=""
    ENTRY.REC<AC.STE.ACCOUNT.NUMBER>   = Y.INT.ACCOUNT
    ENTRY.REC<AC.STE.AMOUNT.LCY>       = -1 * Y.AMT
    ENTRY.REC<AC.STE.TRANSACTION.CODE> = 231
    ENTRY.REC<AC.STE.THEIR.REFERENCE>  = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.CUSTOMER.ID>      = R.ACCOUNT<AC.CUSTOMER>
    ENTRY.REC<AC.STE.ACCOUNT.OFFICER>  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    ENTRY.REC<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    ENTRY.REC<AC.STE.VALUE.DATE>       = TODAY
    ENTRY.REC<AC.STE.CURRENCY>         = R.ACCOUNT<AC.CURRENCY>
    ENTRY.REC<AC.STE.OUR.REFERENCE>    = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.EXPOSURE.DATE>    = TODAY
    ENTRY.REC<AC.STE.TRANS.REFERENCE>  = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.SYSTEM.ID>        = 'CHQ'
    ENTRY.REC<AC.STE.BOOKING.DATE>     = TODAY
    ENTRY.REC<AC.STE.COMPANY.CODE>     = ID.COMPANY
    ENTRY.REC<AC.STE.DEPARTMENT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
    ENTRY.REC<AC.STE.CURRENCY.MARKET>  = "1"

    YENTRY.REC<-1> = LOWER(ENTRY.REC)

    ENTRY.REC=""
    ENTRY.REC<AC.STE.ACCOUNT.NUMBER>   = Y.INT.ACCOUNT
    ENTRY.REC<AC.STE.AMOUNT.LCY>       = Y.AMT
    ENTRY.REC<AC.STE.TRANSACTION.CODE> = 231
    ENTRY.REC<AC.STE.THEIR.REFERENCE>  = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.CUSTOMER.ID>      = R.ACCOUNT<AC.CUSTOMER>
    ENTRY.REC<AC.STE.ACCOUNT.OFFICER>  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    ENTRY.REC<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    ENTRY.REC<AC.STE.VALUE.DATE>       = TODAY
    ENTRY.REC<AC.STE.CURRENCY>         = R.ACCOUNT<AC.CURRENCY>
    ENTRY.REC<AC.STE.OUR.REFERENCE>    = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.EXPOSURE.DATE>    = TODAY
    ENTRY.REC<AC.STE.TRANS.REFERENCE>  = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.SYSTEM.ID>        = 'CHQ'
    ENTRY.REC<AC.STE.BOOKING.DATE>     = TODAY
    ENTRY.REC<AC.STE.COMPANY.CODE>     = ID.COMPANY
    ENTRY.REC<AC.STE.DEPARTMENT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
    ENTRY.REC<AC.STE.CURRENCY.MARKET>  = "1"

    YENTRY.REC<-1> = LOWER(ENTRY.REC)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
RAISE.CUS.IA.ENTRIES:
*********************

    ACCOUNT.ID = Y.INT.ACCOUNT
    GOSUB READ.ACCOUNT

    ENTRY.REC=""
    ENTRY.REC<AC.STE.ACCOUNT.NUMBER>   = Y.INT.ACCOUNT
    ENTRY.REC<AC.STE.AMOUNT.LCY>       = Y.AMT
    ENTRY.REC<AC.STE.TRANSACTION.CODE> = 231
    ENTRY.REC<AC.STE.THEIR.REFERENCE>  = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.CUSTOMER.ID>      = R.ACCOUNT<AC.CUSTOMER>
    ENTRY.REC<AC.STE.ACCOUNT.OFFICER>  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    ENTRY.REC<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    ENTRY.REC<AC.STE.VALUE.DATE>       = TODAY
    ENTRY.REC<AC.STE.CURRENCY>         = R.ACCOUNT<AC.CURRENCY>
    ENTRY.REC<AC.STE.OUR.REFERENCE>    = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.EXPOSURE.DATE>    = TODAY
    ENTRY.REC<AC.STE.TRANS.REFERENCE>  = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.SYSTEM.ID>        = 'CHQ'
    ENTRY.REC<AC.STE.BOOKING.DATE>     = TODAY
    ENTRY.REC<AC.STE.COMPANY.CODE>     = ID.COMPANY
    ENTRY.REC<AC.STE.DEPARTMENT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
    ENTRY.REC<AC.STE.CURRENCY.MARKET>  = "1"

    YENTRY.REC<-1> = LOWER(ENTRY.REC)

    ACCOUNT.ID = R.NEW(TFS.PRIMARY.ACCOUNT)
    GOSUB READ.ACCOUNT

    ENTRY.REC=""
    ENTRY.REC<AC.STE.ACCOUNT.NUMBER>   = ACCOUNT.ID
    ENTRY.REC<AC.STE.AMOUNT.LCY>       = -1 * Y.AMT
    ENTRY.REC<AC.STE.TRANSACTION.CODE> = 231
    ENTRY.REC<AC.STE.THEIR.REFERENCE>  = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.CUSTOMER.ID>      = R.ACCOUNT<AC.CUSTOMER>
    ENTRY.REC<AC.STE.ACCOUNT.OFFICER>  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
    ENTRY.REC<AC.STE.PRODUCT.CATEGORY> = R.ACCOUNT<AC.CATEGORY>
    ENTRY.REC<AC.STE.VALUE.DATE>       = TODAY
    ENTRY.REC<AC.STE.CURRENCY>         = R.ACCOUNT<AC.CURRENCY>
    ENTRY.REC<AC.STE.OUR.REFERENCE>    = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.EXPOSURE.DATE>    = TODAY
    ENTRY.REC<AC.STE.TRANS.REFERENCE>  = R.NEW(TFS.UNDERLYING)<1,Y.TXN.START>
    ENTRY.REC<AC.STE.SYSTEM.ID>        = 'CHQ'
    ENTRY.REC<AC.STE.BOOKING.DATE>     = TODAY
    ENTRY.REC<AC.STE.COMPANY.CODE>     = ID.COMPANY
    ENTRY.REC<AC.STE.DEPARTMENT.CODE>  = R.USER<EB.USE.DEPARTMENT.CODE>
    ENTRY.REC<AC.STE.CURRENCY.MARKET>  = "1"

    YENTRY.REC<-1> = LOWER(ENTRY.REC)

RETURN
*--------------------------------------------------------------------------------------------------------
**************************
READ.REDO.ADMIN.CHQ.PARAM:
**************************
* In this para of the code, file REDO.ADMIN.CHQ.PARAM is read
    R.REDO.ADMIN.CHQ.PARAM  = ''
    REDO.ADMIN.CHQ.PARAM.ER = ''
*  CALL F.READ(FN.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ID,R.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ER) ;*Tus Start
    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ID,R.REDO.ADMIN.CHQ.PARAM,REDO.ADMIN.CHQ.PARAM.ER) ; * Tus End

RETURN
*--------------------------------------------------------------------------------------------------------
********************
READ.CATEG.INT.ACCT:
********************
* In this para of the code, file CATEG.INT.ACCT is read
    R.CATEG.INT.ACCT  = ''
    CATEG.INT.ACCT.ER = ''
    CALL CACHE.READ(FN.CATEG.INT.ACCT, CATEG.INT.ACCT.ID, R.CATEG.INT.ACCT, CATEG.INT.ACCT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
************************
READ.FT.COMMISSION.TYPE:
************************
* In this para of the code, file FT.COMMISSION.TYPE is read
    R.FT.COMMISSION.TYPE  = ''
    FT.COMMISSION.TYPE.ER = ''
    CALL CACHE.READ(FN.FT.COMMISSION.TYPE, FT.COMMISSION.TYPE.ID, R.FT.COMMISSION.TYPE, FT.COMMISSION.TYPE.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
READ.ACCOUNT:
*************
* In this para of the code, file ACCOUNT is read
    R.ACCOUNT  = ''
    ACCOUNT.ER = ''
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
