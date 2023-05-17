*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>28</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.OUTWARD.RETURN.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.OUTWARD.RETURN.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.OUTWARD.RETURN.FIELDS is an H type template
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            ----------
* 15 NOV 2010     Mudassir V           ODR-2010-09-0251         Initial Creation
* 09-03-2011     Sudharsanan S         ODR-2010-03-0083        Insert Check file to NACCOUNT field
* ------------------------------------------------------------------------
* <region name= Header>
* <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)
  ID.N = '35'
  ID.T = 'A'

  neighbour = ''
  fieldName = 'DIN'           ; fieldLength = '10' ; fieldType = ''    ; GOSUB ADD.FIELDS

  fieldName = 'CLEARING'      ; fieldlength = '2'  ; fieldType = ''   ; GOSUB ADD.FIELDS

  fieldName = 'DATE'          ; fieldLength = '8'  ; fieldType = 'D'   ; GOSUB ADD.FIELDS

  fieldName = 'BATCH'         ; fieldLength = '10' ; fieldType = ''   ; GOSUB ADD.FIELDS

  fieldName = 'ACCOUNT'      ; fieldLength = '19' ; fieldType = 'A'   ; GOSUB ADD.FIELDS
*CALL Field.setCheckFile('ACCOUNT')

  fieldName = 'CURRENCY'      ; fieldLength = '3'  ; fieldType = 'A' ; GOSUB ADD.FIELDS
  CALL Field.setCheckFile('CURRENCY')

  fieldName = 'CHEQUE.NO'      ; fieldLength = '10'  ; fieldType = 'A'   ; GOSUB ADD.FIELDS

  fieldName = 'ROUTE.NO'      ; fieldLength = '9'  ; fieldType = ''   ; GOSUB ADD.FIELDS

  fieldName = 'AMOUNT'        ; fieldLength = '14'  ; fieldType = 'AMT'
  fieldType<2,2> = '6' ; GOSUB ADD.FIELDS

  fieldName = 'CATEGORY'      ; fieldLength = '5' ; fieldType = ''   ; GOSUB ADD.FIELDS

  fieldName = 'REJECT.REASON' ; fieldLength = '4'  ; fieldType = ''   ; GOSUB ADD.FIELDS
  CALL Field.setCheckFile('REDO.REJECT.REASON')

  fieldName = 'DEBIT.QUANTITY'; fieldLength = '11' ; fieldType = ''  ; GOSUB ADD.FIELDS

  fieldName = 'DRAWER.ACCT'   ; fieldLength = '19' ; fieldType = 'A'   ; GOSUB ADD.FIELDS


  fieldName = 'CHECK.DIGIT'   ; fieldLength = '12' ; fieldType = 'A'  ; GOSUB ADD.FIELDS

  fieldName = 'IMAGE.ID'      ; fieldLength = '10' ; fieldType = ''   ; GOSUB ADD.FIELDS

  fieldName = 'COMP.CODE'     ; fieldLength = '5' ; fieldType = ''   ; GOSUB ADD.FIELDS

  fieldName = 'NARRATIVE'     ; fieldLength = '65' ; fieldType = 'TEXT'; fieldType<7>='TEXT'; GOSUB ADD.FIELDS

  fieldName = 'HANDOVER.STATUS'; fieldLength = '10' ; fieldType = '' ; fieldType<2> = 'Y_N'; GOSUB ADD.FIELDS

  fieldName = 'HANDOVE.DATE'   ; fieldLength = '11' ; fieldType = 'D'   ; GOSUB ADD.FIELDS

  CALL Table.addReservedField('RESERVED.16')
  CALL Table.addReservedField('RESERVED.15')
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

  CALL Table.setAuditPosition ;* Poputale audit information

  RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  RETURN
*-----------------------------------------------------------------------------
END
