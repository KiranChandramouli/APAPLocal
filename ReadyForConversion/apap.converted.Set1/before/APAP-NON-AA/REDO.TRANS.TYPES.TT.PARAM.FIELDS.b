*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TRANS.TYPES.TT.PARAM.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.TRANS.TYPES.TT.PARAM.FIELDS
* ODR NUMBER    : ODR-2010-03-0131
*----------------------------------------------------------------------------
* Description   : This is .fields routine will define the template fields
* In parameter  : none
* out parameter : none
*----------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 10-03-2011      MARIMUTHU s     ODR-2010-03-0131   Initial Creation
* 09-08-2011      SHANKAR RAJU    PACS00101167       Adding EB.LOOKUP for TYPE OF PAYMENT
* ---------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*-----------------------------------------------------------------------------
  CALL Table.defineId("ID", T24_String) ;* Define Table id
  ID.F = '@ID'
  ID.N = '10'
  ID.T = '':FM:'SYSTEM-TT'
*-----------------------------------------------------------------------------
*CALL Table.addField(fieldName, fieldType, args, neighbour)        ;* Add a new fields
*CALL Field.setCheckFile(fileName)   ;* Use DEFAULT.ENRICH from SS or just field 1

  fieldName = 'XX<TYPE.PAYMENT'
  virtualTableName='TYPE.PAYMENT'
  neighbour = ''
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

* FOR PACS00101167 - EB.LOOKUP ADDED
*    fieldType<2> = 'CREDIT CARD PAYMENT_BILL PAYMENT_LOAN PAYMENT_CHEQUE DEPOSIT'
*    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
* FOR PACS00101167 - EB.LOOKUP ADDED

  fieldName = 'XX-TXN.TYPE'
  fieldLength = '5'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
  CALL Field.setCheckFile('TELLER.TRANSACTION')

  fieldName = 'XX-TXN.DESC'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName = 'XX>REL.TXN.CODE'
  fieldLength = '4'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('TRANSACTION')

*CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)       ;* Specify Lookup values
*CALL Field.setDefault(defaultValue) ;* Assign default value
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
