* @ValidationCode : Mjo4MjIzMzgyMzc6Q3AxMjUyOjE2ODE4MTUwNzA0NjM6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 18 Apr 2023 16:21:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.VIRGIN.CARD.RETURN.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.VIRGIN.CARD.RETURN.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a authorisation routine to update the status of damaged cards in STOCK.REGISTER and
*               REDO.CARD.NUMBERS
*Linked With  : Application REDO.CARD.DAMAGE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*                  Jeeva
*   16 apr 2011   Balagurunathan                                 issue fix for TDN4 delivery
*   6  JUN  2011  KAVITHA                PACS00024249            PACS00024249 FIX
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*18/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION         FM TO @FM, VM TO @VM, = TO EQ, Y.CNT + 1 TO +=1
*18/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.STOCK.REGISTER
    $INSERT I_F.REDO.STOCK.ENTRY
    $INSERT I_F.DATES
    $INSERT I_F.COMPANY
    $INSERT I_F.USER
    $INSERT I_F.REDO.BRANCH.CARD.RETURN
    $INSERT I_F.REDO.CARD.NO.LOCK
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_F.REDO.STOCK.QTY.COUNT
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.VIRGIN.CARD.RETURN
    $INSERT I_F.REDO.CARD.REG.STOCK
*   $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.BRANCH.REQ.STOCK


    GOSUB MAIN.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

    R.NEW(REDO.VIR.RTN.CARD.TYPE.PRE)<1,-1>=R.NEW(REDO.VIR.RTN.CARD.TYPE)
    R.NEW(REDO.VIR.RTN.NUM.OF.CARDS.PRE)<1,-1>=R.NEW(REDO.VIR.RTN.NUMBER.OF.CARDS)
    R.NEW(REDO.VIR.RTN.DESCRIPTION.PRE)<1,-1>=R.NEW(REDO.VIR.RTN.DESCRIPTION)

    R.NEW(REDO.VIR.RTN.CARD.TYPE)=''
    R.NEW(REDO.VIR.RTN.NUMBER.OF.CARDS)=''
    R.NEW(REDO.VIR.RTN.DESCRIPTION)=''

RETURN
*--------------------------------------------------------------------------------------------------------

**********
OPEN.PARA:
**********
* In this para of code file variables are initialised and opened


    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

    FN.BRANCH.REQ.STOCK = 'F.REDO.BRANCH.REQ.STOCK'
    F.BRANCH.REQ.STOCK = ''
    CALL OPF(FN.BRANCH.REQ.STOCK,F.BRANCH.REQ.STOCK)


    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

    FN.REDO.CARD.REG.STOCK = 'F.REDO.CARD.REG.STOCK'
    F.REDO.CARD.REG.STOCK = ''
    CALL OPF(FN.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK)


    FN.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.SERIES.PARAM = ''
    CALL OPF(FN.SERIES.PARAM,F.SERIES.PARAM)

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    FN.REDO.STOCK.REG = 'F.REDO.STOCK.REGISTER'
    F.REDO.STOCK.REG = ''
    CALL OPF(FN.REDO.STOCK.REG,F.REDO.STOCK.REG)

    FN.REDO.BRANCH.REQ.STOCK = 'F.REDO.BRANCH.REQ.STOCK'
    F.REDO.BRANCH.REQ.STOCK= ''
    CALL OPF(FN.REDO.BRANCH.REQ.STOCK,F.REDO.BRANCH.REQ.STOCK)

    FINAL.COMP = R.COMPANY(EB.COM.FINANCIAL.COM)
    Y.ID.CARD.SERIES = 'SYSTEM'
    CALL CACHE.READ(FN.SERIES.PARAM,Y.ID.CARD.SERIES,R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    VIRGIN.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.VIRGIN.DEPT.CODE>
    RECD.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.RECEIVE.DEPT.CODE>
    EMBOSS.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.EMBOSS.DEPT.CODE>

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* Main processing section
    Y.STOCK.REGISTER.ID = 'CARD.':ID.COMPANY:'-':VIRGIN.DEPT.CODE
    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)

    CARD.TYPE.PARAM = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>
    CARD.SERIES.PARAM = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES>

    CHANGE @VM TO @FM IN CARD.SERIES.PARAM
    CHANGE @VM TO @FM IN CARD.TYPE.PARAM

    GOSUB SUBPROCESS

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
UPDATE.STOCK.REGISTER:
*********************

    Y.SERIES.ID = Y.SERIES.ID

    STOCK.SERIES.ID = R.STOCK.REGISTER<STK.REG.SERIES.ID>
    CHANGE @VM TO @FM IN STOCK.SERIES.ID
    LOCATE Y.SERIES.ID IN STOCK.SERIES.ID SETTING Y.SERIES.ID.POS THEN
        Y.NEW.SERIES.BAL = R.STOCK.REGISTER<STK.REG.SERIES.BAL,Y.SERIES.ID.POS> - Y.TOT.DAMAGES.LOST
        R.STOCK.REGISTER<STK.REG.SERIES.BAL,Y.SERIES.ID.POS> = Y.NEW.SERIES.BAL

        R.STOCK.REGISTER<STK.REG.STO.REG.BAL> = R.STOCK.REGISTER<STK.REG.STO.REG.BAL> - Y.TOT.DAMAGES.LOST

    END
