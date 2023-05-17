*-----------------------------------------------------------------------------
* <Rating>-16</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RATE.CHANGE.CRIT.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
* Date            Who             Reference                  Description
* 08-OCT-10     Kishore.SP      ODR-2009-10-0325           Initial Creation
* 28-APR-11     H GANESH            CR009               Change the Vetting value of local field
* 16-MAY-11     H GANESH        PACS00055012 - B.16     Changed made as per the issue
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

*-----------------------------------------------------------------------------
*CALL Table.defineId("@ID", T24_Numeric)       ;* Define Table id
*-----------------------------------------------------------------------------

  ID.F='@ID' ; ID.N = "10" ; ID.T = ""

  fieldName         = 'XX<RATE.ST.RG'
  fieldLength       = '10'
  fieldType         = 'R'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*
  fieldName         = 'XX-RATE.END.RG'
  fieldLength       = '10'
  fieldType         = 'R'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*
  fieldName         = 'XX-ORG.AMT.ST.RG'
  fieldLength       = '19'
  fieldType         = 'AMT'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*
  fieldName         = 'XX-ORG.AMT.END.RG'
  fieldLength       = '19'
  fieldType         = 'AMT'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field

  fieldName         = 'XX-OS.AMT.ST.RG'
  fieldLength       = '19'
  fieldType         = 'AMT'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*
  fieldName         = 'XX-OS.AMT.END.RG'
  fieldLength       = '19'
  fieldType         = 'AMT'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field

  fieldName         = 'XX-LOAN.ST.DATE'
  fieldLength       = '8'
  fieldType         = 'D'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field

  fieldName         = 'XX-LOAN.END.DATE'
  fieldLength       = '8'
  fieldType         = 'D'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field

*
  fieldName         = 'XX-XX.LOAN.STATUS'
  fieldLength       = '30'
  neighbour         = ''
  virtualTableName  = 'L.LOAN.STATUS.1'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

*
  fieldName         = 'XX-XX.LOAN.COND'
  fieldLength       = '30'
  neighbour         = ''
  virtualTableName  = 'L.LOAN.COND'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

  fieldName         = 'XX-OVERDUE.DAYS'
  fieldLength       = '3'
  fieldType         = ''
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field

  fieldName         = 'XX-UNPAID.INST'
  fieldLength       = '10'
  fieldType         = ''
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*
*
  fieldName         = 'XX-MARGIN.TYPE'
  fieldLength       = '30'
  fieldType         = ''
  neighbour         = ''
  virtualTableName='AA.MARGIN.TYPE'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

*
  fieldName         = 'XX-MARGIN.OPERAND'
  fieldLength       = '8'
  fieldType         = ''
  fieldType<2>      = 'ADD_SUB_MULTIPLY'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*
  fieldName         = 'XX-PROP.SPRD.CHG'
  fieldLength       = '10'
  fieldType         = 'R'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*

  fieldName         = 'XX>PROP.INT.CHG'
  fieldLength       = '10'
  fieldType         = 'R'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field

*
*CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
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
*
  fieldName         = 'XX.OVERRIDE'
  fieldLength       = '35'
  fieldType<3>      = 'NOINPUT'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  fieldName         = 'XX.STMT.NOS'
  fieldLength       = '35'
  fieldType<3>      = 'NOINPUT'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  fieldName         = 'XX.LOCAL.REF'
  fieldLength       = '35'
  fieldType<3>      = 'NOINPUT'
  neighbour         = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
