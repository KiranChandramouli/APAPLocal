*-------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>27</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COLLECT.PARAM.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.COLLECT.PARAM.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.COLLECT.PARAM.FIELDS is an H type template
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            --------- -
* 22 Sep 2010     Mudassir V            ODR-2010-09-0251     Initial Creation
* ------------------------------------------------------------------------
* <region name= Header>
* <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '6'    ; ID.T = '' ; ID.T<2> = 'SYSTEM'
*-----------------------------------------------------------------------------
  neighbour = ''
  fieldName = 'TT.FT.TRAN.TYPE' ; fieldLength = '15'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS

  fieldName = 'CAT.FCY.COLLECT'   ; fieldLength = '5'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('CATEGORY')

  fieldName = 'CAT.COMMISSION' ; fieldLength = '5'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('CATEGORY')

  fieldName = 'NOR.TRAN.PERIOD'  ; fieldLength = '3'     ; fieldType = ''   ;  GOSUB ADD.FIELDS

  fieldName = 'XX<CURRENCY'  ; fieldLength = '3'     ; fieldType = 'CCY'   ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('CURRENCY')
  fieldName = 'XX-XX<CUST.TYPE'  ; fieldLength = '35'     ; fieldType = 'A' ; fieldType<2> = 'PERSONA FISICA_CLIENTE MENOR_PERSONA JURIDICA'   ;  GOSUB ADD.FIELDS

  fieldName = 'XX>XX>IN.TRANS.DAYS'  ; fieldLength = '3'     ; fieldType = ''   ;  GOSUB ADD.FIELDS

  fieldName = 'CHARGE.REJECT'  ; fieldLength = '8'     ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

  fieldName = 'CUTOFF'  ; fieldLength = '5'     ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

  fieldName = 'XX<RETURN.CCY'  ; fieldLength = '3'     ; fieldType = 'CCY'   ;  GOSUB ADD.FIELDS
  fieldName = 'XX>RETURN.ACCOUNT'  ; fieldLength = '20'     ; fieldType = 'A'   ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('ACCOUNT')

  fieldName = 'XX<SETTLE.CCY'  ; fieldLength = '3'     ; fieldType = 'CCY'   ;  GOSUB ADD.FIELDS
  fieldName = 'XX>SETTLE.ACCOUNT'  ; fieldLength = '20'     ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

  fieldName = 'XX<UNIV.CLEAR.CCY'  ; fieldLength = '3'     ; fieldType = 'CCY'   ;  GOSUB ADD.FIELDS
  fieldName = 'XX>UNIV.CLEAR.ACCT'  ; fieldLength = '20'     ; fieldType = 'A'   ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('ACCOUNT')

  fieldName = 'CLEARING.CR.CODE' ; fieldLength = '11' ; fieldType = '' ;
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("TRANSACTION")

  fieldName = 'CLEARING.DR.CODE' ; fieldLength = '11' ; fieldType = '' ;
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("TRANSACTION")

  CALL Table.addLocalReferenceField('XX.LOCAL.REF')

  CALL Table.addOverrideField

  fieldName = 'XX<CAT.ACH.CCY'  ; fieldLength = '3'     ; fieldType = 'CCY'   ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('CURRENCY')

  fieldName = 'XX>CAT.ACH.ACCT'  ; fieldLength = '20'     ; fieldType = 'A'   ;  GOSUB ADD.FIELDS
  CALL Field.setCheckFile('ACCOUNT')

  fieldName = 'CAT.ACH.CR.CODE' ; fieldLength = '11' ; fieldType = '' ;
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("TRANSACTION")

  fieldName = 'CAT.ACH.DR.CODE' ; fieldLength = '11' ; fieldType = '' ;
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("TRANSACTION")


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
