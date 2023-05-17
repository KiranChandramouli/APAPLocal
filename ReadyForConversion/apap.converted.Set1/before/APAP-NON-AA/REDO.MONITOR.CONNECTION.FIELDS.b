*-----------------------------------------------------------------------------
* <Rating>-8</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.MONITOR.CONNECTION.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
* Modification History :
*DATE           WHO               REFERENCE          DESCRIPTION
*11.09.2010     C YEPEZ           ODR-2010-08-0005   INITIAL CREATION
*11.03.2019     Gopala Krishnan R   PACS00731205       Issue Fix by
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    dataType = ''
    dataType<2> = 16.1
    dataType<3> = ''
    dataType<3,2> = 'SYSTEM'

    CALL Table.defineId("@ID", dataType)          ;* Define Table id
*-----------------------------------------------------------------------------

*    ID.F = "@ID"
*    ID.N = '20'
*    ID.T = 'ANY'

    neighbour = ''
    fieldName = 'DESCRIPTION'
    fieldLength = '40'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'IP.ADDRESS'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'PORT.NUMBER'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'DATABASE.NAME'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'USER'
    fieldLength = '35.1'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'PASSWORD'
    fieldLength = '40.1'
    fieldType = 'PASSWD'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* PACS00731205 - S
    neighbour = ''
    fieldName = 'ORACLE.MODE'
    fieldLength = '1'
    fieldType<1> = ''
    fieldType<2> = 'Y'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
* PACS00731205 - E

*-------------------------------------------------------------------------------

*   CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")            ;*PACS00731205
    CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

*------------------------------------------------------------------------------

    neighbour = ''
    fieldName = 'XX.OVERRIDE'
    fieldLength = '35'
    fieldType<3> = 'NOINPUT'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
    RETURN
*-----------------------------------------------------------------------------
END


