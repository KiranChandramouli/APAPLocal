SUBROUTINE REDO.APAP.CPH.PARAMETER.FIELDS
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CPH.PARAMETER.FIELDS
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 26/07/2010       JEEVA T              ODR-2009-10-0346        Initial Creation
* 28-APR-2011      H GANESH           CR009              Change the Vetting value of local field
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
    $INSERT I_F.CATEGORY

*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '35'    ; ID.T = '':@FM:'SYSTEM'
*-----------------------------------------------------------------------------
    fieldName='XX.CPH.CATEGORY'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('CATEGORY')

    fieldName='XX.MG.CATEGORY'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    CALL Field.setCheckFile('CATEGORY')

    fieldName='EXCESS.PERCENTAGE'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='NO.OF.RENEWALS'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='XX.ALLOWED.STATUS'
    fieldLength='30'
    fieldType=''
*fieldType<2>='Judicial Collection_Restructured_Write-off'
    neighbour=''
*CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
    virtualTableName='L.LOAN.STATUS.1'
    CALL Table.addFieldWithEbLookup(fieldName,virtualTableName,neighbour)

    fieldName='CHARGE.PROP.NAME'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
