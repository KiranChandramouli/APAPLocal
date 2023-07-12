SUBROUTINE REDO.S.CHECK.AMOUNT(CHQ.AMT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.CHECK.AMOUNT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Amount by checking Txn type

*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.T24.FUND.SERVICES


    Y.TXN.TYPE = R.NEW(TFS.TRANSACTION)
    Y.INIT.TXN = 1
    Y.TXN.COUNT = DCOUNT(Y.TXN.TYPE,@VM)
    Y.TXN.AMT = 0
    CHQ.AMT = 0
    CASH.AMT = 0

    ARR.1 = 'CHQDEP'
    ARR.2 = 'FCHQDEP'
    Y.ENQ.ARR.LIST = ARR.1:@FM:ARR.2

    LOOP
        REMOVE Y.TXN.ID FROM Y.TXN.TYPE SETTING Y.TXN.POS
    WHILE Y.INIT.TXN LE Y.TXN.COUNT
        LOCATE Y.TXN.ID IN Y.ENQ.ARR.LIST SETTING Y.PARAM.POS THEN
            Y.TXN.AMT = R.NEW(TFS.AMOUNT)<1,Y.INIT.TXN>
            CHQ.AMT += Y.TXN.AMT
        END
        Y.INIT.TXN += 1
    REPEAT

RETURN
END
