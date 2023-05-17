*-----------------------------------------------------------------------------
* <Rating>-9</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.CL.BALANCE.HIS.FIELDS
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
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.PGM.FILE
$INSERT I_F.VERSION
$INSERT I_F.AA.ARRANGEMENT
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("ID", T24_String) ;* Define Table id
  ID.CHECKFILE = "AA.ARRANGEMENT" : FM : @ID

*-----------------------------------------------------------------------------
  CALL Table.addField("AA.AMOUNT", T24_Numeric, "", "")     ;* Add a new fields
  CALL Table.addField("AA.BALANCE", T24_Numeric, "", "")    ;* Add a new fields

  CALL Table.addFieldDefinition("XX<COLLATERAL.RIGHT", 35, "A", "")   ;* Add a new fields
  CALL Field.setCheckFile("COLLATERAL.RIGHT")     ;* Use DEFAULT.ENRICH from SS or just field 1

  CALL Table.addFieldDefinition("XX-COLLATERAL.ID", 35, "A", "")      ;* Add a new fields
  CALL Field.setCheckFile("COLLATERAL") ;* Use DEFAULT.ENRICH from SS or just field 1


  CALL Table.addField("XX>MG.ORIGINAL", T24_Numeric, "", "")          ;* Add a new fields














*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
