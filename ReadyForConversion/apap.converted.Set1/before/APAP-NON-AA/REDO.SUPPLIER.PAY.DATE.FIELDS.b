*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.SUPPLIER.PAY.DATE.FIELDS
*-----------------------------------------------------------------------------
*DESCRIPTION:
*This routine is used to define fields for REDO.FILE.DATE.PROCESS table
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.FILE.DATE.PROCESS.FIELDS
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
* 17-OCT-2010        Prabhu.N       ODR-2010-08-0031     Initial Creation
*-----------------------------------------------------------------------------
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.F="@ID"
  ID.N="8"
  ID.T="A"
*-----------------------------------------------------------------------------
  fieldName="PAYMENT.RECORD.ID"
  fieldLength="65"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
