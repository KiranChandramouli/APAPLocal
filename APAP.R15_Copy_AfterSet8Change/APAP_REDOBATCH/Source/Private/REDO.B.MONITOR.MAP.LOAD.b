* @ValidationCode : MjotMTMwMjI2ODYyOkNwMTI1MjoxNjg0ODU0MzkyOTEzOklUU1M6LTE6LTE6Mzk2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 396
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
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
