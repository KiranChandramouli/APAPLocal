*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.STOCK.QTY.CNT.HIS.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.STOCK.QTY.COUNT.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*the Stock register table
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.STOCK.QTY.COUNT
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*8-MARCH-2011    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*--------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.STOCK.QTY.COUNT.COMMON
$INSERT I_GTS.COMMON
$INSERT I_BATCH.FILES
$INSERT I_F.DATES
$INSERT I_F.STOCK.REGISTER

  SEL.CMD.SR = "SELECT ":FN.STOCK.REGISTER:" WITH @ID LIKE ...CARD.":ID.COMPANY:"..."
  CALL EB.READLIST(SEL.CMD.SR,SEL.LIST.SR,'',NO.REC,PGM.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST.SR)
  RETURN

END
