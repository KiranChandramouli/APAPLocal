SUBROUTINE APAP.INDUSTRY.FIELDS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
*   CALL Table.defineId("@ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = '@ID'
    ID.N = '6'
    ID.T = 'A'

    neighbour = ''
    fieldName = 'XX.LL.DESCRIPTION'
    fieldLength = '200'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'HIGH.RISK'
    fieldLength = '3'
    fieldType = ''
    fieldType<2> = 'YES_NO'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'AA.CATEG'
    fieldLength = '4'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.CATEGORY.CIUU")

    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

    fieldName = 'XX.LOCAL.REF'
    fieldLength = '35'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.STMT.NO'
    fieldLength = '35'
    fieldType = 'A'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
