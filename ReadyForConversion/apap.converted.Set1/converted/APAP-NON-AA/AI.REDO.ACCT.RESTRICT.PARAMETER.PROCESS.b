SUBROUTINE AI.REDO.ACCT.RESTRICT.PARAMETER.PROCESS
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.PREVALANCE.STATUS.PROCESS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a authorization routine for attaching the template REDO.PREVALANCE.STATUS.VALIDATE
*In Parameter      :
*Out Parameter     :
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  21/09/2011      Riyas                         ODR-2010-08-0490                Initial Creation
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AI.REDO.ACCT.RESTRICT.PARAMETER

    GOSUB OPEN.FILES
    GOSUB PROCESS
    GOSUB GOEND
RETURN

************
OPEN.FILES:
************
    FN.AI.REDO.ACCT.RESTRICT.PARAMETER = 'F.AI.REDO.ACCT.RESTRICT.PARAMETER'
    F.AI.REDO.ACCT.RESTRICT.PARAMETER = ''
    CALL OPF(FN.AI.REDO.ACCT.RESTRICT.PARAMETER,F.AI.REDO.ACCT.RESTRICT.PARAMETER)

RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------

    Y.ACCT.TYPE = R.NEW(AI.RES.PARAM.RESTRICT.ACCT.TYPE)
    CHANGE @VM TO @FM IN Y.ACCT.TYPE
    Y.DEBIT.CNT   = COUNT(Y.ACCT.TYPE,"DEBIT")
    Y.CREDIT.ACCT = COUNT(Y.ACCT.TYPE,"CREDIT")
    IF Y.DEBIT.CNT GT 1 OR Y.CREDIT.ACCT GT 1 THEN
        AV = 1
        AF    =  AI.RES.PARAM.RESTRICT.ACCT.TYPE
        ETEXT = "EB-DUPCAT.NT.ALLWD"
        CALL STORE.END.ERROR
    END
RETURN
*-----
GOEND:
*-----
END
