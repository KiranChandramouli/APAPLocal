SUBROUTINE REDO.RATE.CHANGE.MESSAGE.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*
*   Date            Who                   Reference               Description
* 27 Dec 2011   H Ganesh                PACS00170056 - B.16      Initial Draft
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------


    ID.F = '@ID'
    ID.N = '6'
    ID.T = ''
    ID.T<2> = 'ARCIB_TELLER_EMAIL'

    fieldName='SUBJECT'
    fieldLength='60'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName='XX.MESSAGE.BODY'
    fieldLength='60'
    fieldType = 'TEXT'
    fieldType<7>='TEXT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.DATA.ORDER'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    virtualTableName='RATE.CHANGE.MSG'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

*CALL Table.addReservedField('RESERVED.10')
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

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
