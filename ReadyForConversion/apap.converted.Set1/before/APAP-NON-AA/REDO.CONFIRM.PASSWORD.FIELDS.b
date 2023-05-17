*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CONFIRM.PASSWORD.FIELDS
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

*  DATE             WHO         REFERENCE         DESCRIPTION
* 27-03-2013    RMONDRAGON   ODR-2009-12-0276   INITIAL CREATION
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------

  ID.F = 'ID'
  ID.N = '12.1'
  ID.T = 'A'
  ID.T<4> = "########-#########"

  fieldName='ID.IBUSER'
  fieldLength='35'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='NEW.PASSWORD'
  fieldLength='16'
  fieldType='PASSWD'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='CONFIRM.PASSWORD'
  fieldLength='16'
  fieldType='PASSWD'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='PASSWORD.MASK'
  fieldLength='16'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='CONFIRM.PWD.DEF'
  fieldLength='16'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='NEW.PASSWORD.DEF'
  fieldLength='16'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
