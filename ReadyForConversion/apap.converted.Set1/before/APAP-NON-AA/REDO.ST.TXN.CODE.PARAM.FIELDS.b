*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ST.TXN.CODE.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.AMORT.SEC.TRADE
*
* @author rshankar@temenos.com
* @Live type template
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 03/12/2010 - ODR-2010-07-0081
*            New Template creation
*
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*-----------------------------------------------------------------------------
  CALL Table.defineId("REDO.ST.TXN.CODE.PARAM", T24_String) ;
*-----------------------------------------------------------------------------

  ID.F = '@ID' ; ID.N = '5'
  ID.T = 'A'

  fieldName   = "XX.TXN.CODE"
  fieldLength = "3"
  fieldType   = "A"
  neighbour   = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("SC.TRANS.NAME")

  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

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
