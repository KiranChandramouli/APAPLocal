*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.CUSTOMER.FIELDS
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
* 22/09/2010 - Changed to R9 standards
*--------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.CURRENCY
$INSERT I_F.CATEGORY
*-----------------------------------------------------------------------------


  ID.F = '@ID' ; ID.N = '35' ; ID.T = 'A'

  neighbour = ''
  fieldName = 'XX<CARD.NO'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX-XX<ACCOUNT.NO'
  fieldLength = '15'
  fieldType = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX-XX>ACCOUNT.TYPE'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX>EXPIRY.DATE'
  fieldLength = '11'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  RETURN
*-----------------------------------------------------------------------------
END
