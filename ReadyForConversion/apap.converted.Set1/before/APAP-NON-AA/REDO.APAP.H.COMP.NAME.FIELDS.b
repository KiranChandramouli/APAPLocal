*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.H.COMP.NAME.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.APAP.H.COMP.NAME.FIELDS *
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR2009100340
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
*
* 22/06/11 - CR010 - pgarzongavilanes@temenos.com
*
*
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
  ID.N = '35'
  ID.T = 'A'
*------------------------------------------------------------------------------
  fieldName = 'INS.COMP.NAME'
  fieldLength = '50.1'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
  fieldName = 'XX<CLASS.POLICY'
  fieldLength = '35'
  neighbour = ''
  fieldType='A'
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
  CALL Field.setCheckFile("APAP.H.INSURANCE.CLASS.POLICY")
*
  fieldName = 'XX-INS.POLICY.TYPE'
  fieldLength = '35'
  fieldType='A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
  CALL Field.setCheckFile("APAP.H.INSURANCE.POLICY.TYPE")
*
  fieldName = 'XX-SEN.POLICY.NUMBER'
  fieldLength = '35'
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
  fieldName = 'XX>MAX.POLICY.NUMBER'
  fieldLength = '35'
  fieldType = ""
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*
  CALL Table.addReservedField("RESERVED.5")
  CALL Table.addReservedField("RESERVED.4")
  CALL Table.addReservedField("RESERVED.3")
  CALL Table.addReservedField("RESERVED.2")
  CALL Table.addReservedField("RESERVED.1")

  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
