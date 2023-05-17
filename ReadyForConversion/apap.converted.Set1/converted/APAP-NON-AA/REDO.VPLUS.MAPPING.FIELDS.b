SUBROUTINE REDO.VPLUS.MAPPING.FIELDS
* <doc>
* Template for field definitions for the application REDO.VISION.PLUS.PARAM
*
* @author: Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History
* ====================
* 04/17/2013 - Initial Version
*-----------------------------------------------------------------------------

*** <region name= Header>
*** <desc>Inserts and control logic</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
    ID.T = 'A'
*-----------------------------------------------------------------------------

    neighbour    = ''
    fieldName    = 'TRANS.PREFIX'
    fieldLength  = '4'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'XX<TRANS.CODE'
    fieldLength  = '20'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'XX-TRANS.MON.CODE'
    fieldLength  = '4'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'XX-TRANS.DESC'
    fieldLength  = '40'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'XX>TRANS.NOTES'
    fieldLength  = '80'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'XX<VP.STATUS.CODE'
    fieldLength  = '1'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'XX-T24.STATUS.CODE'
    fieldLength  = '18'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour    = ''
    fieldName    = 'XX>STATUS.DESC'
    fieldLength  = '18'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*CALL Table.addReservedField('XX-RESERVED.5')
*CALL Table.addReservedField('XX-RESERVED.4')

    neighbour    = ''
    fieldName    = 'XX<VERSION'
    fieldLength  = '50'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    neighbour    = ''
    fieldName    = 'XX>TRANS.CODE.VAL'
    fieldLength  = '20'
    fieldType    = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    CALL Table.addReservedField('XX-RESERVED.3')
    CALL Table.addReservedField('XX-RESERVED.2')
    CALL Table.addReservedField('XX>RESERVED.1')

*-----------------------------------------------------------------------------
    CALL Table.addOverrideField
    CALL Table.setAuditPosition ;* Populate audit information

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
