SUBROUTINE REDO.REINV.AUTH

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.AUTH
*--------------------------------------------------------------------------------
* Description: This Auth routine is to update REDO.TFS.PROCESS in case of multi payment
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE          DESCRIPTION
* 05-Jul-2011    H GANESH     PACS00072695_N.11  INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.REDO.TFS.PROCESS

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.APPLICATION="AZ.ACCOUNT"
    LOC.REF.FIELDS='L.AZ.METHOD.PAY':@VM:'L.AZ.AMOUNT':@VM:'L.AZ.DEBIT.ACC'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AZ.METHOD.PAY = LOC.REF.POS<1,1>
    POS.L.AZ.AMOUNT     = LOC.REF.POS<1,2>
    POS.L.AZ.DEBIT.ACC  = LOC.REF.POS<1,3>

    R.REDO.TFS.PROCESS=''


RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACC,F.ACCOUNT,ACC.ERR)

    Y.METHOD.OF.PAY = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.METHOD.PAY>
    Y.AZ.AMOUNT     = R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.AMOUNT>
    Y.L.AZ.DEBIT.ACC= R.NEW(AZ.LOCAL.REF)<1,POS.L.AZ.DEBIT.ACC>
    IF Y.METHOD.OF.PAY NE '' THEN

        CHANGE @SM TO @VM IN Y.METHOD.OF.PAY
        CHANGE @SM TO @VM IN Y.AZ.AMOUNT
        CHANGE @SM TO @VM IN Y.L.AZ.DEBIT.ACC
        Y.TOT.AMT=''
        R.REDO.TFS.PROCESS<TFS.PRO.PRIMARY.ACCT>=ID.NEW
        R.REDO.TFS.PROCESS<TFS.PRO.ACCOUNT.NAME>=R.ACC<AC.SHORT.TITLE>

        Y.SOURCE.OF.FUND.CNT = DCOUNT(Y.METHOD.OF.PAY,@VM)
        Y.VAR1=1
        LOOP
        WHILE Y.VAR1 LE Y.SOURCE.OF.FUND.CNT
            R.REDO.TFS.PROCESS<TFS.PRO.CURRENCY,Y.VAR1> = R.NEW(AZ.CURRENCY)
            R.REDO.TFS.PROCESS<TFS.PRO.TRANSACTION,Y.VAR1> = Y.METHOD.OF.PAY<1,Y.VAR1>
            IF Y.METHOD.OF.PAY<1,Y.VAR1> EQ 'FROM.CUST.ACC' OR Y.METHOD.OF.PAY<1,Y.VAR1> EQ 'FROM.INT.ACC' OR Y.METHOD.OF.PAY<1,Y.VAR1> EQ 'FROM.NOST.ACC' THEN
                R.REDO.TFS.PROCESS<TFS.PRO.TRANSACTION,Y.VAR1> = 'FROM'
            END
            IF Y.METHOD.OF.PAY<1,Y.VAR1> EQ 'CHEQUE.DEPOSIT' THEN
                R.REDO.TFS.PROCESS<TFS.PRO.TRANSACTION,Y.VAR1> = 'CHQDEP'
            END
            R.REDO.TFS.PROCESS<TFS.PRO.ACCOUNT,Y.VAR1> =   Y.L.AZ.DEBIT.ACC<1,Y.VAR1>
            R.REDO.TFS.PROCESS<TFS.PRO.AMOUNT,Y.VAR1>  =   Y.AZ.AMOUNT<1,Y.VAR1>
            Y.TOT.AMT + = Y.AZ.AMOUNT<1,Y.VAR1>
            Y.VAR1 += 1
        REPEAT
        R.REDO.TFS.PROCESS<TFS.PRO.TOTAL.AMOUNT> = Y.TOT.AMT
        GOSUB OFS
    END

RETURN
*---------------------------
OFS:
*---------------------------

    OFS.TFS.SOURCE.ID = 'REDO.OFS.AZ.UPDATE'
    APPLICATION.NAME = 'REDO.TFS.PROCESS'
    TRANS.FUNC.VAL = 'I'
    TRANS.OPER.VAL = 'PROCESS'
    APPLICATION.NAME.VERSION = 'REDO.TFS.PROCESS,OFS.PROCESS'
    NO.AUT = '0'
    OFS.MSG.ID = ''
    APPLICATION.ID= ''
    OFS.ERR=''
    CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.REDO.TFS.PROCESS,OFS.REQ.MSG)
    CALL OFS.POST.MESSAGE(OFS.REQ.MSG,OFS.MSG.ID,OFS.TFS.SOURCE.ID,OFS.ERR)

RETURN
END
