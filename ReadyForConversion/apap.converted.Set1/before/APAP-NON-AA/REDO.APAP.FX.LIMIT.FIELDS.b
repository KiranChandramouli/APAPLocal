*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.FX.LIMIT.FIELDS
*-----------------------------------------------------------------------------
*COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: Template
*----------------
*DESCRIPTIONS:
*-------------
* This is field definition routine for template REDO.APAP.FX.LIMIT
* All field attriputes will be defined here
*
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who                     Reference              Description
* 08-NOV-2010    A.SabariKumar         ODR-2010-07-0075       INITIAL VERSION
*-----------------------------------------------------------------------------
*** <region name= Header>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.T = 'A' ; ID.N = '35' ; ID.F = '@ID' ;
*-----------------------------------------------------------------------------

  neighbour = ''
  fieldName = 'RISK.AMT'
  fieldLength = '30'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'RISK.CCY'
  fieldLength = '3'
  fieldType = 'CCY'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'PAYMENT.TYPE'
  fieldOptions  = '_FT_TELLER_CHEQUE'
  CALL Table.addOptionsField(fieldName,fieldOptions,'','')

  neighbour = ''
  fieldName = 'PRE.SETT.RISK'
  fieldLength = '3'
  fieldOptions  = 'YES'
  CALL Table.addOptionsField(fieldName,fieldOptions,'','')

  neighbour = ''
  fieldName = 'SETT.RISK'
  fieldLength = '3'
  fieldOptions  = 'YES'
  CALL Table.addOptionsField(fieldName,fieldOptions,'','')

*-----------------------------------------------------------------------------
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
*-----------------------------------------------------------------------------

  CALL Table.addLocalReferenceField(XX.LOCAL.REF)

  CALL Table.addOverrideField

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
