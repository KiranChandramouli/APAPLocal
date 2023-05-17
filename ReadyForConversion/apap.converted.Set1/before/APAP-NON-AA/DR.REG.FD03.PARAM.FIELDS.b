*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.FD03.PARAM.FIELDS
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
* Date              Author              Description
* ==========        ===============    ============
* 02-Aug-2014       Ashokkumar.V.P    PACS00316981 - New fields are added.
*-------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------

  ID.F = 'KEY' ; ID.N = '6.1' ; ID.T = '' ; ID.T<2> = 'SYSTEM'

  neighbour = ""
  fieldName = "FILE.NAME" ;  fieldLength = "65.1" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "OUT.PATH" ;  fieldLength = "65.1" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "XX.FTTC.PAY.TYPES" ;  fieldLength = "8.1" ; fieldType = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "THRESHOLD.FAMT" ;  fieldLength = "6.1" ; fieldType = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "THRESHOLD" ;  fieldLength = "3" ; fieldType = "A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "REP.START.DATE" ;  fieldLength = "8" ; fieldType = "D"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "REP.END.DATE" ;  fieldLength = "8" ; fieldType = "D"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = "LAST.RUN.DATE" ;  fieldLength = "8.1" ; fieldType = "D"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*    fieldName = "PAYER.ENTITY" ;  fieldLength = "40.1" ; fieldType = "A"
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Table.addField ("RESERVED.03", "", Field_NoInput, "")
  CALL Table.addField ("RESERVED.02", "", Field_NoInput, "")
  CALL Table.addField ("RESERVED.01", "", Field_NoInput, "")
*-----------------------------------------------------------------------------
!  CALL Table.addField(fieldName, fieldType, args, neighbour) ;* Add a new fields
!    CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1
!   CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
!    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
!    CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
