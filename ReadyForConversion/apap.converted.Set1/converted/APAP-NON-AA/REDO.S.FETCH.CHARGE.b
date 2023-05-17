SUBROUTINE REDO.S.FETCH.CHARGE(SYS.DATE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.S.FETCH.SYS.DATE
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the date and Convert the date into
*                   dd mon yy (e.g. 01 JAN 09)
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.LATAM.CARD.ORDER

    GOSUB PROCESS
RETURN

PROCESS:

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT =''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    Y.ACCOUNT = R.NEW(CARD.IS.ACCOUNT)
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,Y.ACCOUNT.ERR)
    Y.CURR = R.ACCOUNT<AC.CURRENCY>
    SYS.DATE = Y.CURR

RETURN
END
