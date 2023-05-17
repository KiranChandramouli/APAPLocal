SUBROUTINE REDO.E.BLD.REPO.PDF(ENQ.DATA)
*-----------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : Shiva Prasad
*Program   Name    : REDO.TAKE.TRANS.REF
*IN DATA           : O.DATA
*OUT DATA          : O.DATA
*---------------------------------------------------------------------------------
*DESCRIPTION       : This Routine has been attached to the Enquiry for PDF
* ----------------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------
*Insert Files
*-----------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System

    PDF.HEADER = ''
    PDF.DATA = 'NULL'
    PDF.FOOTER = ''
    CALL System.setVariable("CURRENT.SCA.PDF.HEADER",PDF.HEADER)
    CALL System.setVariable("CURRENT.SCA.PDF.DATA",PDF.DATA)
    CALL System.setVariable("CURRENT.SCA.PDF.FOOTER",PDF.FOOTER)
RETURN
END
