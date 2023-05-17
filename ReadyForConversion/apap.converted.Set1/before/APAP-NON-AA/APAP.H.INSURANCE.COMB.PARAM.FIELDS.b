*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE APAP.H.INSURANCE.COMB.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.COMBINATIONS.POLICY.CLASS.FIELDS
*
* @authors jvalarezoulloa@temenos.com, pgarzongavilanes@temenos.com,sjijon@temenos.com
*          cherrera@temenos.com
* @stereotype template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 16/06/11 - New Template changes
* 10/08/11 Add reserved, local, and override fields
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("COMB.PARAM.ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
  CALL Table.addField("INS.POLICY.TYPE", T24_String, '', '')          ;* Add a new fields
  CALL Field.setCheckFile("APAP.H.INSURANCE.POLICY.TYPE")   ;* Use DEFAULT.ENRICH from SS or just field 1
  CALL Table.addField("INS.POLICY.CLASS", T24_String, '', '')         ;* Add a new fields
  CALL Field.setCheckFile("APAP.H.INSURANCE.CLASS.POLICY")  ;* Use DEFAULT.ENRICH from SS or just field 1

  CALL Table.addField("XX<FIELD.NAME", T24_String,'', '')   ;* Add a Description Field

  fieldName="XX-XX<FIELD.BEHA"
  ebLoookUpTable = "REDO.INS.FIELD.BEHAVIOUR"
  CALL Table.addFieldWithEbLookup(fieldName, ebLoookUpTable, '');

  CALL Table.addField("XX-XX-FIELD.VALUES", T24_String,'', '')        ;* Add a Description Field

  CALL Table.addField("XX>XX>NAME.BEHAVIOUR", T24_String, '', '')

*------------------------------------------------------------------------------

  CALL Table.addReservedField('RESERVED.20')
  CALL Table.addReservedField('RESERVED.19')
  CALL Table.addReservedField('RESERVED.18')
  CALL Table.addReservedField('RESERVED.17')
  CALL Table.addReservedField('RESERVED.16')
  CALL Table.addReservedField('RESERVED.15')
  CALL Table.addReservedField('RESERVED.14')
  CALL Table.addReservedField('RESERVED.13')
  CALL Table.addReservedField('RESERVED.12')
  CALL Table.addReservedField('RESERVED.11')
  CALL Table.addReservedField('RESERVED.10')
  CALL Table.addReservedField('RESERVED.9')
  CALL Table.addReservedField('RESERVED.8')
  CALL Table.addReservedField('RESERVED.7')
  CALL Table.addReservedField('RESERVED.6')
  CALL Table.addReservedField('RESERVED.5')
  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')

*-----------------------------------------------------------------------------
  CALL Table.addLocalReferenceField('XX.LOCAL.REF')

*-----------------------------------------------------------------------------

  CALL Table.addOverrideField


*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
