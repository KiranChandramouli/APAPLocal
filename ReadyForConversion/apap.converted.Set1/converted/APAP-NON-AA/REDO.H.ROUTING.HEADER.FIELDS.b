SUBROUTINE REDO.H.ROUTING.HEADER.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to define id and fields for the table AI.REDO.ARCIB.PARAMETER
*------------------------------------------------------------------------------------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------



    ID.F = '@ID'
    ID.N = '7'
    ID.T = ''
    ID.T<1> = ""
    ID.T<2> = "SYSTEM"
*-----------------------------------------------------------------------------


    fieldName="XX<INW.CCY.TYPE"
    fieldLength="3"
    neighbour=''
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CURRENCY")

    fieldName="XX-INW.DOC.TYPE"
    fieldLength="65"
    neighbour=''
    fieldType="A"
    virtualTableName='RT.DOCUMENT.TYPE'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)


    fieldName="XX>INW.CAT.VAL"
    fieldLength="4"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="XX<OUT.CCY.TYPE"
    fieldLength="3"
    neighbour=''
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile("CURRENCY")

    fieldName="XX-OUT.DOC.TYPE"
    neighbour=''
    virtualTableName='RT.DOCUMENT.TYPE'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName="XX>OUT.CAT.VAL"
    fieldLength="4"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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

    fieldName ="XX.OVERRIDE"
    fieldLength ="35"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
