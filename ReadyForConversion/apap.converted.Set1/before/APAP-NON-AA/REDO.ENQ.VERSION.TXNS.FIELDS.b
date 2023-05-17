*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ENQ.VERSION.TXNS.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.TEMP.VERSION.IDS
*--------------------------------------------------------------------------------------------------
* Description   : This is the template routine to store the version records , used as filter for the txns
*                 to be displayed in enquiries
* In parameter  : none
* out parameter : none
*--------------------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 11-04-2013       Arundev          PACS00263522      Initial Creation
*--------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.F = '@ID'
  ID.N = '50'
  ID.T = 'A'
  ID.CHECKFILE = 'ENQUIRY'

  fieldName = 'XX.VERSION'
  fieldLength = '150.1'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile('VERSION')

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

**CALL Table.addLocalReferenceField
  CALL Table.addOverrideField

  CALL Table.setAuditPosition ;* Populate audit information

  RETURN

*-----------------------------------------------------------------------------
END
