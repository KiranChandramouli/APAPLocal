* @ValidationCode : MjoyNjk3NDA3NTc6Q3AxMjUyOjE3MDQ0Mjk2ODI2MzA6MzMzc3U6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jan 2024 10:11:22
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
$PACKAGE APAP.REDOBATCH
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 26-JUNE-2023     Conversion tool    R22 Auto conversion       No changes
* 26-JUNE-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
SUBROUTINE REDO.B.PRIN.INT.UPDATE.SELECT

    $INSERT I_COMMON
    $INSERT I_EQUATE
*    $INSERT I_BATCH.FILES ;*R22 Manual Conversion
    $INSERT I_REDO.B.PRIN.INT.UPDATE.COMMON
    $USING EB.Service

    SELECT.CMD = ''
    SEL.LIST = ''

    SELECT.CMD = 'SELECT ':FN.OFS.MESSAGE.QUEUE
    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.OF.REC,ERR)
    IF NOT(SEL.LIST) THEN
        SELECT.CMD = 'SELECT ':FN.OFS.CHANGE.RATE.QUEUE
        CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.OF.REC,ERR)
*        CALL BATCH.BUILD.LIST('',SEL.LIST)
        EB.Service.BatchBuildList('',SEL.LIST);* R22 UTILITY AUTO CONVERSION
    END

RETURN
END
