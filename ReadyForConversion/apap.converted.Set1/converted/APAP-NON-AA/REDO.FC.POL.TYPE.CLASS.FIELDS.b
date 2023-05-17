SUBROUTINE REDO.FC.POL.TYPE.CLASS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.FC.POL.TYPE.CLASS.FIELDS
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
    fieldName = 'XX<POLICY.TYPE'
    fieldLength = '50'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-POLICY.CLASS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-POLICY.PROP'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-POLICY.PRIMA'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-POLICY.EXTRA.PR'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-POLICY.TOTMES.PR'
    fieldLength = '16'
    fieldType = 'T24_Numeric'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-POLICY.TOTAL.PR'
    fieldLength = '10'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-POLICY.COMPAN.INS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-POLICY.COND'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-POLICY.RUBRO'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX>POLICY.RUBRO.COM'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    CALL Table.addReservedField('RESERVED.10')
*    CALL Table.addReservedField('RESERVED.9')
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
