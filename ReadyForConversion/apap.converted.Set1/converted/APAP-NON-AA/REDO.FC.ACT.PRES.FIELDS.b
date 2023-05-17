SUBROUTINE REDO.FC.ACT.PRES.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Fields definition for REDO.FC.ACT.PRES
*
* @author btorresalbornoz@temenos.com
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


    neighbour = ''
    fieldName = 'DESC.PRODUCT'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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



    CALL Table.setAuditPosition ;* Populate audit information

RETURN
*------------------------------------------------------------------------------------------------------------------
END
