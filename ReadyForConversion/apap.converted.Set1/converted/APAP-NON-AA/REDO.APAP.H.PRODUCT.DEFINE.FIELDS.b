SUBROUTINE REDO.APAP.H.PRODUCT.DEFINE.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.H.PRODUCT.DEFINE.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.H.PRODUCT.DEFINE is an H type template; this template is used to record
*                    the allowed CATEGORIES for all MM contracts for which the accrual is to done
*                    using Effective rate method
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            --------- -
* 28 Sep 2010     Mudassir V         2000 ODR-2010-07-0077      Initial Creation
* 18-Feb-2013     Arundev KR         CR008 RTC-553577           changes for Discount Amortisation
* ------------------------------------------------------------------------
* <region name= Header>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '6'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'XX.CATEGORY'   ; fieldLength = '10.1'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CATEGORY')

    fieldName = 'INT.PAY.TXN.CODE'   ; fieldLength = '10.1'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('TRANSACTION')

    fieldName = 'INT.ACC.TXN.CODE'   ; fieldLength = '10.1'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('TRANSACTION')

    fieldName = 'INT.ACC.PL.CATEG'   ; fieldLength = '10.1'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CATEGORY')

    fieldName = 'LOAN.CATEG'   ; fieldLength = '10.1'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CATEGORY')

    fieldName = 'DEPO.CATEG'   ; fieldLength = '10.1'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CATEGORY')

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
