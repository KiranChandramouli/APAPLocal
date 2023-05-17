*-----------------------------------------------------------------------------
* <Rating>-19</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.L.CONTRACT.BALANCES.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.L.CONTRACT.BALANCES.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.L.CONTRACT.BALANCES is an L type template; this template is used to record
*                    the details on authorisation of MM.MONEY.MARKET with accrual as effective rate method
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 28 Sep 2010     Mudassir V         ODR-2010-09-0167 B.23B     Initial Creation
* 18-Feb-2013     Arundev KR         CR008 RTC-553577           changes for Discount Amortisation
* ------------------------------------------------------------------------
* <region name= Header>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_Table
* </region>
*-------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '25'    ; ID.T = 'A'
*    ID.CHECKFILE = 'MM.MONEY.MARKET'
*-----------------------------------------------------------------------------
  neighbour = ''
  fieldName = 'XX<INT.ACC.DATE'   ; fieldLength = '10'   ; fieldType = 'D'   ;  GOSUB ADD.FIELDS

  fieldName = 'XX-INT.EFF.RATE'   ; fieldLength = '20'   ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

  fieldName = 'XX>ACCRUE.AMT'     ; fieldLength = '35'   ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

  fieldName = 'ACCRUE.TO.DATE'    ; fieldLength = '10'   ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

  fieldName = 'NOMINAL'           ; fieldLength = '19'   ; fieldType = 'AMT' ;  GOSUB ADD.FIELDS

  fieldName = 'EFF.ADJ.TOT'       ; fieldLength = '19'   ; fieldType = 'AMT' ;  GOSUB ADD.FIELDS

  CALL Table.addReservedField('RESERVED.18')
  CALL Table.addReservedField('RESERVED.17')
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

  V = Table.currentFieldPosition

  RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  RETURN
*-----------------------------------------------------------------------------
END
