*-----------------------------------------------------------------------------
* <Rating>-5</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.ADMIN.CHQ.DETAILS.FIELDS
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
* Modification History :
*DATE           WHO             REFERENCE            DESCRIPTION
*08.04.2010   SHANKAR RAJU      ODR-2009-12-0285     INITIAL CREATION
*10.02.2011   ganesh R          HD1052250            Added another field WAIVE.CHG
* 09-05-2011  Bharath G         PACS00023918         The BENEFICIARY  field should be multivalue field
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID",T24_String)
  ID.N = '25'
  ID.T = ''

  neighbour = ''
  fieldName = 'CHEQUE.INT.ACCT'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*    CALL Field.setCheckFile("ACCOUNT")

  neighbour = ''
  fieldName = 'STATUS'
  fieldLength = '35'
  fieldType = ''
  fieldType<2>='ISSUED_PAID_CANCELLED_REINSTATED_STOP.PAID.CNFRM_STOP.PAID.NON.CNFRM_REISSUED_RECLASSIFY'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setDefault('ISSUED')

  neighbour = ''
  fieldName = 'AMOUNT'
  fieldLength = '35'
  fieldType = 'AMT'
  fieldType<2,2> = LCCY
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'ISSUE.ACCOUNT'
  fieldLength = '25'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("ACCOUNT")

  neighbour = ''
  fieldName = 'ISSUE.DATE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'CAN.REINST.STATUS'
  fieldLength = '25'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'CANCELLATION.DATE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'REINSTATED.DATE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'PAID.DATE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'STOP.PAID.DATE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'STOP.PAID.REASN'
  fieldLength = '35'
  fieldType = ''
  fieldType<2>='LOST_STOLEN_DAMAGED'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'RECLASSIFY.DATE'
  fieldLength = '8'
  fieldType = 'D'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'COMPANY.CODE'
  fieldLength = '15'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
  CALL Field.setCheckFile("COMPANY")

  neighbour = ''
  fieldName = 'XX.BENEFICIARY'          ;* PACS00023918
  fieldLength = '65'          ;* PACS00023918
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'TRANS.REFERENCE'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.USER'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.ADDITIONAL.INFO'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*********************
*HD1052250 Changes*
*********************
  neighbour = ''
  fieldName = 'WAIVE.CHG'
  fieldLength = '3'
  fieldType = ''
  fieldType<2> = 'YES_NO'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


*Added on 29/feb/2012
  neighbour = ''
  fieldName = 'CHQ.SEQ.NUM'
  fieldLength = '16'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)
*-------------------------------------------------------------------------------


  neighbour = ''
  fieldName = 'REV.STATUS'
  fieldLength = '25'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*   CALL Table.addField("RESERVED.19", T24_String, Field_NoInput,"")
*   CALL Table.addField("RESERVED.18", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.17", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.16", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.15", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.14", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.13", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.12", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.11", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.10", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.9", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.8", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.7", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.6", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.5", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.4", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.3", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.2", T24_String, Field_NoInput,"")
  CALL Table.addField("RESERVED.1", T24_String, Field_NoInput,"")

*------------------------------------------------------------------------------
  neighbour = ''
  fieldName = 'XX.LOCAL.REF'
  fieldLength = '35'
  fieldType = 'A'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

  neighbour = ''
  fieldName = 'XX.STMT.NO'
  fieldLength = '35'
  fieldType = 'A'
  fieldType<3>='NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)


  neighbour = ''
  fieldName = 'XX.OVERRIDE'
  fieldLength = '35'
  fieldType<3> = 'NOINPUT'
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

*-----------------------------------------------------------------------------
  CALL Table.setAuditPosition ;* Poputale audit information
*-----------------------------------------------------------------------------
  RETURN
*-----------------------------------------------------------------------------
END
