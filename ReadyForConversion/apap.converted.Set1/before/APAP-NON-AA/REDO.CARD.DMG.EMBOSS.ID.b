*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.DMG.EMBOSS.ID
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CARD.DMG.EMBOSS


  FN.REDO.CARD.GEN = 'F.REDO.CARD.GENERATION'
  F.REDO.CARD.GEN = ''
  CALL OPF(FN.REDO.CARD.GEN,F.REDO.CARD.GEN)

  IF V$FUNCTION EQ 'I' THEN
    CALL F.READ(FN.REDO.CARD.GEN,ID.NEW,R.REDO.CARD.GEN,F.REDO.CARD.GEN,GEN.ERR)
    IF R.REDO.CARD.GEN THEN
      E='ST-DAMAGE.MARK'
      CALL STORE.END.ERROR
    END

    R.NEW(DMG.LST.REG.ID)=''
    R.NEW(DMG.LST.CARD.TYPE)=''
    R.NEW( DMG.LST.SERIES)=''
    R.NEW( DMG.LST.LOST)=''
    R.NEW( DMG.LST.LOST.DESC )=''
    R.NEW( DMG.LST.DAMAGE)=''
    R.NEW( DMG.LST.DAM.DESC)=''
    R.NEW( DMG.LST.MOVE.FROM.INIT)=''
  END


  RETURN

END
