*
    *-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE DR.REG.OPER.DIVISAS.PARAM.FIELDS
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

    fieldName = "OUT.PATH" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.HEADER" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC.HEADER" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC1.COL" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC1.ROW" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC2.COL" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC2.ROW" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC3.COL" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC3.ROW" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC4.COL" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC4.ROW" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC5.COL" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC5.ROW" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC6.COL" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = "XX.SEC6.ROW" ;  fieldLength = "65" ; fieldType = "A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    CALL Table.addField ("RESERVED.10", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.09", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.08", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.07", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.06", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.05", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.04", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.03", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.02", "", Field_NoInput, "")
    CALL Table.addField ("RESERVED.01", "", Field_NoInput, "")
*-----------------------------------------------------------------------------
!  CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
!    CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1
!   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
!    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
!    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
    RETURN
*-----------------------------------------------------------------------------
END
