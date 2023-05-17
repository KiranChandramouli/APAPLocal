*
*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.RIEN4.AZ.REP.OUT2.FIELDS
*-----------------------------------------------------------------------------
*Company   Name    : APAP
*Developed By      : Temenos Americas
*Program   Name    : DR.REG.RIEN4.AZ.REP.OUT2
*-----------------------------------------------------------------------------
*Description       :Table will hold the file details
*In  Parameter     : N/A
*Out Parameter     : N/A
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*
*-----------------------------------------------------------------------------

  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes

  ID.F = '@ID'  ;  ID.N= '20' ;ID.T = ''          ;* Included fields type

  fieldName="RATE"
  fieldLength='15'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.0.15"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.16.30"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.31.60"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.61.90"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.91.180"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.181.360"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.361.720"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.721.1080"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.1081.1440"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.1441.1800"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="RANGE.1881"
  fieldLength='20'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*

*    CALL Table.setAuditPosition         ;* Poputale audit information
*.----------------------------------------------------------------------------
  RETURN
*.----------------------------------------------------------------------------
END
