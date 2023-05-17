SUBROUTINE REDO.LY.GENFORM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.LY.GENFORM.FIELDS *
* @author ganeshr@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 05/04/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.F = '@ID'
    ID.N = '1'
    ID.T = ''
*------------------------------------------------------------------------------
    fieldName = 'FORM.NAME'
    fieldLength = '35'
    fieldType = ''
    fieldType<2>='Cantidad de Puntos Enteros_Factor de Generacion'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
