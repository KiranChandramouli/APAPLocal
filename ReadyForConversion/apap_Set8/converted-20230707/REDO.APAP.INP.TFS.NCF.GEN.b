SUBROUTINE REDO.APAP.INP.TFS.NCF.GEN
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.INP.TFS.CASH.DENOM
*--------------------------------------------------------------------------------------------------------
*Description       : This is an INPUT routine, the routine validates if the amount and the denominations
*                    amount is equal or not and throw an override accordingly
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                      As          I         Mode
*                    ACCOUNT                                As          I         Mode
*                    REDO.L.NCF.STOCK                       As          I-O       Mode
*                    REDO.L.NCF.UNMAPPED                    As          I-O       Mode
*                    REDO.NCF.ISSUED                        As          I-O       Mode
*                    REDO.L.NCF.STATUS                      As          I-O       Mode
*                    MAIL.BP                                As          I-O       Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 19 July 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.L.NCF.STOCK
    $INSERT I_F.REDO.L.NCF.UNMAPPED
    $INSERT I_F.REDO.NCF.ISSUED
    $INSERT I_F.REDO.L.NCF.STATUS
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts

    GOSUB OPEN.PARA

    GOSUB CHECK.PRELIM.CONDITIONS
    IF PROCESS.GOAHEAD THEN
        GOSUB PROCESS.PARA
    END


RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.L.NCF.STOCK = 'F.REDO.L.NCF.STOCK'
    F.REDO.L.NCF.STOCK  = ''
    CALL OPF(FN.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK)

    FN.REDO.L.NCF.UNMAPPED = 'F.REDO.L.NCF.UNMAPPED'
    F.REDO.L.NCF.UNMAPPED  = ''
    CALL OPF(FN.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED)

    FN.REDO.NCF.ISSUED = 'F.REDO.NCF.ISSUED'
    F.REDO.NCF.ISSUED  = ''
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)

    FN.REDO.L.NCF.STATUS = 'F.REDO.L.NCF.STATUS'
    F.REDO.L.NCF.STATUS  = ''
    CALL OPF(FN.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS)

    FN.MAIL.BP = 'MAIL.BP'
    F.MAIL.BP  = ''
    CALL OPF(FN.MAIL.BP,F.MAIL.BP)

    PROCESS.GOAHEAD = 1

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB GET.STOCK.DETAILS
    GOSUB CHECK.TFS.TXN.CODE

RETURN
*--------------------------------------------------------------------------------------------------------
******************
GET.STOCK.DETAILS:
******************
    REDO.L.NCF.STOCK.ID = 'SYSTEM'

    GOSUB READ.REDO.L.NCF.STOCK
    IF NOT(R.REDO.L.NCF.STOCK) THEN
        RETURN
    END

    Y.FROM.MAIL = R.REDO.L.NCF.STOCK<ST.L.FROM.EMAIL.ID>
    Y.TO.MAIL   = R.REDO.L.NCF.STOCK<ST.L.TO.EMAIL.ID>
    Y.SUBJ.MAIL = R.REDO.L.NCF.STOCK<ST.L.SUBJECT.MAIL>
    Y.MSG.MAIL  = R.REDO.L.NCF.STOCK<ST.L.MESSAGE.MAIL>

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
CHECK.TFS.TXN.CODE:
*******************
    Y.TFS.CODES  = 'ADMCHQGOVWITTAX' :@FM: 'ADMCHQGOVWOTAX'  :@FM: 'ADMCHQOTHERS'

    Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
    Y.TXN.COUNT = DCOUNT(Y.TXN.CODES,@VM)

    Y.COUNT = 1

    LOOP
    WHILE Y.COUNT LE Y.TXN.COUNT
        LOCATE Y.TXN.CODES<1,Y.COUNT> IN Y.TFS.CODES SETTING Y.POS  THEN
            Y.TXN.POS = Y.COUNT
            GOSUB TFS.PROCESS
        END
        Y.COUNT += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
