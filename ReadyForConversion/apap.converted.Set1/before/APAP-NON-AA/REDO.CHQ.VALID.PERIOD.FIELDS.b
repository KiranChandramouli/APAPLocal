*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CHQ.VALID.PERIOD.FIELDS
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
*** DATE           BY     ISSUE            DESC
*  18-01-2012   Pradeep S PACS00175817     EB Lookup added for the field CHEQUE.STATUS
*---------------------------------------------------------------------------

*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("TABLE.NAME.ID", T24_String)          ;* Define Table id
  ID.F = ''
  ID.N = '12'
  ID.T = ''
  ID.T<2> = 'NONE_CONFIRMED_NONCONFIRMED'
*-----------------------------------------------------------------------------
*  CALL Table.addField(fieldName, fieldType, args, neighbour)        ;* Add a new fields
* CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1
* CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field


  fieldName = "CHEQUE.STATUS"
  fieldLength = ""
  fieldType = ""
  neighbour = ""
  virtualTableName = "CHEQUE.STATUS"
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

  fieldName = "VALIDITY"
  fieldLength = "6"
  fieldType = ""
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)


* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
* CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
