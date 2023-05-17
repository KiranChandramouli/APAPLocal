SUBROUTINE REDO.ANC.REINV.APP

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.ANC.REINV.APP

*--------------------------------------------------------------------------------
* Description: This ANC routine is used to get the value of APP
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS='L.AZ.APP'
    POS.L.AZ.APP=''

    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,POS.L.AZ.APP)


RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    VAR.ID = ID.NEW
    CALL F.READ(FN.ACCOUNT,VAR.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)

    IF R.ACCOUNT THEN

        Y.APP.ID = R.ACCOUNT<AC.LOCAL.REF,POS.L.AZ.APP>

        R.NEW(AZ.ALL.IN.ONE.PRODUCT) = Y.APP.ID

    END

RETURN
*-----------------------------------------------
END
