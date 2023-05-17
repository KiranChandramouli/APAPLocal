SUBROUTINE REDO.V.VAL.DAMAGE.LOST
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.GENERATION.RECORD
*------------------------------------------------------------------------------

*Description  : This routine is validation routine attached to version STOCK.ENTRY, REDO.MV to validate lost , damage count
*Linked With  : version STOCK.ENTRY, REDO.MV
*In Parameter : N/A
*Out Parameter: N/A
*Linked File  : REDO.CARD.REQUEST In Read mode
*               STOCK.ENTRY In Read mode

*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 05-08-2010       S.KAVITHA            ODR-2010-03-0400          Initial Creation
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.REDO.CARD.REQUEST
*----------------------------------------------------------------------------------


    Y.APPLICATION="STOCK.ENTRY"
    Y.LOCAL.FIELDS="L.SE.DAMAGED.NO":@VM:"L.SE.CARDS.LOST":@VM:"L.SE.CRD.SERIES"
    Y.FIELD.POS=""
    CALL  MULTI.GET.LOC.REF(Y.APPLICATION,Y.LOCAL.FIELDS,Y.FIELD.POS)
    L.SE.DAMAGED.NO.POS = Y.FIELD.POS<1,1>
    L.SE.CARDS.LOST=Y.FIELD.POS<1,2>
    L.SE.CARDS.SERIES = Y.FIELD.POS<1,3>

    Y.REQ.TOT.COUNT= DCOUNT(R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.DAMAGED.NO.POS>,@SM)
    Y.REQ.COUNT = 1
    LOOP
    WHILE Y.REQ.COUNT LE Y.REQ.TOT.COUNT

        STOCK.ENTRY.DAMAGE.NO = R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.DAMAGED.NO.POS,Y.REQ.COUNT>
        STOCK.ENTRY.CARD.LOST = R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.CARDS.LOST,Y.REQ.COUNT>
        Y.SERIES              = R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.CARDS.SERIES,Y.REQ.COUNT>
*IF STOCK.ENTRY.DAMAGE.NO NE '' AND STOCK.ENTRY.CARD.LOST NE '' THEN
*ETEXT= "EB-DAMAGE.OR.LOST"
*AF = STO.ENT.LOCAL.REF
*AV = L.SE.CARDS.LOST
*AS = Y.REQ.COUNT
*CALL STORE.END.ERROR
*END
        IF STOCK.ENTRY.DAMAGE.NO NE '' OR STOCK.ENTRY.CARD.LOST NE '' THEN
            IF Y.SERIES EQ '' THEN
                ETEXT= "EB-INSMNT.MANDATORY"
                AF = STO.ENT.LOCAL.REF
                AV = L.SE.CARDS.SERIES
                AS = Y.REQ.COUNT
                CALL STORE.END.ERROR
            END
        END
        Y.REQ.COUNT += 1
    REPEAT

RETURN

END
