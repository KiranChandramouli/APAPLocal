SUBROUTINE REDO.LOAN.ACCOUNT.STATUS.FIELDS

*<doc>
* Template for field definitions routine REDO.LOAN.ACCOUNT.STATUS
*
* @author
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
*  DATE             WHO         REFERENCE         DESCRIPTION
* 17/8/2011      Ravikiran                          Creation
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>

    GOSUB INITIALISE

    GOSUB FIELD.DEFINITION

RETURN

INITIALISE:

    LOAN.STATUS = ""
    LOAN.STATUS = "L.LOAN.STATUS.1"
    CALL EB.LOOKUP.LIST(LOAN.STATUS)
    CHANGE @FM TO @VM IN LOAN.STATUS

RETURN

FIELD.DEFINITION:

    ID.F = 'LOAN.STATUS'
    ID.N = '35'
    ID.T = 'A'

    fieldName = 'CONSOL.KEY.VAL'
    fieldLength = '3'
    fieldType = 'A'
    neighbour = ''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    CALL Table.addField("RESERVED.5",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.4",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.3",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.2",  T24_String, Field_NoInput,"");
    CALL Table.addField("RESERVED.1",  T24_String, Field_NoInput,"");

    CALL Table.addOverrideField

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
