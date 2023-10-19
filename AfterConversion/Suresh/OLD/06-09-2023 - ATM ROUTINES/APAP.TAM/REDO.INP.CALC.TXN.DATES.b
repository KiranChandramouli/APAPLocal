* @ValidationCode : MjotMTg3NzA0NDYwOTpDcDEyNTI6MTY4MjY4MTkxOTA4ODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 28 Apr 2023 17:08:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------
* <Rating>-140</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.INP.CALC.TXN.DATES(Y.RETURN.DATE)
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.INP.CALC.TXN.DATES
*--------------------------------------------------------------------------------------------------------
*Description  :
*
*Linked With  : Application version T24.FUNDS.SERVICES,LCY.COLLECT , T24.FUNDS.SERVICES, FCY.COLLECT
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 Nov  2010    Mohammed Anies K      ODR-2010-09-0251        Initial Creation
* 28.04.2023       Conversion Tool       R22                  Auto Conversion     - No changes
* 28.04.2023       Shanmugapriya M       R22                  Manual Conversion   - FM TO @FM, VM TO @VM
*
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
    $INSERT I_F.REDO.COLLECT.PARAM
    $INSERT I_F.T24.FUND.SERVICES

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    Y.RETURN.DATE = ''
    GOSUB OPEN.PARA
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*********
OPEN.PARA:
*********

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

    FN.REDO.COLLECT.PARAM = 'F.REDO.COLLECT.PARAM'
    F.REDO.COLLECT.PARAM = ''
    CALL OPF(FN.REDO.COLLECT.PARAM,F.REDO.COLLECT.PARAM)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    GOSUB GET.LOCAL.REF.FIELDS

RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************
    BEGIN CASE
        CASE PGM.VERSION = ',LCY.COLLECT'

            GOSUB LCY.COLLECT.PARA

        CASE PGM.VERSION = ',FCY.COLLECT'

            GOSUB FCY.COLLECT.PARA

    END CASE

