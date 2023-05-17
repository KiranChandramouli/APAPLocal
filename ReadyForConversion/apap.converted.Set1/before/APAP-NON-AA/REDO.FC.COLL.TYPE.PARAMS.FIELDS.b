*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.COLL.TYPE.PARAMS.FIELDS

*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     : TEMPLATE REDO.FC.COLL.CODE.PARAMS
* Attached as     :
* Primary Purpose : Define the fields to table REDO.FC.COLL.TYPE.PARAMS
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Meza William - TAM Latin America
* Date            : 10 Junio 2011
*
*-----------------------------------------------------------------------------------


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

  ID.F = "@ID" ; ID.N = "3" ; ID.T = ""
  ID.CHECKFILE = "COLLATERAL.TYPE"

  neighbour = ''
  fieldName = 'PER.REA'
  fieldLength = '16.1'
  fieldType = 'R'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  neighbour = ''
  fieldName = 'PER.5.ANIOS'
  fieldLength = '16.1'
  fieldType = 'R'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  CALL Table.addReservedField('RESERVED.5')
  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')

*----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information

  RETURN
END
