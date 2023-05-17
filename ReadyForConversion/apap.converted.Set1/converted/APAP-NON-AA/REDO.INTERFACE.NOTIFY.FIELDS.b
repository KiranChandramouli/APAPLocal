SUBROUTINE REDO.INTERFACE.NOTIFY.FIELDS
*-----------------------------------------------------------------------------
* <doc>
*
* This table is used to store all the events in the interface activity
*
* author: rshankar@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 26/07/2010 - C.22 New Template Creation
* 28/07/2010 - C.22 Added ID.INTERFACE field(Sakthi S)
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("@ID", T24_String)        ;* Define Table id

    ID.F = '@ID'
    ID.N = '6'
    ID.T = 'A'
    ID.CHECKFILE = 'REDO.INTERFACE.PARAM'
*-----------------------------------------------------------------------------
*
    fieldName="ID.INTERFACE"
    fieldLength="3"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*
    fieldName="XX<DEST.NAME"
    fieldLength="35"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX>XX.DEST.ADDRESS"
    fieldLength="50"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Populate audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
