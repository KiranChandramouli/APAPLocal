SUBROUTINE AI.REDO.LIST.CRM.PRODUCTS.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*  DATE             WHO         REFERENCE         DESCRIPTION
* 08-Apr-2011   H GANESH        PACS00032454    INITIAL CREATION
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
*CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F='@ID'
    ID.N='35'
    ID.T='A'

    fieldName='XX.DESCRIPTION'
    fieldLength='65'
    fieldType='ANY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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

    CALL Table.addLocalReferenceField('XX.LOCAL.REF')

    CALL Table.addOverrideField

    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
