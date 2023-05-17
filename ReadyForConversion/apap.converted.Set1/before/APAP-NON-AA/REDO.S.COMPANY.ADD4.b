*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.COMPANY.ADD4(Y.ADD4)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Sudharsanan S
*Program   Name    :REDO.S.COMPANY.ADD4
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the 4th multi value set from name.address field
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
  Y.ADD4 = R.COMPANY(EB.COM.NAME.ADDRESS)<1,4>
  RETURN
END
