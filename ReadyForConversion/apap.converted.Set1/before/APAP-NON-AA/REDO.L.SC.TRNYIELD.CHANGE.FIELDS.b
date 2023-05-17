*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.L.SC.TRNYIELD.CHANGE.FIELDS
*-----------------------------------------------------------------------------
* Description:
* This is a template fields definition for REDO.L.SC.TRNYIELD.CHANGE
*---------------------------------------------------------------------------------------
*  Input / Output:
* ---------------
* IN     : -NA-
* OUT    : -NA-
*---------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : RIYAS AHAMAD BASHA J
* PROGRAM NAME : REDO.L.SC.TRNYIELD.CHANGE.FIELDS
*---------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                    REFERENCE         DESCRIPTION
* 15.11.2010   RIYAS AHAMAD BASHA J    ODR-2010-07-0083   INITIAL CREATION
* --------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = 20
  ID.T<1> = 'A'
*-----------------------------------------------------------------------------

  fieldName = 'SECURITY.NO'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  fieldName = 'DATE.CHANGE'
  fieldLength = '11'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  fieldName = 'XX<TIME.CHANGE'
  fieldLength = '5'
  fieldType = 'TIME'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  fieldName = 'XX-NEW.YIELD'
  fieldLength = '16'
  fieldType = 'R'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  fieldName = 'XX-OLD.YIELD'
  fieldLength = '16'
  fieldType = 'R'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
  fieldName = 'XX>INP.USER'
  fieldLength = '30'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
