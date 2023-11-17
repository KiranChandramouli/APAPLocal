* @ValidationCode : MjotMTcyMDA5NjMwMzpDcDEyNTI6MTY4MDY5MDQ2MDM1NzpJVFNTOi0xOi0xOjY5MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:57:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 690
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.REGEN.NAB.ACCOUNTING.LOAD
*--------------------------------------------------------
*Description: This is load routine of the batch REDO.B.REGEN.NAB.ACCOUNTING to create
* and raise the accounting entries for NAB accounting
*--------------------------------------------------------
*Input Arg  : N/A
*Out   Arg  : N/A
*Deals With : NAB Accounting
*--------------------------------------------------------
* Date           Name        Dev Ref.                         Comments
* 16 Oct 2012   H Ganesh     NAB Accounting-PACS00202156     Initial Draft
* 04-APR-2023 Conversion tool    R22 Auto conversion       No changes
* 04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.REGEN.NAB.ACCOUNTING.COMMON

    GOSUB PROCESS
RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------

    FN.REDO.AA.NAB.HISTORY = 'F.REDO.AA.NAB.HISTORY'
    F.REDO.AA.NAB.HISTORY  = ''
    CALL OPF(FN.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT  = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB  = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT  = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.REDO.AA.INT.CLASSIFICATION = 'F.REDO.AA.INT.CLASSIFICATION'
    F.REDO.AA.INT.CLASSIFICATION  = ''
    CALL OPF(FN.REDO.AA.INT.CLASSIFICATION,F.REDO.AA.INT.CLASSIFICATION)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS, F.AA.BILL.DETAILS)

    FN.AA.ACCT.DET = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCT.DET = ''
    CALL OPF(FN.AA.ACCT.DET,F.AA.ACCT.DET)

    LOC.REF.APPLICATION   = "ACCOUNT"
    LOC.REF.FIELDS        = 'L.OD.STATUS'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.OD.STATUS       = LOC.REF.POS<1,1>

    Y.ID = 'SYSTEM'
*Tus Start
*  CALL F.READ(FN.REDO.AA.INT.CLASSIFICATION,Y.ID,R.REDO.AA.INT.CLASSIFICATION,F.REDO.AA.INT.CLASSIFICATION,CLS.ERR)
    CALL CACHE.READ(FN.REDO.AA.INT.CLASSIFICATION,Y.ID,R.REDO.AA.INT.CLASSIFICATION,CLS.ERR)
* Tus End

RETURN
END
