* @ValidationCode : MjotMTM5MTc0OTc1MTpDcDEyNTI6MTY4MTI4MzkzNjYwOTpJVFNTOi0xOi0xOi0zOjE6dHJ1ZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:48:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -3
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
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
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
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
