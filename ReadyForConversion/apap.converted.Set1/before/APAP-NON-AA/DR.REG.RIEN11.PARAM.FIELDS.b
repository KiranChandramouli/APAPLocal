*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RIEN11.PARAM.FIELDS
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
* Modification History :
* ----------------------
*   Date       Author              Modification Description
*  26/09/2014  Ashokkumar            PACS00312712 - Fields added to parameterise the selection values
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

  fieldName = "XX<FIELD.NAME" ;  fieldLength = "40" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX-XX<FIELD.VALUE" ;  fieldLength = "40" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX>XX>DISPLAY.VALUE" ;  fieldLength = "60" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "RNC.APAP" ;  fieldLength = "15.1" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX.COD.FILE" ;  fieldLength = "20.1" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "STATUS" ;  fieldLength = "10.1" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "ST.RECORD" ;  fieldLength = "15.1" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX.CATEGORY" ;  fieldLength = "15.1" ; fieldType = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "FLD.DELIM" ;  fieldLength = "1.1" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
