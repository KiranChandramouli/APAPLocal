SUBROUTINE REDO.H.REVALUATION.PARAM.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*
* 31/03/09 - Swathi K
*            New Development
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

    GOSUB DEFINE.PARAMETERS
RETURN

*-----------------------------------------------------------------------------
DEFINE.PARAMETERS:

* ID definition
    CALL Table.defineId("@ID", T24_String)
    ID.T = 'COM' ; ID.N = '11' ; CALL Field.setCheckFile("COMPANY")

* Normal fields
    neighbour = '' ;
    fieldName = 'DESCRIPTION' ; fieldLength = '35' ; fieldType = 'A' ; GOSUB ADD.FIELDS
    fieldName = 'XX<REV.PL.CATEGORY' ; fieldLength = '6.1' ; fieldType = 'CAT' ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile("CATEGORY")
    fieldName = 'XX-XX<START.PRD.RANGE' ; fieldLength = '6.1' ; fieldType = 'CAT' ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile("CATEGORY")
    fieldName = 'XX-XX-END.PRD.RANGE' ; fieldLength = '6.1' ; fieldType = 'CAT' ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile("CATEGORY")
    fieldName = 'XX>XX>PL.CATEGORY'   ; fieldLength = '6.1' ; fieldType = 'CAT' ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile("CATEGORY")
    fieldName = 'ENTRY.SYSTEM.ID'  ; fieldLength = '4' ; fieldType = 'A'    ; GOSUB ADD.FIELDS ; CALL Field.setCheckFile("EB.SYSTEM.ID")

* Reserved fields
    fieldName = 'RESERVED.6' ; fieldLength = '35' ; fieldType = 'A' ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.5' ; fieldLength = '35' ; fieldType = 'A' ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.4' ; fieldLength = '35' ; fieldType = 'A' ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.3' ; fieldLength = '35' ; fieldType = 'A' ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.2' ; fieldLength = '35' ; fieldType = 'A' ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.1' ; fieldLength = '35' ; fieldType = 'A' ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS

* Local reference field
    fieldName = 'XX.LOCAL.REF' ; fieldLength = '35' ; fieldType = 'A' ; args = '' ; GOSUB ADD.LOCAL.REF.FIELDS

* override field
    fieldName = 'XX.STMT.NOS' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

* override field
    fieldName = 'XX.OVERRIDE' ; fieldLength = '35' ; fieldType = 'A' ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

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
