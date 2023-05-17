SUBROUTINE REDO.CUST.PRD.LIST.FIELDS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*DESCRIPTION:
*This template is used to create local table which holds all the product id and
*product status ,CUSTOMER TYPE for each product information with customer id as id
*
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
* 27-DEC-2009        Prabhu.N       ODR-2009-10-0535     Initial Creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------

*    CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
    ID.F="@ID"
    ID.N="35.1"
    ID.T="A"
*-----------------------------------------------------------------------------
    fieldName="XX<PRODUCT.ID"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="XX-PRD.STATUS"
    fieldLength="35"
    fieldType="A"

    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="XX-TYPE.OF.CUST"
    fieldLength="35"
    fieldType="A"

    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="XX>DATE"
    fieldLength="8"
    fieldType="D"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="PROCESS.DATE"
    fieldLength="8"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*    CALL Table.setAuditPosition

*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
