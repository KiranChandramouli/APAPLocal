SUBROUTINE REDO.STO.OVERRIDE.PARAM.FIELDS
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
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F = '@ID' ; ID.N = '6' ; ID.T = '' ; ID.T<2> = 'SYSTEM'
*-----------------------------------------------------------------------------
    fieldName ='XX<OVERRIDE.ID'
    fieldLength ='35.1'
    fieldType ='A'
    neighbour =''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("OVERRIDE")

    fieldName='XX>XX.MESSAGE'
    fieldLength='65'
    fieldType='A':@FM:'':@FM:'NOINPUT'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
