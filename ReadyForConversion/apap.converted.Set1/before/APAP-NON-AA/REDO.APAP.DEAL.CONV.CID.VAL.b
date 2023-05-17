*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.DEAL.CONV.CID.VAL(Y.VAL)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.APAP.DEAL.CONV.CID.VAL
*Reference Number  :ODR-2007-10-0074
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to display N/A text if value is not present
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX
  GOSUB PROCESS
  RETURN

PROCESS:
  LOC.POS = ''
  CALL MULTI.GET.LOC.REF('FOREX','L.FX.LEGAL.ID',LOC.POS)
  VAR.VAL = R.NEW(FX.LOCAL.REF)<1,LOC.POS>
  IF VAR.VAL EQ '' THEN
    Y.VAL = 'N/A'
  END
  ELSE
    Y.VAL = VAR.VAL
  END
  RETURN
END
