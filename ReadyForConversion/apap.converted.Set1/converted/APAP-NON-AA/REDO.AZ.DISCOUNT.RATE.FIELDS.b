SUBROUTINE REDO.AZ.DISCOUNT.RATE.FIELDS
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
*  15/06/2010       REKHA S            ODR-2009-10-0336 N.18      Initial Creation
* 11 MAR 2011       H GANESH            PACS00032973  - N.18     Modified as per issue

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("DEPOSIT.TYPE", T24_Numeric)          ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = "@ID" ; ID.N = "4" ; ID.CHECKFILE = 'CATEGORY'
*

    fieldName         = 'XX<DATE.RANGE'
    fieldLength       = '10.1'
    fieldType         = 'ANY'
    neighbour         = ''

    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*

    fieldName         = 'XX>PENAL.PERCENT'
    fieldLength       = '16.1'
    fieldType         = 'R'
    neighbour         = ''

    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;*Add a new field
*
    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

*
    fieldName         = 'XX.LOCAL.REF'
    fieldLength       = '35'
    fieldType<3>      = 'NOINPUT'
    neighbour         = ''

    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*
    fieldName         = 'XX.OVERRIDE'
    fieldLength       = '35'
    fieldType<3>      = 'NOINPUT'
    neighbour         = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
