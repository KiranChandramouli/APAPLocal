*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  PROGRAM NEW

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_SCREEN.VARIABLES

  FOR LL = 0 TO 56
    PRINT @(0,LL):S.CLEAR.EOL:
  NEXT LL

  CALL SF.CLEAR(0,0,"")
  CRT "#################"
  CALL SF.BLINK(0,1," UPGRADE DETAILS ")
  CRT ""
  CRT "#################"
  CRT "                 "

  CRT "Current T24 Release :"
  CALL SF.INPUT(3,16,10)
  INPUT T24.CURR.RELEASE

  CRT "Current jBASE Release :"
  INPUT JB.CURR.RELEASE

  CRT "Upgrade T24 Release to :"
  INPUT T24.NEW.RELEASE

  CRT "Upgrade jBASE Release :"
  INPUT JB.NEW.RELEASE

  CRT "Final Database :"
  CRT "(1 . DB / 2. Oracle / 3. jBase) :"
  INPUT FIN.DB


  CALL DISPLAY.MESSAGE("CHANDRU",2)
  INPUT SOME
END
