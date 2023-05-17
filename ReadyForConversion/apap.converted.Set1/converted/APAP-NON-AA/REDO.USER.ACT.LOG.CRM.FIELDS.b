SUBROUTINE REDO.USER.ACT.LOG.CRM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.USER.ACT.LOG.CRM
*
* @author GANESHR@temenos.com
* @LIVE template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("@ID", T24_String)        ;* Define Table id

    ID.F = '@ID' ; ID.N = '16'
    ID.T = 'AA'   ; ID.CHECKFILE='USER'
*------------------------------------------------------------------------------
    fieldName="XX<CASE.ID"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="XX-CASE.TYPE"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="XX-CUSTOMER.ID"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="XX>DATE"
    fieldLength="8"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

RETURN
*-----------------------------------------------------------------------------------
END
