SUBROUTINE REDO.V.REINV.AZ.ACC.BAL.TT.FT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.V.REINV.AZ.ACC.BAL.TT.FT
*--------------------------------------------------------------------------------
* Description:
*--------------------------------------------------------------------------------
*          This validation routine should be attached to the VERSION TELLER,REINV.WDL to populate
* ACCOUNT.1 field and currency
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26.06.2011       RIYAS          PACS00072695      CREATION
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
    LOC.REF.APPL='FUNDS.TRANSFER':@FM:'TELLER'
    LOC.REF.FIELDS="L.FT.REINV.AMT":@FM:"L.TT.REINV.AMT"
    LOC.REF.POS=" "
    CALL MULTI.GET.LOC.REF(LOC.REF.APPL,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.FT.REINV.AMT=LOC.REF.POS<1,1>
    POS.L.TT.REINV.AMT=LOC.REF.POS<2,1>

RETURN
*--------------------------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------------------------

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.INT.AMT = R.NEW(FT.LOCAL.REF)<1,POS.L.FT.REINV.AMT>
        IF COMI GT Y.INT.AMT THEN
            ETEXT="FT-REINV.WDL"
            CALL STORE.END.ERROR
        END

    END

    IF APPLICATION EQ 'TELLER' THEN
        Y.INT.AMT = R.NEW(TT.TE.LOCAL.REF)<1,POS.L.TT.REINV.AMT>
        IF COMI GT Y.INT.AMT THEN
            ETEXT="FT-REINV.WDL"
            CALL STORE.END.ERROR
        END
    END

RETURN
END
