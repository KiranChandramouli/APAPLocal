*-----------------------------------------------------------------------------
* <Rating>-3</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AZ.FUND.PARAM.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine YOURAPPLICATION.FIELDS
*
* @author tcoleman@temenos.com
* @stereotype fields template
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*01.11.2011  S.SUDHARSANAN    CR.18            INITIAL CREATION
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*CALL Table.defineId("REDO.AZ.FUND.PARAM", T24_String)       ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = '@ID'
  ID.N = '6'
  ID.T = ''
  ID.T<2> = 'SYSTEM'

  fieldName='XX<CURRENCY'
  fieldLength='3.1'
  fieldType='CCY'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CURRENCY')

  fieldName='XX-ACCT.NUMBER'
  fieldLength='25.1'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('ACCOUNT')

  fieldName='XX>TRANSACTION.CODE'
  fieldLength='3'
  fieldType=''
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('TELLER.TRANSACTION')

  fieldName='OFS.USER'
  fieldLength='16'
  fieldType='AA'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('USER')

  fieldName='ACL.LCY.ACCT'
  fieldLength='25.1'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('ACCOUNT')

  fieldName='ACL.FCY.ACCT'
  fieldLength='25.1'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('ACCOUNT')

  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