RETURN
*--------------------------------------------------------------------------------------------------------
*********************
READ.STOCK.REGISTER:
*****************
*STOCK.REGISTER record is read for the given stock entry id
    R.STOCK.REGISTER   =''
    STOCK.REGISTER.ERR = ''
    CALL F.READU(FN.REDO.STOCK.REG,Y.STOCK.REGISTER.ID,R.STOCK.REGISTER,F.REDO.STOCK.REG,STOCK.REGISTER.ERR,'P')

RETURN
*--------------------------------------------------------------------------------------------------------
SUBPROCESS:
******************************************************************************************

    Y.CARD.NUMBER = R.NEW(REDO.VIR.RTN.CARD.TYPE)
    Y.COUNT = DCOUNT(Y.CARD.NUMBER,@VM)
    Y.TOT.DAMAGES = R.NEW(REDO.VIR.RTN.NUMBER.OF.CARDS)
    CHANGE @VM TO @FM IN Y.CARD.NUMBER
    Y.CNT = 1
    GOSUB READ.STOCK.REGISTER
    LOOP
    WHILE Y.CNT LE Y.COUNT
        Y.CARD.NUM = Y.CARD.NUMBER<Y.CNT>

        Y.TOT.DAMAGES.LOST = Y.TOT.DAMAGES<1,Y.CNT>
        GOSUB CARD.NUM.UPDATE

        LOCATE Y.CARD.NUM IN CARD.TYPE.PARAM SETTING LOC.POS THEN
            CARD.SER.FETCH = CARD.SERIES.PARAM<LOC.POS>
        END

        GOSUB CONCATE.TAB.UPDATE

        TOT.CNTR = ''
        CARD.AVAIL.BAL = ''
        STORE.AVAIL.BAL = ''
        CARD.SER.FETCH = ''
        SERIES.POS = ''
        RETRIEVE.CARD.SER = ''
        Y.TOT.DAMAGES.LOST = ''
        Y.CARD.NUM = ''

        Y.CNT += 1 ;*AUTO R22 CODE CONVERSION
    REPEAT

* PACS00755208 - S
    IF R.STOCK.REGISTER<STK.REG.SERIES.BAL,Y.SERIES.ID.POS> LT '0' THEN
        R.STOCK.REGISTER<STK.REG.SERIES.BAL,Y.SERIES.ID.POS> = '0'
    END
* PACS00755208 - E

    CALL F.WRITE(FN.REDO.STOCK.REG,Y.STOCK.REGISTER.ID,R.STOCK.REGISTER)
RETURN
******************************************************************************************
CARD.NUM.UPDATE:
******************************************************************************************


    Y.CARD.TYPE = Y.CARD.NUM
    Y.CARD.ALL = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>
    Y.SERIES.CARD = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES>
    CHANGE @VM TO @FM IN Y.CARD.ALL
    LOCATE Y.CARD.TYPE IN Y.CARD.ALL SETTING POS1 THEN
        Y.SERIES.ID = Y.SERIES.CARD<1,POS1>
        Y.LOCAL.ID = Y.SERIES.CARD<1,POS1>
    END
    GOSUB UPDATE.STOCK.REGISTER

RETURN
*--------
CONCATE.TAB.UPDATE:

*PACS00024249-S
    CALL F.READU(FN.REDO.CARD.REG.STOCK,CARD.SER.FETCH,R.REDO.CARD.REG.STOCK,F.REDO.CARD.REG.STOCK,STOCK.ERR,"")
    IF R.REDO.CARD.REG.STOCK THEN
        CARD.AVAIL.BAL = R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.BAL>
        STORE.AVAIL.BAL = CARD.AVAIL.BAL
        CARD.AVAIL.BAL -= Y.TOT.DAMAGES.LOST
        R.REDO.CARD.REG.STOCK<REDO.CARD.REG.STOCK.SERIES.BAL> = CARD.AVAIL.BAL
    END
    CALL F.WRITE(FN.REDO.CARD.REG.STOCK,CARD.SER.FETCH,R.REDO.CARD.REG.STOCK)

    CONCAT.FILE.ID = TODAY:"-":CARD.SER.FETCH
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
*-----------------------
APPEND.RETURN.VAL:

    IF LOC.RET.FLAG EQ 'Y' THEN ;*AUTO R22 CODE CONVERSION
        TOT.CNTR += 1
    END ELSE
        TOT.CNTR = 1
    END

    R.BRANCH.REQ.STOCK<BRAN.STK.CARD.TYPE> = Y.CARD.NUM
    R.BRANCH.REQ.STOCK<BRAN.STK.INITIAL.STK,TOT.CNTR> = STORE.AVAIL.BAL
    R.BRANCH.REQ.STOCK<BRAN.STK.REQUEST.ID,TOT.CNTR> = ID.NEW
*    IF PGM.VERSION = ',CREATE' THEN
    R.BRANCH.REQ.STOCK<BRAN.STK.RETURN,TOT.CNTR> = Y.TOT.DAMAGES.LOST
*    END
    R.BRANCH.REQ.STOCK<BRAN.STK.CURRENT.QTY,TOT.CNTR> = STORE.AVAIL.BAL - Y.TOT.DAMAGES.LOST
    R.BRANCH.REQ.STOCK<BRAN.STK.TXN.DATE> = TODAY

RETURN
*PACS00024249-E
*---------------------
END
