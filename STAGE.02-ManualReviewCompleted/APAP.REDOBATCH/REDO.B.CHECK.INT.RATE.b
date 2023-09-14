* @ValidationCode : MjotOTI0NDUzNzc1OkNwMTI1MjoxNjgxMTA1MDUxOTQ3OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 10 Apr 2023 11:07:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.CHECK.INT.RATE(Y.AZ.ACCOUNT.ID)
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.B.CHECK.INT.RATE
*--------------------------------------------------------------------------------
* Description: Subroutine to get the value from PERIODIC.INTEREST table and assign
*              it to ROLLOVER.INT.RATE field in AZ.ACCOUNT

* Linked with   : None
* In Parameter  : Y.AZ.ACCOUNT.ID
* Out Parameter : None
*--------------------------------------------------------------------------------
*Modification History:
*12/12/2009 - ODR-2009-10-0537
*Development for Subroutine to get the value from PERIODIC.INTEREST table and assign
*it to ROLLOVER.INT.RATE field in AZ.ACCOUNT
*06-08-2010- HD1026611 Routine altered with PI.method field added
**********************************************************************************
*  DATE             WHO         REFERENCE         DESCRIPTION
* 26 Mar 2011    GURU DEV      PACS00033054      Modified as per issue
* 25 May 2011    H Ganesh      PACS00064390      Variable OFS.ERR has been initialised
* Date                  who                   Reference              
* 10-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION ! TO *
* 10-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*--------------------------------------------------------------------------------
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.PERIODIC.INTEREST
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_REDO.B.CHECK.INT.RATE.COMMON

    GOSUB INIT
RETURN
*------
INIT:
*------
    DAYS=''
    R.AZ.ACCOUNT=''
    R.AZ.PRODUCT.PARAM=''
    R.PERIODIC.INTEREST=''
    R.AZ.RECORD=''
    AMOUNT.POS=''
    PERIOD.POS=''
    CALL F.READ(FN.AZ.ACCOUNT,Y.AZ.ACCOUNT.ID,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ACC.ERR)
    Y.AZ.MATURITY.DATE=R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    Y.AZ.PRODUCT.PARAM.ID=R.AZ.ACCOUNT<AZ.ALL.IN.ONE.PRODUCT>
    CALL CACHE.READ(FN.AZ.PRODUCT.PARAM,Y.AZ.PRODUCT.PARAM.ID,R.AZ.PRODUCT.PARAM,AZ.PRO.ERR)

    IF R.AZ.PRODUCT.PARAM<AZ.APP.LOAN.DEPOSIT> EQ 'DEPOSIT' AND  R.AZ.ACCOUNT<AZ.MATURITY.INSTR> EQ 'AUTOMATIC ROLLOVER'  THEN
        GOSUB PROCESS
    END
RETURN
*-------
PROCESS:
*--------

    Y.AZ.LOAN.DEPOSIT=R.AZ.PRODUCT.PARAM<AZ.APP.LOAN.DEPOSIT>
    Y.AZ.AMOUNT=R.AZ.ACCOUNT<AZ.LOCAL.REF><1,AZ.LOCAL.AMT.POS>
*!GD
    Y.RENEWAL.KEY = R.AZ.PRODUCT.PARAM<AZ.APP.LOCAL.REF><1,AZ.RENEW.KEY.POS>

*!GD
    Y.AZ.CURRENCY=R.AZ.ACCOUNT<AZ.CURRENCY>
*    Y.PERIODIC.KEY=R.AZ.PRODUCT.PARAM<AZ.APP.PERIODIC.RATE.KEY>

    Y.PI.METHOD=R.AZ.PRODUCT.PARAM<AZ.APP.PI.METHOD>
    Y.BI.KEY=R.AZ.PRODUCT.PARAM<AZ.APP.RATE.KEY>
    Y.BI.SPREAD=R.AZ.PRODUCT.PARAM<AZ.APP.RATE.SPREAD>
    Y.BI.OPERAND=R.AZ.PRODUCT.PARAM<AZ.APP.RATE.OPERAND>
    Y.BI.PERCENT=R.AZ.PRODUCT.PARAM<AZ.APP.RATE.PERCENT>
    Y.FIXED.RATE=R.AZ.PRODUCT.PARAM<AZ.APP.INT.FIXED.RATE>
    REGION=''
    START.DATE=R.AZ.ACCOUNT<AZ.VALUE.DATE>
    END.DATE=R.AZ.ACCOUNT<AZ.MATURITY.DATE>
    DAYS='C'
    CALL CDD(REGION,START.DATE,END.DATE,DAYS)
    Y.START.DATE=TODAY
    Y.END.DATE=TODAY
    DAYS='+':DAYS:'C'
    CALL CDT(REGION,Y.END.DATE,DAYS)
    CALL EB.CALC.INTEREST.RATE(Y.AZ.LOAN.DEPOSIT,Y.AZ.AMOUNT,Y.AZ.CURRENCY,Y.RENEWAL.KEY,Y.PI.METHOD,Y.BI.KEY,Y.BI.SPREAD,Y.BI.OPERAND,Y.BI.PERCENT,Y.FIXED.RATE,Y.START.DATE,Y.END.DATE,Y.EFFECTIVE.RATE)

    R.AZ.RECORD<AZ.ROLLOVER.INT.RATE> =Y.EFFECTIVE.RATE

    OFS.SOURCE.ID = 'REDO.OFS.AZ.UPDATE'
    APPLICATION.NAME = 'AZ.ACCOUNT'
    TRANS.FUNC.VAL = 'I'
    TRANS.OPER.VAL = 'PROCESS'
    APPLICATION.NAME.VERSION = 'AZ.ACCOUNT,REDO.AZ.UPDATE'
    NO.AUT = ''
    OFS.MSG.ID = ''
    APPLICATION.ID = Y.AZ.ACCOUNT.ID
    OFS.POST.MSG = ''
    OFS.ERR=''

    CALL OFS.BUILD.RECORD(APPLICATION.NAME,TRANS.FUNC.VAL,TRANS.OPER.VAL,APPLICATION.NAME.VERSION,"",NO.AUT,APPLICATION.ID,R.AZ.RECORD,OFS.REQ.MSG)
    CALL OFS.POST.MESSAGE(OFS.REQ.MSG,OFS.MSG.ID,OFS.SOURCE.ID,OFS.ERR)

RETURN

END
