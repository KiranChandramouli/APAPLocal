*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CH.PROFILE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CH.PROFILE.FIELDS
*
* @author rmondragon@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*
* 28/09/11 - First Version
*
* 02/07/12 - Second Version
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("USER.ID", T24_String)      ;* Define Table id
*-----------------------------------------------------------------------------

  fieldName='PROFILE'
  fieldLength='30'
  fieldType=''
  fieldType<2> = 'Teleapap.Consultas_Teleapap.Txns_Apapenlinea.Consultas_Apapenlinea.Txns'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='PRODUCT'
  fieldLength='15'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.PRODUCT")

  fieldName='ARRANGEMENT'
  fieldLength='15'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
*   CALL Table.addLocalReferenceField
  CALL Table.addOverrideField
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
