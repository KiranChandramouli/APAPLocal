*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-26</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ISSUE.DEPT.CODE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
* Template for field definitions routine REDO.ISSUE.DEPT.CODE.FIELDS
* @author ganeshr@temenos.com
* @stereotype fields template
* Reference : ODR-2010-01-0213
* @uses Table
* @public Table Creation
* @package infra.eb
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 04/01/10 - EN_10003543
*            New Template changes
*-----------------------------------------------------------------------------
* Date             Author             Reference         Description
* 04-May-2010      Chandra Prakash T  ODR-2010-01-0213  Initial creation
* 22/08/2011       Bharath G          PACS00100502      New field added to capture Internal Acct
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
*   CALL Table.defineId("TABLE.NAME.ID", T24_String)        ;* Define Table id
  ID.F = 'ISSUE.DEPT.ID'
  ID.N = '3.1'
  ID.T = 'A'
*------------------------------------------------------------------------------
  fieldName = 'ISSUE.DEPT.NAME'
  fieldLength = '35'
  fieldType = 'A'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

* PACS00100502 - S

* CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
  fieldName = 'DEPT.ACCT.NO'
  fieldLength = '15'
  fieldType = 'INT'
  neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;
  CALL Field.setCheckFile("ACCOUNT")

* PACS00100502 - E

  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A'
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  fieldName = 'STMT.NOS'
  fieldLength = '35'
  fieldType = "":FM:"":FM:"NOINPUT"
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
