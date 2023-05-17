*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.H.REPRINT.CHQ.FIELDS
********************************************************************************************************
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
* 08/12/2010 -  New Template changes
*
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
****************************************************************************
  GOSUB PARA
  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
*--------------------------------------------------------------------------------
  fieldName = "XX.LOCAL.REF"
  fieldLength = "35"
  fieldType=''
  fieldType<3> = "NOINPUT"
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX.OVERRIDE"
  fieldLength = "35"
  fieldType<3> = "NOINPUT"
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*---------------------------------------------------------------------------------------
  RETURN
*------------------------------------------------------------------------------

*****
PARA:
******


  fieldName = "REPRINT.SEQ"
  fieldLength = "35"
  fieldType=''
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "REPRINT.FLAG"
  fieldLength = "3"
  fieldType = ""
  fieldType<2>="YES_NO"
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX<INIT.PRINT"
  fieldLength = "100"
  fieldType = "A"
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX>PRINT.TYPE"
  fieldLength = "100"
  fieldType = "A"
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



  RETURN

END
********************************************************************
