SUBROUTINE REDO.B.AA.OVERPAYMENT.SELECT

*-------------------------------------------------
*Description: This batch routine is to post the FT OFS messages for overpayment
*             and also to credit the interest in loan..
*-------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_REDO.B.AA.OVERPAYMENT.COMMON

    GOSUB PROCESS
RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    SEL.CMD = "SELECT ":FN.REDO.AA.OVERPAYMENT:" WITH STATUS EQ PENDIENTE AND NEXT.DUE.DATE GT ":R.DATES(EB.DAT.LAST.WORKING.DAY):" AND NEXT.DUE.DATE LE ":TODAY
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,SEL.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)


RETURN
END
