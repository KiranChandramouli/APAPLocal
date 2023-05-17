*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------

  SUBROUTINE REDO.V.INP.SUP.OVR.AI

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.FUNDS.TRANSFER

  POS.FM.OVER = ''
  POS.VM.OVER = ''

*    FINDSTR 'TRANSACCION PENDIENTE DE AUTORIZACION' IN OFS$OVERRIDES SETTING POS.FM.OVER,POS.VM.OVER THEN
*        DEL OFS$OVERRIDES<1,POS.VM.OVER>
*        DEL OFS$OVERRIDES<2,POS.VM.OVER>
*    END

  T.OV.CLASS  = ''

  RETURN
