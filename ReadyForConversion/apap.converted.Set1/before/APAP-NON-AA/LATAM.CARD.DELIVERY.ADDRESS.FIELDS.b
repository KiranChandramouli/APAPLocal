*-----------------------------------------------------------------------------
* <Rating>-231</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE LATAM.CARD.DELIVERY.ADDRESS.FIELDS
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

  ID.F = '@ID' ; ID.N = '35' ; ID.T = '':FM:'1_2_3_4'

  neighbour = ''
  fieldName = 'XX.DESCRIPTION'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'DELIVERY.ADDRESS'
  fieldLength = '15'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  fieldName='RESERVED.20'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.19'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.18'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.17'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.16'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.15'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.14'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.13'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.12'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.11'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.10'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.9'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.8'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.7'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.6'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.5'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.4'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.3'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.2'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  fieldName='RESERVED.1'
  fieldLength='35'
  fieldType='A':FM:'':FM:'NOINPUT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour);

  neighbour = ''
  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A':FM:'':FM:'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType = 'A':FM:'':FM:'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
