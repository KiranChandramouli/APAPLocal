*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AT.USER.PARMS.FIELDS
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
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("USERPAR.ID", T24_String)   ;* Define Table id
*-----------------------------------------------------------------------------
  CALL Table.addFieldDefinition("XX<SIGNONUSER", "35", "A", "")       ;* Add a new field
  CALL Table.addFieldDefinition("XX>ID.USUARIO", "35", "A", "")
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
