* @ValidationCode : MjotMzc4NzUwMDAzOkNwMTI1MjoxNjg3ODQ4MjM3MTgzOklUU1M6LTE6LTE6MjAwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Jun 2023 12:13:57
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 200
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
SUBROUTINE REDO.B.PRIN.INT.UPDATE.LOAD

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_REDO.B.PRIN.INT.UPDATE.COMMON

    FN.OFS.CHANGE.RATE.QUEUE = 'F.OFS.CHANGE.RATE.QUEUE'
    F.OFS.CHANGE.RATE.QUEUE = ''
    CALL OPF(FN.OFS.CHANGE.RATE.QUEUE,F.OFS.CHANGE.RATE.QUEUE)

    FN.OFS.MESSAGE.QUEUE = 'F.OFS.MESSAGE.QUEUE'
    F.OFS.MESSAGE.QUEUE = ''
    CALL OPF(FN.OFS.MESSAGE.QUEUE, F.OFS.MESSAGE.QUEUE)

RETURN
END
