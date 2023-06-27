*-----------------------------------------------------------------------------
* <Rating>-24</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.CHECK.TXN.CCY
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Ganesh R
* Program Name  : REDO.CHECK.TXN.CCY
*-------------------------------------------------------------------------
* Description: This routine is a Inout routine to default currency and Account.1
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
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*26-06-2023       Conversion Tool           R22 Auto Code conversion          No Changes
*26-06-2023       S.AJITHKUMAR               R22 Manual Code Conversion       Command this Insert file I_F.T24.FUND.SERVICES



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
*$INSERT I_F.T24.FUND.SERVICES ;*R22 manual code conversion

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
    VAR.TRANS.COUNT = DCOUNT(VAR.MULTI.TXN,VM)

*Get the values of Account and Currency field
    CCY.FLAG = ''
    VAR.COUNT = 1

    VAR.TRANS.AC = R.NEW(TFS.PRIMARY.ACCOUNT)
    CALL F.READ(FN.ACCOUNT,VAR.TRANS.AC,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    VAR.TRANC.CCY = R.ACCOUNT<AC.CURRENCY>
    IF VAR.TRANC.CCY EQ LCCY THEN
        ETEXT = "AC-INVALID.AC.NO"
        CALL STORE.END.ERROR
    END
    LOOP
        REMOVE TXN FROM VAR.MULTI.TXN SETTING TXN.POS
    WHILE VAR.COUNT LE VAR.TRANS.COUNT
*Assign the Currency and Surrogate Account of Primary Account
        VAR.INP.CCY = R.NEW(TFS.CURRENCY)<1,VAR.COUNT>
        IF VAR.INP.CCY NE VAR.TRANC.CCY THEN
            AF = TFS.CURRENCY
            AV = VAR.COUNT
            ETEXT = "EB-INVALID.CURRENCY"
            CALL STORE.END.ERROR
        END
        VAR.COUNT++
    REPEAT

RETURN
END
