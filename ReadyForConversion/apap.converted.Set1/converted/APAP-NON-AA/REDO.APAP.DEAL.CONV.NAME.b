SUBROUTINE REDO.APAP.DEAL.CONV.NAME(Y.NAME)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    :REDO.APAP.DEAL.CONV.NAME
*Reference Number  : ODR-2007-10-0074
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the Inputter name and format them
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    GOSUB PROCESS
RETURN

PROCESS:

    VAR.NAME = R.NEW(FX.INPUTTER)
    Y.NAME = FIELD(VAR.NAME,'_',2)

RETURN
END
