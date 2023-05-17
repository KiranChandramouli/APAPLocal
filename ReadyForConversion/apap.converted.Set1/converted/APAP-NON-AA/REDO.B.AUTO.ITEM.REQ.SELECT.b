SUBROUTINE REDO.B.AUTO.ITEM.REQ.SELECT

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : JEEVA T
* Program Name  : REDO.B.AUTO.ITEM.REQ.SELECT
*-------------------------------------------------------------------------
* Description: This routine is a select routine to load all the necessary variables for the
* multi threaded process
*----------------------------------------------------------
* Linked with: Multi threaded batch routine REDO.B.STAFF.CUST.TRACK
* In parameter : None
* out parameter : CUST.ID
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
*   DATE              ODR                             DESCRIPTION
* 03-03-10      ODR-2009-10-0532                     Initial Creation
*------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AUTO.ITEM.REQ.COMMON
    $INSERT I_F.REDO.ITEM.STOCK

    SEL.CMD ='SELECT ':FN.REDO.ITEM.STOCK
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.IDS,SEL.RET)
    ID.LIST = SEL.LIST
    CALL BATCH.BUILD.LIST('',ID.LIST)

RETURN

END
