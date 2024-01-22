* @ValidationCode : MjotMTI3MTU0MTQ3MDpDcDEyNTI6MTcwMzY4MjMzMDgzNzp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Dec 2023 18:35:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.AA
SUBROUTINE REDO.B.AA.OVERPAYMENT.LOAD
*-------------------------------------------------
*Description: This batch routine is to post the FT OFS messages for overpayment
*             and also to credit the interest in loan.
*-------------------------------------------------
* Modification History:
* DATE              WHO                REFERENCE                 DESCRIPTION
* 29-MAR-2023      Conversion Tool    R22 Auto conversion       No changes
* 29-MAR-2023      Harishvikram C     Manual R22 conversion     No changes
*27-12-2023       VIGNESHWARI S      R22 MANUAL CONVERSTION      VARIABLE IS HARDCODED

*-------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.AA.OVERPAYMENT.COMMON

    GOSUB PROCESS
RETURN
*-------------------------------------------------
PROCESS:
*-------------------------------------------------

    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'
    F.REDO.AA.OVERPAYMENT  = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)

    FN.REDO.AA.OVERPAYMENT.PARAM = 'F.REDO.AA.OVERPAYMENT.PARAM'
    F.REDO.AA.OVERPAYMENT.PARAM  = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT.PARAM,F.REDO.AA.OVERPAYMENT.PARAM)

 *   CALL CACHE.READ(FN.REDO.AA.OVERPAYMENT.PARAM,'SYSTEM',R.REDO.AA.OVERPAYMENT.PARAM,F.REDO.AA.OVERPAYMENT.PARAM)
 VAR.VAL = 'SYSTEM'
 CALL CACHE.READ(FN.REDO.AA.OVERPAYMENT.PARAM,VAR.VAL,R.REDO.AA.OVERPAYMENT.PARAM,F.REDO.AA.OVERPAYMENT.PARAM);* R22 MANUAL CONVERSTION-VARIABLE IS HARDCODED

RETURN
END
