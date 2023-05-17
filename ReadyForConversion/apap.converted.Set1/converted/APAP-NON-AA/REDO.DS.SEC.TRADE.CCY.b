SUBROUTINE REDO.DS.SEC.TRADE.CCY(TRADE.CCY)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Pradeep S
*Program   Name    :REDO.DS.SEC.TRADE.CCY
*---------------------------------------------------------------------------------
*DESCRIPTION       : This program is used to get the credit amount details
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    GOSUB PROCESS
RETURN
*********
PROCESS:
*********

    IF TRADE.CCY EQ LCCY THEN
        TRADE.CCY = "RD$"
    END
RETURN
END
