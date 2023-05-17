*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GEN.AC.MASK.OFS.LOAD
*--------------------------------------------------------------
* Description : This routine is to generate ofs message for AC.PRINT.MASK.
*
*--------------------------------------------------------------
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*23.08.2011  Prabhu N      PACS00055362         INITIAL CREATION
*----------------------------------------------------------------------



$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.GEN.AC.MASK.OFS.COMMON

  GOSUB PROCESS
  RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------
  FN.REDO.AC.PRINT.MASK='F.REDO.AC.PRINT.MASK'
  F.REDO.AC.PRINT.MASK=''
  CALL OPF(FN.REDO.AC.PRINT.MASK,F.REDO.AC.PRINT.MASK)

  FN.AC.PRINT.MASK='F.AC.PRINT.MASK'
  F.AC.PRINT.MASK=''
  CALL OPF(FN.AC.PRINT.MASK,F.AC.PRINT.MASK)

  RETURN
END
