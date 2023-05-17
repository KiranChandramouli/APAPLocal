*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LATAM.CARD.RELEASE.RECORD

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.LATAM.CARD.RELEASE

  IF R.OLD(CRD.REL.CARD.NUMBER) EQ R.NEW(CRD.REL.CARD.NUMBER) THEN
    R.NEW(CRD.REL.CARD.NUMBER)=''
  END


  RETURN
