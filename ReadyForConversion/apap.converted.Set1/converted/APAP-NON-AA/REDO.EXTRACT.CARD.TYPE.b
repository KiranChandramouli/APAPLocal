SUBROUTINE REDO.EXTRACT.CARD.TYPE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*------------------------------------------------------------------------------

*Description  : This routine is validation routine attached to version CARD.TYPE,REDO.CARD.TYPE to validate bin nu
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : CARD.TYPE

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 11-09-2010     SWAMINATHAN            ODR-2010-03-0400          Initial Creation
*--------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.STOCK.ENTRY

    Y.TYPE =          O.DATA
    Y.VALUE = FIELD(Y.TYPE,"*",2)
    O.DATA = Y.VALUE
RETURN
END
