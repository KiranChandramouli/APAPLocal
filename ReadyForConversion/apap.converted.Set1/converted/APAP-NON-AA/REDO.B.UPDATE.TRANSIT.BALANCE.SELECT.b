SUBROUTINE REDO.B.UPDATE.TRANSIT.BALANCE.SELECT
*--------------------------------------------------------------
*Description: This is the batch routine to update the transit balance
*             based on the release of ALE.
*--------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.UPDATE.TRANSIT.BALANCE.COMMON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------------
PROCESS:
*--------------------------------------------------------------
* Main Process

    SEL.CMD = 'SELECT ':FN.REDO.TRANSIT.ALE:' WITH @ID LT ':TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
