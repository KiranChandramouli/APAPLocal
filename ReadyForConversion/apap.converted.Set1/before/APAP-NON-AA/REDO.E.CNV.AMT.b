*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CNV.AMT
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      PACS00190859  KAVITHA     For enquiry
*
*------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ENQUIRY
$INSERT I_F.USER
$INSERT I_F.REDO.REJECT.REASON

  GOSUB PROCESS

  RETURN

PROCESS:
**********
  Y.VAR  = O.DATA
  Y.RESULT = FMT(Y.VAR,"L2,#25")
  O.DATA = TRIM(Y.RESULT,' ',"R")
  RETURN
END
