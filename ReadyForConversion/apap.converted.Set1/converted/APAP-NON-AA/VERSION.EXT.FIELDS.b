SUBROUTINE VERSION.EXT.FIELDS
*-------------------------------------------------------------------------
*-------------------------------------------------------------------------
*DESCRIPTION:
*This routine is used to define generic parameter table for sunnel
*-------------------------------------------------------------------------
*Company   Name    : Asociacion Popular de Ahorros y Prestamos
*Developed By      : Ivan Roman Vera
*Program   Name    : VERSION.EXT.FIELDS
*-------------------------------------------------------------------------
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
* 01-19-2012        Ivan Roman       Version extension    Initial Creation
*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
*-------------------------------------------------------------------------
    ID.F="@ID"
    ID.N="65"
    ID.T="ANY"
*-------------------------------------------------------------------------
    fieldName="XX<FIELD.NAME"
    fieldLength="65"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="XX>XX.ROUTINE.NAME"
    fieldLength="65"
    fieldType="ANY"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="RESERVED.9"
    fieldLength="1"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="RESERVED.8"
    fieldLength="1"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="RESERVED.7"
    fieldLength="1"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="RESERVED.6"
    fieldLength="1"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="RESERVED.5"
    fieldLength="1"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="RESERVED.4"
    fieldLength="1"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="RESERVED.3"
    fieldLength="1"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="RESERVED.2"
    fieldLength="1"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

    fieldName="RESERVED.1"
    fieldLength="1"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

*-------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-------------------------------------------------------------------------
RETURN
*-------------------------------------------------------------------------
END
