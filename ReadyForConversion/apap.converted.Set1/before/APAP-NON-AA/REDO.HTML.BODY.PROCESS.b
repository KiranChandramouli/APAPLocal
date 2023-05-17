*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.HTML.BODY.PROCESS
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.HTML.BODY.PROCESS
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System

  FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
  F.REDO.EB.USER.PRINT.VAR=''
  CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

  HTML.BODY = O.DATA
  Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
  Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.HTML.BODY"

*  WRITE HTML.BODY TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start 
CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.BODY);*Tus End

  RETURN
END
