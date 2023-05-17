*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACH.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.ACH.PARAM.FIELDS
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR2009120290
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
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
  ID.N = '6'
  ID.T = ''
  ID.T<2>= 'SYSTEM'
*------------------------------------------------------------------------------
  fieldName = 'XX<TXN.TYPE'
  fieldLength = '4'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

  fieldName = 'XX>OUT.RAD.COND.ID'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('RAD.CONDUIT.LINEAR')

  fieldName = 'OUTW.LENG.LINE'
  fieldLength = '3'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'OUTW.FILE.PREFX'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'OUTW.HIST.PATH'
  fieldLength = '75'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX<TXN.PURPOSE'
  fieldLength = '2'
  virtualTableName='TXN.PURPOSE'
  neighbour = ''
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-XX<TXN.CODE'
  fieldLength = '2'
  virtualTableName = 'TXN.CODE'
  neighbour = ''
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-XX-OFS.RAD.ID'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX>XX>TXN.VERSION'
  fieldLength = '54'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'INW.DELIMITER'
  fieldLength = '1'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'INW.NO.OF.ELMNT'
  fieldLength = '2'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'INW.REJ.FIL.PRE'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'INW.HIST.PATH'
  fieldLength = '75'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'OUT.RJ.HIS.PATH'
  fieldLength = '75'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'IN.REJ.HIST.PATH'
  fieldLength = '75'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'CARD.INTL.ACCT'
  fieldLength = '16'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* Fix for PACS00452811 [ACH special character]

  fieldName = 'XX.ACH.SPL.CHAR'
  fieldLength = '07..C'
  fieldType = 'HEX'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* End of Fix

  CALL Table.addField("RESERVED.19", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.18", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.17", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.16", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType<3> = 'NOINPUT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
