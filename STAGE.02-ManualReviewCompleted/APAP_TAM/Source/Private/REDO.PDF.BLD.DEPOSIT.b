$PACKAGE APAP.TAM
SUBROUTINE REDO.PDF.BLD.DEPOSIT(ENQ.DATA)
*-----------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : Shiva Prasad
*IN DATA           : O.DATA
*OUT DATA          : O.DATA
*---------------------------------------------------------------------------------
*DESCRIPTION       : This Routine has been attached to the Enquiry for PDF
* ----------------------------------------------------------------------------------
*Insert Files
*--------------------------------------------------------------------------------------
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

    PDF.DATA = ''
    CALL System.setVariable("CURRENT.SCA.PDF.DATA",PDF.DATA)
RETURN
END
