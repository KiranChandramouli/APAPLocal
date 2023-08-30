$PACKAGE APAP.TAM
SUBROUTINE REDO.PDF.DATA.DEPOSIT

*-----------------------------------------------------------------------------

*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : REDO.PDF.DATA.DEPOSIT

*-----------------------------------------------------------------------------

*Description       : This routine is used pdf purpose
*In  Parameter     : N/A
*Out Parameter     : N/A
*ODR Number        :

*-----------------------------------------------------------------------------
*Modification History:
*-----------------------------------------------------------------------------
*    Initial Development for APAP ARC - IB
*-----------------------------------------------------------------------------
*Insert Files
*-----------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*---------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

*-----------------------------------------------------------------------------

    PDF.DATA = O.DATA
    CALL System.setVariable("CURRENT.SCA.PDF.DATA",PDF.DATA)
RETURN
END
