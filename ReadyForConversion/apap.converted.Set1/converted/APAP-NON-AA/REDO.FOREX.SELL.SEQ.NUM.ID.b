SUBROUTINE REDO.FOREX.SELL.SEQ.NUM.ID
*--------------------------------------------------------------------------------
* Company   Name    : Asociacion Popular de Ahorros y Prestamos
* Developed By      : GANESH.R
* Program   Name    : REDO.FOREX.SELL.SEQ.NUM.ID
*---------------------------------------------------------------------------------
* DESCRIPTION       : This routine is the .ID routine for the local template REDO.FOREX.SEQ.NUM
*                    and is used to set the ID
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*----------------------------------------------------------------------*
*Getting the ID and formattting the ID to 10 characters preceeded by 0's
*----------------------------------------------------------------------*
    TEMP.ID=ID.NEW
    ID.NEW = FMT(TEMP.ID,'R%10')
RETURN
END
