*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.PRODUCT.GROUP.FIELDS

*<doc>
* Template for field definitions routine REDO.AA.PAYOFF.DETAILS
* @author
* @stereotype fields template
* Reference :
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 24/02/11 -
*            New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
  ID.F = '@ID'
  ID.N = '50'
*------------------------------------------------------------------------------
  fieldName = 'DESCRIPTION'
  fieldLength = '50'
  fieldType = ''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*------------------------------------------------------------------------------

  RETURN

END
