*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.DEFAULT.DETAILS
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.GENERATION.RECORD
*------------------------------------------------------------------------------

*Description  : This routine is validation routine attached to version STOCK.ENTRY, REDO.MV to default card details in STOCK.ENTRY
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
* 28-07-2010    Jeyachandran S         ODR-2010-03-0400          Initial Creation
*--------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STOCK.ENTRY
$INSERT I_F.REDO.CARD.REQUEST
*----------------------------------------------------------------------------------

**********
MAIN.PARA:
**********

  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA
  RETURN

*----------------------------------------------------------------------
***********
OPEN.PARA:
***********
  FN.REDO.CARD.REQUEST='F.REDO.CARD.REQUEST'
  F.REDO.CARD.REQUEST=''
  CALL OPF(FN.REDO.CARD.REQUEST, F.REDO.CARD.REQUEST)

  Y.REQ.COUNT=1
  RETURN

*-----------------------------------------------------------------------

************
PROCESS.PARA:
************

  Y.APPLICATION="STOCK.ENTRY"
  Y.LOCAL.FIELDS="L.SE.BATCH.NO"
  Y.FIELD.POS=""
  CALL  MULTI.GET.LOC.REF(Y.APPLICATION,Y.LOCAL.FIELDS,Y.FIELD.POS)
  L.SE.BATCH.NO.POS = Y.FIELD.POS<1,1>

  Y.REDO.CARD.REQUEST.ID = COMI
  CALL F.READ(FN.REDO.CARD.REQUEST,Y.REDO.CARD.REQUEST.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,F.ERR)
  Y.REQ.TOT.COUNT= DCOUNT(R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.START.NO>,VM)

  LOOP
  WHILE Y.REQ.COUNT LE Y.REQ.TOT.COUNT
    Y.TO.REGISTER = R.NEW(STO.ENT.TO.REGISTER)
    Y.FROM.REGISTER = R.NEW(STO.ENT.FROM.REGISTER)
    STOCK.QTY = R.REDO.CARD.REQUEST<REDO.CARD.REQ.REGOFF.ACCEPTQTY,Y.REQ.COUNT>
    START.NO = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.START.NO,Y.REQ.COUNT>
    SERIES.ID = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CARD.SERIES.ID,Y.REQ.COUNT>

    R.NEW(STO.ENT.STOCK.QUANTITY)<1,Y.REQ.COUNT> = STOCK.QTY
    R.NEW(STO.ENT.STOCK.START.NO)<1,Y.REQ.COUNT>= START.NO
    R.NEW(STO.ENT.STOCK.SERIES)<1,Y.REQ.COUNT>= SERIES.ID

    Y.REQ.COUNT=Y.REQ.COUNT+1
  REPEAT
  RETURN
END
