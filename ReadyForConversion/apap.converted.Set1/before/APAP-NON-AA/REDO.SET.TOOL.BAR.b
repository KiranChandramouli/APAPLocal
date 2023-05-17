*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SET.TOOL.BAR

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.BROWSER.TOOLS
$INSERT I_BROWSER.TAGS
$INSERT I_GTS.COMMON


  IF V$FUNCTION EQ 'S' THEN
    TOOLBAR.ID = 'DSB.TOOL'
    CALL EB.ADD.TOOLBAR(TOOLBAR.ID, LOCATION)
    CALL EB.CHANGE.TOOL("CONTRACT", "TXN.VALIDATE", BRTL.ENABLED, "NO")
  END

  RETURN

END
