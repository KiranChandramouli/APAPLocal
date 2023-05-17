*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.MODTYPE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.LY.MODTYPE.FIELDS *
* @author ganeshr@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 05/04/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = '6'
  ID.T = 'A'
*------------------------------------------------------------------------------
  fieldName = 'MOD.NAME'
  fieldLength = '100'
  fieldType = ''
  fieldType<2>='Transaccion_Balance de Cuenta_Incremento en Balance_Balance Promedio Mensual_Incremento en Balance Promedio Mensual_Evento_Productos Activos Existentes_Interes en Cuenta/Certificado'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
