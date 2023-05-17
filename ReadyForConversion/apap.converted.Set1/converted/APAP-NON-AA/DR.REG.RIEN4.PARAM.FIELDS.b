*
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.RIEN4.PARAM.FIELDS
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

    ID.F = 'KEY' ; ID.N = '6.1' ; ID.T = '' ; ID.T<2> = 'SYSTEM'

    neighbour = ""
    fieldName = "FILE.NAME" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "OUT.PATH" ;  fieldLength = "65.1" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.CATEGORY.REP1" ;  fieldLength = "8" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.CATEGORY.REP2" ;  fieldLength = "8" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.CATEGORY.REP3" ;  fieldLength = "8" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.CATEGORY.REP4" ;  fieldLength = "8" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.CATEGORY.REP5" ;  fieldLength = "8" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.CATEGORY.REP6" ;  fieldLength = "8" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.CATEGORY.REP7" ;  fieldLength = "8" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.DAY.RANGE" ;  fieldLength = "10" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.REP.HEADER" ;  fieldLength = "60" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.REP.NAME" ;  fieldLength = "60" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.REP.FIELDS" ;  fieldLength = "60" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.AC.REP.FIELDS" ;  fieldLength = "60" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
*  CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
*    CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1
*   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
*    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
