SUBROUTINE REDO.H.ROUTING.NUMBER.FIELDS
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
*-----------------------
*  DATE             WHO          REFERENCE         DESCRIPTION
* 29-05-2010     Marimuthu       ODR-2010-02-0290  Initial Creation
*18-11-2010      Ganesh R        ODR-2010-09-0251  Corrected the field names and added Reserve Fields
* ----------------------------------------------------------------------------
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.H.ROUTING.NUMBER.FIELDS", T24_String)     ;* Define Table id
    ID.F = '@ID'
    ID.N = '9'
    ID.T = 'ANY'
*-----------------------------------------------------------------------------
*    CALL Field.setCheckFile(fileName)        ;* Use DEFAULT.ENRICH from SS or just field 1

    fieldName = 'BANK.NAME'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'BANK.CODE'
    fieldLength = '10'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'APAP'
    fieldLength = '3'
    fieldType<1> = ''
    fieldType<2> = 'YES_NO'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName = 'ROUTING.NO'
    fieldLength = '9'
    fieldType<1> = ''
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'EXPOSURE.DAYS'
    fieldLength = '4'
    fieldType<1> = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addLocalReferenceField('XX.LOCAL.REF')
    CALL Table.addOverrideField

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

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
