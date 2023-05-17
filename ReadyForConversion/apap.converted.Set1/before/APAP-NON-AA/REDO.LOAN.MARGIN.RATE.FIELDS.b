*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LOAN.MARGIN.RATE.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*
*  DATE             WHO          REFERENCE           DESCRIPTION
* 16-Mar-2011     H GANESH     PACS00055012 - B.16  INITIAL CREATION
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------

  ID.F='@ID'
  ID.N='30'
  ID.T='A'
  ID.CHECKFILE='AA.PRODUCT'

  fieldName='XX<CAMPAIGN.TYPE'
  fieldLength='35'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('REDO.CAMPAIGN.TYPES')

  fieldName         = 'XX-XX<AFFIL.COMP'
  fieldLength       = '30'
  fieldType         = 'ANY'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
  CALL Field.setCheckFile('REDO.AFFILIATED.COMPANY')

  fieldName         = 'XX>XX>MARGIN.ID'
  fieldLength       = '10'
  fieldType         = ''
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
  CALL Field.setCheckFile('REDO.RATE.CHANGE.CRIT')

  fieldName         = 'BY.DEFAULT'
  fieldLength       = '10'
  fieldType         = ''
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
  CALL Field.setCheckFile('REDO.RATE.CHANGE.CRIT')


*CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
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
