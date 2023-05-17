*-----------------------------------------------------------------------------
* <Rating>-18</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.DISB.CHAIN.FIELDS

*
* Subroutine Type : TEMPLATE.FIELDS
* Attached to     : TEMPLATE REDO.DISB.CHAIN
* Attached as     :
* Primary Purpose : Define the fields to table REDO.DISB.CHAIN
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
*
*
* Error Variables:
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Meza William - TAM Latin America
* Date            : 10 Agosto 2011
*
* Date            : 28-Nov-2012   - Marimuthu S     - PACS00236823
*-----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*************************************************************************

    CALL Table.defineId("@ID", T24_String)        ;* Define Table id

    neighbour = ''
    fieldName = 'ARRANGEMENT.ID'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'DISBURSE.SEQ'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'USER.ID'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'BRANCH.ID'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'DATE'
    fieldLength = '8'
    fieldType = 'D'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'RCA.ID'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX<FT.TEMP.REF'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX-TRANSACTION.ID'
    fieldLength = '16'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX-FTTC'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX-CURRENCY'
    fieldLength = '3'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX-AMOUNT'
    fieldLength = '15'
    fieldType = 'AMT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX-TEMP.VERSION'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX-VERSION'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'XX>TR.STATUS'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    neighbour = ''
    fieldName = 'DISB.STATUS'
    fieldLength = '2.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    fieldName = 'XX.ACCOUNT'
    fieldLength = '35'
    fieldType = 'ACC'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;*
    CALL Field.setCheckFile("ACCOUNT")


    fieldName = 'XX.CUSTOMER'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;*

    neighbour = ''
    fieldName = 'XX.RPD.ID'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;* Add a new field

    CALL Table.addReservedField('RESERVED.2')
    CALL Table.addReservedField('RESERVED.1')

*----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information

    RETURN
END
