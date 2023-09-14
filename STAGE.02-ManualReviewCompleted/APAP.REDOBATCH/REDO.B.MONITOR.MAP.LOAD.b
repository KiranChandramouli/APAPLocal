* @ValidationCode : MjotMTMwMjI2ODYyOkNwMTI1MjoxNjgxMjc3OTI2Mzg0OklUU1M6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 11:08:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.MONITOR.MAP.LOAD
*
*
*
*--------------------------------------------------------------------------
* Modifications;
*
* 30/08/10 - Created by Cesar Yepez
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*

*--------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MONITOR.MAP.COMMON
*
*--------------------------------------------------------------------------
*
* Main processing

    FN.REDO.MON.MAP.QUEUE = 'F.REDO.MON.MAP.QUEUE'
    F.REDO.MON.MAP.QUEUE = ''
    CALL OPF(FN.REDO.MON.MAP.QUEUE, F.REDO.MON.MAP.QUEUE)

    FN.REDO.MON.SEND.QUEUE = 'F.REDO.MON.SEND.QUEUE'
    F.REDO.MON.SEND.QUEUE = ''
    CALL OPF(FN.REDO.MON.SEND.QUEUE, F.REDO.MON.SEND.QUEUE)

    FN.REDO.MON.TABLE = 'F.REDO.MONITOR.TABLE'
    F.REDO.MON.TABLE = ''
    CALL OPF(FN.REDO.MON.TABLE, F.REDO.MON.TABLE)

    FN.REDO.MON.MAP.QUEUE.ERR = 'F.REDO.MON.MAP.QUEUE.ERR'
    F.REDO.MON.MAP.QUEUE.ERR = ''
    CALL OPF(FN.REDO.MON.MAP.QUEUE.ERR, F.REDO.MON.MAP.QUEUE.ERR)


*
RETURN
*
*--------------------------------------------------------------------------
*
END
