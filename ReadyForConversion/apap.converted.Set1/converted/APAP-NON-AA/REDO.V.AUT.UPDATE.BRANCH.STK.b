SUBROUTINE REDO.V.AUT.UPDATE.BRANCH.STK
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.AUT.UPDATE.BRANCH.STK
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
* 11 Mar 2011    Swaminathan            ODR-2010-03-0400         Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.STOCK.ENTRY
    $INSERT I_F.REDO.BRANCH.REQ.STOCK

    GOSUB INITIALIZE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
INITIALIZE:
*-----------------------------------------------------------------------------

    FN.BRANCH.REQ.STOCK = 'F.REDO.BRANCH.REQ.STOCK'
    F.BRANCH.REQ.STOCK = ''
    CALL OPF(FN.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK)

RETURN

*-------------------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------------------


    R.BRANCH.REQ.STOCK = ''
    Y.INTIAL = ''

    Y.TOT.CARD.SERIES = DCOUNT(R.NEW(STO.ENT.STOCK.SERIES),@VM)

    Y.INIT.CARD.SERIES = 1
    LOOP
    WHILE Y.INIT.CARD.SERIES LE Y.TOT.CARD.SERIES
        Y.STOCK.SERIES = R.NEW(STO.ENT.STOCK.SERIES)<1,Y.INIT.CARD.SERIES>
        Y.STK.QTY = R.NEW(STO.ENT.STOCK.QUANTITY)<1,Y.INIT.CARD.SERIES>
*       CALL F.READ(FN.BRANCH.REQ.STOCK,Y.STOCK.SERIES,R.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK,Y.ERR)
*        R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.LOAD> = Y.STK.QTY
*        R.BRANCH.REQ.STOCK<BRAN.STK.LOAD.DATE> = TODAY
*        R.BRANCH.REQ.STOCK<BRAN.STK.LOAD.DATE> = R.NEW(STO.ENT.IN.OUT.DATE)
*<<<<<<<<<<<<<<<<<<<<<<<<<<< CHANGES HAS TO BE CONFIRM>>>>>>>>>>>>>>>>>>>>>>>*
        CALL F.READ(FN.BRANCH.REQ.STOCK,Y.STOCK.SERIES,R.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK,Y.ERR)
        R.BRANCH.REQ.STOCK<BRAN.STK.LOAD.DATE> = R.NEW(STO.ENT.IN.OUT.DATE)
*     Y.INTIAL = R.BRANCH.REQ.STOCK<BRAN.STK.FINALY.QTY>
*      IF Y.INTIAL THEN
*          Y.COUNT = DCOUNT(Y.INTIAL,VM)
*          Y.STK.QTY =  Y.INTIAL<1,Y.COUNT> + Y.STK.QTY
*          R.BRANCH.REQ.STOCK<BRAN.STK.FINALY.QTY,Y.COUNT> = Y.STK.QTY
*      END
        Y.INTIAL = R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.LOAD>
        R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.LOAD> = Y.INTIAL + Y.STK.QTY
        R.BRANCH.REQ.STOCK<BRAN.STK.LAST.STOCK.REQ>=Y.STK.QTY + R.BRANCH.REQ.STOCK<BRAN.STK.LAST.STOCK.REQ>
*>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
        CALL F.WRITE(FN.BRANCH.REQ.STOCK,Y.STOCK.SERIES,R.BRANCH.REQ.STOCK)
        Y.INIT.CARD.SERIES + = 1
    REPEAT

RETURN
*-----------------------------------------------------------------------------------
END
