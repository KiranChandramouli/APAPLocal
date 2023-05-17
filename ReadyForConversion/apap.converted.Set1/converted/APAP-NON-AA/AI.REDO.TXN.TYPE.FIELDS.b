SUBROUTINE AI.REDO.TXN.TYPE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.BRANCH.STATUS.FIELDS *
* @author riyasbasha@temenos.com
* @stereotype fields template
* Reference : ODR-2010-08-0031
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
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
    ID.N = '35'
    ID.T = 'A'


    fieldName = 'XX.LL.DESCRIPTION'
    fieldLength = '50.1'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
