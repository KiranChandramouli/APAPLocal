*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ID.SCV.PROCESS
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      FS-360       Manju.G          REDO.SCV.OUTSTANDING.PROCESSES.SCV
*
*------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
$INSERT I_F.ENQUIRY
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER

  GOSUB INITIALISE
  GOSUB PROCESS
*
  RETURN

INITIALISE:
*************

  FN.CR.CONTACT = 'F.CR.CONTACT.LOG'
  F.CR.CONTACT = ''
  CALL OPF(FN.CR.CONTACT,F.CR.CONTACT)

  RETURN

PROCESS:
**********
  IF COMI EQ 'CURRENT.PROCESS' THEN
    Y.VARIABLE = "CURRENT.PROCESS"
    COMI = System.getVariable(Y.VARIABLE)
  END

  RETURN
END
