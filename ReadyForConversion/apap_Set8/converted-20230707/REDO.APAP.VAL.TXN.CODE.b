SUBROUTINE REDO.APAP.VAL.TXN.CODE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.TXN.CODE
*--------------------------------------------------------------------------------------------------------
*Description       : This is a VALIDATION routine, attached to the field TRANSACTION, the routine
*                    populates the credit account based on the transaction code
*Linked With       : Version T24.FUND.SERVICES,REDO.MULTI.TXN
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : T24.FUND.SERVICES                   As          I       Mode
*                    CATEG.INT.ACCT                      As          I       Mode
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
    $INSERT I_F.REDO.TFS.TRANSACTION.DETAILS
    $INSERT I_F.T24.FUND.SERVICES
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of the code, file variables are initialised and opened

    FN.CATEG.INT.ACCT = 'F.CATEG.INT.ACCT'
    F.CATEG.INT.ACCT  = ''
    CALL OPF(FN.CATEG.INT.ACCT,F.CATEG.INT.ACCT)

    FN.REDO.TFS.TRANSACTION.DETAILS = 'F.REDO.TFS.TRANSACTION.DETAILS'
    F.REDO.TFS.TRANSACTION.DETAILS  = ''
    CALL OPF(FN.REDO.TFS.TRANSACTION.DETAILS,F.REDO.TFS.TRANSACTION.DETAILS)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para
    GOSUB DEFAULT.PAY.METHOD
    GOSUB GET.ADMIN.CHEQUE.DETAILS
    GOSUB GET.BILL.PAYMENT.DETAILS

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
DEFAULT.PAY.METHOD:
*******************
    IF COMI EQ 'BILLPAYMENTCASH' THEN
        R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.O.PAY.MT.POS> = 'Cash'
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
GET.ADMIN.CHEQUE.DETAILS:
*************************
    Y.WAIVE = ''
    BEGIN CASE

        CASE COMI EQ 'ADMCHQGOVWITTAX'
            Y.WAIVE = 1
            CATEG.INT.ACCT.ID = 15006
            GOSUB GET.CR.ACCOUNT

        CASE COMI EQ 'ADMCHQGOVWOTAX'
            CATEG.INT.ACCT.ID = 15006
            GOSUB GET.CR.ACCOUNT

        CASE COMI EQ 'ADMCHQOTHERS'
            Y.WAIVE = 1
            CATEG.INT.ACCT.ID = 15005
            GOSUB GET.CR.ACCOUNT

    END CASE

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
GET.BILL.PAYMENT.DETAILS:
*************************
    REDO.TFS.TRANSACTION.DETAILS.ID = 'SYSTEM'
    GOSUB READ.REDO.TFS.TRANSACTION.DETAILS

    IF NOT(R.REDO.TFS.TRANSACTION.DETAILS) THEN
        RETURN
    END

    Y.TXN.CODES = R.REDO.TFS.TRANSACTION.DETAILS<TFS.TXN.DET.TFS.TRANSACTION>

    LOCATE COMI IN Y.TXN.CODES<1,1> SETTING Y.TXN.POS THEN
        R.NEW(TFS.PRIMARY.ACCOUNT) = R.REDO.TFS.TRANSACTION.DETAILS<TFS.TXN.DET.TFS.DR.ACCT.NO,Y.TXN.POS>
        R.NEW(TFS.SURROGATE.AC)    = R.REDO.TFS.TRANSACTION.DETAILS<TFS.TXN.DET.TFS.CR.ACCT.NO,Y.TXN.POS>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
***************
GET.CR.ACCOUNT:
***************
* In this para of the code, the categ in account is defaulted to the field SURROFATE.AC
    GOSUB READ.CATEG.INT.ACCT
    R.NEW(TFS.SURROGATE.AC)<1,AV> = R.CATEG.INT.ACCT<1>

    IF Y.WAIVE THEN
        R.NEW(TFS.WAIVE.CHARGE)<1,AV> = 'NO'
    END

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
**********************************
READ.REDO.TFS.TRANSACTION.DETAILS:
**********************************
* In this para of the code, file REDO.TFS.TRANSACTION.DETAILS is read
    R.REDO.TFS.TRANSACTION.DETAILS  = ''
    REDO.TFS.TRANSACTION.DETAILS.ER = ''

*  CALL F.READ(FN.REDO.TFS.TRANSACTION.DETAILS,REDO.TFS.TRANSACTION.DETAILS.ID,R.REDO.TFS.TRANSACTION.DETAILS,F.REDO.TFS.TRANSACTION.DETAILS,REDO.TFS.TRANSACTION.DETAILS.ER) ;*Tus Start
    CALL CACHE.READ(FN.REDO.TFS.TRANSACTION.DETAILS,REDO.TFS.TRANSACTION.DETAILS.ID,R.REDO.TFS.TRANSACTION.DETAILS,REDO.TFS.TRANSACTION.DETAILS.ER) ; * Tus End

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained
    APPL.ARRAY = 'T24.FUND.SERVICES'
    FLD.ARRAY  = 'L.TFS.O.PAY.MT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TFS.O.PAY.MT.POS  =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END
