* @ValidationCode : MjotMTQwNjk4NzI1MDpDcDEyNTI6MTY4MTE5Mjk2MDk5NjpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 11:32:40
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
SUBROUTINE REDO.B.INS.CHG.EXP.LOAD
*
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_REDO.B.INS.CHG.EXP.COMMON
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
MAIN:

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.INSURANCE = 'F.APAP.H.INSURANCE.DETAILS'
    F.INSURANCE = ''
    CALL OPF(FN.INSURANCE,F.INSURANCE)

    PLOL = ''
    F.APLS = 'AA.PRD.DES.CHARGE'
    F.FLDS = 'STATUS.POLICY'
    CALL MULTI.GET.LOC.REF(F.APLS,F.FLDS,PLOL)
    Y.STA.POL = PLOL<1,1>

RETURN

END
