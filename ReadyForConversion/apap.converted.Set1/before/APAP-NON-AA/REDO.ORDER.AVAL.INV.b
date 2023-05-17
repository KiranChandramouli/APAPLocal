*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ORDER.AVAL.INV(ENQ.DATA)

****************************************************
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : JEEVA T
* Program Name : REDO.ORDER.AVAL.INV
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
$INSERT I_F.USER
$INSERT I_F.EB.LOOKUP
$INSERT I_F.REDO.H.MAIN.COMPANY
$INSERT I_F.REDO.H.REASSIGNMENT


  LOCATE 'ACCOUNT' IN ENQ.DATA<2,1> SETTING POS1 THEN
    Y.VALUE = ENQ.DATA<4,POS1>
  END

  Y.ITEM = R.NEW(RE.ASS.ITEM.CODE)
  Y.CODE = R.NEW(RE.ASS.CODE)
  Y.BRANCH = R.NEW(RE.ASS.DEPT)

  ENQ.DATA<2,-1> = "ITEM.CODE"
  ENQ.DATA<3,-1> = "EQ"
  ENQ.DATA<4,-1> = Y.ITEM

  ENQ.DATA<2,-1> = "BRANCH.DEPT"
  ENQ.DATA<3,-1> = "EQ"
  ENQ.DATA<4,-1> = Y.BRANCH

  ENQ.DATA<2,-1> = "CODE"
  ENQ.DATA<3,-1> = "EQ"
  ENQ.DATA<4,-1> = Y.CODE

  RETURN

END
