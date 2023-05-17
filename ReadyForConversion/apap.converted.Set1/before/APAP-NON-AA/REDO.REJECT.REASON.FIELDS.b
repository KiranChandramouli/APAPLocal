*-----------------------------------------------------------------------------
* <Rating>-203</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.REJECT.REASON.FIELDS
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
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = '35'
  ID.T = 'A'
*-----------------------------------------------------------------------------

  neighbour = ''
  fieldName = 'XX.LL.DESC'
  fieldLength = '35'
  fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  neighbour = ''
  fieldName = 'RETURN.CODE'
  fieldLength = '2'
  fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.1'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.2'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.3'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.4'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.5'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.6'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.7'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.8'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.9'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.10'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.11'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.12'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.13'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.14'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.15'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.16'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.17'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.18'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.19'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'RESERVED.20'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  CALL Table.addLocalReferenceField('XX.LOCAL.REF')

  CALL Table.addOverrideField

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
