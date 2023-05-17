*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BLD.CONT.CUS(ENQ.DATA)
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------
* Modification History
* DATE            ODR           BY              DESCRIPTION
* 25-08-2011      FS-360       Manju.G          For enquiry REDO.SCV.CONTACT.CURR.SCV
*
*------------------------------------------------------------------------------
*
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ENQUIRY
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_System

  GOSUB INITIALISE
  GOSUB PROCESS
*
  RETURN

INITIALISE:
*************

  FN.CUSTOMER = 'F.CUSTOMER'
  F.CUSTOMER = ''
  CALL OPF(FN.CUSTOMER,F.CUSTOMER)

  FN.CR.CONTACT = 'F.CR.CONTACT.LOG'
  F.CR.CONTACT = ''
  CALL OPF(FN.CR.CONTACT,F.CR.CONTACT)

  RETURN

PROCESS:
**********

  Y.CURR.VALUE = System.getVariable("CURRENT.CONTENT")
 

  ENQ.DATA<2,-1> = "CONTRACT.ID"
  ENQ.DATA<3,-1> = "EQ"
  ENQ.DATA<4,-1> = Y.CURR.VALUE
  RETURN
END
