* @ValidationCode : MjotMTQyNTA4OTAxMDpDcDEyNTI6MTY4MDg4ODMwMTg0NDpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 07 Apr 2023 22:55:01
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.PDF.DATA.PROCESS
*-----------------------------------------------------------------------------

*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : REDO.PDF.DATA.PROCESS

*-----------------------------------------------------------------------------

*Description       : This routine is used pdf purpose
*In  Parameter     : N/A
*Out Parameter     : N/A
*ODR Number        :
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - New condition added
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*

*---------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*Insert Files
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

*-----------------------------------------------------------------------------

    PDF.DATA= System.getVariable('CURRENT.SCA.PDF.DATA')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN         ;** R22 Auto Conversion - Start
        PDF.DATA = ""
    END                                        ;** R22 Auto Conversion - End

    IF PDF.DATA EQ 'NULL' THEN
        PDF.DATA=''
    END
    PDF.DATA = PDF.DATA : O.DATA
    CALL System.setVariable("CURRENT.SCA.PDF.DATA",PDF.DATA)
RETURN
END
