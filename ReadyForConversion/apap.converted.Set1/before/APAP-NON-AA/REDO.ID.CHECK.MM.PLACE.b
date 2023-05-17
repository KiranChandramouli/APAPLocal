*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ID.CHECK.MM.PLACE

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.MM.MONEY.MARKET



  Y.CATEG = R.NEW(MM.CATEGORY)

  Y.MM.VALUE = 21077:VM:21078:VM:21079:VM:21080

  Y.RECORD.STATUS  = R.NEW(MM.RECORD.STATUS)
  IF Y.RECORD.STATUS NE '' THEN
    IF Y.CATEG MATCHES Y.MM.VALUE THEN
    END ELSE
      E = 'EB-VERSION.DIFFERS'
      CALL STORE.END.ERROR
    END
  END



  RETURN

END
