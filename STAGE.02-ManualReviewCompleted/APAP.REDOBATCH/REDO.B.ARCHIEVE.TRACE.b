* @ValidationCode : MjotMjExNzcwNDU0MzpDcDEyNTI6MTY4MDc4MTE1OTEwNDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 17:09:19
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
SUBROUTINE REDO.B.ARCHIEVE.TRACE(TRACE.ARC.ID)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AUDIT.TRAIL.LOG
    $INSERT I_F.REDO.EX.AUDIT.TRAIL.LOG
    $INSERT I_REDO.B.ARCHIEVE.TRACE.COMMON
*-----------------------------------------------------------------------------
* Move the files from REDO.AUDIT.TRAIL.LOG to Y.PATH
* Date                  who                   Reference              
* 06-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
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
