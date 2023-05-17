SUBROUTINE REDO.S.COMPANY.ADD3(Y.ADD3)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Sudharsanan S
*Program   Name    :REDO.S.COMPANY.ADD3
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get city name of company
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
    Y.ADD3 = R.COMPANY(EB.COM.NAME.ADDRESS)<1,3>
RETURN
END
