*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BUILD.GET.CUST.ID(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name :REDO.E.BUILD.GET.CUST.ID
*----------------------------------------------------------

* Description   : This subroutine is used to set selection for customer ID

* Linked with   : REDO.E.BUILD.GET.CUST.ID
* In Parameter  : ENQ.DATA
* Out Parameter : ENQ.DATA
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*07.04.2011     PACS00036498           Prabhu N            INITIAL CREATION
*---------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_System

  GOSUB INIT
  GOSUB PROCESS
  RETURN
*-----
INIT:
*-----

  Y.CUSTOMER= System.getVariable('EXT.SMS.CUSTOMERS')
  RETURN
*-------
PROCESS:
*-------
  Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,VM)
  ENQ.DATA<2,Y.FIELD.COUNT+1>= '@ID'
  ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
  ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.CUSTOMER
  RETURN
END
