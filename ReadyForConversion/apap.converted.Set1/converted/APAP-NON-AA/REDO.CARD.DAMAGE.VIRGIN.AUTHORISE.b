SUBROUTINE REDO.CARD.DAMAGE.VIRGIN.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DAMAGE.VIRGIN.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : Defaulting the Values for the REDO.CARD.DAMAGE.VIRGIN
*Linked With  : Application REDO.CARD.DAMAGE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 MAY 2011     JEEVA T               ODR-2010-03-0400        Initail Draft
* 6 JUN  2011     KAVITHA               PACS00024249            PACS00024249 FIX
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COMPANY
    $INSERT I_F.REDO.CARD.DAMAGE.VIRGIN
    $INSERT I_F.REDO.CARD.REG.STOCK
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_F.REDO.BRANCH.REQ.STOCK
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened

    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    FN.REDO.STOCK.REGISTER = 'F.REDO.STOCK.REGISTER'
    F.REDO.STOCK.REGISTER = ''
    CALL OPF(FN.REDO.STOCK.REGISTER,F.REDO.STOCK.REGISTER)

    FN.REDO.CARD.REG.STOCK = 'F.REDO.CARD.REG.STOCK'
    F.REDO.CARD.REG.STOCK = ''
    CALL OPF(FN.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK)

    FN.BRANCH.REQ.STOCK = 'F.REDO.BRANCH.REQ.STOCK'
    F.BRANCH.REQ.STOCK = ''
    CALL OPF(FN.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK)

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section


    Y.ID = R.NEW(CARD.RET.REG.ID)
    CALL F.READU(FN.REDO.STOCK.REGISTER,Y.ID,R.REDO.STOCK.REGISTER,F.REDO.STOCK.REGISTER,Y.ERR,'')
    Y.STOCK.SERIES.ID = R.REDO.STOCK.REGISTER<STK.REG.SERIES.ID>
    Y.STOCK.SERIES.BAL = R.REDO.STOCK.REGISTER<STK.REG.SERIES.BAL>
    Y.LOST.LIST = R.NEW(CARD.RET.LOST)
    Y.DAMAGE.LIST = R.NEW(CARD.RET.DAMAGE)
    GOSUB CARD.TYPE.CHECK

RETURN
*--------------------------------------------------------------------------------------------------------
CARD.TYPE.CHECK:
*--------------------------------------------------------------------------------------------------------

    Y.CARD.TYPE.NEW = R.NEW(CARD.RET.CARD.TYPE)
    Y.CARD.SERIES = R.NEW(CARD.RET.SERIES)
    Y.COUNT = DCOUNT(Y.CARD.TYPE.NEW,@VM)
    Y.CNT = 1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        Y.SERIES.VAL =  Y.CARD.SERIES<1,Y.CNT>
        Y.LOST.VAL = Y.LOST.LIST<1,Y.CNT>
        Y.DAMAGE.VAL = Y.DAMAGE.LIST<1,Y.CNT>
        GOSUB CHECK.STOCK.REG
        GOSUB CONCAT.UPDATE.TABLE

        Y.LOST.VAL = ''
        Y.DAMAGE.VAL = ''
        Y.CNT += 1
    REPEAT
    R.REDO.STOCK.REGISTER<STK.REG.STO.REG.BAL> = SUM(R.REDO.STOCK.REGISTER<STK.REG.SERIES.BAL>)
    CALL F.WRITE(FN.REDO.STOCK.REGISTER,Y.ID,R.REDO.STOCK.REGISTER)
