*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACCT.MRKWOF.HIST.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Ravikiran (ravikiran@temenos.com)
* Program Name  : REDO.ACCT.MRKWOF.HIST.FIELDS
*-----------------------------------------------------------------------------
* Description : This application is linked to REDO.ACCT.MRKWOF.HIST
*-----------------------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017      17-Jan-2012          Initial draft
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

  fieldName = 'WOF.CHANGE.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CURRENCY'
  fieldLength = '3'
  fieldType = 'IN2CCY'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ARR.AGE.STATUS'
  fieldLength = '3'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'L.LOAN.STATUS'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'PRODUCT'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('AA.PRODUCT')

  fieldName = 'CATEGORY'
  fieldLength = '10'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CATEGORY')

  fieldName = 'XX<BILL.ID'
  fieldLength = '15'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-INT.AMT'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-INT.PAID'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-INT.BALANCE'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-PRINCIPAL.AMT'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-PAYMENT.DATE'
  fieldLength = '8'
  fieldType = 'IN2D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX-PRINCIPAL.PAID'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX>PRINCIPAL.BAL'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'OS.INT'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'OS.PRINCIPAL'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'TOT.INT.PAID'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'TOT.PRINCIPAL.PAID'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'STATUS'
  fieldLength = '10'
  fieldType = 'INITIATED_LIQUIDATED'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ACC.INT.AMT'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'OUTSTANDING.AMT'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'OUT.AMT.REP'
  fieldLength = '15'
  fieldType = 'IN2AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ACC.INT.DATE'
  fieldLength = '15'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'ACC.INT.YN'
  fieldLength = '3'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  CALL Table.addLocalReferenceField('XX.LOCAL.REF')
  CALL Table.addOverrideField
  CALL Table.setAuditPosition ;* Poputale audit information

  RETURN
*-------------------------------------------------------------------------------------------------------

1 END
