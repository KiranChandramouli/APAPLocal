*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONV.TAIL.COMO
*--------------------------------------------
*Description: This routine is to tail to the como for enquiry
*--------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

  Y.COMO.NAME = O.DATA

  CMD.TAIL = 'tail -50 &COMO&/':Y.COMO.NAME
  EXECUTE CMD.TAIL CAPTURING RESULT
  IF VC EQ 1 THEN
    VM.COUNT = DCOUNT(RESULT,FM)
    O.DATA = RESULT<VC>
  END ELSE
    O.DATA = RESULT<VC>
  END



  RETURN
END
