* @ValidationCode : Mjo2OTEzNDgyOTQ6Q3AxMjUyOjE2ODA2ODA2MDc3MzI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
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
SUBROUTINE REDO.CRM.DOCUMENTATION.PROCESS.SELECT

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.DOCUMENTATION.PROCESS.SELECT
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
*
** 06-04-2023 R22 Auto Conversion no changes
** 06-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.REDO.H.CRM.PARAM
    $INSERT I_REDO.CRM.DOCUMENTATION.PROCESS.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

    CALL CACHE.READ(FN.REDO.H.CRM.PARAM,'SYSTEM',R.REDO.H.CRM.PARAM,CRM.PARAM.ERR)
    Y.DAYS      = R.REDO.H.CRM.PARAM<CRM.PARAM.SLA.EXPIRY>
    YREGION     = ''
    YDATE       = TODAY
    YDAYS.ORIG  = '-':Y.DAYS:'C'
    CALL CDT(YREGION,YDATE,YDAYS.ORIG)

    IF NOT(CONTROL.LIST) THEN
        CONTROL.LIST = "REQUEST"
        CONTROL.LIST<-1> = "CLAIMS"
    END

    V.WORK.LIST = CONTROL.LIST<1,1>
    IF V.WORK.LIST EQ 'REQUEST' THEN
        CALL F.READ(FN.REDO.CRM.DOC.DATE,YDATE,R.REDO.CRM.DOC.DATE,F.REDO.CRM.DOC.DATE,CRM.ERR)
        Y.PROCESS.LIST = R.REDO.CRM.DOC.DATE
    END

    IF V.WORK.LIST EQ 'CLAIMS' THEN
        CALL F.READ(FN.REDO.CRM.CLAIM.DOC.DATE,YDATE,R.REDO.CRM.CLAIM.DOC.DATE,F.REDO.CRM.CLAIM.DOC.DATE,CRM.ERR.CLAIM)
        Y.PROCESS.LIST = R.REDO.CRM.CLAIM.DOC.DATE
    END

    CALL BATCH.BUILD.LIST('',Y.PROCESS.LIST)

RETURN
END
