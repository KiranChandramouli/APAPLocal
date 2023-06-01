* @ValidationCode : MjotMTYwODIxMTI4NDpDcDEyNTI6MTY4NDg1NDM5MjY4NDpJVFNTOi0xOi0xOjg3ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 878
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.MM.EFF.RATE.ACCR.LOAD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.B.MM.EFF.RATE.ACCR.LOAD
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.B.MM.EFF.RATE.ACCR.LOAD is the load routine to load all the variables required for the process
*Linked With  :
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date           Who                  Reference           Description
* ------         ------               -------------       -------------
* 12 FEB 2013    Balagurunathan B     RTC-553577          Initial Creation
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - FM TO @FM
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MM.EFF.RATE.ACCR.COMMON
    $INSERT I_F.REDO.APAP.H.PRODUCT.DEFINE
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

    FN.MM.MONEY.MARKET = 'F.MM.MONEY.MARKET'
    F.MM.MONEY.MARKET = ''
    CALL OPF(FN.MM.MONEY.MARKET,F.MM.MONEY.MARKET)

    FN.REDO.APAP.H.PRODUCT.DEFINE = 'F.REDO.APAP.H.PRODUCT.DEFINE'
    F.REDO.APAP.H.PRODUCT.DEFINE = ''
    CALL OPF(FN.REDO.APAP.H.PRODUCT.DEFINE,F.REDO.APAP.H.PRODUCT.DEFINE)

    FN.LMM.INSTALL.CONDS = 'F.LMM.INSTALL.CONDS'
    F.LMM.INSTALL.CONDS = ''
    CALL OPF(FN.LMM.INSTALL.CONDS,F.LMM.INSTALL.CONDS)

    FN.LMM.ACCOUNT.BALANCES = 'F.LMM.ACCOUNT.BALANCES'
    F.LMM.ACCOUNT.BALANCES = ''
    CALL OPF(FN.LMM.ACCOUNT.BALANCES,F.LMM.ACCOUNT.BALANCES)

    FN.BASIC.INTEREST = 'F.BASIC.INTEREST'
    F.BASIC.INTEREST = ''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)

    FN.INTEREST.BASIS = 'F.INTEREST.BASIS'
    F.INTEREST.BASIS  = ''
    CALL OPF(FN.INTEREST.BASIS,F.INTEREST.BASIS)

    FN.REDO.APAP.L.CONTRACT.BALANCES = 'F.REDO.APAP.L.CONTRACT.BALANCES'
    F.REDO.APAP.L.CONTRACT.BALANCES = ''
    CALL OPF(FN.REDO.APAP.L.CONTRACT.BALANCES,F.REDO.APAP.L.CONTRACT.BALANCES)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.STMT.ENTRY = 'F.STMT.ENTRY'
    F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
RETURN
*--------------------------------------------------------------------------------------------------------
**********
PROCESS.PARA:
**********

    R.REDO.APAP.H.PRODUCT.DEFINE = ''
    CALL CACHE.READ(FN.REDO.APAP.H.PRODUCT.DEFINE,'SYSTEM',R.REDO.APAP.H.PRODUCT.DEFINE,REDO.APAP.H.PRODUCT.DEFINE.ERR)
    Y.INT.PAY.TXN.CODE = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.PAY.TXN.CODE>
    Y.INT.ACC.TXN.CODE = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.ACC.TXN.CODE>

    Y.MM.PLACE.CATEG = "21076":@FM:"21077":@FM:"21078":@FM:"21079":@FM:"21080"

RETURN

*--------------------------------------------------------------------------------------------------------
END
