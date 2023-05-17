SUBROUTINE REDO.H.TELLER.TXN.CODES.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.TELLER.TXN.CODES.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.H.TELLER.TXN.CODES
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date            Who                  Reference               Description
*     ------         ------               -------------            -------------
* 11 March  2011    Shiva Prasad Y      ODR-2010-03-0086 35       Initial Creation
* 24 Augest 2011    Pradeep S           PACS00106559              New field added for Product Group.Replaced with Reserved.20
* -----------------------------------------------------------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '35'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    neighbour = ''

    fieldName = 'XX<PAYMENT.MODE'       ; fieldLength = '10.1'    ; fieldType = '':@FM:'CASH_CHEQUE_TRANSFER'     ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX<TXN.TYPE'        ; fieldLength = '15.1'    ; fieldType = '':@FM:'DEPOSITS_WITHDRAWALS_DEPOS.WITHDRW'     ;  GOSUB ADD.FIELDS
    fieldName = 'XX>XX>TXN.CODE'        ; fieldLength = '4.1'     ; fieldType = 'ANY'                               ;  GOSUB ADD.FIELDS
*    CALL Field.setCheckFile('TELLER.TRANSACTION')
    fieldName = 'XX.INT.ACC.CREDIT'     ; fieldLength = '35.1'    ; fieldType = 'ANT'                            ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('ACCOUNT')
    fieldName = 'XX.INTAC.APAP.CASH'    ; fieldLength = '35.1'    ; fieldType = 'ANT'                            ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('ACCOUNT')
    fieldName = 'XX.INTAC.OTH.CASH'     ; fieldLength = '35.1'    ; fieldType = 'ANT'                            ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('ACCOUNT')
    fieldName = 'XX.CHQ.TXN.CODES'      ; fieldLength = '3.1'     ; fieldType = ''                               ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('TRANSACTION')
    fieldName = 'XX.CASH.ACC.CATEG'    ; fieldLength = '10.1'    ; fieldType = ''                               ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CATEGORY')
    fieldName = 'XX.AZ.DP.REINV'    ; fieldLength = '10.1'      ; fieldType = ''                               ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CATEGORY')
    fieldName = 'XX.AZ.DP.NREINV'    ; fieldLength = '35.1'    ; fieldType = 'ANT'                            ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('ACCOUNT')
    fieldName = 'XX.AC.SHORTAGE'    ; fieldLength = '10.1'    ; fieldType = ''                               ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CATEGORY')
    fieldName = 'XX.AC.OVERAGE'    ; fieldLength = '10.1' ; fieldType = ''                              ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('CATEGORY')

    fieldName = 'XX.LOAN.PRD.GRP'    ; fieldLength = '30'    ; fieldType = 'A'                               ;  GOSUB ADD.FIELDS
    CALL Field.setCheckFile('AA.PRODUCT.GROUP')
    fieldName = 'XX.AC.THIRD.PARTY'    ; fieldLength = '10.1'    ; fieldType = ''                               ;  GOSUB ADD.FIELDS
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
