* @ValidationCode : MjotMTQwNjk4NzI1MDpDcDEyNTI6MTY4NDg1NDM4NzUxODpJVFNTOi0xOi0xOjE5NToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 195
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
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
