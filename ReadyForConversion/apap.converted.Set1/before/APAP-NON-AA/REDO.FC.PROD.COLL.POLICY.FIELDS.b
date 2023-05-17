*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.PROD.COLL.POLICY.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.FC.PROD.COLL.POLICY.FIELDS
*
* @author iromanvera@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
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
*-----------------------------------------------------------------------------
*
  neighbour = ''
  fieldName = 'PRODUCT.TYPE'
  fieldLength = '50.1'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  neighbour = ''
  fieldName = 'XX<TIPO.POLIZA'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  neighbour = ''
  fieldName = 'XX>PRES.MANDATORIO'
  fieldLength = '2'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  neighbour = ''
  fieldName = 'XX<COLLATERAL.CODE'
  fieldLength = '3.1'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  neighbour = ''
  fieldName = 'XX-XX<COLLATERAL.TYPE'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  neighbour = ''
  fieldName = 'XX-XX-POLICY.TYPE'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  neighbour = ''
  fieldName = 'XX>XX>POLI.MANDATORIO'
  fieldLength = '2'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
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

  CALL Table.setAuditPosition ;* Poputale audit information

  RETURN
*------------------------------------------------------------------------------------------------------------------
END
