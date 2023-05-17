*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE E.REDO.BUILD.BRANCH.STATUS(ENQ.DATA)
*
* ====================================================================================
*
*     RETURNS COMPANIES TO WHICH THE USER IS GRANTED ACCESS
*
* ====================================================================================
*
*   PACS00136782 - 20110930 -
*
* ====================================================================================
*
* Subroutine Type : BUILD.ROUTINE
* Attached to     : REDO.BRANCH.STATUS
* Attached as     :
* Primary Purpose :
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : APAP
* Development by  : JoaquC-n Costa C
* Date            : 2011-10-04
*=======================================================================

$INSERT I_COMMON
$INSERT I_EQUATE
*
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.USER
$INSERT I_F.COMPANY
*


  GOSUB PROCESS

  RETURN
*
* ======
PROCESS:
* ======
*

  Y.SEL.FLD = ENQ.DATA<2>
  CHANGE VM TO FM IN Y.SEL.FLD

  LOCATE "OPERATION.STATUS" IN Y.SEL.FLD SETTING OPR.POS THEN
    IF ENQ.DATA<4,OPR.POS> EQ 'ABIERTO' THEN
      ENQ.DATA<2,OPR.POS> = "OPERATION.STATUS"
      ENQ.DATA<3,OPR.POS> = "EQ"
      ENQ.DATA<4,OPR.POS> = 'OPEN'
    END
    IF ENQ.DATA<4,OPR.POS> EQ 'CERRAR' THEN
      ENQ.DATA<2,OPR.POS> = "OPERATION.STATUS"
      ENQ.DATA<3,OPR.POS> = "EQ"
      ENQ.DATA<4,OPR.POS> = 'CLOSED'
    END

  END


  RETURN

*

END
