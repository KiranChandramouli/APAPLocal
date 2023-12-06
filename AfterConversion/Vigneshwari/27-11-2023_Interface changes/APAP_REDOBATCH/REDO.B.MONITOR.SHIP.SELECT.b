* @ValidationCode : MjotMTg3OTg1MjkyNDpDcDEyNTI6MTcwMTA4OTI3MTg3NDp2aWduZXNod2FyaTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Nov 2023 18:17:51
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

SUBROUTINE REDO.B.MONITOR.SHIP.SELECT
*-----------------------------------------------------------------------------
* 03/09/10 - Created by Victor Nava
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*27-11-2023	      VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES-SQA-11542 | MONITOR  – By Santiago
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
;*Fix SQA-11542 | MONITOR - By Santiago-New lines added & commented-start
*  this is only for tests
*    SEL.CMD = 'SELECT ':FN.REDO.MON.SEND.QUEUE:' WITH @ID LIKE 204169559814756...'
*    CALL EB.READLIST(SEL.CMD, Y.AZ.LIST,'',NO.SEL,SEL.ERR)
*    CALL BATCH.BUILD.LIST("",Y.AZ.LIST)
 ;*Fix SQA-11542 | MONITOR - By Santiago-end   

RETURN
*-----------------------------------------------------------------------------
END
