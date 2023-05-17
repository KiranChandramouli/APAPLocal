*-----------------------------------------------------------------------------
* <Rating>-15</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.MULTITXN.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author pgarzongavilanes@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 29/03/11 - First release
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("SYSTEM", T24_String)       ;* Define Table id
*-----------------------------------------------------------------------------

  CALL Table.addFieldDefinition("XX<ACTUAL.CATEG", "6", "A", "")      ;* Add a new fields
  CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1
  CALL Table.addFieldDefinition("XX-NEW.CATEG", "6","A", "")          ;* Add a new fields
  CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1
  CALL Table.addFieldDefinition("XX>SUSP.CATEG", 6, "A", "")          ;* Add a new fields
  CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1



  CALL Table.addFieldDefinition("CATEG.CASH", "6", "A", "") ;* Add a new fields
  CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1

  CALL Table.addFieldDefinition("CATEG.CHECK", "6","A", "") ;* Add a new fields
  CALL Field.setCheckFile("CATEGORY")   ;* Use DEFAULT.ENRICH from SS or just field 1

  CALL Table.addFieldDefinition("CHECK.ACCOUNT", "13", "A", "")       ;* Add a new fields
  CALL Table.addFieldDefinition("CHECK.TRANSACT", "3","A", "")        ;* Add a new fields
  CALL Field.setCheckFile("TRANSACTION")          ;* Use DEFAULT.ENRICH from SS or just field 1


*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
