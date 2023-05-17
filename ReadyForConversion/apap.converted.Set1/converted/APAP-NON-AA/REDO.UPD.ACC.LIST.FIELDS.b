SUBROUTINE REDO.UPD.ACC.LIST.FIELDS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*DESCRIPTION:
*This routine is used to add account id field
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
* 27-DEC-2009        Prabhu.N       ODR-2009-10-0339     Initial Creation
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
* CALL Table.defineId("TABLE.NAME.ID", T24_String) ;* Define Table id
    ID.F="@ID"
    ID.N="35"
    ID.T="A"
*-----------------------------------------------------------------------------
    fieldName="ACCOUNT"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
RETURN
END
