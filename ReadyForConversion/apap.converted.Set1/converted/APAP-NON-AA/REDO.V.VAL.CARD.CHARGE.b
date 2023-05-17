SUBROUTINE REDO.V.VAL.CARD.CHARGE
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
    $INSERT I_F.CARD.TYPE


    L.REF.APPL = 'CARD.TYPE'
    L.REF.FIELDS = 'L.CT.CHARGE'
    L.REF.POS = ''
    CALL MULTI.GET.LOC.REF(L.REF.APPL,L.REF.FIELDS,L.REF.POS)
    Y.L.CT.CHARGE.POS = L.REF.POS<1,1>
    Y.CHARGE = R.NEW(CARD.TYPE.LOCAL.REF)<1,Y.L.CT.CHARGE.POS>
    Y.VALUE = FMT(Y.CHARGE,"R2,#15")
    R.NEW(CARD.TYPE.LOCAL.REF)<1,Y.L.CT.CHARGE.POS> = Y.VALUE
RETURN
END
