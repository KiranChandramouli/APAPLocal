SUBROUTINE REDO.H.APAP.PARAMETER.FIELDS

*----------------------------------------------------------------------------------------------------------------------
* Revision History
*----------------------------------------------------------------------------------------------------------------------
* Date           Developed By            Reference        Description
* 16/05/2013     Vignesh Kumaar M R                       Initial Version
*----------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

    GOSUB DEFINE.PARAMETERS
RETURN

*-----------------------------------------------------------------------------
DEFINE.PARAMETERS:

* ID definition
    CALL Table.defineId("RECORD.ID", T24_String)
    ID.T<1> = '' ; ID.T<2> = 'SYSTEM'

* Normal fields
    neighbour = '' ;
    fieldName = 'XX.INAO.OVR.CLS' ; fieldLength = '4' ; fieldType = 'ANY' ; GOSUB ADD.FIELDS

* Reserved fields

    fieldName = 'RESERVED.15' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.14' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.13' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.12' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.11' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.10' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.9' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.8' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.7' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.6' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.5' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.4' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.3' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.2' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.1' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS

*Local reference field
    fieldName = 'XX.LOCAL.REF' ; fieldLength = '35' ; fieldType = T24_String ; args = '' ; GOSUB ADD.LOCAL.REF.FIELDS

*Statement entry field
    fieldName = 'XX.STMT.NOS' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

*Override field
    fieldName = 'XX.OVERRIDE' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

*Audit fields
    GOSUB ADD.AUDIT.FIELDS

RETURN

*----------------------------------------------------------------------------------------------------------------------

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

*----------------------------------------------------------------------------------------------------------------------

END
* End of Subroutine