************
TFS.PROCESS:
************
    Y.CHG.AMT     = R.NEW(TFS.CHG.AMT)<1,Y.COUNT>
    Y.CHG.AMT.LCY = R.NEW(TFS.CHG.AMT.LCY)<1,Y.COUNT>

    IF Y.CHG.AMT THEN
        Y.TOT.CHG.AMT = Y.CHG.AMT
    END

    IF Y.CHG.AMT.LCY THEN
        Y.TOT.CHG.AMT = Y.CHG.AMT.LCY
    END

    IF NOT(Y.TOT.CHG.AMT) THEN
        RETURN
    END

    GOSUB FIND.MULTI.LOCAL.REF

    IF R.NEW(TFS.LOCAL.REF)<1,LOC.L.NCF.REQUIRED.POS> EQ 'YES' THEN
        GOSUB CHECK.UPD.STOCK.GEN.NCF
    END ELSE
        GOSUB UPDATE.UNMAPPED.TABLE
    END

    IF R.REDO.L.NCF.STOCK<ST.QTY.AVAIL.ORG> LT R.REDO.L.NCF.STOCK<ST.L.MIN.NCF.ORG> THEN
        GOSUB RAISE.MAIL.ALERT
    END

RETURN
*--------------------------------------------------------------------------------------------------------
************************
CHECK.UPD.STOCK.GEN.NCF:
************************
    IF R.REDO.L.NCF.STOCK<ST.QTY.AVAIL.ORG> LE 0 THEN
        GOSUB UPDATE.UNMAPPED.TABLE
        RETURN
    END

    Y.SERIES   = R.REDO.L.NCF.STOCK<ST.SERIES>
    Y.BUSI.DIV = R.REDO.L.NCF.STOCK<ST.BUSINESS.DIV>
    Y.PECF     = R.REDO.L.NCF.STOCK<ST.PECF>
    Y.AICF     = R.REDO.L.NCF.STOCK<ST.AICF>
    Y.TCF      = R.REDO.L.NCF.STOCK<ST.TCF>
    Y.SEQ.NO   = FMT(R.REDO.L.NCF.STOCK<ST.SEQUENCE.NO>,'8"0"R')

    Y.NCF.NUMBER = Y.SERIES:Y.BUSI.DIV:Y.PECF:Y.AICF:Y.TCF:Y.SEQ.NO
    R.NEW(TFS.LOCAL.REF)<1,LOC.L.NCF.NUMBER.POS> = Y.NCF.NUMBER

    GOSUB UPDATE.STATUS.ORG.FLD
    GOSUB UPDATE.STOCK.TABLE
    GOSUB UPDATE.ISSUED.TABLE

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
UPDATE.STATUS.ORG.FLD:
**********************
    Y.QTY.AVAIL  = R.REDO.L.NCF.STOCK<ST.QTY.AVAIL.ORG> - 1
    Y.NCF.ISSUED = R.REDO.L.NCF.STOCK<ST.NCF.ISSUED.ORG> + 1

    IF Y.QTY.AVAIL GT R.REDO.L.NCF.STOCK<ST.L.MIN.NCF.ORG> THEN
        R.REDO.L.NCF.STOCK<ST.NCF.STATUS.ORG> = 'AVAILABLE'
    END ELSE
        R.REDO.L.NCF.STOCK<ST.NCF.STATUS.ORG> = 'UNAVAILABLE'
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
UPDATE.STOCK.TABLE:
*******************
    VAR.PREV.RANGE=R.REDO.L.NCF.STOCK<ST.PRE.ED.RG.OR>
    VAR.PREV.RANGE=VAR.PREV.RANGE<1,DCOUNT(VAR.PREV.RANGE,@VM)>

    IF Y.SEQ.NO EQ VAR.PREV.RANGE THEN
        Y.SEQ.NO = R.REDO.L.NCF.STOCK<ST.L.STRT.RNGE.ORG>
    END ELSE
        Y.SEQ.NO += 1
    END

    Y.SEQ.NO = FMT(Y.SEQ.NO,'8"0"R')

    R.REDO.L.NCF.STOCK<ST.SEQUENCE.NO> = Y.SEQ.NO
    R.REDO.L.NCF.STOCK<ST.QTY.AVAIL.ORG> = Y.QTY.AVAIL
    R.REDO.L.NCF.STOCK<ST.NCF.ISSUED.ORG> = Y.NCF.ISSUED

    GOSUB WRITE.REDO.L.NCF.STOCK

