SUBROUTINE REDO.V.INP.AZ.INT.LIQ.CHK

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.INP.AZ.INT.LIQ.CHK

*--------------------------------------------------------------------------------
* Description: This Auth routine is too store value for next version (AZ.ACCOUNT)
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 23/09/2014     PRABHU N                        INITIAL CREATION
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
    Y.INT.LIQ.ACC=R.ACCOUNT<AC.INTEREST.LIQU.ACCT>
    CALL F.READ(FN.ACCOUNT,Y.INT.LIQ.ACC,R.INT.LIQ.ACC,F.ACCOUNT,Y.INT.LIQ.ERR)
    Y.CUSTOMER=R.INT.LIQ.ACC<AC.CUSTOMER>
    IF NOT(Y.CUSTOMER) THEN
        ETEXT="EB-WAIT.INT.LIQ.ACCT"
        CALL STORE.END.ERROR
    END
RETURN
END
