SUBROUTINE REDO.GAR.GEN.TAX.ENTRY
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PrabhuN
*Program   Name    :REDO.GEN.TAX.ENTRY
*---------------------------------------------------------------------------------
*date           who        ref
*25-09-2011     Prabhu    PACS00133294
*-----------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the tax amount and raise the entry(Based on N74)

*LINKED WITH       :
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TAX
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.CATEG.ENTRY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.COMPANY
    $INSERT I_F.TELLER
*   $INSERT I_F.TAX
    $INSERT I_F.USER
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_System
    $INSERT I_F.REDO.ADMIN.CHQ.PARAM
    $INSERT I_F.REDO.GAR.CREDIT.PROCESS
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

INIT:

    LOC.APPLICATION = 'FUNDS.TRANSFER'
    LOC.FIELDS = 'WAIVE.TAX':@VM:'L.FT.TAX.TYPE'
    LOC.POS    = ''
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    FT.WAIVE.TAX.POS = LOC.POS<1,1>
    FT.TAX.POS = LOC.POS<1,2>

RETURN

OPENFILE:
*Opening the Files

    FN.TAX = 'F.TAX'
    F.TAX  = ''
    CALL OPF(FN.TAX,F.TAX)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.COMMISSION.TYPE = ''
    R.COMMISSION.TYPE = ''
    CALL OPF(FN.COMMISSION.TYPE,F.COMMISSION.TYPE)

    FN.REDO.ADMIN.CHQ.PARAM = 'F.REDO.ADMIN.CHQ.PARAM'
    F.REDO.ADMIN.CHQ.PARAM = ''
    R.REDO.ADMIN.CHQ.PARAM = ''
    CALL OPF(FN.REDO.ADMIN.CHQ.PARAM,F.REDO.ADMIN.CHQ.PARAM)

    FN.REDO.GAR.CREDIT.PROCESS='F.REDO.GAR.CREDIT.PROCESS'
    F.REDO.GAR.CREDIT.PROCESS=''
    CALL OPF(FN.REDO.GAR.CREDIT.PROCESS,F.REDO.GAR.CREDIT.PROCESS)

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        GOSUB PROCESS.FT
    END

RETURN

PROCESS.FT:

    FT.DR.CURRENCY  = R.NEW(FT.DEBIT.CURRENCY)
    TRANS.DR.AMT    = R.NEW(FT.DEBIT.AMOUNT)
    VAL.DATE        = R.NEW(FT.DEBIT.VALUE.DATE)
    ACCOUNT.ID      = R.NEW(FT.DEBIT.ACCT.NO)
    FT.CR.CURRENCY  = R.NEW(FT.CREDIT.CURRENCY)
    TRANS.CR.AMT    = R.NEW(FT.CREDIT.AMOUNT)
    VAL.DATE        = R.NEW(FT.CREDIT.VALUE.DATE)
    Y.ACCOUNT       = R.NEW(FT.CREDIT.ACCT.NO)
    Y.COMM.TYPE     = R.NEW(FT.COMMISSION.TYPE)

    CALL CACHE.READ(FN.COMMISSION.TYPE, Y.COMM.TYPE, R.COMMISSION.TYPE, FT.COMM.ERR)
    TAXATION.CODE = R.NEW(FT.LOCAL.REF)<1,FT.TAX.POS>
    LOC.WAIVE.TAX = R.NEW(FT.LOCAL.REF)<1,FT.WAIVE.TAX.POS>
    CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    CUST.NO = R.ACCOUNT<AC.CUSTOMER>
    Y.PROD.CATEGORY = R.ACCOUNT<AC.CATEGORY>

RETURN


