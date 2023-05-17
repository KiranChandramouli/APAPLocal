*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ANC.DMG.EMBOSS

*-----------------------------------------------------------------------------

*DESCRIPTION:
*------------
* *this routine is to clear the fields of REDO.CARD.DMG.EMBOSS on input mode

* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*-----------------------------------------------------------------------------
* TODO - You MUST write a .FIELDS routine for the field definitions
*-----------------------------------------------------------------------------

* Modification History :
*-----------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*  21-MAY-2011  BALAGURUNATHAN        ODR-2010-03-0400         INITIAL VERSION
*-----------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.DMG.EMBOSS
$INSERT I_REDO.CRD.DMG.LST.COMMON
$INSERT I_GTS.COMMON


  R.NEW(DMG.LST.REG.ID)=''
  R.NEW(DMG.LST.CARD.TYPE)=''
  R.NEW( DMG.LST.SERIES)=''
  R.NEW( DMG.LST.LOST)=''
  R.NEW( DMG.LST.LOST.DESC )=''
  R.NEW( DMG.LST.DAMAGE)=''
  R.NEW( DMG.LST.DAM.DESC)=''
  R.NEW( DMG.LST.MOVE.FROM.INIT)=''

  RETURN

END
