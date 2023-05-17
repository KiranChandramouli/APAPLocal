*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VIRTUAL.BRANCH.FIELDS

*COMPANY NAME   : APAP
*DEVELOPED BY   :TEMENOS APPLICATION MANAGEMENT
*PROGRAM NAME   :REDO.BRAN.EDU.DETS.FIELDS
*DESCRIPTION    :TEMPLATE FOR THE FIELDS OF REDO.BRAN.EDU.DETS
*LINKED WITH    :REDO.BRAN.EDU.DETS
*IN PARAMETER   :NULL
*OUT PARAMETER  :NULL
*MODIFICATION DETAILS:
*     03NOV09 ODR-2009-10-0526


$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

  ID.F=''
  ID.N='4'
  ID.T=''

*-------------------------------------------------------------------------
  fieldName="XX.LL.DESCRIPTION"
  fieldLength=35.1
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName="XX.LL.SHORT.DESC"
  fieldLength=20.1
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Table.setAuditPosition

  RETURN
END
