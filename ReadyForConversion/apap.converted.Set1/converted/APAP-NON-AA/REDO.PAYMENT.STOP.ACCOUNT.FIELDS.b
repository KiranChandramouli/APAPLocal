SUBROUTINE REDO.PAYMENT.STOP.ACCOUNT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'

    fieldName="CURRENCY"
    fieldLength="3"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CURRENCY')

    fieldName="CUSTOMER"
    fieldLength="10"
    neighbour=""
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CUSTOMER')

    fieldName="ACCOUNT.NUMBER"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("ACCOUNT")

    fieldName="XX<PAY.STOP.STATUS"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.PAYMENT.STOP.PARAMETER")

    fieldName="XX-ISSUE.DATE"
    fieldLength="12"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-EXPIRY.DATE"
    fieldLength="12"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-EXP.TIME"
    fieldLength="12"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="XX-PAY.REASON"
    fieldLength="12"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("PAYMENT.STOP.TYPE")

    fieldName="XX-CHEQUE.FIRST"
    fieldLength="12"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-CHEQUE.LAST"
    fieldLength="12"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-NO.OF.LEAVES"
    fieldLength="12"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-CHEQUE.TYPE"
    fieldLength="12"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CHEQUE.TYPE")

    fieldName="XX-STOP.DATE"
    fieldLength="12"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-AMT.FROM"
    fieldLength="12"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-AMT.TO"
    fieldLength="12"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-BENIFICIARY"
    fieldLength="50"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-REMARKS"
    fieldLength="12"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-WAIVE.CHARGES"
    fieldLength="5"
    fieldType='':@FM:"YES_NO"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="XX-CHARGE.CODE"
    fieldLength="15"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("FT.COMMISSION.TYPE")

    fieldName="XX-CHARGE.ACCOUNT"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("ACCOUNT")

    fieldName="XX-CHARGE.CURRENCY"
    fieldLength="3"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CURRENCY")

    fieldName="XX-CHARGE.AMOUNT"
    fieldLength="20"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-TAX.TYPE"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-TAX.AMOUNT"
    fieldLength="20"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-TAX.CURRENCY"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-TAX.DATE"
    fieldLength="20"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-MOD.CHQ.NO"
    fieldLength="12"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-MOD.CHQ.TYPE"
    fieldLength="12"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-MOD.DATE"
    fieldLength="12"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="XX-CHEQUE.VAL.TIME"
    fieldLength="12"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX>STOP.CHEQUE.VAL"
    fieldLength="12"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="USER"
    fieldLength="25"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PS.TYPE.NAME.ARCIB"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="NCF.REQUIRED"
    fieldLength="3"
    fieldType=""
    fieldType<2>="YES_NO"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="NCF.NUMBER"
    fieldLength="19"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="NCF.TAX.NUM"
    fieldLength="19"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    CALL Table.addReservedField('RESERVED.5')
    CALL Table.addReservedField('RESERVED.6')
    CALL Table.addReservedField('RESERVED.7')
    CALL Table.addReservedField('RESERVED.8')
    CALL Table.addReservedField('RESERVED.9')
    CALL Table.addReservedField('RESERVED.10')
    CALL Table.addReservedField('RESERVED.11')
    CALL Table.addReservedField('RESERVED.12')
    CALL Table.addReservedField('RESERVED.13')
    CALL Table.addReservedField('RESERVED.14')
    CALL Table.addReservedField('RESERVED.15')
    CALL Table.addReservedField('RESERVED.16')
    CALL Table.addReservedField('RESERVED.17')
    CALL Table.addReservedField('RESERVED.18')
    CALL Table.addReservedField('RESERVED.19')
    CALL Table.addReservedField('RESERVED.20')
    CALL Table.addReservedField('RESERVED.21')
    CALL Table.addReservedField('RESERVED.22')
    CALL Table.addReservedField('RESERVED.23')
    CALL Table.addReservedField('RESERVED.24')
    CALL Table.addOverrideField
*    CALL Table.addLocalReferenceField('XX.LOCAL.REF')
*----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*----------------------------------------------------------------------------
RETURN
*----------------------------------------------------------------------------
END
