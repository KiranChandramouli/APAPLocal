SUBROUTINE REDO.B.SCHEDULE.PROJECTOR.SELECT
*-----------------------------------------------------------
*Description: This service routine is to update the concat table about the schedule projector
* for each arrangement. This needs to be runned only once after that activity api routine will
* update the concat table during schedule changes.
*-----------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.SCHEDULE.PROJECTOR.COMMON

    SEL.CMD = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ 'LENDING'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)
RETURN
END