RETURN
*--------------------------------------------------------------------------------------------------------
****************
LCY.COLLECT.PARA:
****************
    R.REDO.APAP.CLEAR.PARAM = ''
    REDO.APAP.CLEAR.PARAM.ERR = ''
    Y.REDO.APAP.CLEAR.PARAM.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,Y.REDO.APAP.CLEAR.PARAM.ID,R.REDO.APAP.CLEAR.PARAM,REDO.APAP.CLEAR.PARAM.ERR)

    Y.PARAM.CUTOFF.TIME     = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CUTOFF>
    Y.PARAM.FORWARD.DAYS    = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.FORWARD.DAYS>
    Y.PARAM.BANK.CATEGORY   = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.BANK.CATEGORY>
    Y.PARAM.OPERAND         = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.OPERAND>
    Y.PARAM.AMOUNT          = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.AMOUNT>
    Y.PARAM.TT.FT.TRAN.TYPE.LIST = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.TT.FT.TRAN.TYPE>

    Y.HOURS = Y.PARAM.CUTOFF.TIME[1,2]
    Y.MINS = (Y.HOURS*60)+Y.PARAM.CUTOFF.TIME[4,5]
    Y.TIME.IN.SECS = Y.MINS*60

    Y.TRANSACTION.LIST = R.NEW(TFS.TRANSACTION)
    COMPLETE.TFS.AMOUNT = R.NEW(TFS.AMOUNT)
    CHANGE @VM TO @FM IN COMPLETE.TFS.AMOUNT

    TXN.LIST.COUNT = DCOUNT(Y.TRANSACTION.LIST,@VM)
    CHANGE @VM TO @FM IN Y.TRANSACTION.LIST
    L.TT.CHQ.TYPE.VAL = R.NEW(TFS.LOCAL.REF)<1,LOC.TT.CHQ.TYPE>
    VAR.TEMP.CNT = 1
    LOOP
        REMOVE Y.TRANSACTION FROM Y.TRANSACTION.LIST SETTING Y.TRANSACTION.POS
    WHILE VAR.TEMP.CNT LE TXN.LIST.COUNT

        GET.TFS.AMOUNT = COMPLETE.TFS.AMOUNT<VAR.TEMP.CNT>
        LOCATE Y.TRANSACTION IN Y.PARAM.TT.FT.TRAN.TYPE.LIST<1,1> SETTING Y.TRANS.POS THEN
            GOSUB PROCESS.LCY.COLLECT
        END
        VAR.TEMP.CNT++
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
****************
FCY.COLLECT.PARA:
****************
    R.REDO.COLLECT.PARAM = ''
    REDO.COLLECT.PARAM.ERR = ''
    Y.REDO.COLLECT.PARAM.ID = 'SYSTEM'

    CALL CACHE.READ(FN.REDO.COLLECT.PARAM,Y.REDO.COLLECT.PARAM.ID,R.REDO.COLLECT.PARAM,REDO.COLLECT.PARAM.ERR)

    Y.PARAM.CURRENCY = R.REDO.COLLECT.PARAM<COLLECT.PARAM.CURRENCY>
    Y.PARAM.CUSTOMER.TYPE = R.REDO.COLLECT.PARAM<COLLECT.PARAM.CUST.TYPE>
    Y.PARAM.IN.TRANS.DAYS = R.REDO.COLLECT.PARAM<COLLECT.PARAM.IN.TRANS.DAYS>
    Y.PARAM.CUTOFF = R.REDO.COLLECT.PARAM<COLLECT.PARAM.CUTOFF>
    Y.PARAM.TT.FT.TRAN.TYPE.LIST = R.REDO.COLLECT.PARAM<COLLECT.PARAM.TT.FT.TRAN.TYPE>
    Y.HOURS = Y.PARAM.CUTOFF[1,2]
    Y.MINS = (Y.HOURS*60)+Y.PARAM.CUTOFF[4,5]
    Y.TIME.IN.SECS = Y.MINS*60
    Y.PRIMARY.ACCOUNT = R.NEW(TFS.PRIMARY.ACCOUNT)
    CHANGE @VM TO @FM IN Y.PARAM.IN.TRANS.DAYS
    CHANGE @SM TO @VM IN Y.PARAM.IN.TRANS.DAYS

    CALL F.READ(FN.ACCOUNT,Y.PRIMARY.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNT.ERR)

    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    Y.CURRENCY = R.ACCOUNT<AC.CURRENCY>

    IF Y.CURRENCY EQ LCCY THEN
        RETURN
    END
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.TYPE.OF.CLIENT = R.CUSTOMER<EB.CUS.LOCAL.REF,LOC.CU.TIPO.CL>

    Y.TRANSACTION.LIST = R.NEW(TFS.TRANSACTION)
    TXN.LIST.COUNT = DCOUNT(Y.TRANSACTION.LIST,@VM)
    CHANGE @VM TO @FM IN Y.TRANSACTION.LIST
    VAR.TEMP.CNT = 1
    LOOP
        REMOVE Y.TRANSACTION FROM Y.TRANSACTION.LIST SETTING Y.TRANSACTION.POS
    WHILE VAR.TEMP.CNT LE TXN.LIST.COUNT
        LOCATE Y.TRANSACTION IN Y.PARAM.TT.FT.TRAN.TYPE.LIST<1,1> SETTING Y.TRANS.POS THEN
            GOSUB PROCESS.FCY.COLLECT
        END
        VAR.TEMP.CNT++
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------------
********************
GET.LOCAL.REF.FIELDS:
********************

    LF.APP = 'T24.FUND.SERVICES':@FM:'CUSTOMER'
    LF.FLD = 'L.TT.CHQ.TYPE':@FM:'L.CU.TIPO.CL'
    LF.POS = ''
    CALL MULTI.GET.LOC.REF(LF.APP,LF.FLD,LF.POS)
    LOC.TT.CHQ.TYPE= LF.POS<1,1>
    LOC.CU.TIPO.CL = LF.POS<2,1>

RETURN

*--------------------------------------------------------------------------------------------------------
*******************
PROCESS.LCY.COLLECT:
*******************
    Y.CURRENT.TIME = TIME()

    IF L.TT.CHQ.TYPE.VAL EQ 'BOTH' OR L.TT.CHQ.TYPE.VAL EQ 'OTHERS' THEN
        L.TT.CHQ.TYPE.VAL = 'OTHERS'
    END


    BANK.CATEG.COUNTER = DCOUNT(Y.PARAM.BANK.CATEGORY,@VM)

    BANK.CATEG.COUNTER = BANK.CATEG.COUNTER - 1

    CHANGE @VM TO @FM IN Y.PARAM.BANK.CATEGORY
    CHANGE @VM TO @FM IN Y.PARAM.FORWARD.DAYS
    CHANGE @VM TO @FM IN Y.PARAM.AMOUNT

    LOOP.CNTR = 1
    LOOP
    WHILE LOOP.CNTR LE BANK.CATEG.COUNTER

        GET.CATEGORY = Y.PARAM.BANK.CATEGORY<LOOP.CNTR>

        GET.PARAM.AMT = Y.PARAM.AMOUNT<LOOP.CNTR>

        IF GET.CATEGORY EQ L.TT.CHQ.TYPE.VAL THEN
            GOSUB CHECK.AMOUNT.VALIDATION
        END

        LOOP.CNTR =  LOOP.CNTR + 1

    REPEAT

    GOSUB UPDATE.DETAILS1

