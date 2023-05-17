*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.STORE.SUNN.CUS.ST.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  :
* Program Name  :
*-----------------------------------------------------------------------------
* Description : This application is linked to REDO.AA.NAB.HISTORY
*-----------------------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId('ID', T24_String)
  ID.CHECKFILE = 'CUSTOMER'
*-----------------------------------------------------------------------------

  fieldName = 'STATUS'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*  CALL Table.setAuditPosition

  RETURN
*-----------------------------------------------------------------------------
END
