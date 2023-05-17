SUBROUTINE REDO.APAP.AUTO.TRANS.DAYS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUTO.TRANS.DAY
*--------------------------------------------------------------------------------------------------------
*Description       : This is a auto new contenet routine, which populates the local reference field
*                    INTRANSIT DAYS with the no. of days defined in the TRANSACTION table
*Linked With       : Version CHEQUE.COLLECTION,LOANS
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : TELLER.TRANSACTION          As          I     Mode
*                    TRANSACTION                 As          I     Mode
*                    REDO.APAP.H.PARAMETER       As          I     Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date             Who                  Reference               Description
*   ------           -----               -------------            -------------
* 08 JUN 2010    Mohammed Anies K     ODR-2009-10-1678 B.10        Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.TRANSACTION
    $INSERT I_F.TRANSACTION
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.APAP.H.PARAMETER
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.TELLER.TRANSACTION = 'F.TELLER.TRANSACTION'
    F.TELLER.TRANSACTION  = ''
    CALL OPF(FN.TELLER.TRANSACTION,F.TELLER.TRANSACTION)

    FN.TRANSACTION = 'F.TRANSACTION'
    F.TRANSACTION  = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.REDO.APAP.H.PARAMETER = 'F.REDO.APAP.H.PARAMETER'
    F.REDO.APAP.H.PARAMETER  = ''
    CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section

    GOSUB GET.TRANSACTION.CODE
    GOSUB GET.TRANSIT.DAYS

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
GET.TRANSACTION.CODE:
*********************
*In this para of code transaction code is obtained from TELLER.TRANSACTION
    REDO.APAP.H.PARAMETER.ID = 'SYSTEM'
    GOSUB READ.REDO.APAP.H.PARAMETER

    TELLER.TRANSACTION.ID = R.REDO.APAP.H.PARAMETER<PARAM.EXT.TRANS.CODE>
    GOSUB READ.TELLER.TRANSACTION

    IF R.TELLER.TRANSACTION THEN
        TRANSACTION.ID = R.TELLER.TRANSACTION<TT.TR.TRANSACTION.CODE.2>
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
GET.TRANSIT.DAYS:
*****************
*In this para of code no of transit days are obtained from TRANSACTION table
    GOSUB READ.TRANSACTION

    IF NOT(R.TRANSACTION) THEN
        RETURN
    END

    TRANSIT.DAYS=R.TRANSACTION<AC.TRA.EXPOSURE.DATE>
    GOSUB FIND.MULTI.LOCAL.REF
    R.NEW(TT.TE.LOCAL.REF)<1,LOC.L.TT.TRANS.DAYS.POS>= TRANSIT.DAYS[2,2]

RETURN
*--------------------------------------------------------------------------------------------------------
**************************
READ.REDO.APAP.H.PARAMETER:
**************************
    R.REDO.APAP.H.PARAMETER   = ''
    REDO.APAP.H.PARAMETER.ERR = ''
    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,REDO.APAP.H.PARAMETER.ID,R.REDO.APAP.H.PARAMETER,REDO.APAP.H.PARAMETER.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
************************
READ.TELLER.TRANSACTION:
************************
    R.TELLER.TRANSACTION   = ''
    TELLER.TRANSACTION.ERR = ''
    CALL CACHE.READ(FN.TELLER.TRANSACTION, TELLER.TRANSACTION.ID, R.TELLER.TRANSACTION, TELLER.TRANSACTION.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
*****************
READ.TRANSACTION:
*****************
    R.TRANSACTION   = ''
    TRANSACTION.ERR = ''
    CALL CACHE.READ(FN.TRANSACTION, TRANSACTION.ID, R.TRANSACTION, TRANSACTION.ERR)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
*In this para of code, positions of local reference fields are obtained

    APPL.ARRAY = 'TELLER'
    FLD.ARRAY  = 'L.TT.TRANS.DAYS'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.TT.TRANS.DAYS.POS = FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END
