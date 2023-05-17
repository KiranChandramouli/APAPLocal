SUBROUTINE REDO.L.REVAL.FCY.PROD.POS.FIELDS
*-----------------------------------------------------------------------------
* Modification History :
*
* 07/04/09 - Swathi K
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
    ID.T = 'A' ; ID.N = '20'

* Normal fields
    neighbour = '' ;
    fieldName = 'XX<PRODUCT.CODE' ; fieldLength = '6' ; fieldType = 'CAT' ; GOSUB ADD.FIELDS
    fieldName = 'XX-XX<CCY.POSITION' ; fieldLength = '3' ; fieldType = 'CCY' ; GOSUB ADD.FIELDS
    fieldName = 'XX-XX-USD.AMOUNT' ; fieldLength = '19' ; fieldType = 'AMT' ; GOSUB ADD.FIELDS
    fieldName = 'XX-XX>REV.PL.CATEG' ; fieldLength = '6' ; fieldType = 'CAT' ; GOSUB ADD.FIELDS
    fieldName = 'XX>ACCOUNT.OFFICER' ; fieldLength = '8' ; fieldType = '' ; GOSUB ADD.FIELDS

* Reserved fields
    fieldName = 'RESERVED.5' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.4' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.3' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.2' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS
    fieldName = 'RESERVED.1' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.RESERVED.FIELDS

* Local reference field
*fieldName = 'XX.LOCAL.REF' ; fieldLength = '35' ; fieldType = T24_String ; args = '' ; GOSUB ADD.LOCAL.REF.FIELDS

*override field
*fieldName = 'XX.STMT.NOS' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

*override field
*fieldName = 'XX.OVERRIDE' ; fieldLength = '35' ; fieldType = T24_String ; args = Field_NoInput ; GOSUB ADD.LOCAL.REF.FIELDS

*Audit fields
    GOSUB ADD.AUDIT.FIELDS

RETURN
*-----------------------------------------------------------------------------

ADD.FIELDS:
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
RETURN

ADD.RESERVED.FIELDS:
    CALL Table.addField(fieldName, fieldType, args, neighbour)
RETURN

*ADD.LOCAL.REF.FIELDS:
*CALL Table.addField(fieldName, fieldType, args, neighbour)
RETURN

ADD.AUDIT.FIELDS:
    CALL Table.setAuditPosition
RETURN
*-----------------------------------------------------------------------------

END
* End of Subroutine
