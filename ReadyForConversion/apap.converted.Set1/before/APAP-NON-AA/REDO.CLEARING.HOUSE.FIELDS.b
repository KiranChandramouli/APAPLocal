*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CLEARING.HOUSE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CLEARING.HOUSE.FIELDS
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR-2010-09-0148
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
  ID.F = '@ID'
  ID.N = '2'
  ID.T = ''
*------------------------------------------------------------------------------
  fieldName = 'DESCRIPTION'
  fieldLength = '35'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.1'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.2'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.3'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.4'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.5'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.6'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.7'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.8'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.9'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.10'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.11'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.12'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.13'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.14'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.15'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
