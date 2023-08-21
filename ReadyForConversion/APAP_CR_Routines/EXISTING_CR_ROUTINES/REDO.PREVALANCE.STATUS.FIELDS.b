*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.PREVALANCE.STATUS.FIELDS
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
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------

  ID.F = '@ID'
  ID.N = '7'
  ID.T<1> = ""
  ID.T<2> = "SYSTEM"
  Y.FINAL.TABLE=''
  table = 'L.AC.STATUS1'
  CALL EB.LOOKUP.LIST(table)
  table1 = 'L.AC.STATUS2'
  CALL EB.LOOKUP.LIST(table1)

  Y.FINAL.TABLE<2> = table<2>:'_':table1<2>
  Y.FINAL.TABLE<11>=  table<11>:'_':table1<11>


  fieldName="XX<XX.STATUS"
  fieldLength="65"
  neighbour=''
  fieldType=Y.FINAL.TABLE
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="XX>PREVALANT.STATUS"
  fieldLength="2"
  fieldType="A"
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('REDO.STATUS')

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
