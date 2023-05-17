SUBROUTINE REDO.EMPLOYEE.ACCOUNTS.FIELDS
*-----------------------------------------------------------------------------

* COMPANY NAME   : APAP
* DEVELOPED BY   : RAJA SAKTHIVEL K P
* PROGRAM NAME   : REDO.EMPLOYEE.ACCOUNTS.FIELDS
*-----------------------------------------------------------------------------
* Description : This is the field template definition routine to create the table
* 'REDO.EMPLOYEE.ACCOUNTS'
*-----------------------------------------------------------------------------
* Input/Output :
*-------------------------------------------------
* IN : NA
* OUT : NA
*--------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id

    ID.N = '25'
    ID.T = ''
    ID.CHECKFILE='CUSTOMER'

*-----------------------------------------------------------------------------
    fieldName="XX.ACCOUNT"
    fieldLength="19"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)
    CALL Field.setCheckFile('ACCOUNT')

    fieldName="USER.ID"
    fieldLength="35"
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

    fieldName="XX.REL.CUSTOMER"
    fieldLength="25"
    fieldType=""
    neighbour=""
    CALL Table.addFieldDefinition(fieldName,fieldLength,fieldType,neighbour)

*-----------------------------------------------------------------------------
*    CALL Table.setAuditPosition         ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
