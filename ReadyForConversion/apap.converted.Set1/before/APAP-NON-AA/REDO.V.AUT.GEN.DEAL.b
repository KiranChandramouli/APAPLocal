*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.AUT.GEN.DEAL

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DEAL.SLIP.COMMON
$INSERT I_GTS.COMMON


  OFS$DEAL.SLIP.PRINTING = 1
  CALL PRODUCE.DEAL.SLIP('REDO.DEP.TFS')

  RETURN
END
