*-----------------------------------------------------------------------------
* <Rating>-6</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AZ.ROLLOVER.DETAILS.FIELDS
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

*----------------------------------------------------------------------------
* Modification History :
*-----------------------
*  DATE             WHO         REFERENCE           DESCRIPTION
* 23-Jun-2011   H GANESH       PACS00033292 - N.16  INITIAL CREATION
*
*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F =  '@ID'
  ID.N =  '16'
  ID.T =  ''

  fieldName='ACCOUNT.NO'
  fieldLength='16'
  fieldType='ACC'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='ACCOUNT.NAME'
  fieldLength='35'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='STREET'
  fieldLength='100'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='ADDRESS'
  fieldLength='100'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='TOWN.COUNTRY'
  fieldLength='100'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='POST.CODE'
  fieldLength='100'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='DAYS'
  fieldLength='25'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='TIMESTAMP'
  fieldLength='25'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
