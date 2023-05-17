*-----------------------------------------------------------------------------
* <Rating>-17</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.POLIZA.CARGOS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine GENERAL ARRANGEMENT FIELDS
* @author MGUDINO@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*  DATE              WHO                       Modification
*        MGUDINO
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.CUSTOMER
$INSERT I_F.AA.PRODUCT
$INSERT I_F.CURRENCY
$INSERT I_F.REDO.COLL.TYPE.DET
$INSERT I_F.REDO.EMP.RESP.MVMT
$INSERT I_F.REDO.CAMPAIGN.TYPES
$INSERT I_F.REDO.AFFILIATED.COMPANY
*    $INCLUDE TAM.BP I_F.REDO.H.SUCURSAL
$INSERT I_F.REDO.CIUU.LOAN.DESTINATION

*** </region>


  GOSUB DEFINE.GENERAL.FIELDS

  RETURN


DEFINE.GENERAL.FIELDS:

*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
*
  CALL Table.addOptionsField("RUBRO.POLIZA","MONTO PRIMA MENSUAL_TIPO COMISION SEGUROS_EXTRA PRIMA","","")

  neighbour = ''
  fieldName = 'TIPO.PAGO'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("AA.PAYMENT.TYPE")
*
  neighbour = ''
  fieldName = 'PROPIEDAD'
  fieldLength = '35.1'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("AA.PROPERTY")
*
  neighbour = ''
  fieldName = 'DESCRIPCION'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
  neighbour = ''
  fieldName = 'XX.TIPO.POLIZA'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("APAP.H.INSURANCE.POLICY.TYPE")


  CALL Table.addOverrideField
*
*----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*
  RETURN
*----------------------------------------------------------------------------

END
