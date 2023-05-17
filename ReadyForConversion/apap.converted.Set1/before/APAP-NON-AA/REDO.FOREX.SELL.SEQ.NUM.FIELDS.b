*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FOREX.SELL.SEQ.NUM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.FOREX.SEQ.NUM *
* @author ssudharsanan@temenos.com
* @stereotype fields template
* Reference : ODR2010010213 - PACS00033053
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 01/02/10 - EN_10003543
*            New Template changes
* --------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
  ID.F = '@ID'
  ID.N = '10'
  ID.T = ''
*------------------------------------------------------------------------------
  fieldName = 'FX.SEQ.STATUS'
  fieldLength = '10.1'
  fieldType = 'A'
  fieldType = "":FM:"AVAILABLE_ISSUED_CANCELLED"
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'FX.TXN.ID'
  fieldLength = '25'
  fieldType = 'A'
  fieldType<3> = "NOCHANGE"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'TXN.VALUE.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'MANUAL.UPDATE'
  fieldLength = '3'
  fieldType = "":FM:"YES_NO"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'CUSTOMER.NO'
  fieldLength = '25'
  fieldType = 'CUS'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'CUSTOMER.NAME'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'LEGAL.ID'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'HOLD.CONTROL.ID'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'DESCRIPTION'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'AMOUNT'
  fieldLength = '19'
  fieldType = "AMT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.STMT.NOS'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
