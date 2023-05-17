*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CLAIM.STATUS.MAP.FIELDS
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
*  DATE             WHO                DESCRIPTION         REFERENCE
*  11-MAR-2010      PRABHU             HD1100441          Map from Closed.status to Status field
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.F = '@ID' ; ID.N = '35'
  ID.T = 'A'   ;
*------------------------------------------------------------------------------
  fieldName='XX<CLOSED.STATUS'
  fieldLength='35'
  fieldType='A'
  neighbour=''
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  virtualTableName='CL.CLOSING.STATUS'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

  fieldName='XX>STATUS'
  fieldLength='35'
  fieldType='A'
  neighbour=''
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  virtualTableName='CM.STATUS'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)


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


*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
