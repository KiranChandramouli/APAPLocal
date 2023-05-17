*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ORDER.TYPE.AUTO

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : RAJA SAKTHIVEL K P
* Program Name : REDO.E.CNV.REL.DESC
*---------------------------------------------------------

* Description :
*----------------------------------------------------------
* Linked With :
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
* Modification History:
* 02-Jun-2010 - HD1021443
* Modification made on referring to gosub WITH.RG.1.299.ONLY section for the ENQUIRY REDO.CUST.RELATION.VINC only
*----------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON


  Y.FLAG = ''
  FINDSTR "UPDATE.PASSBOOK" IN O.DATA SETTING POS THEN
    Y.FLAG = '1'
  END
  IF Y.FLAG THEN
    O.DATA = 'AUTOMATICA'

  END ELSE
    O.DATA = 'MANUAL'

  END

  RETURN

END
