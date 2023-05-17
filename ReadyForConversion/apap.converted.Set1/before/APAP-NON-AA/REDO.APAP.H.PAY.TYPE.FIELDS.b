*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.H.PAY.TYPE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author prabhakarrao@contractor.temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO          REFERENCE                  DESCRIPTION
* 13-11-2010      Pradeep P      ODR-2010-03-0099    Initial Creation
* ----------------------------------------------------------------------------
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.T = '' ; ID.N = '11' ; ID.F = '@ID' ; ID.T<2> = 'SYSTEM'
*-----------------------------------------------------------------------------
  fieldName = 'PAYMENT.LOAN'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'PAYMENT.CARD'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'THIRD.PTY.PAY'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

*-----------------------------------------------------------------------------
  neighbour = ''
  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType<3> = 'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
