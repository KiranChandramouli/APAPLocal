*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHQ.CHANGE.VER

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON


  Y.VER = O.DATA

  IF Y.VER EQ 'TELLER,REDO.OVERPYMT.CHEQUE' THEN
    O.DATA = 'TELLER,REDO.OVERPYMT.CQ.DUP'
  END

  RETURN

END
