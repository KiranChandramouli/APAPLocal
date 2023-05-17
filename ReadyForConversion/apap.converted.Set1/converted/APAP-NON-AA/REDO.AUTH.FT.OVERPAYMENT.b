SUBROUTINE REDO.AUTH.FT.OVERPAYMENT
*-------------------------------------------------
* Description: This FT auth routine is to update the ref of FT Txn
*             in REDO.AA.OVERPAYMENT.
*-------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.REDO.AA.OVERPAYMENT

    GOSUB PROCESS
RETURN

*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'
    F.REDO.AA.OVERPAYMENT  = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)


    Y.REF.ID = R.NEW(FT.ORDERING.CUST)

    CALL F.READU(FN.REDO.AA.OVERPAYMENT,Y.REF.ID,R.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT,Y.ERR.QTY,'')
    R.REDO.AA.OVERPAYMENT<REDO.OVER.FT.TXN.REFS,-1> = ID.NEW
    CALL F.WRITE(FN.REDO.AA.OVERPAYMENT,Y.REF.ID,R.REDO.AA.OVERPAYMENT)

RETURN

END
