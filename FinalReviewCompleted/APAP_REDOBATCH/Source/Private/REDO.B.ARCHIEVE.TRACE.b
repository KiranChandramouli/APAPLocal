* @ValidationCode : MjotMjExNzcwNDU0MzpDcDEyNTI6MTY4NDg1NDM3OTc2NjpJVFNTOi0xOi0xOjg4OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 88
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.ARCHIEVE.TRACE(TRACE.ARC.ID)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AUDIT.TRAIL.LOG
    $INSERT I_F.REDO.EX.AUDIT.TRAIL.LOG
    $INSERT I_REDO.B.ARCHIEVE.TRACE.COMMON
*-----------------------------------------------------------------------------
* Move the files from REDO.AUDIT.TRAIL.LOG to Y.PATH
* Date                  who                   Reference              
* 06-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 06-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB PROCESS

RETURN

INIT:
    Y.CMD.CPY = ''

RETURN

*-------
PROCESS:
*-------

    Y.CMD.CPY = 'COPY FROM ':FN.REDO.AUDIT.TRAIL.LOG:' TO ':Y.PATH: ' ': TRACE.ARC.ID
    EXECUTE Y.CMD.CPY

RETURN
END
