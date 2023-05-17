SUBROUTINE REDO.L.NCF.ISSUE.FIELDS
*DESCRIPTION:
*------------
*This routine defines fields for the table REDO.L.NCF.ISSUE

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 23-FEB-2010       Ganesh.R       ODR-2009-12-0321    Initial Creation.*-----------------------------------------------------------------------------
* 12-DEC-2011       Prabhu         PACS00169426        Field length Modified
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
*-----------------------------------------------------------------------------
    ID.F="@ID"
    ID.N="8"
    ID.T=""
*-----------------------------------------------------------------------------
    fieldName="TXN.REFERENCE"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CUSTOMER"
    fieldLength="15"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="ACCOUNT"
    fieldLength="15"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CEDULE.ID"
    fieldLength="16"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="RNC.NUMBER"
    fieldLength="16"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="IDENDITY.TYPE"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="UNIQUE.ID.NUM"
    fieldLength="16"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PASSPORT"
    fieldLength="20"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="AMOUNT"
    fieldLength="20"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="DEAL.DATE"
    fieldLength="10"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CHARGE.AMOUNT"
    fieldLength="20"
    fieldType="AMT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="NCF.REQUIRED"
    fieldLength="8.1"
    fieldType="A"
    fieldType="":@FM:"Yes_No"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setDefault('Yes')

    fieldName="NCF"
    fieldLength="19"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX.OVERRIDE"
    fieldLength="35"
    fieldType<2>="A"
    fieldType<3>="NOINPUT"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
