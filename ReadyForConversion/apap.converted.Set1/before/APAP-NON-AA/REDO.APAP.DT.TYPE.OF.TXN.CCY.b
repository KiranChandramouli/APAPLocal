*-----------------------------------------------------------------------------
* <Rating>-41</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.DT.TYPE.OF.TXN.CCY(COUNTRY.CODE)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.TYPE.OF.TXN.CCY
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
*Description:  REDO.APAP.DT.TYPE.OF.TXN.CCY is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*              the routine reads the currencies from CURRENCY.BOUGHT and CURRENCY.SOLD
*              fetches the foreign currency and gets the COUNTRY.CODE
*

* In parameter  : None
* out parameter : COUNTRY.CODE
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX
$INSERT I_F.CURRENCY

  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA
  RETURN

OPEN.PARA:
  FN.CURRENCY = 'F.CURRENCY'
  F.CURRENCY = ''
  CALL OPF(FN.CURRENCY,F.CURRENCY)

  RETURN

PROCESS.PARA:
  GOSUB GET.FCY.CCY
  IF CURRENCY.ID THEN
    GOSUB GET.COUNTRY.CODE
  END
  RETURN

GET.FCY.CCY:
*Get the Currency Details

  Y.CCY.SOLD = R.NEW(FX.CURRENCY.SOLD)
  Y.CCY.BUY = R.NEW(FX.CURRENCY.BOUGHT)
  IF Y.CCY.SOLD NE LCCY THEN
    CURRENCY.ID  = Y.CCY.SOLD
  END
  IF Y.CCY.BUY NE LCCY THEN
    CURRENCY.ID = Y.CCY.BUY
  END
  RETURN


GET.COUNTRY.CODE:
  CALL F.READ(FN.CURRENCY,CURRENCY.ID,R.CURRENCY,F.CURRENCY,ERR.CURR)
  COUNTRY.CODE = R.CURRENCY<EB.CUR.COUNTRY.CODE>
  RETURN
END
