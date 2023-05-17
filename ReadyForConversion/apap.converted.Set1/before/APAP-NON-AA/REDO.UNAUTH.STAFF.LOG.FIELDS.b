*-----------------------------------------------------------------------------
* <Rating>-4</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.UNAUTH.STAFF.LOG.FIELDS
*-----------------------------------------------------------------------------

* COMPANY NAME   : APAP
* DEVELOPED BY   : RAJA SAKTHIVEL K P
* PROGRAM NAME   : REDO.UNAUTH.STAFF.LOG.FIELDS
*-----------------------------------------------------------------------------
* Description : This is the field template definition routine to create the table
* 'REDO.UNAUTH.STAFF.LOG'
*-----------------------------------------------------------------------------
* Input/Output :
*-------------------------------------------------
* IN : NA
* OUT : NA
*--------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_Table
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id

  ID.F = '@ID'
  ID.N = '25'
  ID.T = 'A'

*-----------------------------------------------------------------------------
  fieldName="USER.ID"
  fieldLength="25"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
  fileName="USER"
  CALL Field.setCheckFile(fileName)

  fieldName="ACTIVITY.DATE"
  fieldLength="8"
  fieldType="D"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="ACTIVITY.TIME"
  fieldLength="25"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="APPLICATION"
  fieldLength="25"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  fieldName="RECORD.ID"
  fieldLength="25"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

  V = Table.currentFieldPosition
*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
