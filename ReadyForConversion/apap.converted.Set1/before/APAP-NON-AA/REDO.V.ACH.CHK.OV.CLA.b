*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ACH.CHK.OV.CLA

$INSERT I_F.FUNDS.TRANSFER
$INSERT I_COMMON
$INSERT I_EQUATE


  Y.OVER=R.NEW(FT.OVERRIDE)
  Y.CHK.CL=DCOUNT(Y.OVER,SM)
  IF Y.CHK.CL GT 1 THEN
    ETEXT='EB-CLASS.OVERRIDE'
    CALL STORE.END.ERROR
  END
  RETURN
END
