SUBROUTINE REDO.AA.PART.DISBURSE.FC.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : TAM
* Program Name  : REDO.AA.PART.DISBURSE.FC.FIELDS
*-----------------------------------------------------------------------------
* Description : This application is for partial disbursement next version
*-----------------------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Author
* PACS00236823        28-11-2012            Marimuthu S
* PACS00254302        13-03-2013            Sivakumar K
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------

    ID.F = '@ID'
    ID.N = '20'
    ID.T = 'A'

    fieldName   = 'ID.ARRANGEMENT'
    fieldLength = '15'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'PARTIAL.OS.AMT'
    fieldLength = '18'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'DIS.AMT.TOT'
    fieldLength = '18.1'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX<DIS.TYPE'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("REDO.FC.FORM.DISB")

    neighbour = ''
    fieldName = 'XX-XX<ID.DET.INS'
    fieldLength = '4'
    fieldType = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'XX-XX-FIELD.DET.INS'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'XX-XX>VAL.DET.INS'
    fieldLength = '80'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'XX-DIS.AMT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'XX-DIS.STA'
    fieldLength = '15'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'XX>DIS.CODTXN'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'DIS.STAT'
    fieldLength = '2'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'XX<CHARG.DISC'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PROPERTY")

    neighbour = ''
    fieldName = 'XX>CHARG.AMOUNT'
    fieldLength = '19'
    fieldType = 'AMT'
    fieldType<2,2> = LCCY
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'PRODUCT'
    fieldLength = '40'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("AA.PRODUCT")

    neighbour = ''
    fieldName = 'CURRENCY'
    fieldLength = '3'
    fieldType = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CURRENCY")

    neighbour = ''
    fieldName = 'LOAN.AC'
    fieldLength = '15'
    fieldType = 'ACC'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("ACCOUNT")

    neighbour = ''
    fieldName = 'VALUE.DATE'
    fieldLength = '10'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    neighbour = ''
    fieldName = 'CUSTOMER'
    fieldLength = '20.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
    CALL Field.setCheckFile("CUSTOMER")

    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.4')
    CALL Table.addReservedField('RESERVED.3')
    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------

RETURN
*-----------------------------------------------------------------------------
END
