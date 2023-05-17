SUBROUTINE DR.REG.PASIVAS.PARAM.FIELDS
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
* Date         Author                Description
* ==========   =================     ============
*
* 09-Oct-2014  Ashokkumar.V.P         PACS00305233:- Added fields to parameter hardcoded values.
*-------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------

    ID.F = 'KEY' ; ID.N = '6.1' ; ID.T = '' ; ID.T<2> = 'SYSTEM'

    neighbour = ""
    fieldName = "XX.FILE.NAME" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "OUT.PATH" ;  fieldLength = "65.1" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.CATEGORY" ;  fieldLength = "8.1" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.BANK.EMP.REL" ;  fieldLength = "8.1" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.GROUP.SEL" ;  fieldLength = "15.1" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.RANGE.DAYS" ;  fieldLength = "8.1" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.GRP14.CATEGORY" ;  fieldLength = "8.1" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.GRP15.CATEGORY" ;  fieldLength = "8.1" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.GRP16.CATEGORY" ;  fieldLength = "8.1" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.GRP.REP.NAME" ;  fieldLength = "65.1" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.GRP.REP.RANGE" ;  fieldLength = "15.1" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.GRP.MM.RANGE" ;  fieldLength = "15.1" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.MM.RANGE.DAYS" ;  fieldLength = "8.1" ; fieldType = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addField ("RESERVED.02", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.01", "", Field_NoInput, "")
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
