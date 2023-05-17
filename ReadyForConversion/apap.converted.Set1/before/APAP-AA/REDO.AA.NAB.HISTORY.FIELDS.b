*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AA.NAB.HISTORY.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Puneet Kammar (puneetkammar@contractor.temenos.com)
* Program Name  : REDO.AA.INT.CLASSIFICATION.FIELDS
*-----------------------------------------------------------------------------
* Description : This application is linked to REDO.AA.NAB.HISTORY
*-----------------------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-09-0029      21-Nov-2011          Initial draft
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId('ID', T24_String)
  ID.CHECKFILE = 'AA.ARRANGEMENT'
*-----------------------------------------------------------------------------

  fieldName = 'NAB.CHANGE.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CURRENCY'
  fieldLength = '3'
  fieldType = 'CCY'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'SECTOR'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('SECTOR')

  fieldName = 'L.LOAN.STATUS'
  fieldLength = '1'
  fieldType = 'ANY'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*    CALL Field.setCheckFile('AA.ARR.ACCOUNT')

  fieldName = 'CATEGORY'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CATEGORY')

  fieldName = 'XX<BILL.ID'
  fieldLength = '45'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-INT.AMT'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-PAYMENT.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-INT.PAID'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-INT.BALANCE'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName   = 'XX-ACCT.AMT.RAISED'
  fieldLength = '40'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName   = 'XX>RESERVED.1'
  fieldLength = '40'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'NAB.INTEREST'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'TOT.INT.PAID'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'LAST.PAY.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'LAST.INT.PAID'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'STATUS'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'WOF.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'NXT.BILL.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ACC.AMT'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ACC.AMT.SETLED'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'PREV.NAB.AMT'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'PREV.PAY.AMT'
  fieldLength = '19'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ACCT.YES.NO'
  fieldLength = '5'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'MIGRATED.LOAN'
  fieldLength = '5'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'BACK.DATED.LN'
  fieldLength = '5'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'MARK.HOLIDAY'
  fieldLength = '3'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'REPAY.REV.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ACCRUED.AMT.RAISED'
  fieldLength = '30'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  CALL Table.setAuditPosition

  RETURN
*-----------------------------------------------------------------------------
END
