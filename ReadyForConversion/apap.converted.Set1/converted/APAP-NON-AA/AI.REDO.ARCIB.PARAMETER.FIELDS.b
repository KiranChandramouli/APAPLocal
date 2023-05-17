SUBROUTINE AI.REDO.ARCIB.PARAMETER.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to define id and fields for the table AI.REDO.ARCIB.PARAMETER
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    ID.F="@ID"
    ID.N = '6'
    ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    fieldName="XX<PRODUCT"
    fieldLength="65"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-TRANSACTION.TYPE"
    fieldLength="30"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('AI.REDO.TXN.TYPE')


    fieldName="XX-MODE.OF.PAYMENT"
    fieldLength="65"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-CURRENCY"
    fieldLength="3"
    fieldType="CCY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CURRENCY')

    fieldName="XX-ACCOUNT.NO"
    fieldLength="35"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    fieldName="XX>TRANSACTION.CODE"
    fieldLength="10"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')

    fieldName="XX<ARC.SERVICE"
    fieldLength="65"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="XX>ARC.CHARGE.CODE"
    fieldLength="65"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('FT.COMMISSION.TYPE')


    fieldName="XX<ACCOUNT.TYPE"
    fieldLength="65"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('AI.REDO.TXN.TYPE')

    fieldName="XX-CATEG.START"
    fieldLength="10"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CATEGORY')

    fieldName="XX>CATEG.END"
    fieldLength="10"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CATEGORY')

    fieldName="XX<CCARD.CUR"
    fieldLength="3"
    fieldType="CCY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CURRENCY')

    fieldName="XX>CCARD.INT.ACCT"
    fieldLength="35"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    fieldName="XX<ACH.PAY.TYPE"
    fieldLength="35"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('AI.REDO.TXN.TYPE')

    fieldName="XX>ACH.CODE"
    fieldLength="35"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="PAYROLL.PMT.DAYS"
    fieldLength="65"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PAYROLL.TXN.CODE"
    fieldLength="65"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PAYROLL.INT.ACCT"
    fieldLength="65"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    fieldName="SUPPLIER.PMT.DAYS"
    fieldLength="65"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="SUPPLIER.TXN.CODE"
    fieldLength="65"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="SUPPLIER.INT.ACCT"
    fieldLength="65"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('ACCOUNT')


    fieldName="XX.RELATION.CODE"
    fieldLength="3"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('RELATION')

    fieldName="XX.MIGRATION.CODE"
    fieldLength="3"
    fieldType="A"
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('TRANSACTION')

    fieldName="RET.TXN.CODE"
    fieldLength="10"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')


    fieldName="RET.TAX.CODE"
    fieldLength="10"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('FT.TXN.TYPE.CONDITION')


    fieldName="UPLOAD.PATH"
    fieldLength="100"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName ="XX.OVERRIDE"
    fieldLength ="35"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
