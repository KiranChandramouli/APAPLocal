* @ValidationCode : MjotMTkwMDkzNzkyNDpDcDEyNTI6MTY4MTI3ODIyNDgyNTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 11:13:44
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
SUBROUTINE REDO.B.MONITOR.SHIP.SELECT
*-----------------------------------------------------------------------------
* 03/09/10 - Created by Victor Nava
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MONITOR.SHIP.COMMON
*-----------------------------------------------------------------------------
*
    LIST.PARAMETER = ''
    LIST.PARAMETER<2> = FN.REDO.MON.SEND.QUEUE
    CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')
*

RETURN
*-----------------------------------------------------------------------------
END
