$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.CARDNO.MIG.RT.SELECT
*-----------------------------------------------------------------------------------------------------------
*MODIFICATION HISTORY
* Date                  Who                    Reference                        Description
* ----                  ----                     ----                              ----
* 09-08-2023           Samaran T         R22 Manual Code Conversion     BP is removed from insert file.
*-------------------------------------------------------------------------------------------------------------
    $INSERT  I_EQUATE  ;*R22 MANUAL CODE CONVERSION.START
    $INSERT  I_F.COMPANY
    $INSERT  I_F.LAPAP.BIN.SEQ.CTRL
    $INSERT  I_F.LAPAP.CARD.GEN.CARDS
    $INSERT  I_F.REDO.CARD.NUMBERS
    $INSERT  I_LAPAP.CARDNO.MIG.COMMON ;*R22 MANUAL CODE CONVERSION.END
    GOSUB SELECTOR

RETURN

SELECTOR:
    SEL.CMD = 'SELECT ' : FN.REDO.CARD.NUMBERS
    CALL EB.READLIST(SEL.CMD,KEY.LIST,'',SELECTED,SYSTEM.RET.CODE)
    CALL BATCH.BUILD.LIST('',KEY.LIST)
RETURN
END
