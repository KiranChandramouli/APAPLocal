* @ValidationCode : MjotMTY4MTk4MDMwNDpDcDEyNTI6MTY4NDg1NDM3ODQ2NDpJVFNTOi0xOi0xOjEwMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 100
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.ACI.UPD.SELECT
****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.B.ACI.UPD.SELECT
* ODR NO        : ODR-2009-10-0317
*-------------------------------------------------------------------------

* Description :This routine will form a list which will be processed
*               by the routine REDO.B.ACI.UPD

* In parameter : None
* out parameter : None
*-------------------------------------------------------------------------------------
*Modification
* Date                  who                   Reference              
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT.CREDIT.INT
    $INSERT I_F.ACCOUNT
    $INSERT I_F.BASIC.INTEREST
    $INSERT I_F.DATES
    $INSERT I_F.REDO.UPD.ACC.LIST
    $INSERT I_F.REDO.ACC.CR.INT
    $INSERT I_REDO.B.ACI.UPD.COMMON

    VAR.LAST.WORK.DAY=R.DATES(EB.DAT.LAST.WORKING.DAY)
    CALL F.READ(FN.REDO.UPD.ACC.LIST,VAR.LAST.WORK.DAY,R.REDO.UPD.ACC.LIST,F.REDO.UPD.ACC.LIST,ACC.UPD.ERR)
    PROCESS.LIST=R.REDO.UPD.ACC.LIST
    IF PROCESS.LIST NE '' THEN
        CALL BATCH.BUILD.LIST('',PROCESS.LIST)
    END
RETURN
END
