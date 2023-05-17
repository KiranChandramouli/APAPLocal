*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ARC.PRINT.TXN.DETAILS
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Martin Macias
*Program   Name    : REDO.ARC.PRINT.TXN.DETAILS
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System

  FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
  F.REDO.EB.USER.PRINT.VAR=''
  CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)

  PDF.VERSION = APPLICATION:PGM.VERSION ;*PGM.VERSION
  PDF.RECORD = ID.NEW
  Y.USR = System.getVariable("EXT.EXTERNAL.USER")
  Y.USR.VAR = Y.USR:"-":"CURRENT.ARC.VER"

*  WRITE PDF.VERSION TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start 
CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,PDF.VERSION) ;*Tus End

  Y.USR.VAR = Y.USR:"-":"CURRENT.ARC.REC"

*  WRITE PDF.RECORD TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start 
CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,PDF.RECORD) ;*Tus End

*        WRITE PDF.VERSION TO F.REDO.EB.USER.PRINT.VAR,PDF.RECORD

  RETURN
END
