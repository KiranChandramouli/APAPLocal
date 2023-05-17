*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.CHEQ.CHANGE.PARAM.FIELDS
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
* Modification History :
*-----------------------
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 08-02-2010      HARISH      ODR-2009-12-0275   INITIAL CREATION
*

*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("@ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = '6'
  ID.T = ''
  ID.T<2> = 'SYSTEM'


*-----------------------------------------------------------------------------
  fieldName = "XX<CHEQ.STATUS"
  fieldLength = "5.1"
  fieldType = ""
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = "XX>NO.OF.DAYS"
  fieldLength = "4.1"
  fieldType = "A"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