PROCESS:



    IF LOC.WAIVE.TAX EQ 'YES' THEN
        GOSUB PROCESS.DR.CATEG
        GOSUB NORNAL.ENTRY
        MULTI.STMT = ''
        GOSUB CAT.DEB.GEN
        GOSUB CAT.ENT.GEN
    END ELSE
        GOSUB NORNAL.ENTRY
        MULTI.STMT = ''
        GOSUB STMT.ENT.GEN
        GOSUB CAT.ENT.GEN
    END

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        CALL EB.ACCOUNTING('FT','SAO',MULTI.STMT,'')
    END
    Y.GAR.ID=System.getVariable('CURRENT.GAR.ID')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.GAR.ID = ""
    END

    CALL F.READ(FN.REDO.GAR.CREDIT.PROCESS,Y.GAR.ID,R.REDO.GAR.CREDIT.PROCESS,F.REDO.GAR.CREDIT.PROCESS,ERR)
    R.REDO.GAR.CREDIT.PROCESS<GAR.PRO.CHEQUE.PRINTED>='YES'

    CALL F.WRITE(FN.REDO.GAR.CREDIT.PROCESS,Y.GAR.ID,R.REDO.GAR.CREDIT.PROCESS)
RETURN

NORNAL.ENTRY:
    SEL.CMD = "SELECT ":FN.TAX:" WITH @ID LIKE ":TAXATION.CODE:"... BY-DSND @ID"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,RET.ERR)
    TAXATION.CODE = SEL.LIST<1>
    CALL CACHE.READ(FN.TAX, TAXATION.CODE, R.TAX, ERR.TAX)
    Y.DR.TAX.CODE = R.TAX<EB.TAX.TR.CODE.DR>
    Y.CR.TAX.CODE = R.TAX<EB.TAX.TR.CODE.CR>
    Y.TAX.CATEG   = R.TAX<EB.TAX.CATEGORY>
    Y.TAX.AMT=System.getVariable('CURRENT.GAR.TAX.AMT')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        Y.TAX.AMT = ""
    END
    R.NEW(FT.TAX.AMT) = FT.DR.CURRENCY:' ':Y.TAX.AMT

RETURN

****************
PROCESS.DR.CATEG:
****************
    CALL CACHE.READ(FN.REDO.ADMIN.CHQ.PARAM,'SYSTEM',R.REDO.ADMIN.CHQ.PARAM,ERR.PAR)

    Y.ALL.ITEM.CODES = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ITEM.CODE>

    LOCATE Y.ACCOUNT IN R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ACCOUNT,1> SETTING POS1 THEN
        Y.ITEM.CODE=R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.ITEM.CODE,POS1>
    END

    LOCATE Y.ITEM.CODE IN Y.ALL.ITEM.CODES<1,1> SETTING ITEM.POS THEN
        Y.PL.CATEG.DEBIT = R.REDO.ADMIN.CHQ.PARAM<ADMIN.CHQ.PARAM.CATEGORY,ITEM.POS>
    END
RETURN

******************
CAT.ENT.GEN:
******************

    R.STMT.ENT = ''
    ACCOUNT.NO = FT.DR.CURRENCY:Y.TAX.CATEG:"0001"

    R.STMT.ENT<AC.STE.ACCOUNT.NUMBER> =ACCOUNT.NO
    R.STMT.ENT<AC.STE.COMPANY.CODE>=ID.COMPANY

    IF FT.DR.CURRENCY EQ LCCY THEN
        R.STMT.ENT<AC.STE.AMOUNT.LCY> =  Y.TAX.AMT
    END ELSE
        R.STMT.ENT<AC.STE.AMOUNT.FCY> = Y.TAX.AMT
    END

    R.STMT.ENT<AC.STE.TRANSACTION.CODE> = Y.CR.TAX.CODE
    R.STMT.ENT<AC.STE.ACCOUNT.OFFICER> = '1'
    R.STMT.ENT<AC.STE.CUSTOMER.ID> = CUST.NO
    R.STMT.ENT<AC.STE.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.STMT.ENT<AC.STE.PRODUCT.CATEGORY> = Y.PROD.CATEGORY
    R.STMT.ENT<AC.STE.VALUE.DATE> = TODAY
    R.STMT.ENT<AC.STE.CURRENCY> = FT.DR.CURRENCY
    R.STMT.ENT<AC.STE.EXCHANGE.RATE> = ''
    R.STMT.ENT<AC.STE.CURRENCY.MARKET> = "1"
    R.STMT.ENT<AC.STE.TRANS.REFERENCE> = ID.NEW
    R.STMT.ENT<AC.STE.SYSTEM.ID> = "FT"
    R.STMT.ENT<AC.STE.BOOKING.DATE> = TODAY
    R.STMT.ENT<AC.STE.NARRATIVE> ='TAX ENTRY'

    MULTI.STMT<-1> = LOWER(R.STMT.ENT)

