*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHK.SAVE.CUST.ID
*---------------------------------------------------------------------------------
* This is a CHECK.REC.RTN to save the Customer id in a common variable.
*----------------------------------------------------------------------------------
* Company Name  : APAP
* Developed By  : SHANKAR RAJU
* Program Name  : REDO.CHK.SAVE.CUST.ID
* ODR NUMBER    : ODR-2009-10-0315
* HD Reference  : PACS00092771
*----------------------------------------------------------------------
*MODIFICATION DETAILS:
*   DATE            DEVELOPER          REFERENCE            DESCRIPTION
* 30-JULY-2011    GANESH HARIDAS     PACS00092771 - B.29   Save a ID to a Common variable
*----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_System
  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------------------
PROCESS:
*-------

  CALL System.setVariable("CURRENT.AZ.ID.REF",ID.NEW)

  RETURN
END
