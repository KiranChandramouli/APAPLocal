$PACKAGE APAP.REDOSRTN
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*14-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,FM TO @FM,++ TO +=1
*14-07-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.S.GET.CASH.AMOUNT(CASH.AMT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.GET.CASH.AMOUNT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Amount by checking Txn type

*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ENQUIRY
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.T24.FUND.SERVICES


    Y.TXN.TYPE = R.NEW(TFS.TRANSACTION)
    Y.INIT.TXN = 1
    Y.TXN.COUNT = DCOUNT(Y.TXN.TYPE,@VM) ;*R22 AUTO CONVERSION
    Y.TXN.AMT = 0
    CASH.AMT = 0
    ARR.1 = 'CASHDEP'
    ARR.2 = 'FCASHDEP'
    Y.ENQ.ARR.LIST = ARR.1:@FM:ARR.2 ;*R22 AUTO CONVERSION
    LOOP
        REMOVE Y.TXN.ID FROM Y.TXN.TYPE SETTING Y.TXN.POS
    WHILE Y.INIT.TXN LE Y.TXN.COUNT
        LOCATE Y.TXN.ID IN Y.ENQ.ARR.LIST SETTING Y.PARAM.POS THEN
            Y.TXN.AMT = R.NEW(TFS.AMOUNT)<1,Y.INIT.TXN>
            CASH.AMT += Y.TXN.AMT
        END
        Y.INIT.TXN += 1 ;*R22 AUTO CONVERSION
    REPEAT

RETURN
*----------------------------------------------------
END
