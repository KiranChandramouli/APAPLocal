SUBROUTINE REDO.ITEM.STOCK.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.STOCK.REGISTER
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
* 18/05/11 -New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = "@ID"
    ID.N = '35'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'XX<ITEM.CODE'
    fieldLength = '35'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX-DESC'
    fieldLength = '65'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX-BAL'
    fieldLength = '35'
    fieldType = ""
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'XX>ORDER.STATUS'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')
    CALL Table.addLocalReferenceField('XX.LOCAL.REF')
    CALL Table.addOverrideField
    CALL Table.setAuditPosition

RETURN
*-----------------------------------------------------------------------------
END
