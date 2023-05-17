*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.H.CUST.WRITE.PROV.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.H.CUSTOMER.PROVISION *
* @author crajkumar@contractor.temenos.com
* @stereotype fields template
* Reference :ODR-2010-09-0167
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 01/02/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
*    Date             Author         Reference          Description
* 22-Sep-2010      A C Rajkumar   ODR-2010-09-0167    Initial creation
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*    CALL Table.defineId("TABLE.NAME.ID",T24_String)         ;* Define Table id

  ID.F = "@ID"
  ID.N = "20"
  ID.T = "A"
*------------------------------------------------------------------------------
  fieldName = 'XX<SC.PORTFOLIO.ID'
  fieldLength = '20'
  fieldType = ''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('SEC.ACC.MASTER')

  fieldName = 'XX-XX<SECURITY.NO'
  fieldLength = '20'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('SECURITY.MASTER')

  fieldName = 'XX-XX-SC.PROV.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-XX-SC.PROV.TIME'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


  fieldName = 'XX-XX-SC.NOMINAL'
  fieldLength = '18'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-XX-SC.INTEREST'
  fieldLength = '18'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


  fieldName = 'XX-XX-SC.CAP.PROV'
  fieldLength = '18'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX>XX>SC.INT.PROV'
  fieldLength = '18'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;


  fieldName = 'XX.SEC.TRADE.ID'
  fieldLength = '20'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('SEC.TRADE')

  fieldName = 'XX<MM.CONT.ID'
  fieldLength = '20'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile('MM.MONEY.MARKET')

  fieldName = 'XX-XX<MM.PORTFOLIO.ID'
  fieldLength = '20'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-XX-MM.PROV.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-XX-MM.PROV.TIME'
  fieldLength = '10'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-XX-MM.PRINCIPAL'
  fieldLength = '18'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-XX-MM.INTEREST'
  fieldLength = '18'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX-XX-MM.CAP.PROV'
  fieldLength = '18'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX>XX>MM.INT.PROV'
  fieldLength = '18'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'TOT.CAP.PROV'
  fieldLength = '18'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'TOT.INT.PROV'
  fieldLength = '18'
  fieldType = 'AMT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'REC.DATE'
  fieldLength = '10'
  fieldType = 'D'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'LOCAL.REF'
  fieldLength = '35'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
