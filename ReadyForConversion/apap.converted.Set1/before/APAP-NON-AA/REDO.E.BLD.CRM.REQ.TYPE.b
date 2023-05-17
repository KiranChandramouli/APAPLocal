*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BLD.CRM.REQ.TYPE(ENQ.DATA)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : PRADEEP S
* Program Name  : REDO.E.BLD.CRM.REQ.TYPE
*-------------------------------------------------------------------------

* Description : This is a Build routine which will be executed to display the
* Request type based on the SLA parameter

* In parameter : ENQ.DATA
* out parameter : ENQ.DATA
* Linked with : Build routine for the enquiry REDO.DES.CLAIM.LIST
*-------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.ENQUIRY
$INSERT I_System
$INSERT I_F.REDO.FRONT.REQUESTS

  GOSUB PROCESS

  RETURN
*********
PROCESS:
*********

  Y.TYPE = R.NEW(FR.CM.TYPE)
  Y.PRODUCT.TYPE = R.NEW(FR.CM.PRODUCT.TYPE)
  Y.SLA.ID = Y.TYPE:"-":Y.PRODUCT.TYPE

  ENQ.DATA<2,1> = '@ID'
  ENQ.DATA<3,1> = 'EQ'
  ENQ.DATA<4,1> = Y.SLA.ID

  RETURN

************************************************************************
END
