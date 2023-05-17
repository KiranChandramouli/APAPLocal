*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SOLICITUD.REPRINT

*---------------------------------------------
*Description: This routine is to change some value in the template to reprint the
* deal slip.
*---------------------------------------------
* Input  Arg   := N/A
* Output Arg   := N/A
* Linked With  := VERSION>REDO.H.SOLICITUD.CK,REPRINT
*---------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.SOLICITUD.CK

  GOSUB PROCESS

  RETURN
*---------------------------------------
PROCESS:
*---------------------------------------

  R.NEW(REDO.H.SOL.RESERVED.1) = R.NEW(REDO.H.SOL.RESERVED.1) + 1

  RETURN
END
