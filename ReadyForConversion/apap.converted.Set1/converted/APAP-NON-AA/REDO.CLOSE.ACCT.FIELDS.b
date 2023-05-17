SUBROUTINE REDO.CLOSE.ACCT.FIELDS
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
* 28/07/2011 - PACS00089082 - field property changed for DIR.PATH
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id

    ID.F = '@ID'
    ID.N = '35'
    ID.T = 'A'
*-----------------------------------------------------------------------------

    fieldName="LIQ.ACCOUNT"
    fieldLength="35.3"          ;* C.21
    fieldType="A"
    neighbour=""
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

    fieldName="CUST"
    fieldLength="30"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


    fieldName="PRODUCT"
    fieldLength="40"
    fieldType="A"
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
RETURN

END
