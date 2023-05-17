SUBROUTINE REDO.S.CUSTOMER.CITY(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.CITY
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the CITY value
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.OUT = VAR.CITY
RETURN
END
