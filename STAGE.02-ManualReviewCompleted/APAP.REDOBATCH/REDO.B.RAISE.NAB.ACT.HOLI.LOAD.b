* @ValidationCode : MjoyOTA1MzE4NTg6Q3AxMjUyOjE2ODEyOTgyOTc1ODg6SVRTUzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 16:48:17
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
SUBROUTINE REDO.B.RAISE.NAB.ACT.HOLI.LOAD
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference
* 12-04-2023        CONVERSTION TOOL     R22 AUTO CONVERSTION - VM TO @VM
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.RAISE.NAB.ACT.HOLI.COMMON


    FN.REDO.AA.NAB.HISTORY = 'F.REDO.AA.NAB.HISTORY'
    F.REDO.AA.NAB.HISTORY = ''
    CALL OPF(FN.REDO.AA.NAB.HISTORY,F.REDO.AA.NAB.HISTORY)

    FN.REDO.CONCAT.ACC.NAB = 'F.REDO.CONCAT.ACC.NAB'
    F.REDO.CONCAT.ACC.NAB = ''
    CALL OPF(FN.REDO.CONCAT.ACC.NAB,F.REDO.CONCAT.ACC.NAB)

    FN.AC = 'F.ACCOUNT'
    F.AC = ''
    CALL OPF(FN.AC,F.AC)

    FN.REDO.AA.INT.CLASSIFICATION = 'F.REDO.AA.INT.CLASSIFICATION'
    F.REDO.AA.INT.CLASSIFICATION = ''

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    Y.ID = 'SYSTEM'
    CALL CACHE.READ(FN.REDO.AA.INT.CLASSIFICATION,Y.ID,R.REDO.AA.INT.CLASSIFICATION,CLS.ERR)

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
