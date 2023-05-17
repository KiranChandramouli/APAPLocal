*-----------------------------------------------------------------------------
* <Rating>-17</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.213IF01.CONCAT.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 11-Aug-2014     V.P.Ashokkumar      PACS00309079 - Updated the field mapping and format
* 14-Oct-2014     V.P.Ashokkumar      PACS00309079 - Updated to filter AML transaction
*-----------------------------------------------------------------------------
* Report IF01 - Concat table
*-----------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*-----------------------------------------------------------------------------

  ID.F = "CUST.DATE" ; ID.N = "25.1" ; ID.T = "A"

  neighbour = ""
  fieldName = "XX.STMT.ID" ;  fieldLength = "65" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "CR.AMOUNT" ;  fieldLength = "19" ; fieldType = "AMT"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "CR.DATE" ;  fieldLength = "8" ; fieldType = "D"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "CUST.RELATION" ;  fieldLength = "4" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "CUST.RTE.FORM" ;  fieldLength = "3" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX.PEP.STMT.ID" ;  fieldLength = "65" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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
