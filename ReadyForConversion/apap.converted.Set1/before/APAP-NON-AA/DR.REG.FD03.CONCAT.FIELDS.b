*-----------------------------------------------------------------------------
* <Rating>-18</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.FD03.CONCAT.FIELDS
*-----------------------------------------------------------------------------
* Report ID01 - Concat table
*-----------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*-----------------------------------------------------------------------------

  ID.F = "FD03.ID" ; ID.N = "25" ; ID.T = "A"

  neighbour = ""
  fieldName = "STMT.ID" ;  fieldLength = "65" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    CALL Table.addField ("RESERVED.06", "", Field_NoInput, "")
*    CALL Table.addField ("RESERVED.05", "", Field_NoInput, "")
*    CALL Table.addField ("RESERVED.04", "", Field_NoInput, "")
*    CALL Table.addField ("RESERVED.03", "", Field_NoInput, "")
*    CALL Table.addField ("RESERVED.02", "", Field_NoInput, "")
*    CALL Table.addField ("RESERVED.01", "", Field_NoInput, "")
*-----------------------------------------------------------------------------
!  CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
!    CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1
!   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
!    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
!    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
