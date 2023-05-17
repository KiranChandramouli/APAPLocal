SUBROUTINE REDO.V.VAL.ACCOUNT.CATEGORY
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.REINV.APP.CHECK
*--------------------------------------------------------------------------------
* Description: This Validation routine is to Populate the value ALLOWED.CATEGORY of AZ.PRODUCT.PARMAETER in ACCOUNT appln.
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 22-Jul-2011 Bharath G PACS00085750 INITIAL CREATION
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER


    GOSUB INIT
    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

    FN.AZ.PRODUCT.PARAMETER = 'F.AZ.PRODUCT.PARAMETER'
    F.AZ.PRODUCT.PARAMETER=''
    CALL OPF(FN.AZ.PRODUCT.PARAMETER,F.AZ.PRODUCT.PARAMETER)

    LOC.REF.APPLICATION="AZ.PRODUCT.PARAMETER"
    LOC.REF.FIELDS='L.AZ.RE.INV.CAT'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AZ.RE.INV.CAT = LOC.REF.POS<1,1>


RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    Y.APP.ID = COMI
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAMETER,Y.APP.ID,R.APP,APP.ERR)

    Y.REINV.CATEG = R.APP<AZ.APP.ALLOWED.CATEG>

    R.NEW(AC.CATEGORY) = Y.REINV.CATEG

RETURN
END
