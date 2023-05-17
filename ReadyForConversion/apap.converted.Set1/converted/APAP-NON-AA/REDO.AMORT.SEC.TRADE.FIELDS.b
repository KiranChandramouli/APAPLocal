SUBROUTINE REDO.AMORT.SEC.TRADE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.AMORT.SEC.TRADE
*
* @author rshankar@temenos.com
* @Live type template
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 03/12/2010 - ODR-2010-07-0081
*            New Template creation
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*-----------------------------------------------------------------------------
    CALL Table.defineId("APAP.AMORT.SEC.TRADE", T24_String) ;
*-----------------------------------------------------------------------------

    ID.F = '@ID' ; ID.N = '25'
    ID.T = 'A'

    fieldName   = "XX<BUY.TXN.REF"
    fieldLength = "16"
    fieldType   = "A"
    neighbour   = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = "XX-BUY.VALUE.DT"
    fieldLength = "11"
    fieldType   = "D"
    neighbour   = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = "XX-BUY.NOMINAL"
    fieldLength = "18"
    fieldType   = "A"
    neighbour   = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = "XX-BALANCE.NOMINAL"
    fieldLength = "18"
    fieldType   = "A"
    neighbour   = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = "XX-XX<SELL.TXN.REF"
    fieldLength = "16"
    fieldType   = "A"
    neighbour   = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = "XX-XX-SELL.VALUE.DT"
    fieldLength = "11"
    fieldType   = "D"
    neighbour   = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName   = "XX>XX>SELL.NOMINAL"
    fieldLength = "18"
    fieldType   = "A"
    neighbour   = ""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
