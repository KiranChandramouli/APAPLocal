$PACKAGE APAP.TAM
SUBROUTINE REDO.THIRDPRTY.PARAMETER.ID
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*ODR Number        :ODR-2009-10-0480
*Program   Name    :REDO.THIRDPRTY.PARAMETER.ID
*---------------------------------------------------------------------------------
*DESCRIPTION       :This routine is the .ID routine for the local template REDO.THIRDPRTY.PARAMETER
* to format the ID

** 17-04-2023 R22 Auto Conversion no changes
** 17-04-2023 Skanda R22 Manual Conversion - No changes
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE

    VAR.ID = ID.NEW
    ID.NEW = FMT(VAR.ID,'R%3')
RETURN
END
