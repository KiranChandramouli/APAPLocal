*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RESUBMIT.FT.DET.FIELDS
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
  CALL Table.defineId("ARRANGEMENT.ID", T24_String)         ;* Define Table id
*-----------------------------------------------------------------------------

  neighbour = ''
  fieldName = 'XX<FT.ID'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addField(fieldName, fieldType, args, neighbour)
  fieldName = 'XX-DATE'
  fieldLength = '11'
  fieldType = 'D'
  CALL Table.addField(fieldName, fieldType, args, neighbour)
  fieldName = 'XX-BILL.AMT'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addField(fieldName, fieldType, args, neighbour)
  fieldName = 'XX>OFS.MSG.ID'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addField(fieldName, fieldType, args, neighbour)
  RETURN
*-----------------------------------------------------------------------------
END
