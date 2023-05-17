SUBROUTINE REDO.V.REINV.CHECK.TRANSIT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.REINV.CHECK.TRANSIT
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
* This validation routine should be attached to the VERSION
* AZ.ACCOUNT,REVINV.AZ.CLOSE to close the AZ.ACCOUNT
*--------------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 16-06-2010 SUJITHA.S ODR-2009-10-0332 INITIAL CREATION
*
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.AZ.PRODUCT.PARAMETER

    GOSUB INIT
    GOSUB PROCESS
RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------


    LOC.REF.APPL='AZ.ACCOUNT'
    LOC.REF.FLD='L.AZ.IN.TRANSIT'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPL,LOC.REF.FLD,LOC.REF.POS)
RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

    Y.INTRANSIT=R.NEW(AZ.LOCAL.REF)<1,LOC.REF.POS>

    IF COMI EQ 'YES' THEN
        TEXT = "AZ.IN.TRANSIT"
        CURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),@VM)
        CALL STORE.OVERRIDE(CURR.NO+1)
    END ELSE
    END

RETURN
END
