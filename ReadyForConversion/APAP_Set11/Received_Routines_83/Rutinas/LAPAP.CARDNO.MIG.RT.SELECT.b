*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE LAPAP.CARDNO.MIG.RT.SELECT
    $INSERT T24.BP I_EQUATE
    $INSERT T24.BP I_F.COMPANY
    $INSERT BP I_F.LAPAP.BIN.SEQ.CTRL
    $INSERT BP I_F.LAPAP.CARD.GEN.CARDS
    $INSERT TAM.BP I_F.REDO.CARD.NUMBERS
    $INSERT LAPAP.BP I_LAPAP.CARDNO.MIG.COMMON

    GOSUB SELECTOR

    RETURN

SELECTOR:
    SEL.CMD = 'SELECT ' : FN.REDO.CARD.NUMBERS
    CALL EB.READLIST(SEL.CMD,KEY.LIST,'',SELECTED,SYSTEM.RET.CODE)
    CALL BATCH.BUILD.LIST('',KEY.LIST)
    RETURN
END
