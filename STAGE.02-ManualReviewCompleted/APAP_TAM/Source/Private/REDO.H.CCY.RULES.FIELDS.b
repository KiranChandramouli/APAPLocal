$PACKAGE APAP.TAM
SUBROUTINE REDO.H.CCY.RULES.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*  DATE           WHO                REFERENCE           MODIFICATION
* 19/05/2010    Naveenkumar N     ODR-2010-02-0290      Initial Creation
** 11-04-2023 R22 Auto Conversion no changes
** 11-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*------------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '3'
    ID.T = 'A'   ; ID.CHECKFILE='CURRENCY'
*------------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'FWD.DAYS'
    fieldLength = '5'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'AMOUNT'
    fieldLength = '20'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    neighbour = ''
    fieldName = 'OPERAND'
    fieldLength = '3'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
*
    CALL Table.setAuditPosition ;* Poputale audit information
*
RETURN
END
