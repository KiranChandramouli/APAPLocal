SUBROUTINE REDO.COLLATERAL.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Fields definition for REDO.COLLATERAL.PARAMETER
*
* @author lpazminodiaz@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
* --------------------
* 07.01.2011 - Initial Version
*-----------------------------------------------------------------------------
*** <region name= Header>
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_DataTypes
*** </region>

*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
*
    neighbour = ''
    fieldName = 'XX<COLLATERAL.TYPE'
    fieldLength = 3.1
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('COLLATERAL.TYPE')
*
    neighbour = ''
    fieldName = 'XX-CR.CATEGORY.CODE'
    fieldLength = 5.1
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CATEGORY')
*
    neighbour = ''
    fieldName = 'XX-DB.CATEGORY.CODE'
    fieldLength = 5.1
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CATEGORY')
*
    neighbour = ''
    fieldName = 'XX-XX<CURRENCY'
    fieldLength = 3.1
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CURRENCY')
*
    neighbour = ''
    fieldName = 'XX-XX-CR.INT.ACCOUNT'
    fieldLength = 16.1
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-XX>DB.INT.ACCOUNT'
    fieldLength = 16.1
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    neighbour = ''
    fieldName = 'XX-CR.TRX.CODE'
    fieldLength = 3.1
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('TRANSACTION')
*
    neighbour = ''
    fieldName = 'XX>DB.TRX.CODE'
    fieldLength = 4.1
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('TRANSACTION')
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

    CALL Table.setAuditPosition ;* Populate audit information

RETURN
*------------------------------------------------------------------------------------------------------------------
END
