* @ValidationCode : Mjo3MTc0NTE3NDk6Q3AxMjUyOjE2ODc4NDgyMzcyMTE6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Jun 2023 12:13:57
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
    $INSERT I_BATCH.FILES
    $INSERT I_REDO.B.PRIN.INT.UPDATE.COMMON

    SELECT.CMD = ''
    SEL.LIST = ''

    SELECT.CMD = 'SELECT ':FN.OFS.MESSAGE.QUEUE
    CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.OF.REC,ERR)
    IF NOT(SEL.LIST) THEN
        SELECT.CMD = 'SELECT ':FN.OFS.CHANGE.RATE.QUEUE
        CALL EB.READLIST(SELECT.CMD,SEL.LIST,'',NO.OF.REC,ERR)
        CALL BATCH.BUILD.LIST('',SEL.LIST)
    END

RETURN
END
