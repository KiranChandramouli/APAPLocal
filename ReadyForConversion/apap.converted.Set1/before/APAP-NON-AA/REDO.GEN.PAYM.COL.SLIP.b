*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GEN.PAYM.COL.SLIP

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON

  OFS$DEAL.SLIP.PRINTING = 1
  DEAL.SLIP.CALL = 'COL.TT.PRINT'
  CALL PRODUCE.DEAL.SLIP(DEAL.SLIP.CALL)


  RETURN

END