RETURN
*--------------------------------------------------------------------------------------------------------
********************
UPDATE.ISSUED.TABLE:
********************
    Y.TXN.DATE = R.NEW(TFS.DATE.TIME)
    Y.DATE     = 20:Y.TXN.DATE[1,6]

    ACCOUNT.ID = R.NEW(TFS.PRIMARY.ACCOUNT)
    GOSUB READ.ACCOUNT

    REDO.NCF.ISSUED.ID = R.ACCOUNT<AC.CUSTOMER>:'.':Y.DATE:'.':ID.NEW
    GOSUB READ.REDO.NCF.ISSUED

    R.REDO.NCF.ISSUED<ST.IS.TXN.ID>        = ID.NEW
    R.REDO.NCF.ISSUED<ST.IS.CHARGE.AMOUNT> = Y.TOT.CHG.AMT
    R.REDO.NCF.ISSUED<ST.IS.DATE>          = Y.DATE
    R.REDO.NCF.ISSUED<ST.IS.NCF>           = Y.NCF.NUMBER
    R.REDO.NCF.ISSUED<ST.IS.CUSTOMER>      = R.ACCOUNT<AC.CUSTOMER>
    R.REDO.NCF.ISSUED<ST.IS.MODIFIED.NCF>  = Y.NCF.NUMBER

    GOSUB WRITE.REDO.NCF.ISSUED

    REDO.L.NCF.STATUS.ID = REDO.NCF.ISSUED.ID
    Y.FLAG.TABLE = 1

    GOSUB UPDATE.STATUS.TABLE

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
UPDATE.UNMAPPED.TABLE:
**********************
    Y.TXN.DATE = R.NEW(TFS.DATE.TIME)
    Y.DATE     = 20:Y.TXN.DATE[1,6]

    ACCOUNT.ID = R.NEW(TFS.PRIMARY.ACCOUNT)
    GOSUB READ.ACCOUNT

    REDO.L.NCF.UNMAPPED.ID = R.ACCOUNT<AC.CUSTOMER>:'.':Y.DATE:'.':ID.NEW
    GOSUB READ.REDO.L.NCF.UNMAPPED

    R.REDO.L.NCF.UNMAPPED<ST.UN.TXN.ID>        = ID.NEW
    R.REDO.L.NCF.UNMAPPED<ST.UN.CHARGE.AMOUNT> = Y.TOT.CHG.AMT
    R.REDO.L.NCF.UNMAPPED<ST.UN.DATE>          = Y.DATE
    R.REDO.L.NCF.UNMAPPED<ST.UN.BATCH>         = 'NO'

    GOSUB WRITE.REDO.L.NCF.UNMAPPED

    REDO.L.NCF.STATUS.ID = REDO.L.NCF.UNMAPPED.ID
    Y.FLAG.TABLE = 2

    GOSUB UPDATE.STATUS.TABLE

RETURN
*--------------------------------------------------------------------------------------------------------
********************
UPDATE.STATUS.TABLE:
********************

    GOSUB READ.REDO.L.NCF.STATUS

    R.REDO.L.NCF.STATUS<NCF.ST.TRANSACTION.ID> = ID.NEW
    R.REDO.L.NCF.STATUS<NCF.ST.CUSTOMER.ID>    = R.ACCOUNT<AC.CUSTOMER>
    R.REDO.L.NCF.STATUS<NCF.ST.DATE>           = Y.DATE
    R.REDO.L.NCF.STATUS<NCF.ST.CHARGE.AMOUNT>  = Y.TOT.CHG.AMT

    IF Y.FLAG.TABLE EQ 1 THEN
        R.REDO.L.NCF.STATUS<NCF.ST.NCF>    = Y.NCF.NUMBER
        R.REDO.L.NCF.STATUS<NCF.ST.STATUS> = 'AVAILABLE'
    END ELSE
        R.REDO.L.NCF.STATUS<NCF.ST.NCF>    = ''
        R.REDO.L.NCF.STATUS<NCF.ST.STATUS> = 'UNAVAILABLE'
    END

    GOSUB WRITE.REDO.L.NCF.STATUS

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
RAISE.MAIL.ALERT:
*****************
    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    MAIL.BP.ID = 'APAP':UNIQUE.TIME:'.txt'

    R.MAIL.BP = Y.FROM.MAIL:'#':Y.TO.MAIL:'#':Y.SUBJ.MAIL:'#':Y.MSG.MAIL
    GOSUB WRITE.MAIL.BP

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
READ.REDO.L.NCF.STOCK:
**********************
* In this para of the code, file REDO.L.NCF.STOCK is read
    R.REDO.L.NCF.STOCK  = ''
    REDO.L.NCF.STOCK.ER = ''
