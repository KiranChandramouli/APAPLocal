* @ValidationCode : MjoxMDcxNzc1NDM1OkNwMTI1MjoxNzAxMDg5MDc4OTg5OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Nov 2023 18:14:38
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
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
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*27-11-2023	      VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES- SQA-11542 | MONITOR  – By Santiago-no changes

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
