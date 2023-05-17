*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.U.CRM.PRODUCT.TYPE.FIELDS
*-----------------------------------------------------------------------------
**-----------------------------------------------------------------------------
* COMPANY      : APAP
* DEVELOPED BY : Pradeep S
* PROGRAM NAME : REDO.U.CRM.PRODUCT.TYPE.FIELDS
*-----------------------------------------------------------------------------
* * Modification History :
*
* *-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
*The ID of the Field is validated with the record ID of the Currency Table
*
!
  ID.N = "35" ; ID.T = "A"
!
  fieldName         = 'XX.LL.DESCRIPTION'
  fieldLength       = '50.1'
  fieldType         = 'A'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field

  fieldName         = 'PRD.CATEG.FROM'
  fieldLength       = '12'
  fieldType         = 'A'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
  CALL Field.setCheckFile("CATEGORY")

  fieldName         = 'PRD.CATEG.TO'
  fieldLength       = '12'
  fieldType         = 'A'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
  CALL Field.setCheckFile("CATEGORY")

  fieldName         = 'REL.CODE.FROM'
  fieldLength       = '6'
  fieldType         = 'A'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
  CALL Field.setCheckFile("RELATION")

  fieldName         = 'REL.CODE.TO'
  fieldLength       = '6'
  fieldType         = 'A'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
  CALL Field.setCheckFile("RELATION")

  fieldName         = 'ROLES'
  fieldLength       = '30'
  fieldType         = 'A'
  neighbour         = ''
  virtualTableName='AA.PARTY.ROLE'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

  CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")
*
  fieldName         = 'XX.LOCAL.REF'
  fieldLength       = '35'
  fieldType<3>      = 'NOINPUT'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
