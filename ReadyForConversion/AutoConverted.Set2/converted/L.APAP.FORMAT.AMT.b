SUBROUTINE L.APAP.FORMAT.AMT(Y.INP.DEAL)
    $INSERT I_COMMON
    $INSERT I_EQUATE

    Y.AMOUNT = FMT(Y.INP.DEAL, "L2,")
    Y.INP.DEAL = FMT( "RD$":Y.AMOUNT, "15R")

RETURN
END
