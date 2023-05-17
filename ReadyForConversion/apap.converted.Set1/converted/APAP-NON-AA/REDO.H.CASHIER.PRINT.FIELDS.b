SUBROUTINE REDO.H.CASHIER.PRINT.FIELDS

*----------------------------------------------------------------------------------------------------------------------
* Revision History
*----------------------------------------------------------------------------------------------------------------------
* Date          Developed By          Reference        Description
* 31/07/2013    Vignesh Kumaar M R    PACS00305984     CASHIER DEAL SLIP PRINT OPTION
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

* ID definition
    CALL Table.defineId("RECORD.ID", T24_String)
    ID.T<1> = '' ; ID.T<2> = 'SYSTEM'

* Normal fields
    neighbour = '' ;
    fieldName = 'XX<VERSION.NAME' ; fieldLength = '54' ; fieldType = 'A' ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile('VERSION')
    fieldName = 'XX-XX.SLIP.ID' ; fieldLength = '15' ; fieldType = 'A' ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile('DEAL.SLIP.FORMAT')
    fieldName = 'XX-PRINT' ; fieldLength = '2' ; fieldType = '':@FM:'SI_NO' ; GOSUB ADD.FIELDS
    fieldName = 'XX-RESERVED.7' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'XX-RESERVED.6' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'XX>REPRINT' ; fieldLength = '2' ; fieldType = '':@FM:'SI_NO' ; GOSUB ADD.FIELDS

* Reserved fields

    fieldName = 'RESERVED.5' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.4' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.3' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.2' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.1' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS

* Local reference field

    fieldName = 'XX.LOCAL.REF' ; fieldLength = '35' ; fieldType = T24_String ; args = '' ; GOSUB ADD.LOCAL.REF.FIELDS

*override field

    fieldName = 'XX.STMT.NOS' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

*override field

    fieldName = 'XX.OVERRIDE' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

* Audit fields
    GOSUB ADD.AUDIT.FIELDS

RETURN
*-----------------------------------------------------------------------------

ADD.FIELDS:
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
RETURN

ADD.RESERVED.FIELDS:
    CALL Table.addField(fieldName, fieldType, args, neighbour)
RETURN

ADD.LOCAL.REF.FIELDS:
    CALL Table.addField(fieldName, fieldType, args, neighbour)
RETURN

ADD.AUDIT.FIELDS:
    CALL Table.setAuditPosition
RETURN

*-----------------------------------------------------------------------------

END
* End of Subroutine
