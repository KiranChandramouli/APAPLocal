*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ID.CHECK.MM.PLACE.CALL

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.MM.MONEY.MARKET



  Y.CATEG = R.NEW(MM.CATEGORY)

  Y.MM.VALUE = 21076

  Y.RECORD.STATUS  = R.NEW(MM.RECORD.STATUS)
  IF Y.RECORD.STATUS NE '' THEN
    IF  Y.CATEG NE Y.MM.VALUE THEN
      E = 'EB-VERSION.DIFFERS'
      CALL STORE.END.ERROR
    END
  END


  RETURN

END