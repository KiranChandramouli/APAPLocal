*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.CHARGES.FIELDS
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
* 19/10/07 - EN_10003543
*            New Template changes
*
* 14/11/07 - BG_100015736
*            Exclude routines that are not released
* Date             Who                 Reference           Description
* 24-NOV-2011      KAVITHA             PACS00164142        FIX
*--------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_METHODS.AND.PROPERTIES
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.CURRENCY
$INSERT I_F.CATEGORY
*-----------------------------------------------------------------------------

  GOSUB DEFINE.FIELDS
  RETURN

*======================================================================================================================
DEFINE.FIELDS:

  ID.F = '@ID' ; ID.N = '35' ; ID.T = 'A'

  neighbour = ''
  fieldName = 'ISSUE.DATE'
  fieldLength = '11'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'EXPIRY.DATE'
  fieldLength = '11'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'LAST.CHG.DATE'
  fieldLength = '11'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  neighbour = ''
  fieldName = 'ACCOUNT'
  fieldLength = '16.1'
  fieldType = 'ACC'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('ACCOUNT')

  neighbour = ''
  fieldName = 'CUSTOMER'
  fieldLength = '15'
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CUSTOMER')


  RETURN
*-----------------------------------------------------------------------------
END
