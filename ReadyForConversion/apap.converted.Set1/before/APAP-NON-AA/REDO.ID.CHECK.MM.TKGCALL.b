*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ID.CHECK.MM.TKGCALL

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.MM.MONEY.MARKET


  Y.CATEG = R.NEW(MM.CATEGORY)
  Y.MM.VALUE  = 21031
  Y.RECORD.STATUS  = R.NEW(MM.RECORD.STATUS)
  IF Y.RECORD.STATUS NE '' THEN
    IF Y.MM.VALUE NE Y.CATEG THEN
      E = 'EB-VERSION.DIFFERS'
      CALL STORE.END.ERROR
    END
  END


  RETURN

END
