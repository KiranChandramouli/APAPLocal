*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.EXT.SUNN.CUS.STATUS(Y.ID)

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.EXT.SUNN.COMMON
$INSERT I_F.REDO.STORE.SUNN.CUS.ST


  Y.CUS = FIELD(Y.ID,',',1)
  Y.STAUS = FIELD(Y.ID,',',2)


  R.VAL<SUN.CUS.STATUS> = Y.STAUS

  CALL F.WRITE(FN.REDO.STORE.SUNN.CUS.ST,Y.CUS,R.VAL)

  CALL OCOMO('PROCESSED CUSTOMER - ':Y.CUS)

  RETURN

END
