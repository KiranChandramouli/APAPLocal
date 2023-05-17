*-----------------------------------------------------------------------------
* <Rating>-21</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.DT.RATE(SP.FW.RATE)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.RATE
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------

*Description    : REDO.APAP.DT.RATE is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*                 the routine reads the SPOT.RATE/FORWARD.RATE and returns the one with value
* In parameter  : None
* out parameter : SP.FW.RATE
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX

  GOSUB PROCESS.PARA
  RETURN

PROCESS.PARA:
  GOSUB GET.SP.FW.RATE
  RETURN

GET.SP.FW.RATE:
*Get the Currency Details

  IF R.NEW(FX.SPOT.RATE) THEN
    SP.FW.RATE = R.NEW(FX.SPOT.RATE)
  END
  IF R.NEW(FX.FORWARD.RATE) THEN
    SP.FW.RATE = R.NEW(FX.FORWARD.RATE)
  END
  RETURN

END
