*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AUTH.DEP.REPRINT
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.APAP.H.REPRINT.DEP

  GOSUB PROCESS
  RETURN
*------------
PROCESS:
*-----------
  R.NEW(REDO.REP.DEP.REPRINT.SEQ) = R.NEW(REDO.REP.DEP.REPRINT.SEQ) + 1
  R.NEW(REDO.REP.DEP.REPRINT.FLAG) = ''
  R.NEW(REDO.REP.DEP.OVERRIDE) = ''

  VAR.ID = FIELD(ID.NEW,"-",1)

  VEROPR ="ENQ REDO.DEP.REPRINT.LIST @ID EQ ":VAR.ID
  IF VEROPR THEN
    CALL EB.SET.NEW.TASK(VEROPR)
  END

  RETURN
*-------------
END
