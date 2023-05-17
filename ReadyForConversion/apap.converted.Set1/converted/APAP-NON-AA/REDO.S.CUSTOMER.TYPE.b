SUBROUTINE REDO.S.CUSTOMER.TYPE(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.ADD4
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the address value from address field
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.OUT=VAR.CLIENT.TYPE
RETURN
END
