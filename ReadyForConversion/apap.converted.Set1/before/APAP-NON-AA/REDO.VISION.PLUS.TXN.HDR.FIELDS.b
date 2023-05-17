*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VISION.PLUS.TXN.HDR.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions for the application REDO.VISION.PLUS.TXN.HDR
*
* @author: Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History
* ====================
* 04/17/2013 - Initial Version
*-----------------------------------------------------------------------------

*** <region name= Header>
*** <desc>Inserts and control logic</desc>

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_Table

*** </region>

*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.T = 'A'
*-----------------------------------------------------------------------------

  neighbour   = ''
  fieldName   = 'RECORD.TYPE'
  fieldLength = '1'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'STATUS'
  fieldLength = '1'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'HEADER.BATCH.NBR'
  fieldLength = '5'
  fieldType   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'SEQUENCE.NBR'
  fieldLength = '3'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'NBR.OF.ITEMS'
  fieldLength = '3'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'AMOUNT'
  fieldLength = '15.2'
  fieldType   = 'AMT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'MERCHANT.NBR'
  fieldLength = '13'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'BATCH.REVERSAL'
  fieldLength = '1'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'ATM.BATCH'
  fieldLength = '1'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'OPERADOR'
  fieldLength = '3'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'VIC.PROC.DATE'
  fieldLength = '7'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'MC.PROC.DATE'
  fieldLength = '7'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'CARD.ACCEPTOR.ID'
  fieldLength = '15'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'TERM.ID'
  fieldLength = '8'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'USER.REF.NBR'
  fieldLength = '11'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'SOURCE.ID'
  fieldLength = '3'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'HDR.ARITH.ERR'
  fieldLength = '1'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'HDR.ADJ.TRN.COD'
  fieldLength = '2'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'HDR.ADJ.AMT'
  fieldLength = '9.2'
  fieldType   = 'AMT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'HDR.ADJ.RSN.CODE'
  fieldLength = '3'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour   = ''
  fieldName   = 'HDR.ADJ.RSN.DESC'
  fieldLength = '35'
  fieldType   = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  V = Table.currentFieldPosition

*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------

END
