*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BUILD.LOAN.DETS(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.APAP.ARC.LOAN.DETS
*----------------------------------------------------------

* Description   : This subroutine is used to set selection for REDO.APAP.ARC.LOAN.DETS

*Linked with   : REDO.APAP.ARC.LOAN.DETS
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
  Y.PRODUCT= System.getVariable('CURRENT.PRODUCT.ID')
  RETURN
*-------
PROCESS:
*-------
  Y.FIELD.COUNT=DCOUNT(ENQ.DATA<2>,VM)
  ENQ.DATA<2,Y.FIELD.COUNT+1>= 'ARRANGEMENT.ID'
  ENQ.DATA<3,Y.FIELD.COUNT+1>= 'EQ'
  ENQ.DATA<4,Y.FIELD.COUNT+1> = Y.PRODUCT
  RETURN
END
