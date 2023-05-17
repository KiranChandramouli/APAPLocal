SUBROUTINE REDO.DS.FX.BUY.SELL.NAME(IN.OUT.PARA)
*------------------------------------------------------------------------------------------------------------
* DESCRIPTION : This deal slip routine should be attached to the DEAL.SLIP.FORMAT, REDO.BUY.SELL.DSLIP
*------------------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*--------------------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : PRADEEP S
* PROGRAM NAME : REDO.DS.FX.BUY.SELL.NAME
*--------------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference                   Description
* 27-Jun-2012      Pradeep S         PACS00204543                 Initial Creation
*----------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    GOSUB INIT
    GOSUB PROCESS

RETURN

*****
INIT:
*****
* Initialisation of variables
*
    Y.ID = IN.OUT.PARA


********
PROCESS:
********
* Getthe description for source

    Y.CCY.BOUGHT = R.NEW(FX.CURRENCY.BOUGHT)
    Y.CCY.SOLD   = R.NEW(FX.CURRENCY.SOLD)

    IF Y.CCY.BOUGHT NE LCCY THEN
        IN.OUT.PARA = "Recibo de Compra de Divisas"
    END ELSE
        IN.OUT.PARA = "Recibo de Venta de Divisas"
    END

RETURN

END
