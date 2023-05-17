SUBROUTINE REDO.INP.CHK.CHARGE.AMOUNT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.INP.CHK.CHARGE.AMOUNT
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
* This validation routine should be attached to the FT,SERVICE.CREATE to check the charge amount
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
* DATE WHO REFERENCE DESCRIPTION
* 10.07.2012 Sudhar PACS00197329 CREATION
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.ACCOUNT
*   $INSERT I_F.TELLER
    $INSERT I_F.FUNDS.TRANSFER


    GOSUB GET.LOC.VALUES
    GOSUB PROCESS

RETURN
*-----------------------------------------------------------------------------
GET.LOC.VALUES:
*----------------
* Get the Needed Local table position
*
    LOC.REF.APPL='FUNDS.TRANSFER'
    LOC.REF.FIELDS="L.COMMENTS"
    LOC.REF.POS=" "
    CALL GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)


RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------
    VAR.CR.AMOUNT = R.NEW(FT.CREDIT.AMOUNT)
    VAR.CHARGE.AMT = R.NEW(FT.LOCAL.REF)<1,LOC.REF.POS>
    IF VAR.CHARGE.AMT NE VAR.CR.AMOUNT THEN
        AF = FT.CREDIT.AMOUNT
        ETEXT = 'FT-CREDIT.CHARGE.AMT':@FM:VAR.CHARGE.AMT
        CALL STORE.END.ERROR
        RETURN
    END
RETURN
END
