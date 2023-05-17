SUBROUTINE TOLERANCE.CATEG.RANGE.FIELDS
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
*CALL Table.defineId("@ID", T24_String)        ;* Define Table id
    ID.F=""
    ID.N="10"
    ID.T=""
    ID.CONCATFILE = "AR"
*-----------------------------------------------------------------------------

    fieldName="XX.LL.DESCRIPTION"
    fieldLength=35.1
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="MIN.LIM.AGNCY"
    fieldLength="5"
    fieldType="R"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName ="MAX.LIM.AGNCY"
    fieldLength ="5"
    fieldType="R"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName ="MIN.LIM.CASHIER"
    fieldLength ="5"
    fieldType="R"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName ="MAX.LIM.CASHIER"
    fieldLength ="5"
    fieldType="R"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*-----------------------------------------------------------------------------

    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN

*-----------------------------------------------------------------------------
END
