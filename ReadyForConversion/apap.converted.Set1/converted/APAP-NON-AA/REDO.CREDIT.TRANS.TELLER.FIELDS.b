SUBROUTINE REDO.CREDIT.TRANS.TELLER.FIELDS
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*DESCRIPTION:
*This routine is used to define fields for  REDO.CREDIT.TRANS.TELLER table
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.CREDIT.TRANS.TELLER.FIELDS
*-----------------------------------------------------------------------------
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
* 16-apr-2010        Prabhu.N       ODR-2009-10-0536     Initial Creation
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
    fieldName="XX.TRANSACTION.ID"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="DATE"
    fieldLength="8"
    fieldType="D"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="CREDIT.NO"
    fieldLength="8"
    fieldType="20"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

RETURN
END
