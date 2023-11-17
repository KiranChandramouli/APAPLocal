* @ValidationCode : MjotMTE3MjMwMTA5NzpDcDEyNTI6MTY4MDY3NDc1MTM5MzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 11:35:51
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

SUBROUTINE REDO.CLEAR.WAIVE.CHARGE
*-----------------------------------------------------------------------------
* Description:
* This routine is a validate routine for REDO.CLEARING.INWARD template and it default the
* charge amount from FT.CHARGE.TYPE or FT.COMMISSION.TYPE application
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : -NA-
* OUT    : -NA-
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : GANESH R
* PROGRAM NAME : REDO.CLEAR.WAIVE.CHARGE
*---------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO               REFERENCE           DESCRIPTION
* 04.10.2010       Arulpraksam P     ODR-2010-09-0148    INITIAL CREATION
* 30 8 2011        GANESH R          PACS0099575
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - VM TO @VM, FM TO @FM, F TO CACHE
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.REDO.APAP.CLEARING.INWARD
    $INSERT I_F.REDO.APAP.CLEAR.PARAM

    GOSUB INIT
    GOSUB PROCESS

RETURN

*---------------------------------------------------------------------------------------------------
*****
INIT:
*****

    FN.FT.CHARGE.TYPE = 'F.FT.CHARGE.TYPE'
    F.FT.CHARGE.TYPE  = ''
    CALL OPF(FN.FT.CHARGE.TYPE,F.FT.CHARGE.TYPE)

    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE  = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.APAP.CLEAR.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.CLEAR.PARAM  = ''
    CALL OPF(FN.REDO.APAP.CLEAR.PARAM,F.REDO.APAP.CLEAR.PARAM)

RETURN

*--------------------------------------------------------------------------------------------------------
********
PROCESS:
********


    GOSUB FIND.MULTI.LOCAL.REF
    Y.ACCOUNT = R.NEW(CLEAR.CHQ.ACCOUNT.NO)
    CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACCOUNTE.ERR)
    IF R.ACCOUNT THEN
        Y.CUSTOMER.NO = R.ACCOUNT<AC.CUSTOMER>
        Y.CURRENCY    = R.ACCOUNT<AC.CURRENCY>
        ACCT.OFFICER  = R.ACCOUNT<AC.ACCOUNT.OFFICER>
        Y.CO.CODE     = R.ACCOUNT<AC.CO.CODE>
    END

    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER.NO,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    IF R.CUSTOMER THEN
        Y.SEGMENTO    = R.CUSTOMER<EB.CUS.LOCAL.REF,L.CU.SEGMENTO.POS>
    END

    CALL CACHE.READ(FN.REDO.APAP.CLEAR.PARAM,'SYSTEM',R.REDO.APAP.CLEAR.PARAM,REDO.APAP.CLEAR.PARAM.ERR)
    Y.CUSTOMER.TYPE = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.CUSTOMER.TYPE>
    CHANGE @VM TO @FM IN Y.CUSTOMER.TYPE

    LOCATE Y.SEGMENTO IN Y.CUSTOMER.TYPE SETTING Y.SEG.POS THEN
        Y.FT.REF.CHG = R.REDO.APAP.CLEAR.PARAM<CLEAR.PARAM.FT.REF.CHG,Y.SEG.POS>
    END

    GOSUB GET.GROUP.DETAILS


*PACS00112979 -S
    GOSUB VALIDATE.CHARGE.TYPE
*PACS00112979 -E

RETURN

*--------------------------------------------------------------------------------------------------------
******************
GET.GROUP.DETAILS:
******************


    CUSTOMER.ID = Y.CUSTOMER.NO
    DEAL.AMOUNT =  R.NEW(CLEAR.CHQ.AMOUNT)
    DEAL.CURRENCY = Y.CURRENCY
    CCY.MKT = '1'
    CROSS.RATE = ""
    CROSS.CURRENCY = DEAL.CURRENCY
    DRAWDOWN.CURRENCY = CROSS.CURRENCY
    T.DATA = ""
    TOTAL.FOREIGN.AMT = ""
    TOTAL.LOCAL.AMT = ""
    TOTAL.AMT = ""
    T.DATA<1,1> = Y.FT.REF.CHG

    CALL CALCULATE.CHARGE(CUSTOMER.ID, DEAL.AMOUNT, DEAL.CURRENCY, CCY.MKT, CROSS.RATE,CROSS.CURRENCY, DRAWDOWN.CURRENCY, T.DATA, '', TOTAL.LOCAL.AMT, TOTAL.FOREIGN.AMT)
    VAR.TOT.CHG.AMT = T.DATA<4,1>

    IF COMI EQ 'NO' OR COMI EQ '' THEN
        R.NEW(CLEAR.CHQ.CHG.AMOUNT) = VAR.TOT.CHG.AMT
    END
    IF COMI EQ 'YES' THEN
        R.NEW(CLEAR.CHQ.CHG.AMOUNT) = 0.00
    END

RETURN

*-------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************

    APPL.ARRAY = 'CUSTOMER'
    FLD.ARRAY = 'L.CU.SEGMENTO'

    FLD.POS = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    L.CU.SEGMENTO.POS = FLD.POS<1,1>

RETURN
*-----------------------------------------------------------------------------------------------------
VALIDATE.CHARGE.TYPE:


    GET.FT.REF.CHG = R.NEW(CLEAR.CHQ.CHARGE.TYPE)
    R.FT.TXN.TYPE.CONDITION = ''
    R.FT.CHARGE.TYPE = ''

    IF GET.FT.REF.CHG THEN
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, GET.FT.REF.CHG, R.FT.TXN.TYPE.CONDITION, FT.ERR)     ;** R22 Auto conversion - F TO CACHE
        IF NOT(R.FT.TXN.TYPE.CONDITION) THEN
            CALL CACHE.READ(FN.FT.CHARGE.TYPE, GET.FT.REF.CHG, R.FT.CHARGE.TYPE, CHG.ERR)       ;** R22 Auto conversion - F TO CACHE
        END

    END

RETURN
*--------------
END
