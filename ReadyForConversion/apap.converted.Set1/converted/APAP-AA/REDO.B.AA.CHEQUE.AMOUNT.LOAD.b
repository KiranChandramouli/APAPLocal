SUBROUTINE REDO.B.AA.CHEQUE.AMOUNT.LOAD
*---------------------------------------------------
* Description: This routine is a Load routine of batch routine to update the cheque amount among the transaction.
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

    FN.REDO.TRANSACTION.CHAIN = 'F.REDO.TRANSACTION.CHAIN'
    F.REDO.TRANSACTION.CHAIN = ''
    CALL OPF(FN.REDO.TRANSACTION.CHAIN,F.REDO.TRANSACTION.CHAIN)

    FN.REDO.LOAN.FT.TT.TXN = 'F.REDO.LOAN.FT.TT.TXN'
    F.REDO.LOAN.FT.TT.TXN = ''
    CALL OPF(FN.REDO.LOAN.FT.TT.TXN,F.REDO.LOAN.FT.TT.TXN)

    FN.REDO.CONCAT.CHQ.TXN = 'F.REDO.CONCAT.CHQ.TXN'
    F.REDO.CONCAT.CHQ.TXN = ''
    CALL OPF(FN.REDO.CONCAT.CHQ.TXN,F.REDO.CONCAT.CHQ.TXN)

    FN.REDO.TEMP.WORK = 'F.REDO.TEMP.WORK'
    F.REDO.TEMP.WORK = ''
    CALL OPF(FN.REDO.TEMP.WORK,F.REDO.TEMP.WORK)

    FN.REDO.TEMP.WORK.TXN = 'F.REDO.TEMP.WORK.TXN'
    F.REDO.TEMP.WORK.TXN = ''
    CALL OPF(FN.REDO.TEMP.WORK.TXN,F.REDO.TEMP.WORK.TXN)

RETURN
END
