* @ValidationCode : MjoxMzI0MjQ5OTQ2OkNwMTI1MjoxNjgwNjgwNjA3ODAzOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
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
SUBROUTINE REDO.CRM.EXPIRY.PROCESS(Y.REQ.ID)

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.EXPIRY.PROCESS
*--------------------------------------------------------------------------------
* Description:  This is batch routine to mark the REDO.ISSUE.REQUESTS records with
* SER.AGR.COMP as expired after the SLA days.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE                DESCRIPTION
* 24-May-2011     H GANESH         CRM                  INITIAL CREATION
*
** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.ISSUE.REQUESTS
    $INSERT I_F.REDO.ISSUE.CLAIMS
    $INSERT I_REDO.CRM.EXPIRY.PROCESS.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    V.WORK.FILE.LIST = CONTROL.LIST<1,1>
    IF V.WORK.FILE.LIST EQ 'REQUEST' THEN
        CALL F.READ(FN.REDO.ISSUE.REQUESTS,Y.REQ.ID,R.REDO.ISSUE.REQUESTS,F.REDO.ISSUE.REQUESTS,REQ.ERR)
        R.REDO.ISSUE.REQUESTS<ISS.REQ.SER.AGR.COMP>='EXPIRED'
        CALL F.WRITE(FN.REDO.ISSUE.REQUESTS,Y.REQ.ID,R.REDO.ISSUE.REQUESTS)
    END

    IF V.WORK.FILE.LIST EQ 'CLAIMS' THEN
        CALL F.READ(FN.REDO.ISSUE.CLAIMS,Y.REQ.ID,R.REDO.ISSUE.CLAIMS,F.REDO.ISSUE.CLAIMS,CL.ERR)
        R.REDO.ISSUE.CLAIMS<ISS.CL.SER.AGR.COMP>='EXPIRED'
        CALL F.WRITE(FN.REDO.ISSUE.CLAIMS,Y.REQ.ID,R.REDO.ISSUE.CLAIMS)
    END

RETURN
END
