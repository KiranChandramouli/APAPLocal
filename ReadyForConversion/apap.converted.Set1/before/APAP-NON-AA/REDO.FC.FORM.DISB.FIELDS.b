*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.FORM.DISB.FIELDS

*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     : TEMPLATE REDO.FC.INST.DISB
* Attached as     :
* Primary Purpose : Define the fields to table REDO.FC.INST.DISB
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
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : 16 Junio 2011
* Date            : 28 Nov 2012      - Marimuthu S    - PACS00236823
*-----------------------------------------------------------------------------------



$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.REDO.FC.INST.DISB

  CALL Table.defineId("@ID", T24_String)          ;* Define Table id

  neighbour = ''
  fieldName = 'DESCRIPCION'
  fieldLength = '35.1'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  neighbour = ''
  fieldName = 'XX<ID.INST.DISB'
  fieldLength = '10'
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile("REDO.FC.INST.DISB")

  neighbour = ''
  fieldName = 'XX>FIELD.VRN'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  neighbour = ''
  fieldName = 'NAME.VRN'
  fieldLength = '65'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  neighbour = ''
  fieldName = 'NAME.PART.VRN'
  fieldLength = '65'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')

*----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information

  RETURN
END
