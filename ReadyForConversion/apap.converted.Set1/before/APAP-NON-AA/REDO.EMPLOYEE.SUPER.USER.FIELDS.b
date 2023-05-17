*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.EMPLOYEE.SUPER.USER.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*    DATE             WHO          REFERENCE         DESCRIPTION
* 28 JUN 2011       H GANESH       PACS00075748   INITIAL CREATION
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------

  ID.F = '@ID'
  ID.N = '6'
  ID.T = ''
  ID.T<2> = 'SYSTEM'

  fieldName='XX.DAO'
  fieldLength='16'
  fieldType='DAO'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("DEPT.ACCT.OFFICER")

  CALL Table.addReservedField('RESERVED.11')
  CALL Table.addReservedField('RESERVED.10')
  CALL Table.addReservedField('RESERVED.9')
  CALL Table.addReservedField('RESERVED.8')
  CALL Table.addReservedField('RESERVED.7')
  CALL Table.addReservedField('RESERVED.6')
  CALL Table.addReservedField('RESERVED.5')
  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')
  CALL Table.addLocalReferenceField('XX.LOCAL.REF')
  CALL Table.addOverrideField

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
