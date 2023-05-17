*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.CUSTOMER.RNC(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.RNC
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get rnc value
* ----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.DEAL.SLIP.COMMON
  GOSUB PROCESS
  RETURN
*********
PROCESS:
*********
  Y.OUT = VAR.RNC
  RETURN
END
