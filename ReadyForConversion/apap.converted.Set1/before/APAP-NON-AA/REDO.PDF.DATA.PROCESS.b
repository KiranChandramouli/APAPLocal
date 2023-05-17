*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
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

  IF PDF.DATA EQ 'NULL' THEN
    PDF.DATA=''
  END
  PDF.DATA = PDF.DATA : O.DATA
  CALL System.setVariable("CURRENT.SCA.PDF.DATA",PDF.DATA)
  RETURN
END
