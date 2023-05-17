*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ACH.TRANSFER.DETAILS.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.ACH.TRANSFER.DETAILS.FIELDS
* ODR NUMBER    : ODR-2009-10-0795
*-----------------------------------------------------------------------------
* Description   : This is .fields routine will define the template fields
* In parameter  : none
* out parameter : none
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 10-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)
  ID.F = '@ID'
  ID.N = '22'
  ID.T = 'A'
*-----------------------------------------------------------------------------
  fieldName = 'AGENCY'
  fieldLength = '13'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('COMPANY')

  fieldName = 'PAYMENT.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CLIENT.ID'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CUSTOMER')

  fieldName = 'DEPOSIT.NO'
  fieldLength = '15'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('ACCOUNT')

  fieldName = 'INT.PAYMNT.AMT'
  fieldLength = '15'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'BENEFICIARY'
  fieldLength = '35'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'BENEFICIARY.ACC'
  fieldLength = '16'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'BEN.BNK.CODE'
  fieldLength = '10'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('FT.REDO.ACH.PARTICIPANTS')

  fieldName = 'TRANS.ACH'
  fieldLength = '3'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
