*-----------------------------------------------------------------------------
* <Rating>-6</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.L.SERIES.CHANGE.DETS.FIELDS
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = '35'
  ID.T = 'ANY'
*-----------------------------------------------------------------------------

  fieldName = 'XX.STATUS'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'CATEGORY'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'XX<AZ.ID'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'XX>DEP.ID'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'DATE'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'Reserved.1'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
