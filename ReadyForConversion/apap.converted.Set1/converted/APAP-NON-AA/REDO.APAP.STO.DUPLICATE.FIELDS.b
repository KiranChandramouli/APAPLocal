SUBROUTINE REDO.APAP.STO.DUPLICATE.FIELDS
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
    ID.F = '@ID' ; ID.N = '35'
    ID.T = 'A'   ;
*-----------------------------------------------------------------------------


    fieldName   = 'ORIGIN.ACCT.NO'
    fieldLength = '20'
    fieldType = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'LOAN.ACCT.NO'
    fieldLength = '20'
    fieldType = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'STO.START.DATE'
    fieldLength = '8.1'
    fieldType   = 'D'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName   = 'CURRENT.END.DATE'
    fieldLength = '8.1'
    fieldType   = 'D'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'CURRENCY'
    fieldLength = '3'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('CURRENCY')

    fieldName   = 'CURRENT.AMOUNT.BAL'
    fieldLength = '15'
    fieldType   = 'AMT'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName   = 'NO.OF.BILL'
    fieldLength = '4'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'BILL.AMOUNT'
    fieldLength = '15'
    fieldType   = 'AMT'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'CURRENT.FREQUENCY'
    fieldLength = '35'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName   = 'PAYMENT.DETAILS'
    fieldLength = '35'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'COMPANY.NAME'
    fieldLength = '35'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'CONTRACT.NO'
    fieldLength = '35'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'CARD.DISP.NO'
    fieldLength = '35'
    fieldType   = 'ANY'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'VERSION.NAME'
    fieldLength = '60'
    fieldType   = 'ANY'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'ORIGIN.ACCT.CUST'
    fieldLength = '10'
    fieldType   = 'CUS'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'COMPANY.ID'
    fieldLength = '35'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'SIGNATORY'
    fieldLength = '35'
    fieldType   = 'CUS'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'MANDATE.STATUS'
    fieldLength = '35'
    fieldType   = 'AA'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'PAY.METHOD'
    fieldLength = '35'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'BENEFICIARY.ID'
    fieldLength = '35'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = 'TP.BILL.MSD'
    fieldLength = '35'
    fieldType   = 'A'
    neighbour   = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

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
