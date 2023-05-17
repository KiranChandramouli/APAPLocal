*-----------------------------------------------------------------------------
* <Rating>-5</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.PAYMENT.DISBURSE.DESC.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : MARIMUTHU S
* Program Name  : REDO.PAYMENT.DISBURSE.DESC.FIELDS
*-----------------------------------------------------------------------------
* Description : This application is linked to REDO.PAYMENT.DISBURSE.DESC
*-----------------------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* PACS00203617           10 JUL 2012
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId('@ID', T24_String)
  ID.F = '@ID'
  ID.N = '6'
  ID.T = ''
  ID.T<2> = 'SYSTEM'

*-----------------------------------------------------------------------------

  fieldName = 'XX<DISBURSE.TYPE'
  fieldType = 'A'
  neighbour = ''
  virtualTableName = 'DISBURSE.TYPE'
  CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

  fieldName = 'XX>DESCRIPTION'
  fieldLength = '65'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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
*-------------------------------------------------------------------------------------------------------

END
