SUBROUTINE REDO.CLEARING.OUTWARD.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CLEARING.OUTWARD.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.CLEARING.OUTWARD.FIELDS is an H type template
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            ------------
* 15 NOV 2010      ganesh R           ODR-2010-09-0251        Initial Creation
* ------------------------------------------------------------------------
* <region name= Header>
* <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
    GOSUB ID
    GOSUB FIELDS
RETURN

ID:
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '35'
    ID.T = 'A'
RETURN

FIELDS:
    neighbour = ''
    fieldName = 'DIN'            ; fieldLength = '10' ; fieldType = ''; GOSUB ADD.FIELDS
    fieldName = 'CLEARING.CODE'  ; fieldlength = '2' ; fieldType = ''; GOSUB ADD.FIELDS
    fieldName = 'DATE'           ; fieldLength = '8' ; fieldType = 'D'   ; GOSUB ADD.FIELDS
    fieldName = 'BATCH'          ; fieldLength = '10' ; fieldType = ''  ; GOSUB ADD.FIELDS

    fieldName = 'DRAWER.ACCT'   ; fieldLength = '19' ; fieldType = 'A'  ; GOSUB ADD.FIELDS

    fieldName = 'CHEQUE.NO'     ; fieldLength = '10' ; fieldType = ''   ; GOSUB ADD.FIELDS
    fieldName = 'ROUTE.NO'      ; fieldLength = '9' ; fieldType = ''   ; GOSUB ADD.FIELDS
    fieldName = 'EXPOSURE.DATE' ; fieldLength = '8' ; fieldType = 'D'  ; GOSUB ADD.FIELDS
    fieldName = 'AMOUNT'        ; fieldLength = '15' ; fieldType = 'AMT' ; GOSUB ADD.FIELDS

    fieldName = 'CATEGORY'      ; fieldLength = '4' ; fieldType = ''  ; GOSUB ADD.FIELDS

    fieldName = 'ACCOUNT'      ; fieldLength = '19'; fieldType = 'A'  ; GOSUB ADD.FIELDS
    CALL Field.setCheckFile('ACCOUNT')

    fieldName = 'CURRENCY'     ; fieldLength = '3'; fieldType = 'A'  ; GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CURRENCY')

    fieldName = 'CHECK.DIGIT'   ; fieldLength = '2' ; fieldType = ''  ; GOSUB ADD.FIELDS

    fieldName = 'TFS.REFERENCE' ; fieldLength = '15'; fieldType = 'A' ; GOSUB ADD.FIELDS

    fieldName = 'TELLER.ID' ; fieldLength = '4' ; fieldType = ''  ; GOSUB ADD.FIELDS
    CALL Field.setCheckFile('TELLER.ID')

    fieldName = 'CHQ.STATUS' ; fieldLength = '10' ; fieldType = ''; fieldType<2> = 'DEPOSITED_CLEARED_RETURNED' ; GOSUB ADD.FIELDS
    fieldName = 'IMAGE.ID'      ; fieldLength = '14' ; fieldType = ''   ; GOSUB ADD.FIELDS
    fieldName = 'TXN.REFERENCE' ;fieldLength = '10' ; fieldType = '' ; GOSUB ADD.FIELDS
    fieldName = 'NO.OF.CHEQUE'  ; fieldLength = '4' ; fieldType = '' ; GOSUB ADD.FIELDS
    fieldName = 'COMP.CODE'       ; fieldLength = '10' ; fieldType = 'A'   ; GOSUB ADD.FIELDS
    fieldName = 'NARRATIVE'     ; fieldLength = '35' ; fieldType = 'A'  ; GOSUB ADD.FIELDS
    fieldName = 'BATCH.RELEASED' ; fieldLength = '1' ; fieldType = '':@FM:'Y_N' ; GOSUB ADD.FIELDS
    fieldName = 'XX.AC.LOCK.ID' ; fieldLength = '25' ; fieldType = 'A' ; GOSUB ADD.FIELDS
    fieldName = 'SEQUENCE' ; fieldLength = '25' ; fieldType = '' ; GOSUB ADD.FIELDS
    fieldName = 'RETURN.STATUS' ; fieldLength = '25' ; fieldType = 'A'; GOSUB ADD.FIELDS

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
