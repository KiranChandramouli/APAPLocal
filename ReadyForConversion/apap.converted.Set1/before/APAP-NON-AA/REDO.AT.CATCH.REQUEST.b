*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AT.CATCH.REQUEST(ACTUAL.REQUEST)

*--------------------------------------------
* By JP
*-------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

  AUXREQUEST = ACTUAL.REQUEST
  USERINFO = FIELD(AUXREQUEST,',',3)

  PASSUSER = FIELD(USERINFO,'/',2)
  SIGNONUSER = FIELD(USERINFO,'/',1)

  NEWPASSUSER = SIGNONUSER
  CALL REDO.S.GET.PASS(NEWPASSUSER)

  IF NEWPASSUSER THEN
    CHANGE PASSUSER TO NEWPASSUSER IN AUXREQUEST
    ACTUAL.REQUEST = AUXREQUEST
  END


  RETURN
END
