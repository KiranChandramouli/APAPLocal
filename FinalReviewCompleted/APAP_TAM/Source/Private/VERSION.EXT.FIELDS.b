* @ValidationCode : MjotMzA1ODgzMDM5OkNwMTI1MjoxNjg0ODQyMTU3MjU2OklUU1M6LTE6LTE6LTE2OjE6dHJ1ZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -16
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
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
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*19-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*19-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------
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
