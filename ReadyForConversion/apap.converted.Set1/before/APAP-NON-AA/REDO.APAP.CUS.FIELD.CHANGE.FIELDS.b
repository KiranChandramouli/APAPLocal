*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CUS.FIELD.CHANGE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.ACH.PARAM.FIELDS
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR2009120290
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
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
  fieldName = 'XX.FLD.NAME'
  fieldLength = '35'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'ACCT.OFFICER'
  fieldLength = '35'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('DEPT.ACCT.OFFICER')

  fieldName = 'XX.OTHR.OFFICER'
  fieldLength = '35'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('COMPANY')

  fieldName = 'PERSON.TYPE'
  fieldLength = '35'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.DATE'
  fieldLength = '35'
  fieldType = 'D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.INPUTER'
  fieldLength = '35'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
