*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SUNNEL.METHOD.FIELDS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*DESCRIPTION:
*This routine is used to define generic parameter table for sunnel
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.SUNNEL.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 01-12-2010        Prabhu.N         sunnel-CR           Initial Creation
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
*-----------------------------------------------------------------------------
  ID.F="@ID"
  ID.N="35"
  ID.T="ANY"
*-----------------------------------------------------------------------------
  fieldName="METHOD.NAME"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName="XX<APPLICATION"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-XX<T24.IN"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-XX-FLD.NAME"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-XX>FLD.TYPE"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-XX<T24.OUT"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX-XX-OT.NAME"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX>XX>OT.TYPE"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="MSG.CODE.FLD"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="MSG.DESC.FLD"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX<RSM.FIELD.NAME"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX>RSM.ROUTINE.NAME"
  fieldLength="35"
  fieldType="ANY"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.6"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.5"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.4"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.3"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.2"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RESERVED.1"
  fieldLength="1"
  fieldType<3>="NOINPUT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName ="XX.LOCAL.REF"
  fieldLength ="35"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
