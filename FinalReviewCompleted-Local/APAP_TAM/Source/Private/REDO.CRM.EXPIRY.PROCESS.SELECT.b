* @ValidationCode : MjotMTEwNDE2MjE4OkNwMTI1MjoxNjgwNjg4MDA0MDgwOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:16:44
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
SUBROUTINE REDO.CRM.EXPIRY.PROCESS.SELECT

*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.CRM.EXPIRY.PROCESS.SELECT
*--------------------------------------------------------------------------------
* Description: This is batch routine to mark the REDO.ISSUE.REQUESTS records with
* SER.AGR.COMP as expired after the SLA days.
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO            REFERENCE         DESCRIPTION
* 24-May-2011    H GANESH            CRM             INITIAL CREATION
* 05.04.2023     Conversion Tool     R22            Auto Conversion     - No changes
* 05.04.2023     Shanmugapriya M     R22            Manual Conversion   - No changes
*
*----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.CRM.EXPIRY.PROCESS.COMMON

    GOSUB PROCESS
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------
    IF NOT(CONTROL.LIST) THEN
        CONTROL.LIST = "REQUEST"
        CONTROL.LIST<-1> = "CLAIMS"
    END
    V.WORK.LIST = CONTROL.LIST<1,1>
    IF V.WORK.LIST EQ 'REQUEST' THEN
        SEL.CMD='SELECT ':FN.REDO.ISSUE.REQUESTS:' WITH (STATUS EQ OPEN OR STATUS EQ IN-PROCESS) AND DATE.RESOLUTION LE ':TODAY
    END

    IF V.WORK.LIST EQ 'CLAIMS' THEN
        SEL.CMD='SELECT ':FN.REDO.ISSUE.CLAIMS:' WITH (STATUS EQ OPEN OR STATUS EQ IN-PROCESS) AND DATE.RESOLUTION LE ':TODAY
    END

    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NR.CNT,'')
    CALL BATCH.BUILD.LIST('',SEL.LIST)

RETURN
END
