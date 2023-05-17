SUBROUTINE REDO.TEMP.FI.CONTROL.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This routine is used to define id and fields for the table REDO.TELLER.PROCESS
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
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 23-04-2010        Prabhu.N          N.78               Initial Creation
*------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    ID.F="@ID"
    ID.N="35"
    ID.T="A"
*-----------------------------------------------------------------------------

    fieldName  ="PARAM.VAL"
    fieldLength="10"
    fieldType  =""
    neighbour  =""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="STATUS"
    fieldLength="2"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="MAIL.MSG"
    fieldLength="65"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="RESP.MSG"
    fieldLength="65"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)



    fieldName="FT.REF"
    fieldLength="12"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="INTER.TYPE"
    fieldLength="12"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

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

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
