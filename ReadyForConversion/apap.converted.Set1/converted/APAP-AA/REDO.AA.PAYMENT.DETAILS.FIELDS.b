SUBROUTINE REDO.AA.PAYMENT.DETAILS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.AA.PAYOFF.DETAILS
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR-2010-03-0171
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
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '30'
*------------------------------------------------------------------------------

    fieldName = 'ARR.ID'
    fieldLength = '17'
    fieldType = 'ARR'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'EFFECTIVE.DATE'
    fieldLength = '8'
    fieldType = ''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName = 'ACTIVITY.CLASS'
    fieldLength = '35'
    fieldType = 'A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
