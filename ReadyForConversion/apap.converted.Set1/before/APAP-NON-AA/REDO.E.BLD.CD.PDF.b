*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.CD.PDF(ENQ.DATA)
*-----------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : Prabhu N
*Program   Name    : REDO.E.BLD.CD.PDF
*IN DATA           : O.DATA
*OUT DATA          : O.DATA
*---------------------------------------------------------------------------------
*DESCRIPTION       : This Routine has been attached to the Enquiry for PDF
* ----------------------------------------------------------------------------------
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
  CALL System.setVariable("CURRENT.SCA.PDF.HEADER",PDF.HEADER)
  CALL System.setVariable("CURRENT.SCA.PDF.DATA",PDF.DATA)
  RETURN
END
