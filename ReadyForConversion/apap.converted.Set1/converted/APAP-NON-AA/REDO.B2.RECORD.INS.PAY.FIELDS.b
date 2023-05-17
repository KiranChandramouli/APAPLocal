SUBROUTINE REDO.B2.RECORD.INS.PAY.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.B2.FT.PARAMETERS.FIELDS *
* @author ejijon@temenos.com
* @stereotype fields template
* @uses Table
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*------------------------
*
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'

*------------------------------------------------------------------------------
*
*

    fieldName = 'XX<DATES'
    fieldLength = '20'
    fieldType = 'D'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName = 'XX.XX>FT.IDS'
    fieldLength = '35'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
*
    CALL Table.addReservedField("RESERVED.1")


*
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
