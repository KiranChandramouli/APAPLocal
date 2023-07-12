SUBROUTINE REDO.APAP.AUT.MUL.TXN.UPD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.AUT.MUL.TXN.UPD
*--------------------------------------------------------------------------------------------------------
*Description       :
*
*Linked With       : Version TFS,REDO.MULTI.TXN
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
* 13 July 2010       Ganesh R           ODR-2009-10-0318 B.126        Initial Creation
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.TFS.PARAMETER
    $INSERT I_F.T24.FUND.SERVICES
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
    TFS.PARAMETER.ID = ID.COMPANY
    GOSUB READ.TFS.PARAMETER

    Y.BRANCH.ACCT.LIST = R.TFS.PARAMETER<TFS.PAR.LOCAL.REF,LOC.L.TFS.BRCH.ACCT.POS>
    CHANGE @SM TO @FM IN Y.BRANCH.ACCT.LIST
    Y.BRANCH.ACCT = R.NEW(TFS.PRIMARY.ACCOUNT)

    LOCATE Y.BRANCH.ACCT IN Y.BRANCH.ACCT.LIST<1> SETTING Y.POS THEN
        GOSUB UPDATE.MULTI.TXN.DETAILS
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*************************
UPDATE.MULTI.TXN.DETAILS:
*************************
* In this para of the code, the details are written on to the local file REDO.MULTI.TRANSACTION.DETAIL
    REDO.MULTI.TRANSACTION.DETAIL.ID = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.ORIG.REF.POS>
    GOSUB READ.REDO.MULTI.TRANSACTION.DETAIL
    IF R.REDO.MULTI.TRANSACTION.DETAIL EQ '' THEN
        RETURN
    END

    R.REDO.MULTI.TRANSACTION.DETAIL<MUL.TXN.RECON.REF> = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.ORIG.REF.POS>
    R.REDO.MULTI.TRANSACTION.DETAIL<MUL.TXN.RECON.DATE> = R.NEW(TFS.LOCAL.REF)<1,LOC.L.TFS.TXN.DATE.POS>

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
    CALL F.READ(FN.REDO.MULTI.TRANSACTION.DETAIL,REDO.MULTI.TRANSACTION.DETAIL.ID,R.REDO.MULTI.TRANSACTION.DETAIL,F.REDO.MULTI.TRANSACTION.DETAIL,REDO.MULTI.TRANSACTION.DETAIL.ER)

RETURN
*--------------------------------------------------------------------------------------------------------
************************************
WRITE.REDO.MULTI.TRANSACTION.DETAIL:
************************************
* In this para of the code, values are written on to local file REDO.APAP.LOAN.CHEQUE.DETAILS
    CALL F.WRITE(FN.REDO.MULTI.TRANSACTION.DETAIL,REDO.MULTI.TRANSACTION.DETAIL.ID,R.REDO.MULTI.TRANSACTION.DETAIL)

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
* In this para of the code, local reference field positions are obtained

    APPL.ARRAY = 'TFS.PARAMETER':@FM:'T24.FUND.SERVICES'
    FLD.ARRAY  = 'L.TFS.BRCH.ACCT':@FM:'L.TFS.ORIG.REF':@VM:'L.TFS.TXN.DATE'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.TFS.BRCH.ACCT.POS = FLD.POS<1,1>
    LOC.L.TFS.ORIG.REF.POS  =  FLD.POS<2,1>
    LOC.L.TFS.TXN.DATE.POS  =  FLD.POS<2,2>

RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
