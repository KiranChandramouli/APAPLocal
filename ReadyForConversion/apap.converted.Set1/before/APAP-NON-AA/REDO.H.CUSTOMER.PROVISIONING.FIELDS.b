*-------------------------------------------------------------------------
* <Rating>6</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.H.CUSTOMER.PROVISIONING.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.CUSTOMER.PROVISIONING.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.H.CUSTOMER.PROVISIONING.FIELDS is an H type template; This TEMPLATE
*                    will store the calculated results of CUSTOMER details based on the
*                    REDO.H.PROVISION.PARAMETER
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            ----------
* 21  Oct 2010     Bharath G         ODR-2009-11-0159 B.23A     Initial Creation
* ------------------------------------------------------------------------
* <region name= Header>
* <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '20'    ; ID.T = 'A' ; ID.CHECKFILE = 'CUSTOMER'
*-----------------------------------------------------------------------------
  neighbour = ''
  fieldName = 'PROCESS.DATE'      ; fieldLength = '8'    ; fieldType = 'D'      ;  GOSUB ADD.FIELDS

  fieldName = 'XX<LOAN.TYPE'      ; fieldLength = '20'   ; fieldType = 'A'
*    fieldType<2>= 'COMMERCIAL_CONSUMER_MORTGAGE'
  GOSUB ADD.FIELDS


  fieldName = 'XX-CURRENT.CLASS'  ; fieldLength = '4'    ; fieldType = 'A'      ;  GOSUB ADD.FIELDS

  fieldName = 'XX-PREVIOUS.CLASS' ; fieldLength = '4'    ; fieldType = 'A'      ;  GOSUB ADD.FIELDS

  fieldName = 'XX-WORST.DAYS.OD'  ; fieldLength = '3'    ; fieldType = 'A'      ;  GOSUB ADD.FIELDS

  fieldName = 'XX>WORST.DAYS.JC'  ; fieldLength = '3'    ; fieldType = 'A'      ;  GOSUB ADD.FIELDS

  fieldName = 'TOTAL.COMMERCIAL'  ; fieldLength = '20'   ; fieldType = 'AMT'    ;  GOSUB ADD.FIELDS

  fieldName = 'PREV.CUST.RATING'  ; fieldLength = '5'    ; fieldType = 'A'      ;  GOSUB ADD.FIELDS

  fieldName = 'CURR.CUST.RATING'  ; fieldLength = '5'    ; fieldType = 'A'      ;  GOSUB ADD.FIELDS

  fieldName = 'XX<ARRANGEMENT.ID' ; fieldLength = '20'   ; fieldType = 'ARR'    ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('AA.ARRANGEMENT')

  fieldName = 'XX-ARR.LOAN.TYPE'  ; fieldLength = '20'    ; fieldType = 'A'     ;  GOSUB ADD.FIELDS

  fieldName = 'XX-CURRENCY'       ; fieldLength = '3'      ; fieldType = 'CCY'  ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('CURRENCY')

  fieldName = 'XX-DAYS.OD'        ; fieldLength = '3'      ; fieldType = ''    ;  GOSUB ADD.FIELDS

  fieldName = 'XX-DAYS.JC'        ; fieldLength = '3'      ; fieldType = ''    ;  GOSUB ADD.FIELDS

  fieldName = 'XX-PROV.PRINC'     ; fieldLength = '25'     ; fieldType = 'AMT'  ;  GOSUB ADD.FIELDS

  fieldName = 'XX-PROV.INTEREST'  ; fieldLength = '25'     ; fieldType = 'AMT'  ;  GOSUB ADD.FIELDS

  fieldName = 'XX-PROV.RESTRUCT'  ; fieldLength = '35'     ; fieldType = 'AMT'  ;  GOSUB ADD.FIELDS

  fieldName = 'XX-PROV.FX'        ; fieldLength = '35'     ; fieldType = 'AMT'  ;  GOSUB ADD.FIELDS

  fieldName = 'XX-TOTAL.PROV.FX'  ; fieldLength = '35'     ; fieldType = 'AMT'  ;  GOSUB ADD.FIELDS

  fieldName = 'XX>TOTAL.PROV'     ; fieldLength = '35'     ; fieldType = 'AMT'  ;  GOSUB ADD.FIELDS


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
