*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SUPRESS.LIMIT.OVERRIDE
*-----------------------------------------------------
*Description: This routine is to suppress the core limit override
*             and it will be attached at the AA.ARRANGEMENT.ACTIVITY level..
*-----------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.OVERRIDE
$INSERT I_F.AA.TERM.AMOUNT


  GOSUB PROCESS
  RETURN
*-----------------------------------------------------
PROCESS:
*-----------------------------------------------------

  IF OFS.VAL.ONLY NE 1 THEN
    GOSUB LOCATE.AND.REMOVE
  END
  RETURN
*-----------------------------------------------------
LOCATE.AND.REMOVE:
*-----------------------------------------------------

  Y.OVERRIDE.ID = 'EXCESS.ID'
  LOCATE.FLAG = 1
  LOOP
  WHILE LOCATE.FLAG

    FINDSTR Y.OVERRIDE.ID IN R.NEW(AA.AMT.OVERRIDE) SETTING POS.FM,POS.VM THEN
      DEL R.NEW(AA.AMT.OVERRIDE)<POS.FM,POS.VM>
    END ELSE
      LOCATE.FLAG = 0
    END

  REPEAT

  RETURN
END
