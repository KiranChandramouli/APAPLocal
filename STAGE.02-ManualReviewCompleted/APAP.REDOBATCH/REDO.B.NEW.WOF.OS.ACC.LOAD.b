* @ValidationCode : MjoyODkxODc3NTM6Q3AxMjUyOjE2ODEyODIwNjAzNzY6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:17:40
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
SUBROUTINE REDO.B.NEW.WOF.OS.ACC.LOAD
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.NEW.WOF.OS.ACC.LOAD
*-----------------------------------------------------------------
* Description : This routine used to raise the entry for group of aa loans
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017    23-OCT-2011            WOF ACCOUNTING - PACS00202156
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - VM TO @VM
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.WORK.INT.CAP.AMT
    $INSERT I_REDO.B.NEW.WOF.OS.ACC.COMMON

    FN.REDO.NEW.WORK.INT.CAP.OS = 'F.REDO.NEW.WORK.INT.CAP.OS'
    F.REDO.NEW.WORK.INT.CAP.OS = ''
    CALL OPF(FN.REDO.NEW.WORK.INT.CAP.OS,F.REDO.NEW.WORK.INT.CAP.OS)

    FN.REDO.ACCT.MRKWOF.HIST = 'F.REDO.ACCT.MRKWOF.HIST'
    F.REDO.ACCT.MRKWOF.HIST = ''
    CALL OPF(FN.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.AA.INT.CLASSIFICATION = 'F.REDO.AA.INT.CLASSIFICATION'
    F.REDO.AA.INT.CLASSIFICATION = ''

    FN.REDO.CONCAT.ACC.WOF = 'F.REDO.CONCAT.ACC.WOF'
    F.REDO.CONCAT.ACC.WOF = ''
    CALL OPF(FN.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF)

    FN.REDO.ACCT.MRKWOF.PARAMETER = 'F.REDO.ACCT.MRKWOF.PARAMETER'
    F.REDO.ACCT.MRKWOF.PARAMETER = ''
    CALL OPF(FN.REDO.ACCT.MRKWOF.PARAMETER,F.REDO.ACCT.MRKWOF.PARAMETER)

    FN.COMPANY = 'F.COMPANY'
    F.COMPANY = ''
    CALL OPF(FN.COMPANY,F.COMPANY)

    FN.REDO.WOF.CONCAT.FILE = 'F.REDO.WOF.CONCAT.FILE'
    F.REDO.WOF.CONCAT.FILE = ''
    CALL OPF(FN.REDO.WOF.CONCAT.FILE,F.REDO.WOF.CONCAT.FILE)


    Y.SID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.AA.INT.CLASSIFICATION,Y.SID,R.REDO.AA.INT.CLASSIFICATION,INT.ERR)
    CALL CACHE.READ(FN.REDO.ACCT.MRKWOF.PARAMETER,Y.SID,R.REDO.ACCT.MRKWOF.PARAMETER,INT.ERR)
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)


    FN.REDO.GET.REPAID.DATE = 'F.REDO.GET.REPAID.DATE'
    F.REDO.GET.REPAID.DATE = ''
    CALL OPF(FN.REDO.GET.REPAID.DATE,F.REDO.GET.REPAID.DATE)

    FN.REDO.NEW.REPAID.PRIN.AMT = 'F.REDO.NEW.REPAID.PRIN.AMT'
    F.REDO.NEW.REPAID.PRIN.AMT = ''
    CALL OPF(FN.REDO.NEW.REPAID.PRIN.AMT,F.REDO.NEW.REPAID.PRIN.AMT)

    FN.REDO.NEW.REPAID.INT.PL = 'F.REDO.NEW.REPAID.INT.PL'
    F.REDO.NEW.REPAID.INT.PL = ''
    CALL OPF(FN.REDO.NEW.REPAID.INT.PL,F.REDO.NEW.REPAID.INT.PL)

    LOC.REF.APPLICATION = "ACCOUNT"
    LOC.REF.FIELDS      = 'L.LOAN.STATUS':@VM:'L.OD.STATUS':@VM:'L.OD.STATUS.2':@VM:'L.AC.AV.BAL':@VM:'ORIGEN.RECURSOS'
    LOC.REF.POS         = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.LOAN.STATUS = LOC.REF.POS<1,1>
    POS.L.OD.STATUS   = LOC.REF.POS<1,2>
    POS.L.OD.STATUS.2 = LOC.REF.POS<1,3>
    POS.AV.BAL = LOC.REF.POS<1,4>
    POS.OR.RE = LOC.REF.POS<1,5>

RETURN

END
