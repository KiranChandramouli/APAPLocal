*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.REPORT.NAME.VALUE

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.E.CNV.PROD.CODE
*---------------------------------------------------------

* Description : This subroutine is attached as a conversion routine to enquiry REDO.PLASTIC.CARD.BRANCH
* to calculate total no of card lost for the request

*----------------------------------------------------------
* Linked With : Enquiry REDO.E.CNV.COUNT.LOST
* In Parameter : None
* Out Parameter : None
*----------------------------------------------------------
* Modification History:
*----------------------------------------------------------
*
* 31-May-2010 - HD1021443
* This section of routine will remove entries, which has RELATION.CODE specified not in range from 1 to 299
*
* 02-Jun-2010 - HD1021443
* Modification made on referring to gosub WITH.RG.1.299.ONLY section for the ENQUIRY REDO.CUST.RELATION.VINC only
*----------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON


  Y.VALUE = O.DATA
  O.DATA = Y.VALUE:"zado"
  RETURN
END
