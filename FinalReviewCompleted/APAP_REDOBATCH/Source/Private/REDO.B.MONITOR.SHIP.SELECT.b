* @ValidationCode : MjotMTkwMDkzNzkyNDpDcDEyNTI6MTY4NDg1NDM5MzA0ODpJVFNTOi0xOi0xOi0yOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:33
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.MONITOR.SHIP.SELECT
*-----------------------------------------------------------------------------
* 03/09/10 - Created by Victor Nava
* Date                  who                   Reference              
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
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
