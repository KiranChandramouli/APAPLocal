SUBROUTINE REDO.THIRDPRTY.PARAMETER.ID
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*ODR Number        :ODR-2009-10-0480
*Program   Name    :REDO.THIRDPRTY.PARAMETER.ID
*---------------------------------------------------------------------------------
*DESCRIPTION       :This routine is the .ID routine for the local template REDO.THIRDPRTY.PARAMETER
* to format the ID
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    VAR.ID = ID.NEW
    ID.NEW = FMT(VAR.ID,'R%3')
RETURN
END
