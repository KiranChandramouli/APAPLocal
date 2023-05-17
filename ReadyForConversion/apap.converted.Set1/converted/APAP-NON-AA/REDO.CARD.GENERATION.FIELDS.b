SUBROUTINE REDO.CARD.GENERATION.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.GENERATION.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CARD.GENERATION
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 22 Jul 2010    Mohammed Anies K      ODR-2010-03-0400        Initial Creation
* 13-MAY-2011       KAVITHA             ODR-2010-08-0467          PACS00055017  FIX
* 28 Sep 2011    Balagurunathan         PACS00131231             Added fields for bulk renewal process
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '25'    ; ID.T = 'A'
    ID.CHECKFILE = 'REDO.CARD.REQUEST'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'AGENCY'          ; fieldLength = '15'  ; fieldType = 'A':@FM:'':@FM:'NOINPUT'  ;  GOSUB ADD.FIELDS ; CALL Field.setCheckFile('COMPANY')
    fieldName = 'XX<CARD.TYPE'       ; fieldLength = '5'   ; fieldType = 'A':@FM:'':@FM:'NOINPUT'  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CARD.TYPE')
    fieldName = 'XX-BIN'             ; fieldLength = '15'  ; fieldType = '':@FM:'':@FM:'NOINPUT'      ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('REDO.CARD.BIN')
*    fieldName = 'XX-PERSONLISED'     ; fieldLength = '10'  ; fieldType = '':FM:'URGENT_REGULAR':FM:'NOINPUT'  ;  GOSUB ADD.FIELDS

*PACS00055017-S

    fieldName = 'XX-PERSONLISED'
    fieldLength = '10'
    virtualTableName='PERSONLISED'
    neighbour = ''
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

*PACS00055017-E

    fieldName = 'XX-QTY'             ; fieldLength = '10'  ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-CARD.SERIES'     ; fieldLength = '35'  ; fieldType = 'A':@FM:'':@FM:'NOINPUT'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-CARD.START.NO'   ; fieldLength = '15'  ; fieldType = '':@FM:'':@FM:'NOINPUT'    ;  GOSUB ADD.FIELDS
    fieldName = 'XX-EXPIRY'          ; fieldLength = '8'   ; fieldType = 'D':@FM:'':@FM:'NOINPUT'       ;  GOSUB ADD.FIELDS
    fieldName = 'XX-EXPORT.RECORDS'     ; fieldLength = '5'   ; fieldType = '':@FM:'':@FM:'NOINPUT'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-RESPONSE.MSG'       ; fieldLength = '250' ; fieldType = 'A':@FM:'':@FM:'NOINPUT' ;  GOSUB ADD.FIELDS
    fieldName = 'XX>XX.CARD.NUMBERS' ; fieldLength = '35'  ; fieldType = '':@FM:'':@FM:'NOINPUT'    ;  GOSUB ADD.FIELDS
    fieldName = 'REQUEST.DESC' ; fieldLength = '35'  ; fieldType = 'A'    ;  GOSUB ADD.FIELDS
    fieldName = 'RENEWAL.FLAG' ; fieldLength = '3'  ; fieldType = 'A'    ;  GOSUB ADD.FIELDS

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
