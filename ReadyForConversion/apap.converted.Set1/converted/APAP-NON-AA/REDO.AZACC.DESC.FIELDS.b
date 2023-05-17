SUBROUTINE REDO.AZACC.DESC.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.AZACC.DESC.FIELDS
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
*-------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    neighbour = ''
*    fieldName = 'XX<DESC'
    fieldName = 'DESC'
    fieldLength = '50'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
*    fieldName = 'XX>XX.ASSET.TYPE'
    fieldName = 'ASSET.TYPE'
    fieldLength = '25'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
