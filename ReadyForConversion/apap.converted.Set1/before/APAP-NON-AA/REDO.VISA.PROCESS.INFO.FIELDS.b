*-----------------------------------------------------------------------------
* <Rating>-11</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISA.PROCESS.INFO.FIELDS
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
*  DATE             WHO           REFERENCE          DESCRIPTION
* 08-02-2010    Akthar Rasool S  ODR-2010-08-0469   INITIAL CREATION
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("REDO.VISA.PROCESS.INFO", T24_String)         ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID' ; ID.N = '35'
  ID.T = 'A'

  fieldName='STATUS'
  fieldLength='10'
  fieldType=''
  fieldType<2>='PROCESSING_PROCESSED'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='LASTDATE.PROCESS'
  fieldLength='8'
  fieldType='D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='LAST.LINE.PROCESS'
  fieldLength=''
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
* Fields added for PACS00195641

  fieldName='NO.TXN.RECIEVED'
  fieldLength=''
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='NO.TXN.SETTLED'
  fieldLength=''
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  fieldName='NO.TXN.REJECTED'
  fieldLength=''
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  fieldName='NO.TXN.AUTO.CHGBCK'
  fieldLength=''
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  fieldName='TXN.NOT.PROCESSED'
  fieldLength=''
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  fieldName="TOT.AMT"
  fieldLength=''
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
*    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")


*-----------------------------------------------------------------------------
* CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
