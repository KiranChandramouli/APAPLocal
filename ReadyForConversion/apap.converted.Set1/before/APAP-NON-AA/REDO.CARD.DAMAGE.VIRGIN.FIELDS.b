*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.DAMAGE.VIRGIN.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = '25'
  ID.T = 'A'

  fieldName="REG.ID"
  fieldLength="20"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX<CARD.TYPE"
  fieldLength="20.1"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CARD.TYPE')

  fieldName="XX-SERIES"
  fieldLength="20"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-LOST"
  fieldLength="35"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-XX.LOST.DESC"
  fieldLength="65"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-DAMAGE"
  fieldLength="20"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX>XX.DAM.DESC"
  fieldLength="65"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



  fieldName="DATE.DL"
  fieldLength="8"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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

  CALL Table.addOverrideField
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
