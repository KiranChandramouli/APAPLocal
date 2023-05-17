SUBROUTINE REDO.B.PRE.DD.PROCESS
*------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : JEEVA T
* PROGRAM NAME : REDO.B.POST.DD.PROCESS
* Primary Purpose : Clearing FT record from the template 'REDO.W.DIRECT.DEBIT'
* MODIFICATION HISTORY
*-------------------------------
*-----------------------------------------------------------------------------------
*    NAME                 DATE                ODR              DESCRIPTION
* JEEVA T              31-10-2011         B.9-DIRECT DEBIT
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.DATES
    $INSERT I_F.REDO.W.DIRECT.DEBIT

    FN.REDO.W.DIRECT.DEBIT = 'F.REDO.W.DIRECT.DEBIT'
    F.REDO.W.DIRECT.DEBIT = ''
    CALL OPF(FN.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT)

    FN.FUNDS.TRANSFER.NAU = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER.NAU = ''

    CALL OPF(FN.FUNDS.TRANSFER.NAU,F.FUNDS.TRANSFER.NAU)
    CALL F.READ(FN.REDO.W.DIRECT.DEBIT,'FT',R.REDO.W.DIRECT.DEBIT,F.REDO.W.DIRECT.DEBIT,Y.ERR)

    Y.ID.LIST = R.REDO.W.DIRECT.DEBIT<REDO.AA.DD.FT.ID>

    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE DCOUNT(Y.ID.LIST,@VM)
        Y.ID = Y.ID.LIST<1,Y.CNT>
        CALL F.DELETE(FN.FUNDS.TRANSFER.NAU,Y.ID)
        Y.CNT += 1
    REPEAT
    CALL F.DELETE(FN.REDO.W.DIRECT.DEBIT,'FT')
    Y.DATE.ID = R.DATES(EB.DAT.LAST.WORKING.DAY)
    CALL F.DELETE(FN.REDO.W.DIRECT.DEBIT,Y.DATE.ID)

RETURN
END