*  CALL F.READ(FN.REDO.L.NCF.STOCK,REDO.L.NCF.STOCK.ID,R.REDO.L.NCF.STOCK,F.REDO.L.NCF.STOCK,REDO.L.NCF.STOCK.ER) ;*Tus Start
    CALL CACHE.READ(FN.REDO.L.NCF.STOCK,REDO.L.NCF.STOCK.ID,R.REDO.L.NCF.STOCK,REDO.L.NCF.STOCK.ER) ; * Tus End

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
*********************
READ.REDO.NCF.ISSUED:
*********************
* In this para of the code, file REDO.NCF.ISSUED is read
    R.REDO.NCF.ISSUED  = ''
    REDO.NCF.ISSUED.ER = ''
    CALL F.READ(FN.REDO.NCF.ISSUED,REDO.NCF.ISSUED.ID,R.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED,REDO.NCF.ISSUED.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
READ.REDO.L.NCF.UNMAPPED:
*************************
* In this para of the code, file REDO.L.NCF.UNMAPPED is read
    R.REDO.L.NCF.UNMAPPED  = ''
    REDO.L.NCF.UNMAPPED.ER = ''
    CALL F.READ(FN.REDO.L.NCF.UNMAPPED,REDO.L.NCF.UNMAPPED.ID,R.REDO.L.NCF.UNMAPPED,F.REDO.L.NCF.UNMAPPED,REDO.L.NCF.UNMAPPED.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
READ.REDO.L.NCF.STATUS:
***********************
* In this para of the code, file REDO.L.NCF.STATUS is read
    R.REDO.L.NCF.STATUS  = ''
    REDO.L.NCF.STATUS.ER = ''
    CALL F.READ(FN.REDO.L.NCF.STATUS,REDO.L.NCF.STATUS.ID,R.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS,REDO.L.NCF.STATUS.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
***********************
WRITE.REDO.L.NCF.STOCK:
***********************
* In this para of the code, values are written to file REDO.L.NCF.STOCK
    CALL F.WRITE(FN.REDO.L.NCF.STOCK,REDO.L.NCF.STOCK.ID,R.REDO.L.NCF.STOCK)

RETURN
*--------------------------------------------------------------------------------------------------------
**********************
WRITE.REDO.NCF.ISSUED:
**********************
* In this para of the code, values are written to file REDO.NCF.ISSUED
    CALL F.WRITE(FN.REDO.NCF.ISSUED,REDO.NCF.ISSUED.ID,R.REDO.NCF.ISSUED)

RETURN
*--------------------------------------------------------------------------------------------------------
**************************
WRITE.REDO.L.NCF.UNMAPPED:
**************************
* In this para of the code, values are written to file REDO.L.NCF.UNMAPPED
    CALL F.WRITE(FN.REDO.L.NCF.UNMAPPED,REDO.L.NCF.UNMAPPED.ID,R.REDO.L.NCF.UNMAPPED)

RETURN
*--------------------------------------------------------------------------------------------------------
************************
WRITE.REDO.L.NCF.STATUS:
************************
* In this para of the code, values are written to file REDO.L.NCF.STATUS
    CALL F.WRITE(FN.REDO.L.NCF.STATUS,REDO.L.NCF.STATUS.ID,R.REDO.L.NCF.STATUS)

RETURN
*--------------------------------------------------------------------------------------------------------
**************
WRITE.MAIL.BP:
**************
* In this para of the code, values are written to file MAIL.BP
    CALL F.WRITE(FN.MAIL.BP,MAIL.BP.ID,R.MAIL.BP)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'T24.FUND.SERVICES'
    FLD.ARRAY  = 'L.NCF.REQUIRED':@VM:'L.NCF.NUMBER'
    FLD.POS    = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.NCF.REQUIRED.POS =  FLD.POS<1,1>
    LOC.L.NCF.NUMBER.POS   = FLD.POS<1,2>

RETURN
************************
CHECK.PRELIM.CONDITIONS:
************************

    VAL.STATUS=R.NEW(TFS.RECORD.STATUS)

    IF VAL.STATUS[1,1] EQ 'R' THEN
        PROCESS.GOAHEAD = ""
    END
RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of Program
