*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.S.CUSTOMER.LASTNAME1(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.LASTNAME1
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the first name from family name field
* ----------------------------------------------------------------------------------
* DATE              REF                   WHO               DESCRIPTION
*17-08-2011      PACS000100501          Prabhu N          PACS000100501-VAR.CUS-Customer field mapping is modified
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.DEAL.SLIP.COMMON
  GOSUB PROCESS
  RETURN
*********
PROCESS:
*********
  Y.OUT = VAR.LASTNAME1
  RETURN
END
