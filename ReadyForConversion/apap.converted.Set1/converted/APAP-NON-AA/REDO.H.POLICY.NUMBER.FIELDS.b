SUBROUTINE REDO.H.POLICY.NUMBER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.H.POLICY.NUMBER.FIELDS *
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR2009100340
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
    ID.F = '@ID'
    ID.N = '3'
    ID.T = 'A'
*------------------------------------------------------------------------------

    fieldName = 'DESCRIPTION'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'POLICY.NUMBER'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    CALL Table.addLocalReferenceField(XX.LOCAL.REF)
    CALL Table.addOverrideField

    CALL Table.addReservedField("RESERVED.15")
    CALL Table.addReservedField("RESERVED.14")
    CALL Table.addReservedField("RESERVED.13")
    CALL Table.addReservedField("RESERVED.12")
    CALL Table.addReservedField("RESERVED.11")
    CALL Table.addReservedField("RESERVED.10")
    CALL Table.addReservedField("RESERVED.9")
    CALL Table.addReservedField("RESERVED.8")
    CALL Table.addReservedField("RESERVED.7")
    CALL Table.addReservedField("RESERVED.6")
    CALL Table.addReservedField("RESERVED.5")
    CALL Table.addReservedField("RESERVED.4")
    CALL Table.addReservedField("RESERVED.3")
    CALL Table.addReservedField("RESERVED.2")
    CALL Table.addReservedField("RESERVED.1")

    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
