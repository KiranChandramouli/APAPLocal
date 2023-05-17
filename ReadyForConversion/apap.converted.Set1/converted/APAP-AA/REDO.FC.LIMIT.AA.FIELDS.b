SUBROUTINE REDO.FC.LIMIT.AA.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.FC.LIMIT.AA
*
* @author lpazminodiaz@temenos.com
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

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------

    CALL Table.defineId("LIMIT.REFERENCE", T24_String)        ;* Define Table id

*-----------------------------------------------------------------------------

    neighbour = ''
    fieldName = 'XX.ARRANGEMENT.ID'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field


*-----------------------------------------------------------------------------
END
