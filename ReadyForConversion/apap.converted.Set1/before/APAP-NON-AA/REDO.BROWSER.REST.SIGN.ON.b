*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BROWSER.REST.SIGN.ON

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_F.COMPANY
  $INSERT I_F.PROTOCOL

  ETEXT='Browser Restriction Issue'

  CALL STORE.END.ERROR

  RETURN

END
