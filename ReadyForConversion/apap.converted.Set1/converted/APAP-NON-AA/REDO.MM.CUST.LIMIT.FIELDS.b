SUBROUTINE REDO.MM.CUST.LIMIT.FIELDS
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CPH.PARAMETER.FIELDS
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* * 20-Jan-2012   BALAGURUNATHAN
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes


*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '20'
    ID.CHECKFILE='CUSTOMER'
*-----------------------------------------------------------------------------
    fieldName='XX.LIMIT.ID'
    fieldLength='35.1'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('LIMIT')

    fieldName='XX.MAIL.ID'
    fieldLength='65.1'
    fieldType='ANY'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
