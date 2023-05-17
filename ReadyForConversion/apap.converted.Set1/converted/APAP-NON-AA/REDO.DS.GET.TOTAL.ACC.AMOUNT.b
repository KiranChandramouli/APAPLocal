SUBROUTINE REDO.DS.GET.TOTAL.ACC.AMOUNT(VAR.TOT.AMOUNT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :S SUDHARSANAN
*Program   Name    :REDO.DS.GET.TOTAL.ACC.AMOUNT
*---------------------------------------------------------------------------------
* DESCRIPTION       :This program is used to get the AMOUNT VALUE
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CLOSURE

    GOSUB PROCESS

RETURN
*********
PROCESS:
**********

    Y.AMOUNT = R.NEW(AC.ACL.TOTAL.ACC.AMT)
    Y.CURR = R.NEW(AC.ACL.CURRENCY)


    Y.AMOUNT = TRIM(FMT(Y.AMOUNT,"L2,#19")," ",'B')

    VAR.TOT.AMOUNT = Y.CURR:" ":Y.AMOUNT

RETURN
END
*----------------------------------------------- End Of Record ----------------------------------
