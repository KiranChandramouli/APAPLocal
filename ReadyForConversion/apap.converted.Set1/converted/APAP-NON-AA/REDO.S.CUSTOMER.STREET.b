SUBROUTINE REDO.S.CUSTOMER.STREET(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.STREET
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the social name from NAME1 and NAME.2 fields
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.OUT = VAR.STREET
RETURN
END
