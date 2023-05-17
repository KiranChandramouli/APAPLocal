*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACCT.MRKWOF.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.ACCT.MRKWOF.PARAMETER.FIELDS
*-----------------------------------------------------------------
* Description : This application is to parameterise the category codes
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      21-Nov-2011          Initial draft
* ----------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*-----------------------------------------------------------------------------
*CALL Table.defineId("@ID", T24_String)

  ID.F = '@ID'
  ID.N = '6'
  ID.T = ''
  ID.T<2> = 'SYSTEM'

*-----------------------------------------------------------------------------

*fieldName = 'XX<PRODUCT'
*fieldLength = 35
*fieldType = 'A'
*neighbour = ''
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field
*CALL Field.setCheckFile('REDO.PRODUCT')

  fieldName   = 'XX<PROD.CATEGORY'
  fieldLength = 10
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CATEGORY')

  fieldName = 'XX-XX<LOAN.STATUS'
  fieldLength = 1
  fieldType = 'ANY'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-XX-PRIN.DEB.CATEGORY'
  fieldLength = 10
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CATEGORY')

  fieldName = 'XX-XX-PRIN.DEB.TXN'
  fieldLength = 3
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('TRANSACTION')

  fieldName = 'XX-XX-PRIN.CRED.CATEGORY'
  fieldLength = 19
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*CALL Field.setCheckFile('ACCOUNT')

  fieldName = 'XX-XX-PRIN.CRED.TXN'
  fieldLength = 3
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('TRANSACTION')

  fieldName = 'XX-XX-INT.DEB.CATEGORY'
  fieldLength = 10
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CATEGORY')

  fieldName = 'XX-XX-INT.DEB.TXN'
  fieldLength = 3
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('TRANSACTION')

  fieldName = 'XX-XX-INT.CRED.CATEGORY'
  fieldLength = 19
  fieldType = 'POSANT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*CALL Field.setCheckFile('ACCOUNT')

  fieldName = 'XX>XX>INT.CRED.TXN'
  fieldLength = 3
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('TRANSACTION')

  fieldName = 'PRINCIPAL.INCOME'
  fieldLength = 10
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CATEGORY')

  fieldName = 'INTEREST.INCOME'
  fieldLength = 10
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CATEGORY')

  fieldName = 'INT.SETTLE.ACC'
  fieldLength = 19
  fieldType = 'POSANT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('ACCOUNT')

  CALL Table.addReservedField('RESERVED.8')
  CALL Table.addReservedField('RESERVED.7')
  CALL Table.addReservedField('RESERVED.6')
  CALL Table.addReservedField('RESERVED.5')
  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')


* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
* CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
