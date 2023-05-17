*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INTERFACE.ACT.FIELDS
*-----------------------------------------------------------------------------
* <doc>
*
* This table is used to store all the events in the interface activity
*
* author: rshankar@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 26/07/2010 - C.22 New Template Creation
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("@ID", T24_String)        ;* Define Table id

  ID.F = '@ID'
  ID.N = '12'
  ID.T = 'A'
*-----------------------------------------------------------------------------

  fieldName="ID.INTERFACE"
  fieldLength="6"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="DESCRIPTION"
  fieldLength="200"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="PROCESS.DATE"
  fieldLength="8"
  fieldType="D"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName="START.TIME"
  fieldLength="4"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="END.TIME"
  fieldLength="4"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="TOTAL.REC"
  fieldLength="6"
  fieldType="6"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="SUCCESS.REC"
  fieldLength="6"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="REJECT.REC"
  fieldLength="6"
  fieldType="6"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="STATUS"
  fieldLength="12"
  fieldType=""
  fieldType<2>="Inicio_En Proceso_Fin con errores_Fin sin errors"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="USER"
  fieldLength="15"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="MACHINE"
  fieldLength="20"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="NEXT.SEQ.DET"
  fieldLength="6"
  fieldType="A"
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
