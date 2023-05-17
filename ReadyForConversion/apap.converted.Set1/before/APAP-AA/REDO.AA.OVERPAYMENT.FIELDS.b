*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AA.OVERPAYMENT.FIELDS
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.REDO.AA.OVERPAYMENT


*-----------------------------------------------------------------------------
  CALL Table.defineId("TABLE.NAME.ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------

  ID.F = '@ID'
  ID.N = '35'
  ID.T = 'A'


  fieldName='LOAN.NO'
  fieldLength='35'
  fieldType='POSANT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("ACCOUNT")

  fieldName='CURRENCY'
  fieldLength='3'
  fieldType='CCY'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("CURRENCY")

  fieldName='AMOUNT'
  fieldLength='19'
  fieldType='AMT'
  fieldType<2,2> = REDO.OVER.CURRENCY
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='PAYMENT.METHOD'
  fieldLength='15'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='PAYMENT.DATE'
  fieldLength='12'
  fieldType='D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='TELLER.TXN.REF'
  fieldLength='20'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='CUSTOMER.ID'
  fieldLength='20'
  fieldType='CUS'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("CUSTOMER")

  fieldName='INTEREST.RATE'
  fieldLength='20'
  fieldType='R'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='NEXT.DUE.DATE'
  fieldLength='12'
  fieldType='D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='LOAN.AGING.STATUS'
  fieldLength='8'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='LOAN.MANUAL.STATUS'
  fieldLength='8'
  fieldType='ANY'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='CATEGORY'
  fieldLength='8'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("CATEGORY")

  fieldName='COMP.CODE'
  fieldLength='20'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("COMPANY")

  fieldName='TOT.COMP.INTEREST'
  fieldLength='19'
  fieldType='AMT'
  fieldType<2,2> = REDO.OVER.CURRENCY
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='COMP.INT.THISMONTH'
  fieldLength='19'
  fieldType='AMT'
  fieldType<2,2> = REDO.OVER.CURRENCY
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='COMP.INT.NEXTMONTH'
  fieldLength='19'
  fieldType='AMT'
  fieldType<2,2> = REDO.OVER.CURRENCY
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='STATUS'
  fieldLength='25'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='XX.FT.TXN.REFS'
  fieldLength='25'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName   = 'PROGLOAN.STATUS'
  fieldLength = '25'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*CALL Table.addReservedField('RESERVED.15')
  CALL Table.addReservedField('RESERVED.14')
  CALL Table.addReservedField('RESERVED.13')
  CALL Table.addReservedField('RESERVED.12')
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
