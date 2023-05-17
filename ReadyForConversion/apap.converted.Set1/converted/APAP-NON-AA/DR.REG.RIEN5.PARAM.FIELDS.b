SUBROUTINE DR.REG.RIEN5.PARAM.FIELDS
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
* Modification History :
* ----------------------
*   Date       Author              Modification Description
* 05/10/2014  Ashokkumar.V.P        PACS00309203 - Renamed old fields 'AA.PRODUCT' and added new fields
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

    fieldName = "XX.AA.PRODUCT" ;  fieldLength = "20" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.DAY.RANGE" ;  fieldLength = "10" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.REP.HEADER" ;  fieldLength = "60" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.REP.NAME" ;  fieldLength = "60" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.REP.FIELDS" ;  fieldLength = "60" ; fieldType = "A"
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
