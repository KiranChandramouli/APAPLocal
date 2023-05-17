SUBROUTINE REDO.S.CUSTOMER.AMOUNT(Y.OUT)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SUDHARSANAN S
*Program   Name    :REDO.S.CUSTOMER.AMOUNT
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the credit amount details
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.DEAL.SLIP.COMMON
    GOSUB PROCESS
RETURN
*********
PROCESS:
*********
    Y.OUT = TRIM(FMT(VAR.AMOUNT,"L2,#19")," ",'B')
RETURN
END