RETURN

*--------------------------------------------------------------------------------------------------------
CHECK.AMOUNT.VALIDATION:

    IF GET.PARAM.AMT  THEN

        IF GET.TFS.AMOUNT LT GET.PARAM.AMT THEN
            Y.CALC.FORW.DAYS  = Y.PARAM.FORWARD.DAYS<LOOP.CNTR>
        END ELSE
            Y.CALC.FORW.DAYS  = Y.PARAM.FORWARD.DAYS<LOOP.CNTR + 1>
        END

    END ELSE
        Y.CALC.FORW.DAYS  = Y.PARAM.FORWARD.DAYS<LOOP.CNTR>

    END

RETURN
*---------------------------------------------------------------------------------------------------------
*******************
PROCESS.FCY.COLLECT:
*******************

    LOCATE Y.CURRENCY IN Y.PARAM.CURRENCY<1,1> SETTING Y.CURRENCY.POS THEN
        CHANGE @VM TO @FM IN Y.PARAM.CUSTOMER.TYPE
        CHANGE @SM TO @VM IN Y.PARAM.CUSTOMER.TYPE
        LOCATE Y.TYPE.OF.CLIENT IN Y.PARAM.CUSTOMER.TYPE<1,Y.CURRENCY.POS> SETTING Y.TYPE.OF.CLIENT.POS THEN
            Y.CALC.FORW.DAYS = Y.PARAM.IN.TRANS.DAYS<Y.CURRENCY.POS,Y.TYPE.OF.CLIENT.POS>
        END
    END

    Y.CURRENT.TIME = TIME()

    GOSUB UPDATE.DETAILS2


RETURN
*--------------------------------------------------------------------------------------------------------
****************
UPDATE.DETAILS1:
****************
    Y.CALC.FORW.DAYS  = '1'
    IF Y.CURRENT.TIME GT Y.TIME.IN.SECS THEN
        Y.CALC.FORW.DAYS = '2'
    END
    Y.REGION=""
    Y.TODAY.DATE = TODAY
    CALL CDT(Y.REGION,Y.TODAY.DATE,"+":Y.CALC.FORW.DAYS:"W")

    Y.RETURN.DATE<-1> = Y.TODAY.DATE



*R.NEW(TFS.CR.VALUE.DATE)<1,VAR.TEMP.CNT> = TODAY
*R.NEW(TFS.DR.VALUE.DATE)<1,VAR.TEMP.CNT> = TODAY
*R.NEW(TFS.CR.EXP.DATE)<1,VAR.TEMP.CNT>   = TODAY
*R.NEW(TFS.DR.EXP.DATE)<1,VAR.TEMP.CNT>   = TODAY
RETURN

****************
UPDATE.DETAILS2:
****************
    Y.CALC.FORW.DAYS  = '1'
    IF Y.CURRENT.TIME GT Y.TIME.IN.SECS THEN
        Y.CALC.FORW.DAYS = '2'
    END

    Y.REGION=""
    Y.TODAY.DATE = TODAY
    CALL CDT(Y.REGION,Y.TODAY.DATE,"+":Y.CALC.FORW.DAYS:"W")
    Y.RETURN.DATE<-1> = Y.TODAY.DATE

*R.NEW(TFS.CR.VALUE.DATE)<1,VAR.TEMP.CNT> = TODAY
*R.NEW(TFS.DR.VALUE.DATE)<1,VAR.TEMP.CNT> = TODAY
*R.NEW(TFS.CR.EXP.DATE)<1,VAR.TEMP.CNT>   = TODAY
*R.NEW(TFS.DR.EXP.DATE)<1,VAR.TEMP.CNT>   = TODAY

RETURN
*--------------------------------------------------------------------------------------------------------
END
