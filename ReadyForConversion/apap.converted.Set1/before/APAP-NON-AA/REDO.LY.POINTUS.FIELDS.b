*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LY.POINTUS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.LY.POINTUS.FIELDS
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
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
  ID.F = '@ID'
  ID.N = '1'
  ID.T = 'A'
*------------------------------------------------------------------------------
  fieldName = 'POINTU.NAME'
  fieldLength = '100'
  fieldType = ''
  fieldType<2>='Transaccion Interna/A Cuenta Ahorros_Generacion de Archivo_Repositorio de Cliente, uso pendiente definido por el negocio_Repositorio de Cliente, uso pendiente definido por el cliente'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
