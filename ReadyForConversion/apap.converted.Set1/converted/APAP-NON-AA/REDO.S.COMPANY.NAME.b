SUBROUTINE REDO.S.COMPANY.NAME(Y.COMPANY.NAME)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Sudharsanan S
*Program   Name    :REDO.S.COMPANY.NAME
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the branch name
*LINKED WITH       :
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.COMPANY.NAME = R.COMPANY(EB.COM.COMPANY.NAME)
RETURN
END
