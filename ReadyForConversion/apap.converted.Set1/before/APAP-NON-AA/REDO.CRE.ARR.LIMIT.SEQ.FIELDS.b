*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CRE.ARR.LIMIT.SEQ.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.CRE.ARR.LIMIT.SEQ
*
* @author hpasquel@temenos.com
* @stereotype fields template
* @uses Live Table
* @public Table Creation
* @package redo.create.arrangement
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
  CALL Table.defineId("CUSTOMER.ID", T24_Customer)          ;* Define Table id
*-----------------------------------------------------------------------------
  neighbour = ''
  fieldName = "XX<LIMIT.REF"
  fieldLenght = "7.3"
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("LIMIT.REFERENCE")
  neighbour = ''
  fieldName = "XX>LAST.ID"
  fieldLenght = "2.2"
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  neighbour = ''
  fieldName = "LAST.COL.RIG.ID"
  fieldLenght = "10"
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
