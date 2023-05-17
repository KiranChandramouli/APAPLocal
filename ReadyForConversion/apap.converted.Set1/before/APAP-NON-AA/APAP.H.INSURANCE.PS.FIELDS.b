*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE APAP.H.INSURANCE.PS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author ejijon@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
* Date          Who          Refernce          Description
* 13-FEB-2012   Santiago Jijon                 Initial Creation
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = '35'
  ID.T = 'A'
*------------------------------------------------------------------------------
  fieldName = 'AA.PS'
  fieldLength = '20'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'PAYMENT.TYPE'
  fieldLength = '20'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.PROPERTY'
  fieldLength = '20'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  CALL Table.addReservedField("RESERVED.5")
  CALL Table.addReservedField("RESERVED.4")
  CALL Table.addReservedField("RESERVED.3")
  CALL Table.addReservedField("RESERVED.2")
  CALL Table.addReservedField("RESERVED.1")


  RETURN
*-----------------------------------------------------------------------------
END
