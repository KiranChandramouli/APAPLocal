SUBROUTINE REDO.APAP.DT.TYPE.OF.TXN(TYPE.TXN)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH
* Program Name  : REDO.APAP.DT.TYPE.OF.TXN
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
*Description:  REDO.APAP.DT.TYPE.OF.TXN is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*              the routine reads the currencies from CURRENCY.BOUGHT and CURRENCY.SOLD and checks for
*              the currency not equal to foreign currency and displays it with either BUY or SELL
*
* In parameter  : None
* out parameter : TYPE.TXN
*----------------------------------------------------------------------------------
* ----------------------------------------------------------------------------------
* MODIFICATION HISTORY:
* DATE            WHO             REFERENCE              DESCRIPTION
* 26 JUL 2012     Pradeep S       PACS00209521          Date format changed
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX

    GOSUB PROCESS.PARA
RETURN

PROCESS.PARA:

    GOSUB GET.CCY.DETAILS
RETURN

GET.CCY.DETAILS:
*Get the Currency Details

    Y.CCY.SOLD = R.NEW(FX.CURRENCY.SOLD)
    Y.CCY.BUY = R.NEW(FX.CURRENCY.BOUGHT)
    IF Y.CCY.SOLD NE LCCY THEN
        TYPE.TXN  = "Venta ":Y.CCY.SOLD
    END
    IF Y.CCY.BUY NE LCCY THEN
        TYPE.TXN  = "Compra ":Y.CCY.BUY
    END
RETURN

END
