SUBROUTINE REDO.LY.PROGAERO.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.LY.PROGAERO.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 03-12-2013     RMONDRAGON   ODR-2009-12-0276   INITIAL CREATION
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.LY.PROGAERO", T24_String)       ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '6'
    ID.T = 'A'

    fieldName='XX<PROGRAM.ID'
    fieldLength='7'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.LY.PROGRAM")

    fieldName='XX>AIRLINE.ID'
    fieldLength='6'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.LY.AEROCAT")

    fieldName='FILE.GEN.PATH'
    fieldLength='50'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
