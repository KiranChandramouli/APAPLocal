SUBROUTINE REDO.APAP.L.AMORT.BALANCES.FIELDS
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
* 28 Sep 2010     SHANKAR RAJU        ODR-2010-07-0081         Initial Creation
* ------------------------------------------------------------------------
* <region name= Header>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '25'    ; ID.T = 'A'
*-----------------------------------------------------------------------------

    neighbour = ''

    fieldName = 'XX<INT.AMRT.DATE'   ; fieldLength = '10'   ; fieldType = 'D'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX-INT.EFF.RATE'   ; fieldLength = '20'   ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX-AMORT.AMT'     ; fieldLength = '35'   ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    fieldName = 'XX>AMORT.TO.DATE'    ; fieldLength = '10'   ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    CALL Table.addReservedField('RESERVED.20')
    CALL Table.addReservedField('RESERVED.19')
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

RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*-----------------------------------------------------------------------------
END
