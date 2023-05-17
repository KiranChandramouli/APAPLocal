*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.PARAM.EMAIL.FIELDS
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: Template
*----------------
*DESCRIPTIONS:
*-------------
* This is field definition routine for template REDO.APAP.PARAM.EMAIL
* All field attriputes will be defined here
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                   Reference              Description
* 23-NOV-2010    A.SabariKumar         ODR-2010-07-0075       INITIAL VERSION
*-----------------------------------------------------------------------------
*** <region name= Header>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.T = '' ; ID.N = '35' ; ID.F = '@ID' ; ID.T<2> = 'SYSTEM'
*-----------------------------------------------------------------------------

  neighbour = ''
  fieldName = 'IN.PATH.MAIL'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'ERR.PATH.MAIL'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'ATTACH.PATH.MAIL'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------

  CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")
*-----------------------------------------------------------------------------

  CALL Table.addLocalReferenceField(XX.LOCAL.REF)

  CALL Table.addOverrideField

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
