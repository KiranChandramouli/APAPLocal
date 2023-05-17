*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.CUSTOMER.DOB(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.DOB
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the Customer's date of birth
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.DEAL.SLIP.COMMON
  GOSUB PROCESS
  RETURN
*********
PROCESS:
*********
  Y.OUT = VAR.DOB
  RETURN
END
