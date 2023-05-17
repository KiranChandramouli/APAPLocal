*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.STORE.SPOOL.ID.FIELDS
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Puneet Kammar (puneetkammar@contractor.temenos.com)
* Program Name  : REDO.STORE.SPOOL.ID.FIELDS
*-----------------------------------------------------------------------------
* Description : This application is linked to REDO.AA.NAB.HISTORY
*-----------------------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-09-0029      21-Nov-2011          Initial draft
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId('ID', T24_String)
*-----------------------------------------------------------------------------

  fieldName = 'SPOOL.ID'
  fieldLength = '20'
  fieldType = ''
  neighbour = ''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)

* CALL Table.setAuditPosition

  RETURN
*-----------------------------------------------------------------------------
END
