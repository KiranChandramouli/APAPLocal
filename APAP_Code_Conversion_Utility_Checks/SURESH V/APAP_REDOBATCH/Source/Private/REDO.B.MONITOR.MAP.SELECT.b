* @ValidationCode : MjotMTkzNjY2NDcyNDpDcDEyNTI6MTcwMTEwOTYzNjExMjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Nov 2023 23:57:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH

SUBROUTINE REDO.B.MONITOR.MAP.SELECT
*-----------------------------------------------------------------------------
*
* 30/08/2010 - Created by Cesar Yepez
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*27-11-2023	     VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES- SQA-11542 | MONITOR  – By Santiago
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MONITOR.MAP.COMMON
*-----------------------------------------------------------------------------
*

    LIST.PARAMETER = ''
    LIST.PARAMETER<2> = FN.REDO.MON.MAP.QUEUE
    CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')
;*Fix SQA-11542 | MONITOR – By Santiago-new added &commented-start
*    this is only for tests
*    SEL.CMD = 'SELECT ': FN.REDO.MON.MAP.QUEUE : ' WITH @ID LIKE 204169559814756...'
*    CALL EB.READLIST(SEL.CMD, Y.AZ.LIST,'',NO.SEL,SEL.ERR)
*    CALL BATCH.BUILD.LIST("",Y.AZ.LIST)
 ;*Fix SQA-11542 | MONITOR – By Santiago-end   
*

RETURN
*-----------------------------------------------------------------------------
END

