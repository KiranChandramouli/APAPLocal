SUBROUTINE REDO.S.COMPANY.ID(Y.COMPANY.ID)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Sudharsanan S
*Program   Name    :REDO.S.COMPANY.ID
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the branch code
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    GOSUB PROCESS
RETURN
**********
PROCESS:
**********
    Y.COMPANY.ID = ID.COMPANY
RETURN
END
