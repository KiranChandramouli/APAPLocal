* @ValidationCode : MjotMTA2MTg3NDU3NTpDcDEyNTI6MTY5NjgyNzQ1MTk0NTphaml0aDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Oct 2023 10:27:31
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
*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.CRF.NWGL.LOAD
*-----------------------------------------------------------------------------
*

*-----------------------------------------------------------------------------
* Modification History :
*DATE               NAME       REFERENCE                 DESCRIPTION
* 31 JAN 2023 Edwin Charles D  ACCOUNTING-CR            TSR479892
*----------------------------------------------------------------------------------------------------
** 09-10-2023     AJITH KUMAR .S               R22 MANUAL CODE CONVERSION                 FM ,VM,SM to @FM, @VM,@SM
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.T.ACCTSTAT.BY.DATE
    $INSERT I_F.EB.CONTRACT.BALANCES
    $INSERT I_REDO.CRF.NWGL.COMMON
    $INSERT I_F.REDO.PREVALANCE.STATUS
    $INSERT I_REDO.PREVAL.STATUS.COMMON

    FN.REDO.T.ACCTSTAT.BY.DATE = 'F.REDO.T.ACCTSTAT.BY.DATE'
    F.REDO.T.ACCTSTAT.BY.DATE = ''
    CALL OPF(FN.REDO.T.ACCTSTAT.BY.DATE,F.REDO.T.ACCTSTAT.BY.DATE)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.ECB = 'F.EB.CONTRACT.BALANCES'
    F.ECB = ''
    CALL OPF(FN.ECB,F.ECB)

    FN.RE.CRF.NWGL = 'F.RE.CRF.NWGL'
    F.RE.CRF.NWGL = ''
    CALL OPF(FN.RE.CRF.NWGL,F.RE.CRF.NWGL)

    FN.DATES = 'F.DATES'
    F.DATES = ''
    CALL OPF(FN.DATES, F.DATES)

    Y.BAL.RECLASSIFY.LIST = ''; Y.INT.RECLASSIFY.LIST = '';   PARAM.STATUS = ''; PREVALANCE.STATUS = ''; STAT.FM.CNTR = 0 ; ACCT.TYPE.LIST = ''
    FN.REDO.PREVALANCE.STATUS = 'F.REDO.PREVALANCE.STATUS'
    F.REDO.PREVALANCE.STATUS = ''
    CALL OPF(FN.REDO.PREVALANCE.STATUS,F.REDO.PREVALANCE.STATUS)

    CALL CACHE.READ(FN.REDO.PREVALANCE.STATUS,'SYSTEM',R.REDO.PREVALANCE.STATUS,F.ERR)

    PARAM.STATUS.VAL = R.REDO.PREVALANCE.STATUS<REDO.PRE.STATUS>
    PREVALANCE.STATUS.VAL = CHANGE(R.REDO.PREVALANCE.STATUS<REDO.PRE.PREVALANT.STATUS>,@VM,@FM)
    ACCT.TYPE.VAL = CHANGE(R.REDO.PREVALANCE.STATUS<REDO.PRE.ACCT.TYPE>,@VM,@FM)
    Y.BAL.RECLASSIFY.LIST = CHANGE(R.REDO.PREVALANCE.STATUS<REDO.PRE.BAL.RECLASS>,@VM,@FM)
    Y.INT.RECLASSIFY.LIST = CHANGE(R.REDO.PREVALANCE.STATUS<REDO.PRE.INT.RECLASS>,@VM,@FM)

    STAT.FM.CNTR = DCOUNT(PARAM.STATUS.VAL,@VM)
    LOOP.FM.CNTR = 1

    LOOP
    WHILE LOOP.FM.CNTR LE STAT.FM.CNTR
        Y.FM.STATUS = PARAM.STATUS.VAL<1,LOOP.FM.CNTR>
        Y.FM.STATUS = CHANGE(Y.FM.STATUS,@FM,':')
        Y.FM.STATUS = CHANGE(Y.FM.STATUS,@SM,':')
        PARAM.STATUS<-1> = Y.FM.STATUS
        PREVALANCE.STATUS<-1> = PREVALANCE.STATUS.VAL<LOOP.FM.CNTR>
        ACCT.TYPE.LIST<-1> = ACCT.TYPE.VAL<LOOP.FM.CNTR>
*        Y.BAL.RECLASSIFY.LIST<-1> = Y.BAL.RECLASSIFY.VAL<LOOP.FM.CNTR>
*       Y.INT.RECLASSIFY.LIST<-1> = Y.INT.RECLASSIFY.VAL<LOOP.FM.CNTR>
        LOOP.FM.CNTR + = 1
    REPEAT

RETURN
END
