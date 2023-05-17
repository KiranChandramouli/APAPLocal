SUBROUTINE REDO.S.CUSTOMER.TOWN.COUNTRY(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.SOC.NAME
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the customer's town.country details
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.OUT = VAR.TOWN.COUNTRY
RETURN
END
