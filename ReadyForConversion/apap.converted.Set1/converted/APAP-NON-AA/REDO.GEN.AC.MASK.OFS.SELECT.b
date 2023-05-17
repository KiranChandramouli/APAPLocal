SUBROUTINE REDO.GEN.AC.MASK.OFS.SELECT
*--------------------------------------------------------------
* Description : This routine is to select the record for masking
*--------------------------------------------------------------
**********************************************************************
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*14.08.2011  PRABHU N      PACS00055362         INITIAL CREATION
*----------------------------------------------------------------------



    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.GEN.AC.MASK.OFS.COMMON


    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------

    SEL.CMD = 'SELECT ':FN.REDO.AC.PRINT.MASK
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
