*-----------------------------------------------------------------------------
* <Rating>-15</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.SIGNATORY.LIST.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.APAP.SIGNATORY.LIST*
* @author crajkumar@contractor.temenos.com
* @stereotype fields template
* Reference : ODR-2010-07-0074
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 01/02/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
*     Date             Author             Reference         Description
* 05-August-2010   A C Ra]jkumar      ODR-2010-07-0074    Initial creation
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID",T24_String)         ;* Define Table id
  ID.F = "USER.ID" ;  ID.N = "35" ;  ID.T = "A"
  ID.CHECKFILE = "USER"
*------------------------------------------------------------------------------
  fieldName = 'DESCRIPTION'
  fieldLength = '35'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*This field holds the description

  fieldName = 'DEPARTMENT'
  fieldLength = '35'
  fieldType = "":FM:"TREASURY_CREDIT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*This field holds the department type of the user
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
