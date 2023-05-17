SUBROUTINE REDO.INP.AMOUNT.CHECK
*--------------------------------------------------
* This routine is to check the amount entered in the local field
* is same as the amount of cheque.
*--------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*--------------------------------------------------
OPENFILES:
*--------------------------------------------------

    LOC.REF.APPLICATION   = "FUNDS.TRANSFER"
    LOC.REF.FIELDS        = 'L.COMMENTS'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.COMMENTS = LOC.REF.POS<1,1>

RETURN
*--------------------------------------------------
PROCESS:
*--------------------------------------------------
    Y.CHEQUE.AMOUNT = R.NEW(FT.LOCAL.REF)<1,POS.L.COMMENTS>
    Y.DEBIT.AMOUNT  = R.NEW(FT.DEBIT.AMOUNT)

    IF Y.CHEQUE.AMOUNT NE Y.DEBIT.AMOUNT THEN
        AF = FT.DEBIT.AMOUNT
        ETEXT = 'EB-REDO.AMT.MISSMATCH'
        CALL STORE.END.ERROR
    END

RETURN
END
