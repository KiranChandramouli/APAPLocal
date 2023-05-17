*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.L.ADMIN.DEP.DETS.FIELDS
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
  ID.F = '@ID'
  ID.N = '35'
  ID.T = 'ANY'
*-----------------------------------------------------------------------------

  fieldName = 'FT.ID'
  fieldLength = '18'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'AZ.ID'
  fieldLength = '18'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'CHQ.ISS.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'CHQ.NNUMBER'
  fieldLength = '18'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'ISSUER'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'AUTHORISER'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'CHQ.AMOUNT'
  fieldLength = '18'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'ADMIN.CHK.ID'
  fieldLength = '18'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'CURRENCY'
  fieldLength = '3'
  fieldType = 'CCY'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'CATEGORY'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'CO.CODE'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'BENEF.NAME'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'RESERVED.9'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'RESERVED.8'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'RESERVED.7'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'RESERVED.6'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'RESERVED.5'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'RESERVED.4'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'RESERVED.3'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'RESERVED.2'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName = 'RESERVED.1'
  fieldLength = ''
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
