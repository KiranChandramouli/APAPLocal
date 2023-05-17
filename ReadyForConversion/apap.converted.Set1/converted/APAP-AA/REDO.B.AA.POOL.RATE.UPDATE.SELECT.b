SUBROUTINE REDO.B.AA.POOL.RATE.UPDATE.SELECT
*------------------------------------------------------
*Description: This batch routine is to update the pool rate
*             for back to back loans which has deposit as a collateral.
*------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AA.POOL.RATE.UPDATE.COMMON

    GOSUB PROCESS
RETURN
*------------------------------------------------------
PROCESS:
*------------------------------------------------------

    IF R.REDO.AZ.CONCAT.ROLLOVER EQ '' THEN
        CALL OCOMO("No Deposit has rolled over today")
        RETURN
    END

    SEL.CMD = 'SELECT ':FN.REDO.T.DEP.COLLATERAL
    CALL EB.READLIST(SEL.CMD,Y.ARRANGEMENT.IDS,'',SEL.NOR,SEL.RET)
    IF Y.ARRANGEMENT.IDS THEN
        CALL BATCH.BUILD.LIST('',Y.ARRANGEMENT.IDS)
    END ELSE
        CALL OCOMO("No Loans selected in REDO.T.DEP.COLLATERAL")
    END
RETURN
END
