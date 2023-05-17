SUBROUTINE REDO.B.AA.UNC.PENDING.SELECT

*-------------------------------------------------
*Description: This batch routine is to change the arrangement status for inconsistent entries
*-------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.AA.UNC.PENDING
    $INSERT I_REDO.B.AA.UNC.PENDING.COMMON

    GOSUB PROCESS

RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    SEL.CMD = "SELECT ":FN.REDO.AA.UNC.PENDING:" WITH ARR.STATUS EQ 'PENDING.CLOSURE'"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
