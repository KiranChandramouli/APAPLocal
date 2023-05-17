*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.LOAN.FT.TT.TXN.FIELDS
*-----------------------------------------------------------------------------
* Description: This is .fields routine to store the cheque repayment details
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : NA
* Deals With     : NA
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                          DESCRIPTION
*  16-01-2012    S.MARIMUTHU             PACS00170057                        Initial draft
*------------------------------------------------------------------------
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.REDO.LOAN.FT.TT.TXN
*-----------------------------------------------------------------------------

  ID.F = '@ID'
  ID.N = '15'
  ID.T = 'A'
*-----------------------------------------------------------------------------


  fieldName   = 'XX<FT.TRANSACTION.ID'
  fieldLength = '25'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX-LOAN.ID'
  fieldLength = '25'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX-CURRENCY'
  fieldLength = '25'
  fieldType   = 'CCY'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX-AMOUNT'
  fieldLength = '25'
  fieldType   = 'AMT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX-RETURN.AMOUNT'
  fieldLength = '25'
  fieldType   = 'AMT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX-RETURN.FT.REF'
  fieldLength = '25'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX-RETURNED.AMOUNT'
  fieldLength = '25'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX-XX<RETURNED.CHQ'
  fieldLength = '25'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX>XX>INDV.RET.AMT'
  fieldLength = '25'
  fieldType   = 'AMT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'DATE'
  fieldLength = '8'
  fieldType   = 'D'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX<CHEQUE.REF'
  fieldLength = '25'
  fieldType   = 'ANY'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX-DRAWDOWN.ACC'
  fieldLength = '25'
  fieldType   = 'ANY'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'XX>CHEQUE.AMOUNT'
  fieldLength = '25'
  fieldType   = 'AMT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'TOTAL.AMOUNT'
  fieldLength = '25'
  fieldType   = 'AMT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'TOTAL.RETURN.AMT'
  fieldLength = '25'
  fieldType   = 'AMT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'STATUS'
  fieldLength = '25'
  fieldType   = 'A'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'CHQ.AMOUNT'
  fieldLength = '25'
  fieldType   = 'AMT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'CASH.AMOUNT'
  fieldLength = '25'
  fieldType   = 'AMT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  fieldName   = 'TRANS.AMOUNT'
  fieldLength = '25'
  fieldType   = 'AMT'
  neighbour   = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

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
  CALL Table.setAuditPosition ;* Poputale audit information

  RETURN
*-----------------------------------------------------------------------------
END
