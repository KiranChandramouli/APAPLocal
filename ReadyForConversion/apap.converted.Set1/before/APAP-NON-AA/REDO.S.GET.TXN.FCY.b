*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.GET.TXN.FCY(TXN.FCY)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Chandra Prakash T
* Program Name  : REDO.S.GET.TXN.FCY
* ODR NUMBER    : ODR-2010-01-0213
*----------------------------------------------------------------------------------
* Description   : Deal slip routine attached to FX.FXSN.PSLIP, TT.FXSN.SLIP & FT.FXSN.SLIP to retrieve transaction foreign currency, which depends
*                 on the transaction
* In parameter  : None
* out parameter : None
*----------------------------------------------------------------------------------
* Date             Author             Reference         Description
* 13-Jul-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
*----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX
$INSERT I_F.FUNDS.TRANSFER

  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

OPEN.FILES:

  FN.FOREX = 'F.FOREX'
  F.FOREX = ''
  CALL OPF(FN.FOREX,F.FOREX)

  FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER = ''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  RETURN

PROCESS:

  CONTRACT.NO = ID.NEW

  BEGIN CASE
  CASE APPLICATION EQ "FOREX"
    IF R.NEW(FX.CURRENCY.BOUGHT) NE LCCY THEN
      TXN.FCY = R.NEW(FX.CURRENCY.BOUGHT)
    END ELSE
      TXN.FCY = R.NEW(FX.CURRENCY.SOLD)
    END
  CASE APPLICATION EQ "FUNDS.TRANSFER"
    TXN.AMT.DEBITED = R.NEW(FT.AMOUNT.DEBITED)
    TXN.AMT.CREDITED = R.NEW(FT.AMOUNT.CREDITED)

    IF TXN.AMT.DEBITED[1,3] EQ LCCY THEN
      TXN.FCY = TXN.AMT.CREDITED[1,3]
    END ELSE
      TXN.FCY = TXN.AMT.DEBITED[1,3]
    END
  END CASE

  RETURN

END
