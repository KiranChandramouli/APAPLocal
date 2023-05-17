*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INTERFACE.ACT.DETAILS.FIELDS
*-----------------------------------------------------------------------------
* <doc>
*
* This table is used to store all the events in the interface activity
*
* author: rshankar@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 26/07/2010 - C.22 New Template Creation
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id

  ID.F = '@ID'
  ID.N = '33'
  ID.T = 'A'
*-----------------------------------------------------------------------------

  fieldName="ID.INTERFACE.ACT"
  fieldLength="12"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="ID.MONITOR.TYPE"
  fieldLength="100"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="ORIGIN.ENT"
  fieldLength="35"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="DEST.ENT"
  fieldLength="35"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RECORD.ID"
  fieldLength="15"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="DESCRIPTION"
  fieldLength="200"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="REC.CONTENT"
  fieldLength="200"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="TIME"
  fieldLength="20"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="USER"
  fieldLength="15"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="MACHINE"
  fieldLength="20"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
