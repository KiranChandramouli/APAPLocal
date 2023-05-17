*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.RECIPT.DATE
*-------------------------------------------------------------------------
*DIS:is the record routine will default the @ID value in the field GARNISHMENT.REF
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPUL
* Developed By  : JEEVA T
* Program Name  : REDO.H.RECIPT.DATE
* ODR NUMBER    : HD1053868
*----------------------------------------------------------------------
*Input param = none
*output param =none
*--------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.ORDER.DETAILS

  R.NEW(RE.ORD.RECEIPT.DATE) = TODAY

  RETURN
*---------------------
END
