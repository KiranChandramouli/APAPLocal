*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.APPLY.CHG.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.APPLY.CHG.SELECT
*---------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select the LATAM.CARD.ORDER ids
*---------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.APPLY.CHG
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*05-AUG-2010    Swaminathan.S.R        ODR-2010-03-0400      INITIAL CREATION
*--------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.APPLY.CHG.COMMON
$INSERT I_F.LATAM.CARD.ORDER
$INSERT I_BATCH.FILES
$INSERT I_GTS.COMMON
$INSERT I_F.DATES
$INSERT I_F.STMT.ENTRY
$INSERT I_F.CATEG.ENTRY
$INSERT I_F.CARD.TYPE
$INSERT I_F.ACCOUNT



  SEL.CMD.LCO = "SELECT ":FN.LATAM.CARD.CHARGE
  CALL EB.READLIST(SEL.CMD.LCO,SEL.LIST.LCO,'',NO.REC,PGM.ERR)
  CALL BATCH.BUILD.LIST('',SEL.LIST.LCO)

  RETURN

END
