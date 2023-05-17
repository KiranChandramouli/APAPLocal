SUBROUTINE REDO.ACCT.COMP.EXCE.FIELDS
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
* Date          Who          Refernce          Description
* 20-OCT-2011   Pradeep M    PACS00071941      Initial Creation
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    ID.F = '@ID'
    ID.N = '15'
    ID.T='A'
*------------------------------------------------------------------------------
    fieldName = 'ACCOUNT'
    fieldLength = '20'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

RETURN
*-----------------------------------------------------------------------------
END
