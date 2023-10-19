* @ValidationCode : MjotMTUyMzYwMzg2MDpDcDEyNTI6MTY4MDc3MzM4NzQ4ODozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 14:59:47
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CRM.DOCUMENTATION.PROCESS.LOAD

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.DOCUMENTATION.PROCESS.LOAD
*--------------------------------------------------------------------------------
* Description: This is batch routine to mark the REDO.FRONT.REQUEST records with
* status as pending document after the calendar days defined in param table.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 24-May-2011    H GANESH         CRM             INITIAL CREATION
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.CRM.DOCUMENTATION.PROCESS.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    FN.REDO.CRM.DOC.DATE='F.REDO.CRM.DOC.DATE'
    F.REDO.CRM.DOC.DATE=''
    CALL OPF(FN.REDO.CRM.DOC.DATE,F.REDO.CRM.DOC.DATE)

    FN.REDO.CRM.CLAIM.DOC.DATE='F.REDO.CRM.CLAIM.DOC.DATE'
    F.REDO.CRM.CLAIM.DOC.DATE=''
    CALL OPF(FN.REDO.CRM.CLAIM.DOC.DATE,F.REDO.CRM.CLAIM.DOC.DATE)

    FN.REDO.FRONT.REQUESTS='F.REDO.FRONT.REQUESTS'
    F.REDO.FRONT.REQUESTS=''
    CALL OPF(FN.REDO.FRONT.REQUESTS,F.REDO.FRONT.REQUESTS)

    FN.REDO.FRONT.CLAIMS='F.REDO.FRONT.CLAIMS'
    F.REDO.FRONT.CLAIMS=''
    CALL OPF(FN.REDO.FRONT.CLAIMS,F.REDO.FRONT.CLAIMS)

    FN.REDO.H.CRM.PARAM = 'F.REDO.H.CRM.PARAM'
    F.REDO.H.CRM.PARAM  = ''
    CALL OPF(FN.REDO.H.CRM.PARAM,F.REDO.H.CRM.PARAM)

RETURN
END
