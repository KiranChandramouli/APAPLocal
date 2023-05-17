*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.STOCK.ENTRY.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.STOCK.ENTRY.FIELDS
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR-2010-08-0469
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 18/05/11 - New Template changes
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
  ID.N = '12'
  ID.T = 'A'
*------------------------------------------------------------------------------
  fieldName = 'IN.OUT.DATE'
  fieldLength = '8.1'
  fieldType = 'D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'FROM.REGISTER'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('REDO.STOCK.REGISTER')

  fieldName = 'TO.REGISTER'
  fieldLength = '20.1'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX<STOCK.SERIES'
  fieldLength = '35.1'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('CARD.TYPE')

  fieldName = 'XX>STOCK.QUANTITY'
  fieldLength = '35.1'
  fieldType = ""
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'NOTES'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'BATCH.NO'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('REDO.CARD.REQUEST')

  CALL Table.addLocalReferenceField('XX.LOCAL.REF')
  CALL Table.addOverrideField

  CALL Table.addReservedField('RESERVED.20')
  CALL Table.addReservedField('RESERVED.19')
  CALL Table.addReservedField('RESERVED.18')
  CALL Table.addReservedField('RESERVED.17')
  CALL Table.addReservedField('RESERVED.16')
  CALL Table.addReservedField('RESERVED.15')
  CALL Table.addReservedField('RESERVED.14')
  CALL Table.addReservedField('RESERVED.13')
  CALL Table.addReservedField('RESERVED.12')
  CALL Table.addReservedField('RESERVED.11')
  CALL Table.addReservedField('RESERVED.10')
  CALL Table.addReservedField('RESERVED.9')
  CALL Table.addReservedField('RESERVED.8')
  CALL Table.addReservedField('RESERVED.7')
  CALL Table.addReservedField('RESERVED.6')
  CALL Table.addReservedField('RESERVED.5')
  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
