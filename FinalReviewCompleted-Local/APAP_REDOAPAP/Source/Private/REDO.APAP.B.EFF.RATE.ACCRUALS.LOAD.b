* @ValidationCode : MjoxODM3NzczODc6Q3AxMjUyOjE2ODEyMDk1MTk0ODY6YWppdGg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Apr 2023 16:08:39
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.B.EFF.RATE.ACCRUALS.LOAD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.B.EFF.RATE.ACCRUALS.LOAD
*--------------------------------------------------------------------------------------------------------
*Description  : REDO.APAP.B.EFF.RATE.ACCRUALS.LOAD is the load routine to load all the variables required for the process
*Linked With  :
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 30 SEP 2010    Mohammed Anies K      ODR-2010-07-0077        Initial Creation
* 29-Jan-2012  Gangadhar.S.V.      Performance Tuning     Commented the select and F.READ to CACHE.READ
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*11-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*11-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.APAP.B.EFF.RATE.ACCRUALS.COMMON
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

    FN.BASIC.INTEREST = 'F.BASIC.INTEREST'
    F.BASIC.INTEREST = ''
    CALL OPF(FN.BASIC.INTEREST,F.BASIC.INTEREST)

    FN.INTEREST.BASIS = 'F.INTEREST.BASIS'
    F.INTEREST.BASIS  = ''
    CALL OPF(FN.INTEREST.BASIS,F.INTEREST.BASIS)

*    FN.EB.ACCRUAL.PARAM = 'F.EB.ACCRUAL.PARAM' ;* 29-Jan-2012 - S
*    F.EB.ACCRUAL.PARAM = ''
*    CALL OPF(FN.EB.ACCRUAL.PARAM,F.EB.ACCRUAL.PARAM) ;* 29-Jan-2012 - E

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
*    SEL.CMD.EAP = "SELECT ":FN.EB.ACCRUAL.PARAM ;* 29-Jan-2012 - S
*    CALL EB.READLIST(SEL.CMD.EAP,SEL.LIST.EAP,'',NO.OF.REC.EAP,SEL.ERR.EAP)

*    CALL F.READ(FN.REDO.APAP.H.PRODUCT.DEFINE,'SYSTEM',R.REDO.APAP.H.PRODUCT.DEFINE,F.REDO.APAP.H.PRODUCT.DEFINE,REDO.APAP.H.PRODUCT.DEFINE.ERR)
    CALL CACHE.READ(FN.REDO.APAP.H.PRODUCT.DEFINE,'SYSTEM',R.REDO.APAP.H.PRODUCT.DEFINE,REDO.APAP.H.PRODUCT.DEFINE.ERR)   ;* 29-Jan-2012 - E
    Y.INT.PAY.TXN.CODE = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.PAY.TXN.CODE>
    Y.INT.ACC.TXN.CODE = R.REDO.APAP.H.PRODUCT.DEFINE<PRD.DEF.INT.ACC.TXN.CODE>
RETURN
*--------------------------------------------------------------------------------------------------------
END
