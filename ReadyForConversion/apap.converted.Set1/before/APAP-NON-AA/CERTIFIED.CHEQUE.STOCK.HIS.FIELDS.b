*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE CERTIFIED.CHEQUE.STOCK.HIS.FIELDS
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
* Modification History :
*
*  DATE             WHO                REFERENCE         DESCRIPTION
* 09-03-2010      SUDHARSANAN S       ODR-2009-10-0319  INITIAL CREATION
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  ID.F = 'CHEQUE.NO' ; ID.N = '15'
  ID.T = 'A'   ;
*------------------------------------------------------------------------------
  table = 'STATUS'
  fieldName='STATUS'
  fieldLength='16'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldWithEbLookup(fieldName, table, neighbour)
  CALL Field.setDefault('AVAILABLE')

  fieldName='AMOUNT'
  fieldLength='15'
  fieldType='AMT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='DATE'
  fieldLength='8'
  fieldType='D'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='TRANS.REF'
  fieldLength='18'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='ACCOUNT.NO'
  fieldLength='19'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  fieldName='USER'
  fieldLength='16'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("USER")

  fieldName='COMP.CODE'
  fieldLength='9'
  fieldType='A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("COMPANY")
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
