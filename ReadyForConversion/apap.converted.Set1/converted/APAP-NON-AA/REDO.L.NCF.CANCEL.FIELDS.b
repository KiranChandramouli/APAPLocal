SUBROUTINE REDO.L.NCF.CANCEL.FIELDS
*DESCRIPTION:
*------------
*This routine defines fields for the table REDO.L.NCF.STATUS

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
* 23-FEB-2010       Ganesh.R       ODR-2009-10-0321    Initial Creation.*-----------------------------------------------------------------------------
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
    ID.N="8.1"
    ID.T=""
*-----------------------------------------------------------------------------
    fieldName="TRANSACTION.ID"
    fieldLength="16.1"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CUSTOMER.ID"
    fieldLength="10.1"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CANCEL.TYPE"
    fieldLength="32.1"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
    CALL Field.setCheckFile('REDO.L.NCF.CANCELLATION.TYPE')

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
