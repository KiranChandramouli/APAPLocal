*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CPH.DETAIL.FIELDS
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CPH.DETAIL.FIELDS
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
  fieldName='DEP.ACT.NO'
  fieldLength='35'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='DEP.ACT.NAME'
  fieldLength='35'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='START.DATE'
  fieldLength='8'
  fieldType='D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='END.DATE'
  fieldLength='8'
  fieldType='D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='PRINCIPAL'
  fieldLength='35'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='MATURITY.AMT'
  fieldLength='35'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='XX<LOAN.ACT.NO'
  fieldLength='35'
  fieldType=''
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='XX-ARR.ID'
  fieldLength='35'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='XX-ACT.NAME'
  fieldLength='35'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='XX-XX.STATUS'
  fieldLength='35'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName='XX>OUTS.PRINCIPAL'
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
