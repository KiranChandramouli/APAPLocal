*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE AI.REDO.LIST.CRM.PRODUCTS.VALIDATE
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*  DATE             WHO         REFERENCE         DESCRIPTION

*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.AI.REDO.LIST.CRM.PRODUCTS

  AV.LIST = REDO.CRM.DESCRIPTION
  CALL  DUP.FLD.SET(AV.LIST)
END
