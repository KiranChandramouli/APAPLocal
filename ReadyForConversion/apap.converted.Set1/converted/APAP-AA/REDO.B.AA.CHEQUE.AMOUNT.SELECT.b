SUBROUTINE REDO.B.AA.CHEQUE.AMOUNT.SELECT
*---------------------------------------------------
* Description: This routine is a Select routine of batch routine to update the cheque amount among the transaction.
*---------------------------------------------------
* Input  Arg: N/A
* Output Arg: N/A
*---------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AA.CHEQUE.AMOUNT.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------
PROCESS:
*---------------------------------------------------

    SEL.CMD = 'SELECT ':FN.REDO.CONCAT.CHQ.TXN
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
