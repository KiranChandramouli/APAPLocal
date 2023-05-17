SUBROUTINE REDO.FC.BH.VALIDATIONS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine GENERAL ARRANGEMENT FIELDS
* @author MGUDINO@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*  DATE              WHO                       Modification
*        MGUDINO
*-----------------------------------------------------------------------------
*** <region name= Header>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------

*
    neighbour = ''
    fieldName = 'XX<DESCRIP.RUTINE'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'XX>NAME.RUTINE'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------

    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

    CALL Table.addOverrideField
*
*----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
*------------------------------------------------------------------------------------------------------------------

END
