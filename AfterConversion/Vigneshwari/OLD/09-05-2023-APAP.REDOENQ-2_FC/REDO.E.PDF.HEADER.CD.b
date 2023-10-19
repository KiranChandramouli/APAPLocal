$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.PDF.HEADER.CD

*-----------------------------------------------------------------------------

*Company   Name    : APAP
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.PDF.HEADER.CD

*-----------------------------------------------------------------------------

*Description       : This routine is used pdf purpose
*In  Parameter     : N/A
*Out Parameter     : N/A
*ODR Number        :

*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
* 12-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 12-APRIL-2023      Harsha                R22 Manual Conversion - No changes 
*---------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*Insert Files
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    PDF.HEADER = O.DATA
    CALL System.setVariable("CURRENT.SCA.PDF.HEADER",PDF.HEADER)
RETURN
END
