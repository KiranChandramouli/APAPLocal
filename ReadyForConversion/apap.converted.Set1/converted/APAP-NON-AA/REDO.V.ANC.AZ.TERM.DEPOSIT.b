SUBROUTINE REDO.V.ANC.AZ.TERM.DEPOSIT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.ANC.AZ.TERM.DEPOSIT
*--------------------------------------------------------------------------------
* Description: This Validation routine attached to version AZ.ACCOUNT,REDO.MAIN
* to Populate the necessary values
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE            WHO         REFERENCE         DESCRIPTION
*  22-Jul-2011   Bharath G     PACS00085750      INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER

    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    LOC.REF.APPLICATION="ACCOUNT"
    LOC.REF.FIELDS = "L.AZ.APP"
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AZ.APP = LOC.REF.POS<1,1>

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACCOUNT,F.ACCOUNT,ACCT.ERR)
    IF R.ACCOUNT THEN
        R.NEW(AZ.ALL.IN.ONE.PRODUCT) =  R.ACCOUNT<AC.LOCAL.REF,POS.L.AZ.APP>
    END

RETURN
END
