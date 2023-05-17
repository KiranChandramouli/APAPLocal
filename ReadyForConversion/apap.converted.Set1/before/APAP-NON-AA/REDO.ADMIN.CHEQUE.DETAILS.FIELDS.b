*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ADMIN.CHEQUE.DETAILS.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.ADMIN.CHEQUE.DETAILS.FIELDS
* ODR NUMBER    : ODR-2009-10-0795
*-----------------------------------------------------------------------------
* Description   : This is .fields routine will define the template fields
* In parameter  : none
* out parameter : none
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 10-01-2011      MARIMUTHU s     ODR-2009-10-0795   Initial Creation
* 12-10-2011       JEEVA T          PACS00139330
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.F = '@ID'
  ID.N = '20'
  ID.T<1> = 'A'
*-----------------------------------------------------------------------------

  fieldName = 'AGENCY'
  fieldLength = '13'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile('COMPANY')

  fieldName = 'PAYMENT.DATE'
  fieldLength = '8'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CLIENT.ID'
  fieldLength = '30'
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

  fieldName = 'INTEREST.RATE'
  fieldLength = '6'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'INT.PAYMNT.AMT'
  fieldLength = '6'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CHEQ.BENEFICIARY'
  fieldLength = '35'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CHEQ.PRINT'
  fieldLength = '3'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'CHEQ.NO.REF'
  fieldLength = '15'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'FT.NO.REF'
  fieldLength = '15'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*---------------------------PACS00139330  -------------------------------------
  fieldName = 'XX<HLD.CNTRL.ID'
  fieldLength = '150'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX>APPROVAL'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-------------------------------PACS00139330  --------------------------------

*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
