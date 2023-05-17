SUBROUTINE REDO.VISION.PLUS.TXN.FIELDS
*<doc>
* Template for field definitions for the application REDO.VISION.PLUS.TXN
*
* @author: Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History
* ====================
* 04/17/2013 - Initial Version
*-----------------------------------------------------------------------------

*** <region name= Header>
*** <desc>Inserts and control logic</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID", T24_String) ;* Define Table id
    ID.T = 'A'
*-----------------------------------------------------------------------------

    neighbour   = ''
    fieldName   = 'CARDHOLDER.NUM'
    fieldLength = '20'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.CODE'
    fieldLength = '4'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.AMOUNT'
    fieldLength = '19'
    fieldType   = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'CASH.AMT'
    fieldLength = '19'
    fieldType   = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'CHEQUE.AMT'
    fieldLength = '19'
    fieldType   = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'ADV.PYMT.AMT'
    fieldLength = '19'
    fieldType   = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'POSTING.DATE'
    fieldLength = '8'
    fieldType   = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.AUTH'
    fieldLength = '10'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'CHANNEL'
    fieldLength = '15'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'TRANS.TYPE'
    fieldLength = '50'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'CUSTOMER'
    fieldLength = '20'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
* TODO Confirm
* CALL Field.setCheckFile("CUSTOMER")

    neighbour   = ''
    fieldName   = 'DEBIT.ACCT'
    fieldLength = '20'
    fieldType   = 'ACC'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
* TODO Confirm
* CALL Field.setCheckFile("ACCOUNT")

    neighbour   = ''
    fieldName   = 'TXN.REF'
    fieldLength = '40'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'CURRENCY'
    fieldLength = '3'
    fieldType   = 'CCY'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CURRENCY")

    neighbour   = ''
    fieldName   = 'BRANCH'
    fieldLength = '11'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("COMPANY")

    neighbour   = ''
    fieldName   = 'TERMINAL'
    fieldLength = '15'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour   = ''
    fieldName   = 'STATUS'
    fieldLength = '10'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* Fix for PACS00424073 [ACH Vision Plus Payment]

    neighbour   = ''
    fieldName   = 'REJ.ERR.MSG'
    fieldLength = '25'
    fieldType   = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* End of Fix

    CALL Table.addReservedField('XX-RESERVED.4')
    CALL Table.addReservedField('XX-RESERVED.3')
    CALL Table.addReservedField('XX-RESERVED.2')
    CALL Table.addReservedField('XX>RESERVED.1')

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Populate audit information

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
