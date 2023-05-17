*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TRANUTIL.INTAMT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.INTRANSIT.LOCK
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
  fieldName = 'XX<UTIL.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


  fieldName = 'XX-UTIL.AMOUNT'
  fieldLength = '35'
  fieldType = 'AMT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-CALC.INTEREST'
  fieldLength = '35'
  fieldType = 'AMT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX>NO.OF.DAYS'
  fieldLength = '10'
  fieldType = ''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;



*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
