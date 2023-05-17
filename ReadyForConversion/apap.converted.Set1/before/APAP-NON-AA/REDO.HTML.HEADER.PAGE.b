*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.HTML.HEADER.PAGE
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.HTML.HEADER.PAGE
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System

  FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
  F.REDO.EB.USER.PRINT.VAR=''
  CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

  HTML.PAGE = O.DATA
  Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")
  Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.HTML.PAGE"

*  WRITE HTML.PAGE TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start 
CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,HTML.PAGE);*Tus End

  RETURN
END
