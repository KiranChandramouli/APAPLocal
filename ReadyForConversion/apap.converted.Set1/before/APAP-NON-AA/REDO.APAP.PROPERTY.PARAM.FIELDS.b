*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.PROPERTY.PARAM.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*DATE           WHO           REFERENCE         DESCRIPTION
*18.11.2010  H GANESH      ODR-2010-03-0176    INITIAL CREATION
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes

*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID' ; ID.N = '30'
  ID.T = 'A' ; ID.CHECKFILE='AA.PRODUCT.GROUP'


  fieldName='PENALTY.ARREAR'
  fieldLength='30'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.PROPERTY")

  fieldName='XX.PRIN.DECREASE'
  fieldLength='30'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.PROPERTY")


  fieldName='BAL.MAIN.PROPERTY'
  fieldLength='30'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.PROPERTY")

  fieldName='XX.PAYOFF.ACTIVITY'
  fieldLength='55'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.ACTIVITY")

  fieldName='XX.INS.COMM.FIXED'
  fieldLength='30'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.PROPERTY")

  fieldName='XX.INS.COMM.VARIABLE'
  fieldLength='30'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.PROPERTY")

  fieldName='XX.ENDORSE.COMM'
  fieldLength='30'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.PROPERTY")

  fieldName        = 'PENALTY.AGE'
  virtualTableName = 'AA.OVERDUE.STATUS'
  neighbour        = ''
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

  fieldName='XX.PAYOFF.ACT.UNC'
  fieldLength='55'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.ACTIVITY")

  fieldName='XX.OVERPAYMENT.TYPE'
  fieldLength='55'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("AA.PAYMENT.TYPE")

*CALL Table.addReservedField('RESERVED.9')
*CALL Table.addReservedField('RESERVED.8')
*CALL Table.addReservedField('RESERVED.7')
*CALL Table.addReservedField('RESERVED.6')
*CALL Table.addReservedField('RESERVED.5')
*CALL Table.addReservedField('RESERVED.4')
*CALL Table.addReservedField('RESERVED.3')
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