RETURN
*--------------------------------------------------------------------------------------------------------
CHECK.STOCK.REG:
*--------------------------------------------------------------------------------------------------------
    LOCATE Y.SERIES.VAL IN Y.STOCK.SERIES.ID<1,1> SETTING POS1 THEN
        Y.STCK.SER.VAL = Y.STOCK.SERIES.BAL<1,POS1>
        IF Y.LOST.VAL AND NOT(Y.DAMAGE.VAL) THEN
            R.REDO.STOCK.REGISTER<STK.REG.SERIES.BAL,POS1> = Y.STOCK.SERIES.BAL<1,POS1> - Y.LOST.VAL
        END
        IF NOT(Y.LOST.VAL) AND Y.DAMAGE.VAL THEN
            R.REDO.STOCK.REGISTER<STK.REG.SERIES.BAL,POS1> = Y.STOCK.SERIES.BAL<1,POS1> - Y.DAMAGE.VAL
        END
        IF Y.LOST.VAL AND Y.DAMAGE.VAL THEN
            Y.TOT = Y.LOST.VAL + Y.DAMAGE.VAL
            R.REDO.STOCK.REGISTER<STK.REG.SERIES.BAL,POS1> = Y.STOCK.SERIES.BAL<1,POS1> - Y.TOT
        END
    END
RETURN
*-----------
CONCAT.UPDATE.TABLE:

*PACS00024249 -S
    CALL F.READU(FN.REDO.CARD.REG.STOCK,Y.SERIES.VAL,R.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK,STOCK.ERR,"")
    IF R.REDO.CARD.REG.STOCK THEN
        CARD.AVAIL.BAL = R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.BAL>
        Y.AVAIL.BAL=CARD.AVAIL.BAL
        CARD.AVAIL.BAL = CARD.AVAIL.BAL - Y.LOST.VAL - Y.DAMAGE.VAL
        R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.BAL> = CARD.AVAIL.BAL
    END

    CALL F.WRITE(FN.REDO.CARD.REG.STOCK,Y.SERIES.VAL,R.REDO.CARD.REG.STOCK)
    GOSUB CONCATE.TAB.UPDATE
RETURN
*-----------------
CONCATE.TAB.UPDATE:
*-----------------
    CONCAT.FILE.ID = TODAY:"-":Y.SERIES.VAL
    CALL F.READU(FN.BRANCH.REQ.STOCK,CONCAT.FILE.ID,R.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK,STK.ENT.ERR,'P')
    IF R.BRANCH.REQ.STOCK THEN
        TOT.CNTR = DCOUNT(R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK>,@VM)
        IF TOT.CNTR LT 1 THEN
            TOT.CNTR = DCOUNT(R.BRANCH.REQ.STOCK<BRAN.STK.VIRGIN.LOAD>,@VM)
        END
        LOOP.REST.CNT = TOT.CNTR
        LOC.RET.FLAG = 'Y'
    END
    GOSUB APPEND.RETURN.VAL
    CALL F.WRITE(FN.BRANCH.REQ.STOCK,CONCAT.FILE.ID,R.BRANCH.REQ.STOCK)
RETURN

*-----------------
APPEND.RETURN.VAL:
*-----------------
    IF LOC.RET.FLAG EQ 'Y' THEN
        TOT.CNTR += 1
    END ELSE
        TOT.CNTR = 1
    END

    R.BRANCH.REQ.STOCK<BRAN.STK.CARD.TYPE> = Y.CARD.TYPE.NEW<1,Y.CNT>
    R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK,TOT.CNTR> = Y.AVAIL.BAL
    R.BRANCH.REQ.STOCK<BRAN.STK.REQUEST.ID,TOT.CNTR> = ID.NEW
    R.BRANCH.REQ.STOCK<BRAN.STK.LOST,TOT.CNTR> = Y.LOST.VAL
    R.BRANCH.REQ.STOCK<BRAN.STK.DAMAGE,TOT.CNTR> =Y.DAMAGE.VAL
    R.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY,TOT.CNTR> = Y.AVAIL.BAL- Y.LOST.VAL - Y.DAMAGE.VAL
    R.BRANCH.REQ.STOCK<BRAN.STK.TXN.DATE> = TODAY

RETURN
END
