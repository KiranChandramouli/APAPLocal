SUBROUTINE REDO.B.AUTOMATIC.ORDER.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.AUTOMATIC.ORDER.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the Stock register table with @ID equal to CARD.ID-COMPANY
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.AUTOMATIC.ORDER
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*31-07-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*17 MAY 2010      JEEVA T             ODR-2010-03-0400      fix for PACS00036010
*                                                           select command had been changed
*--------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AUTOMATIC.ORDER.COMMON
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.REDO.CARD.REORDER.DEST
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_GTS.COMMON
    $INSERT I_BATCH.FILES
    $INSERT I_F.CARD.TYPE

*    SEL.LIST.SR = 1

*>>>>>>>>>>>>>>>>>>>>>>>>>>>>PACS00036010<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


    SEL.CMD.SR = "SELECT ":FN.REDO.CARD.REORDER.DEST
    CALL EB.READLIST(SEL.CMD.SR,SEL.LIST.SR,'',NO.REC,PGM.ERR)

*>>>>>>>>>>>>>>>>>>>>>>>>>>>PACS00036010<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    CALL BATCH.BUILD.LIST('',SEL.LIST.SR)
RETURN

END
