  SUBROUTINE REDO.CONV.ARRANGEMENT.REVERSAL
*------------------------------------------------------------------
*Description: This conversion routine has been attached to the enquiry REDO.ENQ.ARRANGEMENT.REVERSAL
*             to bring the lending new arrangement activity id.

*------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AA.ACTIVITY.HISTORY

  GOSUB PROCESS

  RETURN
*------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------
* Here we will get the AAA ref.

  IF O.DATA EQ "" THEN
    RETURN
  END

  FINDSTR "LENDING-NEW-ARRANGEMENT" IN R.RECORD<AA.AH.ACTIVITY> SETTING POS1,POS2,POS3 THEN
    O.DATA = R.RECORD<AA.AH.ACTIVITY.REF,POS2,POS3>
  END ELSE
    O.DATA = ""
  END

  RETURN
END
