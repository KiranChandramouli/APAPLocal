*-----------------------------------------------------------------------------
* <Rating>-7</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BRANCH.INT.ACCT.PARAM.FIELDS
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
*
* Revision History:
*-----------------------------------------------------------------------------
*   Date               who             Reference            Description
* 02-05-2011          Bharath G       ODR-2010-08-0017      Initial Creation
* 09-09-2011          Marimuthu S     PACS00121111          Fields added for cheque type and account nos
* 12-04-2012          Marimuthu S     PACS00189769          Eb lookup def added
* 02-08-2012          Nandhini M      PACS00210703          Fields added for version and account nos
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
*-----------------------------------------------------------------------------
  ID.F = "@ID" ;     ID.N = '10'    ; ID.T = '':FM:'SYSTEM'

  fieldName="XX<COMPANY"
  fieldLength="10.1"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('COMPANY')

  fieldName="XX-XX<CURRENCY"
  fieldLength="3.1"
  fieldType="A"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('CURRENCY')

  fieldName="XX>XX>BRANCH.INT.ACCT"
  fieldLength="20.1"
  fieldType="INT"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('ACCOUNT')

** PACS00121111 -s

  virtualTableName = 'ADMIN.CHQ.TYPE'
  CALL EB.LOOKUP.LIST(virtualTableName)
  fieldName="XX<ADMIN.CHQ.TYPE"
  fieldLength="30.1"
  fieldType=virtualTableName
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour)

  fieldName="XX>ADMIN.CHQ.ACCOUNT"
  fieldLength="20.1"
  fieldType="ACC"
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour)
  CALL Field.setCheckFile('ACCOUNT')
** PACS00121111 -e

  fieldName="TREASURY.DEPT"
  fieldLength="3.1"
  fieldType=""
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour)
  CALL Field.setCheckFile('REDO.ISSUE.DEPT.CODE')


*CALL Table.addReservedField('RESERVED.8')
*    CALL Table.addReservedField('RESERVED.7')
*    CALL Table.addReservedField('RESERVED.6')

** PACS00210703
  fieldName="XX<VERSION.NAME"
  fieldLength="54"
  fieldType='A'
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour)


  fieldName="XX>INT.ACCOUNT"
  fieldLength="30"
  fieldType='A'
  neighbour=""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour)
  CALL Field.setCheckFile('ACCOUNT')
** PACS00210703

  fieldName = "XX<RELATION.START"
  fieldLength = "5"
  fieldType = ''
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour)
  CALL Field.setCheckFile('RELATION')

  fieldName = "XX>RELEATION.END"
  fieldLength = "5"
  fieldType = ''
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType,neighbour)
  CALL Field.setCheckFile('RELATION')

  fieldName = "INSUR.CHQ.ACCT"
  fieldLength = "20.1"
  fieldType = "INT"
  neighbour = ""
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile('ACCOUNT')

  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')
  CALL Table.addLocalReferenceField('XX.LOCAL.REF')

  CALL Table.addOverrideField

  CALL Table.setAuditPosition ;* Poputale audit information

  RETURN
*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
END
