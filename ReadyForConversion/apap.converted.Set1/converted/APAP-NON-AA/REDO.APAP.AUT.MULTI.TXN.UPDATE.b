SUBROUTINE REDO.APAP.AUT.MULTI.TXN.UPDATE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.MULTI.TXN.UPDATE
*--------------------------------------------------------------------------------------------------------
*Description       : This is an AUTHORISATION routine, which updates  table REDO.MULTI.TRANSACTION.DETAIL
*                    with details like account number, transaction date and amount with @ID as transaction ID
*Linked With       : Version TELLER,REDO.LCY.CASHIN and TELLER,REDO.CHQ.CLG
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : TELLER                              As          I       Mode
*                    TFS.PARAMETER                       As          I       Mode
*                    REDO.MULTI.TRANSACTION.DETAIL       As          I-o     Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                 Description
*   ------             -----               -------------              -------------
* 13 July 2010     Shiva Prasad Y      ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TFS.PARAMETER
    $INSERT I_F.REDO.MULTI.TRANSACTION.DETAIL
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

    FN.TFS.PARAMETER = 'F.TFS.PARAMETER'
    F.TFS.PARAMETER  = ''
    CALL OPF(FN.TFS.PARAMETER,F.TFS.PARAMETER)

    FN.REDO.MULTI.TRANSACTION.DETAIL = 'F.REDO.MULTI.TRANSACTION.DETAIL'
    F.REDO.MULTI.TRANSACTION.DETAIL  = ''
    CALL OPF(FN.REDO.MULTI.TRANSACTION.DETAIL,F.REDO.MULTI.TRANSACTION.DETAIL)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

    GOSUB FIND.MULTI.LOCAL.REF
    GOSUB CHECK.PRIMARY.ACC

RETURN
*--------------------------------------------------------------------------------------------------------
******************
CHECK.PRIMARY.ACC:
******************
* In this para of the code, the account is checked if its branch account or not


    Y.BRANCH.ACCT = R.NEW(TT.TE.ACCOUNT.2)

    TFS.PARAMETER.ID = ID.COMPANY
    GOSUB READ.TFS.PARAMETER

    Y.BRANCH.ACCT.LIST = R.TFS.PARAMETER<TFS.PAR.LOCAL.REF><1,LOC.L.TFS.BRCH.ACCT.POS>

    LOCATE Y.BRANCH.ACCT IN Y.BRANCH.ACCT.LIST<1,1,1> SETTING Y.POS THEN
        GOSUB UPDATE.MULTI.TXN.DETAILS
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
UPDATE.MULTI.TXN.DETAILS:
*************************
* In this para of the code, the details are written on to the local file REDO.MULTI.TRANSACTION.DETAIL
    REDO.MULTI.TXN.DETAIL.ID = ID.NEW
    GOSUB READ.REDO.MULTI.TRANSACTION.DETAIL
    R.REDO.MULTI.TRANSACTION.DETAIL<MUL.TXN.ACCT.NUMBER> = R.NEW(TT.TE.ACCOUNT.2)
    R.REDO.MULTI.TRANSACTION.DETAIL<MUL.TXN.TXN.DATE>    = R.NEW(TT.TE.VALUE.DATE.2)
    R.REDO.MULTI.TRANSACTION.DETAIL<MUL.TXN.TXN.AMOUNT>  = R.NEW(TT.TE.AMOUNT.LOCAL.1)

    GOSUB WRITE.REDO.MULTI.TRANSACTION.DETAIL

RETURN
*--------------------------------------------------------------------------------------------------------
*******************
READ.TFS.PARAMETER:
*******************
* In this para of the code, file TFS.PARAMETER is read
    R.TFS.PARAMETER  = ''
    TFS.PARAMETER.ER = ''
    CALL CACHE.READ(FN.TFS.PARAMETER,TFS.PARAMETER.ID,R.TFS.PARAMETER,TFS.PARAMETER.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
***********************************
READ.REDO.MULTI.TRANSACTION.DETAIL:
***********************************
* In this para of the code, file REDO.MULTI.TRANSACTION.DETAIL is read
    R.REDO.MULTI.TRANSACTION.DETAIL  = ''
    REDO.MULTI.TRANSACTION.DETAIL.ER = ''
    CALL F.READ(FN.REDO.MULTI.TRANSACTION.DETAIL,REDO.MULTI.TXN.DETAIL.ID,R.REDO.MULTI.TRANSACTION.DETAIL,F.REDO.MULTI.TRANSACTION.DETAIL,REDO.MULTI.TRANSACTION.DETAIL.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
************************************
WRITE.REDO.MULTI.TRANSACTION.DETAIL:
************************************
* In this para of the code, values are written on to local file REDO.APAP.LOAN.CHEQUE.DETAILS
    CALL F.WRITE(FN.REDO.MULTI.TRANSACTION.DETAIL,REDO.MULTI.TXN.DETAIL.ID,R.REDO.MULTI.TRANSACTION.DETAIL)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained

    APPL.ARRAY = 'TFS.PARAMETER'
    FLD.ARRAY  = 'L.TFS.BRCH.ACCT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.TFS.BRCH.ACCT.POS = FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
