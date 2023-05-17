SUBROUTINE REDO.LOCALIDAD.FIELDS

*<doc>
* Template for field definitions routine
* @author
* @stereotype fields template
* Reference :
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 24/02/11 -
*            New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id

    ID.F = '@ID'
*    ID.N = '7'
    ID.N = '6.6'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'XX.DESCRIPTION'
    fieldLength = '55'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.setAuditPosition ;* Poputale audit information

*------------------------------------------------------------------------------

RETURN

END
