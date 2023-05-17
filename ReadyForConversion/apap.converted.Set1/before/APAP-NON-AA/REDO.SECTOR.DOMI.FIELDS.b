*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SECTOR.DOMI.FIELDS
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACI POPULAR DE AHORROS Y PRTAMOS
*Developed By      : TEMENOS APPLICATION MANAGEMENT
*Program   Name    : REDO.SECTOR.DOMI.FIELDS
*-----------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*-----------------------------------------------------------------------------
  CALL Table.defineId("ID",T24_String)
*-----------------------------------------------------------------------------
* CALL Table.addField(fieldName, fieldType, args, neighbour)
* CALL Field.setCheckFile(fileName)

  CALL Table.addFieldDefinition("XX.DESCRIPTION", "35.1", "A", "")
  CALL Table.addFieldDefinition("XX.SHORT.NAME", "35.1", "A", "")
  CALL Table.addField("XX.LOCAL.REF", T24_String,"","")
  CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput ,"")

* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
* CALL Field.setDefault(defaultValue)
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
