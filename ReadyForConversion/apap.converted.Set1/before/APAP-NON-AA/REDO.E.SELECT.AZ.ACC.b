*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.SELECT.AZ.ACC(ENQ.DATA)
************************************************************
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRABHU N
* Program Name : REDO.E.INS.SELECT
*----------------------------------------------------------

* Description   : This subroutine will return the list of AZ PRODUCT PARAMETERS
* Linked with   : Enquiry REDO.E.INS.SELECT as conversion routine
* In Parameter  : None
* Out Parameter : None
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_System
  VAR.SEL.LIST =ENQ.DATA<2>
  VAR.SEL.SIZE =DCOUNT(VAR.SEL.LIST,VM)

  ENQ.DATA<2,VAR.SEL.SIZE+1>= 'CUSTOMER'
  ENQ.DATA<3,VAR.SEL.SIZE+1>= 'EQ'
  ENQ.DATA<4,VAR.SEL.SIZE+1>= System.getVariable("EXT.SMS.CUSTOMERS")
  
  RETURN
END
