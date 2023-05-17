SUBROUTINE REDO.LY.AIR.FILEGEN.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine .FIELDS
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
* 15-10-2014     RMONDRAGON   ODR-2009-12-0276   INITIAL CREATION
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("REDO.LY.AIR.FILEGEN", T24_String)    ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '6'
    ID.T = 'A'

    fieldName='PROGRAM.ID'
    fieldLength='7'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("REDO.LY.PROGRAM")

    fieldName='PREV.PTS.SUB'
    fieldLength='3'
    fieldType=''
    neighbour=''
    fieldType<2>='NO_YES'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
