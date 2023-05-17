*-----------------------------------------------------------------------------
* <Rating>-55</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CCRG.RISK.LIMIT.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CCRG.RISK.LIMIT.PARAM.FIELDS
*
* @author anoriega@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 14/March/2011 - EN_10003543
*                 New Template changes
*REM Just for compile
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_Table
$INSERT I_F.PGM.FILE
$INSERT I_F.CURRENCY
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("RISK.LIMIT.ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
  CALL Table.addField("DESCRIPTION", T24_String, Field_NoInput, '')   ;* Add a new fields

  args = ''
  args = Field_Mandatory:",":Field_NoInput
  CALL Table.addField("LOCAL.CCY", T24_Currency, args, '')  ;* Add a new fields
  CHECKFILE(Table.currentFieldPosition) ="CURRENCY":FM:EB.CUR.CCY.NAME:FM:"L"
  T(Table.currentFieldPosition)<3> = "NOINPUT"

  CALL Table.addFieldDefinition("PERCENTAGE", "6", 'R', '') ;* Add a new fields

  args = ''
  args = Field_NoInput
  CALL Table.addAmountField("MAX.AMOUNT", "LOCAL.CCY", args, '')      ;* Add a new fields

  args = ''
*    CALL Table.addField("XX<APPLICATION", "40..C" , args, '')         ;* Add a new
  CALL Table.addFieldDefinition("XX<APPLICATION", "40..", 'PG' : FM : 'AHULTMSW', '')     ;* Add a new fields
  CALL Field.setDefault("CUSTOMER")
  CHECKFILE(Table.currentFieldPosition) ="PGM.FILE":FM:EB.PGM.SCREEN.TITLE:FM:"L"
*

  CALL Table.addFieldDefinition('XX-XX<FIELD.NO', 18, 'A', '')        ;* Add a new fields
*
  fieldType = '':FM:'EQ_NE_RG_NR'
  CALL Table.addFieldDefinition('XX-XX-OPERATOR', 3, fieldType, '')   ;* Add a new fields
*
  CALL Table.addFieldDefinition('XX-XX-MIN.VALUE', 40, 'A', '')       ;* Add a new fields
*
  CALL Table.addFieldDefinition('XX-XX-MAX.VALUE', 40, 'A', '')       ;* Add a new fields
*
  fieldType = '':FM:'OR_AND'
  CALL Table.addFieldDefinition('XX-XX-BOOL.OPER', 3, fieldType, '')  ;* Add a new fields
*
  CALL Table.addOptionsField("FSHOW.TDIS","YES_NO",'', '')

  CALL Table.addReservedField("XX>XX>RESERVED.1") ;* Add a new Reserved fields

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
