*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CLEAR.HTML.DATA.PROCESS
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.CLEAR.HTML.DATA.PROCESS
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System

  FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
  F.REDO.EB.USER.PRINT.VAR=''
  CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

  Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
  Y.USR.VAR.HTML = Y.USR.VAR:"-":"CURRENT.HTML.DATA"

*  READ HTML.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML THEN ;*Tus Start 
CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML,HTML.DATA,F.REDO.EB.USER.PRINT.VAR,HTML.DATA.ERR)
 IF HTML.DATA THEN  ;* Tus End
 
 * DELETE F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML ;*Tus Start
 CALL F.DELETE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML);*Tus End
  END

  Y.USR.VAR.HTML = Y.USR.VAR:"-":"CURRENT.HTML.FOOTER"
*  READ HTML.DATA FROM F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML THEN ;*Tus Start 
CALL F.READ(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML,HTML.DATA,F.REDO.EB.USER.PRINT.VAR,HTML.DATA.ERR)
 IF HTML.DATA THEN  ;* Tus End
*    DELETE F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML ;*Tus Start 
CALL F.DELETE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR.HTML) ; *Tus End 
  END
  CALL JOURNAL.UPDATE('')

  RETURN
END
