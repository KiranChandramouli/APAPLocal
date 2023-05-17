SUBROUTINE REDO.DS.SC.CCY(Y.CCY)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos.
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.DS.SC.CCY
*Modify            :btorresalbornoz
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the Y.CCY value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.USER
    $INSERT I_F.CURRENCY

    GOSUB PROCESS
RETURN
*********
PROCESS:
*********

    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''
    CALL OPF(FN.CURRENCY,F.CURRENCY)

    Y.CURRENCY=R.NEW(TT.TE.CURRENCY.1)
    CALL CACHE.READ(FN.CURRENCY, Y.CURRENCY, R.CURRENCY, Y.ERR)
    Y.CCY=R.CURRENCY<EB.CUR.CCY.NAME>


    IF Y.CCY EQ 'PESOS DOMINICANOS' THEN

        Y.CCY="RD$(":Y.CCY:")"

    END
    IF Y.CCY EQ 'USD DOLLAR' THEN


        Y.CCY=FMT(Y.CCY,"22R")
    END



RETURN
END
