SUBROUTINE REDO.APAP.MORTGAGES.DETAIL.FIELDS
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.MORTGAGES.DETAIL.FIELDS
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 26/07/2010       JEEVA T              ODR-2009-10-0346        Initial Creation
*
*********************************************************************************************************


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes

*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
    fieldName='LOAN.ACCT.NO'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='ARR.ID'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='ACCT.NAME'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='XX.STATUS'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='MATURITY.DATE'
    fieldLength='35'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='OUTS.PRINCIPLE'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='LIEN.AMT'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='BAL.PRINCIPAL'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='XX<DEP.ACT.NO'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='XX-DEP.ACT.NAME'
    fieldLength='35'
    fieldType='A'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='XX-START.DATE'
    fieldLength='35'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='XX-END.DATE'
    fieldLength='35'
    fieldType='D'
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

    fieldName='XX>MATURITY.AMT'
    fieldLength='35'
    fieldType=''
    neighbour=''
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*-----------------------------------------------------------------------------
    CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
RETURN
*-----------------------------------------------------------------------------
END
