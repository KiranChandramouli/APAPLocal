*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.UPDATE.DESTRUCTION.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.UPDATE.DESTRUCTION.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the Stock entry table with INOUT.DATE equal to Last working date & TO.REGISTER equal to CARD.ID-COMPANY
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.UPDATE.DESTRUCTION
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*31-07-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*--------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.UPDATE.DESTRUCTION.COMMON
$INSERT I_F.REDO.CARD.REQUEST
$INSERT I_F.REDO.CARD.DES.HIS
$INSERT I_F.REDO.CARD.REORDER.DEST
$INSERT I_F.STOCK.ENTRY
$INSERT I_GTS.COMMON
$INSERT I_BATCH.FILES
$INSERT I_F.DATES



  SEL.CMD.SE = "SELECT ":FN.REDO.CARD.REQUEST:" WITH BR.RECEIVE.DATE EQ ":Y.LAST.WORKING.DATE:" AND WITH STATUS EQ 6 "
  CALL EB.READLIST(SEL.CMD.SE,SEL.LIST.SE,'',NO.REC,PGM.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST.SE)
  RETURN

END
