* @ValidationCode : MjotNzQ2MzA4MTI6Q3AxMjUyOjE2ODA2ODA2MDc3NDc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:13:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CRM.EXPIRY.PROCESS.LOAD

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.EXPIRY.PROCESS.LOAD
*--------------------------------------------------------------------------------
* Description: This is batch routine to mark the REDO.ISSUE.REQUESTS records with
* SER.AGR.COMP as expired after the SLA days.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 24-May-2011    H GANESH         CRM             INITIAL CREATION
*** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.CRM.EXPIRY.PROCESS.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    FN.REDO.ISSUE.REQUESTS='F.REDO.ISSUE.REQUESTS'
    F.REDO.ISSUE.REQUESTS=''
    CALL OPF(FN.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS)

    FN.REDO.ISSUE.CLAIMS='F.REDO.ISSUE.CLAIMS'
    F.REDO.ISSUE.CLAIMS=''
    CALL OPF(FN.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS)

RETURN
END
