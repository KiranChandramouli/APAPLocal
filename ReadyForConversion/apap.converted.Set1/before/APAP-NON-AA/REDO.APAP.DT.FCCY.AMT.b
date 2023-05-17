*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.DT.FCCY.AMT(FRN.CCY.AMT)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.FCCY.AMT
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
*Description:  REDO.APAP.DT.FCCY is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*              the routine reads the currencies from CURRENCY.BOUGHT and CURRENCY.SOLD fetches
*              the foreign currency and the respective AMOUNT.SOLD or AMOUNT.BOUGHT


* In parameter  : None
* out parameter : FRN.CCY.AMT
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX

  GOSUB PROCESS.PARA
  RETURN

PROCESS.PARA:
  GOSUB GET.FCY.CCY.AMT
  RETURN

GET.FCY.CCY.AMT:
*Get the Currency Details

  Y.CCY.SOLD = R.NEW(FX.CURRENCY.SOLD)
  Y.CCY.BUY = R.NEW(FX.CURRENCY.BOUGHT)
  IF Y.CCY.SOLD NE LCCY THEN
    FRN.CCY.AMT  = R.NEW(FX.AMOUNT.SOLD)
    COMI = FRN.CCY.AMT
    CALL IN2AMT('19','AMT')
    FRN.CCY.AMT = V$DISPLAY
  END
  IF Y.CCY.BUY NE LCCY THEN
    FRN.CCY.AMT = R.NEW(FX.AMOUNT.BOUGHT)
    COMI = FRN.CCY.AMT
    CALL IN2AMT('19','AMT')
    FRN.CCY.AMT = V$DISPLAY
  END
  RETURN

END
