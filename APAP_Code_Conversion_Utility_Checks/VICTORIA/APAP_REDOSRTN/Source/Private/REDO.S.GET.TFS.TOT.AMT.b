$PACKAGE APAP.REDOSRTN
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,++ TO +=1
*14-07-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.S.GET.TFS.TOT.AMT(Y.TOTAL.AMT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.GET.TFS.TOT.AMT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine is to get the total amount for TFS transaction
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.T24.FUND.SERVICES


    Y.INIT.TXN = 1
    Y.TXN.AMT = 0
    Y.TOTAL.AMT = 0
    TXN.LIST = R.NEW(TFS.TRANSACTION)
    Y.TXN.COUNT = DCOUNT(TXN.LIST,@VM) ;*R22 AUTO CONVERSION

    LOOP
        REMOVE Y.TXN.ID FROM TXN.LIST SETTING Y.TXN.POS
    WHILE Y.INIT.TXN LE Y.TXN.COUNT
        IF Y.TXN.ID NE 'NET.ENTRY' THEN
            Y.TXN.AMT = R.NEW(TFS.AMOUNT)<1,Y.INIT.TXN>
            Y.TOTAL.AMT += Y.TXN.AMT
        END
        Y.INIT.TXN += 1 ;*R22 AUTO CONVERSION
    REPEAT

RETURN
END
