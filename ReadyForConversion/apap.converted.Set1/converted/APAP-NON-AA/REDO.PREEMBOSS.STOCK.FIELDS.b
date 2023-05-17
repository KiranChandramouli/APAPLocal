SUBROUTINE REDO.PREEMBOSS.STOCK.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.STOCK.REGISTER
* @author KAVITHA
* @stereotype fields template
* Reference : ODR-2010-03-0400
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
    $INSERT I_Table

*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = "@ID"
    ID.N = '35'
    ID.T = 'A'
*------------------------------------------------------------------------------
    fieldName = 'SERIES.BAL'
    fieldLength = '35'
    fieldType = "A"
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    V = Table.currentFieldPosition

RETURN
*-----------------------------------------------------------------------------
END
