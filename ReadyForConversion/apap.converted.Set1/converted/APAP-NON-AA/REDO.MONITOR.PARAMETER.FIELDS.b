SUBROUTINE REDO.MONITOR.PARAMETER.FIELDS
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
*DATE           WHO           REFERENCE         DESCRIPTION
*08.31.2010  V NAVA        ODR-2010-08-0005  INITIAL CREATION

*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = "@ID"
    ID.N = '40.1'
    ID.T = 'A'

    neighbour = ''
    fieldName = 'XX<VERSION.NAME'
    fieldLength = '54'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("VERSION")

    neighbour = ''
    fieldName = 'XX-XX<VER.MAP.REF'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("RAD.CONDUIT.LINEAR")

    neighbour = ''
    fieldName = 'XX-XX-VER.ACCOUNT.FIELD'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX>XX>VER.MAP.REF.PRE'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("RAD.CONDUIT.LINEAR")

    neighbour = ''
    fieldName = 'GEN.MAP.ENQ'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("RAD.CONDUIT.LINEAR")

    neighbour = ''
    fieldName = 'XX<ENQUIRY.NAME'
    fieldLength = '50'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("ENQUIRY":@FM: "FILE.NAME")

    neighbour = ''
    fieldName = 'XX-ENQ.CUSTOMER'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX-ENQ.ACCOUNT'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'XX>ENQ.MAP.REF'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("RAD.CONDUIT.LINEAR")

    neighbour = ''
    fieldName = 'XX.FIELD.NAME'
    fieldLength = '65'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'FIELD.MAP.REF'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    neighbour = ''
    fieldName = 'CUS.ACC.MAP'
    fieldLength = '30'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("RAD.CONDUIT.LINEAR")

*-------------------------------------------------------------------------------

    CALL Table.addField("RESERVED.20", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.19", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.18", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.17", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.16", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
    CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
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
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
