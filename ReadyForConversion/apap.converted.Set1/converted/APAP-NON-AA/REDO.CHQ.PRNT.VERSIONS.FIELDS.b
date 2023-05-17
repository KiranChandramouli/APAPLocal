SUBROUTINE REDO.CHQ.PRNT.VERSIONS.FIELDS
*-----------------------------------------------------------------------------
* @author rshankar@temenos.com
*-----------------------------------------------------------------------------
* Modification History :

*   DATE           WHO           REFERENCE         DESCRIPTION

* 08.03.2011  SHANKAR RAJU     ODR-2009-12-0285  INITIAL CREATION

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.VERSION

*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------

    ID.F = "@ID"
    ID.N = '9'
    ID.T = '':@FM:'SYSTEM'

    neighbour = ''
    fieldName = 'XX.VERSIONS'
    fieldLength = '60'
    fieldType = 'A'
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("VERSION":@FM:EB.VER.DESCRIPTION)

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
