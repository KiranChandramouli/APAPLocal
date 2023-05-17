SUBROUTINE REDO.CARD.REQ.STATUS.FIELDS
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACI POPULAR DE AHORROS Y PRTAMOS
*Developed By      : TEMENOS APPLICATION MANAGEMENT
*Program   Name    : REDO.CARD.REQ.STATUS.FIELDS
*By                : Kavitha
*Initial Creation  : 3-Mar-2011
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*-----------------------------------------------------------------------------
    CALL Table.defineId("ID",T24_String)
*-----------------------------------------------------------------------------
* CALL Table.addField(fieldName, fieldType, args, neighbour)
* CALL Field.setCheckFile(fileName)

    CALL Table.addFieldDefinition("XX.LL.DESCRIPTION", "65.1", "A", "")
    CALL Table.addField("XX.LOCAL.REF", T24_String,"","")
    CALL Table.addField("XX.OVERRIDE", T24_String, Field_NoInput ,"")

* CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)
* CALL Field.setDefault(defaultValue)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
