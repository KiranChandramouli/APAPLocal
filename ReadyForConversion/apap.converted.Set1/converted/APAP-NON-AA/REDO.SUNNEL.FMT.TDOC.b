SUBROUTINE REDO.SUNNEL.FMT.TDOC(IN.DATA,OUT.DATA)
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*DESCRIPTION:
*This routine is used to define generic parameter table for sunnel
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :Ivan Roman
*Program   Name    :REDO.SUNNEL.FMT.TDOC
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 30-11-2011        Ivan Roman        sunnel-CR           Execute instruction
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    OUT.DATA = CHANGE(IN.DATA," ","")

RETURN
*-----------------------------------------------------------------------------
END
