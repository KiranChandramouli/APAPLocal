*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISA.NULL.OUTGOING.FLD

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.VISA.OUTGOING


  R.NEW(VISA.OUT.DOCUMENT.INDICATOR)=''
  R.NEW( VISA.OUT.MEMBER.MESSAGE.TXT)=''
  R.NEW( VISA.OUT.DEST.AMT)=''

  RETURN

END
