SUBROUTINE REDO.CONV.AA.DISB.PROCESS.SELECT

*-------------------------------------------------
*Description: This batch routine is to change the arrangement status for inconsistent entries
*-------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.CONV.AA.DISB.PROCESS.COMMON

    GOSUB PROCESS

RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    SEL.CMD = "SELECT ":FN.REDO.DISB.CHAIN:" WITH DATE LT '20170811'"
    SEL.LIST = ''
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
