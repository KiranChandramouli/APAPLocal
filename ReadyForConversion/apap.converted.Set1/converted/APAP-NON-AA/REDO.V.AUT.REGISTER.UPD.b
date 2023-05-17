SUBROUTINE REDO.V.AUT.REGISTER.UPD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.AUT.REGISTER.UPD
*--------------------------------------------------------------------------------------------------------
*Description  : This is an authorisation routine to update STOCK.REGISTER
*Linked With  : STOCK.ENTRY,REDO.CARDMV
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 4 Aug 2010    Mohammed Anies K       ODR-2010-03-0400         Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.STOCK.ENTRY
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_F.REDO.CARD.REQUEST


    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.STOCK.ENTRY = 'F.STOCK.ENTRY'
    F.STOCK.ENTRY = ''
    CALL OPF(FN.STOCK.ENTRY,F.STOCK.ENTRY)

    FN.STOCK.REGISTER = 'F.STOCK.REGISTER'
    F.STOCK.REGISTER = ''
    CALL OPF(FN.STOCK.REGISTER,F.STOCK.REGISTER)

    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)

    R.STOCK.REGISTER = ''
    REG.ID = ''
    Y.NO.DAMAGE.CARD = ''
    Y.NO.LOST.CARD = ''
    Y.DAMAGE.LOST.NO = ''

RETURN

*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------
* used to update the STOCK.REGISTER for no.of card demaged
* number of demaged card details can be ontained from the local reference field created in STOCK.ENTRY application



*Y.REDO.CARD.REQUEST.ID=R.NEW(STO.ENT.LOCAL.REF)<1,L.SE.BATCH.NO.POS>
    Y.REDO.CARD.REQUEST.ID = R.NEW(STK.BATCH.NO)
    CALL F.READ(FN.REDO.CARD.REQUEST,Y.REDO.CARD.REQUEST.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,F.ERR)

*NOTES = R.NEW(STO.ENT.NOTES)
    NOTES = R.NEW(STK.NOTES)
    CHANGE @VM TO @FM IN NOTES
    CHANGE @SM TO @FM IN NOTES
    NOTES = NOTES<1>
    IF NOTES EQ "PRINTING" THEN
        R.REDO.CARD.REQUEST<REDO.CARD.REQ.PRINTING.SE.ID> = ID.NEW
    END
    IF NOTES EQ "DELIVERY TO TRANSIT" THEN
        R.REDO.CARD.REQUEST<REDO.CARD.REQ.TRANSIT.SE.ID> = ID.NEW
    END
    IF NOTES EQ "DELIVERY TO BRANCH" THEN
        R.REDO.CARD.REQUEST<REDO.CARD.REQ.BRANCH.SE.ID> = ID.NEW
    END


    CALL F.WRITE(FN.REDO.CARD.REQUEST,Y.REDO.CARD.REQUEST.ID,R.REDO.CARD.REQUEST)

RETURN
*-------------------------------------------------------------------------------------------------------
END
