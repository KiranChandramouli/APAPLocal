* @ValidationCode : MjoxOTk5MzY0Nzk2OkNwMTI1MjoxNzA0MzY3OTczNDQwOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Jan 2024 17:02:53
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
 
SUBROUTINE REDO.B.MONITOR.MAP.SELECT
*-----------------------------------------------------------------------------
*
* 30/08/2010 - Created by Cesar Yepez
* Date                  who                   Reference
* 12-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*27-11-2023	     VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES- SQA-11542 | MONITOR  – By Santiago
*
*18/01/2024         Suresh             R22 AUTO CONVERSION  CALL routine Modified
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.MONITOR.MAP.COMMON
    $USING EB.Service ;* R22 AUTO CONVERSION
*-----------------------------------------------------------------------------
*

    LIST.PARAMETER = ''
    LIST.PARAMETER<2> = FN.REDO.MON.MAP.QUEUE
*CALL BATCH.BUILD.LIST(LIST.PARAMETER,'')
    EB.Service.BatchBuildList(LIST.PARAMETER,'') ;* R22 AUTO CONVERSION
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

