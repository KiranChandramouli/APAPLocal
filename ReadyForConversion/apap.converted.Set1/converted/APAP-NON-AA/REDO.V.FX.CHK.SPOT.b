SUBROUTINE REDO.V.FX.CHK.SPOT
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.FX.CHK.SPOT
*--------------------------------------------------------------------------------------------------------
*Description  : This routine will check for deal type SPOT if not raise an error
*Linked With  : Version group FOREX,SP
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date           Who                  Reference           Description
* ------         ------               -------------       -------------
* 14 FEB 2013    Riyas                PACS00243434        Initial Creation
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    IF R.NEW(FX.RECORD.STATUS) NE '' THEN
        GOSUB PROCESS
    END

RETURN  ;* Return to end

PROCESS:
*********

    Y.DEAL.TYPE  = R.NEW(FX.DEAL.TYPE)
    Y.CCY.BOUGHT = R.NEW(FX.CURRENCY.BOUGHT)

    IF Y.DEAL.TYPE NE 'SP' THEN
        E = 'EB-VERSION.DIFFERS'
        CALL STORE.END.ERROR
    END

RETURN  ;* Return from PROCESS

END
