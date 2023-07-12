SUBROUTINE REDO.VAL.CCY.CHECK
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.VAL.CCY.CHECK
*-------------------------------------------------------------------------
* Description: This routine is a Validation routine to CURRENCY field
*
*----------------------------------------------------------
* Linked with:  T24.FUNDS.SERVICES,FCY.COLLECT
* In parameter :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 21-09-10          ODR-2010-09-0251              Initial Creation
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.T24.FUND.SERVICES


    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

OPEN.FILE:
*Opening Files

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN

PROCESS:

*Get the Count of Transaction Field

    VAR.MULTI.TXN = R.NEW(TFS.TRANSACTION)
    VAR.TRANS.COUNT = DCOUNT(VAR.MULTI.TXN,@VM)

*Get the values of Account and Currency field
    CCY.FLAG = ''
    VAR.COUNT = 1
    LOOP
        REMOVE TXN FROM VAR.MULTI.TXN SETTING TXN.POS
    WHILE VAR.COUNT LE VAR.TRANS.COUNT
        VAR.TRANS.AC = R.NEW(TFS.SURROGATE.AC)<1,VAR.COUNT>
        VAR.TRANC.CCY = COMI
*Get the Currency of Surrogate Account

        CALL F.READ(FN.ACCOUNT,VAR.TRANS.AC,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
        VAR.SUR.CCY = R.ACCOUNT<AC.CURRENCY>

*Check the Currency of Surrogate Account with Currency value in the Record

        IF VAR.TRANC.CCY EQ VAR.SUR.CCY THEN
            CCY.FLAG = 1
        END
        VAR.COUNT += 1
    REPEAT

    IF CCY.FLAG EQ '' THEN
        ETEXT = "EB-INVALID.CURRENCY"
        CALL STORE.END.ERROR
    END
RETURN
END
