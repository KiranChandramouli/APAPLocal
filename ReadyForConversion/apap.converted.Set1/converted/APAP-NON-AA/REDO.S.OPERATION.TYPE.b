SUBROUTINE REDO.S.OPERATION.TYPE(Y.OPERATION.TYPE)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Pradeep S
*Program   Name    :REDO.S.OPERATION.TYPE
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the branch code
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON

    GOSUB PROCESS
RETURN
**********
PROCESS:
**********

    Y.OPERATION.TYPE = VAR.RTE.POS<1>

    DEL VAR.RTE.POS<1>

RETURN
END
