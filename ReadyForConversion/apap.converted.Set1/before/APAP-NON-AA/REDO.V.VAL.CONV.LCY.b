*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.V.VAL.CONV.LCY
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.CONV.LCY
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine converts  the amount deposited in local currency
*                   into  equivalent indexed currency amount
*LINKED WITH       :

* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.CURRENCY
$INSERT I_GTS.COMMON

  IF OFS$HOT.FIELD EQ 'Tab.ORIG.LCY.AMT' OR OFS$HOT.FIELD EQ 'ORIG.LCY.AMT' THEN
    GOSUB INIT
    GOSUB EXCHANGE
  END

  RETURN
******
INIT:
******
  LREF.APP='AZ.ACCOUNT'
  LREF.FIELD='ORIG.LCY.AMT'
  LREF.POS=''
  FN.CURRENCY='F.CURRENCY'
  F.CURRENCY=''
  CALL OPF(FN.CURRENCY,F.CURRENCY)

  RETURN
**********
EXCHANGE:
**********

  CCY.BUY = R.NEW(AZ.CURRENCY)
  BUY.AMT             = ''
  CCY.SELL            = LCCY
  SELL.AMT            = COMI
  RETURN.CODE         = ''
  CALL F.READ(FN.CURRENCY,CCY.BUY,R.CURRENCY,F.CURRENCY,ERR.CURRENCY)
  CCY.MKT='1'
  CALL EXCHRATE(CCY.MKT,CCY.BUY,BUY.AMT,CCY.SELL,SELL.AMT,'','','','',RETURN.CODE)
  R.NEW(AZ.PRINCIPAL)=BUY.AMT

  CALL REDO.V.PRINCIPAL.INT.RATE

  RETURN
********
END
