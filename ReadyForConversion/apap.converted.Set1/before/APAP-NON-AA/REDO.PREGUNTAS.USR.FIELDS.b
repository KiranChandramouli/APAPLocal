*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.PREGUNTAS.USR.FIELDS
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
  ID.F = "ID.PREUSER" ;  ID.N = "35" ;  ID.T = "" ; ID.T<4> = '########-#########'
*-----------------------------------------------------------------------------
  CALL Table.addOptionsField("TIPO.CANAL", "INTERNET_IVR", "", "")
  CALL Table.addFieldDefinition('ID.USUARIO', 35, 'A', '')
  CALL Table.addFieldDefinition('PREGUNTA', 50, 'A', '')
  CALL Table.addFieldDefinition('RESPUESTA', 50, 'A', '')
*-----------------------------------------------------------------------------
  CALL Table.addReservedField('RESERVED.5')
  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