RETURN

****************
STMT.ENT.GEN:
****************
* STATEMENT ENTRY GENERATION
    R.ACC = ''
    NARRATIVE = 'APAP FT TAX'
    R.ACC<AC.STE.ACCOUNT.NUMBER>   = ACCOUNT.ID
    IF FT.DR.CURRENCY EQ LCCY THEN
        R.ACC<AC.STE.AMOUNT.LCY>   = -1 * Y.TAX.AMT
    END ELSE
        R.ACC<AC.STE.AMOUNT.FCY>   = -1 * Y.TAX.AMT
    END
    R.ACC<AC.STE.THEIR.REFERENCE>  = ID.NEW
    R.ACC<AC.STE.TRANSACTION.CODE> = Y.DR.TAX.CODE
    R.ACC<AC.STE.PL.CATEGORY>      = ''
    R.ACC<AC.STE.ACCOUNT.OFFICER>  = '1'
    R.ACC<AC.STE.VALUE.DATE>       = VAL.DATE
    R.ACC<AC.STE.CURRENCY>         = FT.DR.CURRENCY
    R.ACC<AC.STE.NARRATIVE>        = NARRATIVE
    IF CUST.NO THEN
        R.ACC<AC.STE.CUSTOMER.ID>  = CUST.NO
    END
    R.ACC<AC.STE.POSITION.TYPE>    = 'TR'
    R.ACC<AC.STE.OUR.REFERENCE>    = ID.NEW
    R.ACC<AC.STE.CURRENCY.MARKET>  = '1'
    R.ACC<AC.STE.TRANS.REFERENCE>  = ID.NEW
    R.ACC<AC.STE.BOOKING.DATE>     = TODAY
    R.ACC<AC.STE.COMPANY.CODE>     = ID.COMPANY
    MULTI.STMT<-1>                 = LOWER(R.ACC)
RETURN

******************
CAT.DEB.GEN:
******************

    R.STMT.ENT = ''
    ACCOUNT.NO = FT.DR.CURRENCY:Y.TAX.CATEG:"0001"

    R.STMT.ENT<AC.STE.ACCOUNT.NUMBER> =ACCOUNT.NO
    R.STMT.ENT<AC.STE.COMPANY.CODE>=ID.COMPANY

    IF FT.DR.CURRENCY EQ LCCY THEN
        R.STMT.ENT<AC.STE.AMOUNT.LCY> =  -1 * Y.TAX.AMT
    END ELSE
        R.STMT.ENT<AC.STE.AMOUNT.FCY> = -1 * Y.TAX.AMT
    END

    R.STMT.ENT<AC.STE.TRANSACTION.CODE> = Y.DR.TAX.CODE
    R.STMT.ENT<AC.STE.ACCOUNT.OFFICER> = '1'
    R.STMT.ENT<AC.STE.CUSTOMER.ID> = CUST.NO
    R.STMT.ENT<AC.STE.DEPARTMENT.CODE> = R.USER<EB.USE.DEPARTMENT.CODE>
    R.STMT.ENT<AC.STE.PRODUCT.CATEGORY> = Y.PROD.CATEGORY
    R.STMT.ENT<AC.STE.VALUE.DATE> = TODAY
    R.STMT.ENT<AC.STE.CURRENCY> = FT.DR.CURRENCY
    R.STMT.ENT<AC.STE.EXCHANGE.RATE> = ''
    R.STMT.ENT<AC.STE.CURRENCY.MARKET> = "1"
    R.STMT.ENT<AC.STE.TRANS.REFERENCE> = ID.NEW
    R.STMT.ENT<AC.STE.SYSTEM.ID> = "FT"
    R.STMT.ENT<AC.STE.BOOKING.DATE> = TODAY
    R.STMT.ENT<AC.STE.NARRATIVE> ='TAX ENTRY'

    MULTI.STMT<-1> = LOWER(R.STMT.ENT)

RETURN
END
