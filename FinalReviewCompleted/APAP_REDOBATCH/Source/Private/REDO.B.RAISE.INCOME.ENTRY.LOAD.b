* @ValidationCode : MjotMTg5MTkwOTY2NTpDcDEyNTI6MTY4NDg1NDM5NDg0MzpJVFNTOi0xOi0xOjYwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 600
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.RAISE.INCOME.ENTRY.LOAD
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.RAISE.INCOME.ENTRY.LOAD
*-----------------------------------------------------------------
* Description : This multi threaded routine is used to raise the entries whenever income has happened.
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      21-Nov-2011          Initial draft
* Date                  who                   Reference
* 12-04-2023        CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ACCT.MRKWOF.HIST
    $INSERT I_REDO.B.RAISE.INCOME.ENTRY.COMMON


    FN.REDO.ACCT.MRKWOF.HIST = 'F.REDO.ACCT.MRKWOF.HIST'
    F.REDO.ACCT.MRKWOF.HIST = ''
    CALL OPF(FN.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST)

    FN.REDO.ACCT.MRKWOF.PARAMETER = 'F.REDO.ACCT.MRKWOF.PARAMETER'
    F.REDO.ACCT.MRKWOF.PARAMETER = ''

    FN.REDO.WORK.INT.CAP.AMT.RP = 'F.REDO.WORK.INT.CAP.AMT.RP'
    F.REDO.WORK.INT.CAP.AMT.RP = ''
    CALL OPF(FN.REDO.WORK.INT.CAP.AMT.RP,F.REDO.WORK.INT.CAP.AMT.RP)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.WORK.PAID.PL = 'F.REDO.WORK.PAID.PL'
    F.REDO.WORK.PAID.PL = ''
    CALL OPF(FN.REDO.WORK.PAID.PL,F.REDO.WORK.PAID.PL)

    FN.REDO.GET.REPAID.DATE = 'F.REDO.GET.REPAID.DATE'
    F.REDO.GET.REPAID.DATE = ''
    CALL OPF(FN.REDO.GET.REPAID.DATE,F.REDO.GET.REPAID.DATE)

    CALL CACHE.READ(FN.REDO.ACCT.MRKWOF.PARAMETER,ID.COMPANY,R.REDO.ACCT.MRKWOF.PARAMETER,PAR.ERR)

    APP = 'ACCOUNT'
    LOC.FLD = 'L.LOAN.STATUS'
    LOC.FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APP, LOC.FLD, LOC.FLD.POS)
    L.LOAN.STATUS.POS = LOC.FLD.POS<1,1>

RETURN

END
