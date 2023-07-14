* @ValidationCode : MjotMTQ1ODMyODM2ODpDcDEyNTI6MTY4NDg1NDM5NDQzNDpJVFNTOi0xOi0xOjI4MzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 283
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.POLICY.AUTO.CANCEL(INS.ID)
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : HARISH Y
* Program Name  : REDO.B.POLICY.AUTO.CANCEL
*-------------------------------------------------------------------------

* Description :This routine will UPDATE the files in APAP.H.INSURANCE.DETAILS if the ARRANGEMENT is MATURED
* In parameter : INS.ID
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_REDO.B.POLICY.AUTO.CANCEL.COMMON

    GOSUB INIT
    GOSUB PROCESS

RETURN

***********
INIT:
***********

    CALL F.READ(FN.APAP.H.INSURANCE.DETAILS,INS.ID,R.INS.DET,F.APAP.H.INSURANCE.DETAILS,INS.ERR)
    IF R.INS.DET THEN
        ARR.ID = R.INS.DET<INS.DET.ASSOCIATED.LOAN>
        PolicyStatus = R.INS.DET<INS.DET.POLICY.STATUS>
        CALL F.READ(FN.AA.ARRANGEMENT,ARR.ID,R.ARR,F.AA.ARRANGEMENT,ARR.ERR)
        IF R.ARR THEN
            ARR.STATUS = R.ARR<AA.ARR.ARR.STATUS>
        END
    END
RETURN
**********
PROCESS:
**********
*TUS AA Changes 20161021
*  IF ARR.STATUS EQ 'MATURED' AND PolicyStatus NE 'CANCELLED' THEN
    IF ARR.STATUS EQ 'PENDING.CLOSURE' AND PolicyStatus NE 'CANCELLED' THEN
*TUS END
        V.BKP = V
        V = 59
        R.INS.DET<INS.DET.POLICY.STATUS> = 'CANCELLED'
        CALL F.LIVE.WRITE(FN.APAP.H.INSURANCE.DETAILS,INS.ID,R.INS.DET)
        V = V.BKP
    END
RETURN
END
