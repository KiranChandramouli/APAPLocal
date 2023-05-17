SUBROUTINE REDO.REINV.DEBIT.ACC

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.DEBIT.ACC
*--------------------------------------------------------------------------------
* Description: This Validation routine is to check whether the entered debit account
* has sufficient fund
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE          DESCRIPTION
* 05-Jul-2011    H GANESH      PACS00072695_N.11  INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_EB.TRANS.COMMON

    IF COMI EQ '' THEN
        RETURN
    END

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS="L.AC.AV.BAL"
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.L.AC.AV.BAL = LOC.REF.POS<1,1>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.ACC.ID = COMI
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACC,F.ACCOUNT,ACC.ERR)
    Y.ACC.BAL = R.ACC<AC.LOCAL.REF,POS.L.AC.AV.BAL>
*C$SPARE(456) = Y.ACC.BAL
    Y.PRINCIPAL     = R.NEW(AZ.PRINCIPAL)

    IF Y.PRINCIPAL GT Y.ACC.BAL THEN

*AF = AZ.REPAY.ACCOUNT
*ETEXT = "EB-INSUFFICIENT.FUNDS"
*CALL STORE.END.ERROR

    END



RETURN
END
