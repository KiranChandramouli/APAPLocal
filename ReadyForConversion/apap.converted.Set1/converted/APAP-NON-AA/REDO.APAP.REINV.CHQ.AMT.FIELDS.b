SUBROUTINE REDO.APAP.REINV.CHQ.AMT.FIELDS
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
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '35'
    ID.T = 'A'   ;
*------------------------------------------------------------------------------

    fieldName="XX<XX.PROCESS.ID"
    fieldLength="20"
    neighbour=''
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-XX.AMOUNT"
    fieldLength="20"
    neighbour=''
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX>XX.STATUS"
    fieldLength="20"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
