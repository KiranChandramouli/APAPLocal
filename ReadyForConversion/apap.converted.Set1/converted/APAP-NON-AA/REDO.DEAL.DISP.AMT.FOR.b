SUBROUTINE REDO.DEAL.DISP.AMT.FOR(Y.INP.DEAL)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of FT

*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: FT  payement
*-------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS
RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------

    Y.AMT.TOT = Y.INP.DEAL
    Y.AMT = Y.AMT.TOT[4,99]
    Y.COMI = COMI
    COMI = Y.AMT
    Y.A = 1
    Y.B = 1
    CALL IN2AMT(Y.A, Y.B)
    Y.AMT = V$DISPLAY
    COMI = Y.COMI
    Y.INP.DEAL = 'RD$':Y.AMT

RETURN
END
