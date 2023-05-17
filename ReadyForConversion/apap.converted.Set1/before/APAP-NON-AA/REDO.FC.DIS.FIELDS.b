*---*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.DIS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*  DATE              WHO                       Modification
* 19/05/2010 -      Naveenkumar N             Initial Creation
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>

  GOSUB DEFINE.FIELDS.ONE

  RETURN


DEFINE.FIELDS.ONE:

*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*----------------------------------------------------------------------------
  neighbour = ''
  fieldName = 'DIS.FIELD'
  fieldLength = '30'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  CALL Table.setAuditPosition ;* Poputale audit information

*----------------------

*----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
