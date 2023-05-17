*-----------------------------------------------------------------------------
* <Rating>-18</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.ACCOUNT.ACT.FIELDS
*-------------------------------------------------------------------------
*********************************************************************************************************
* Company   Name    : APAP Bank
* Developed By      : Temenos Application Management
* Program   Name    : REDO.APAP.ACCOUNT.ACT.FIELDS
*--------------------------------------------------------------------------------------------------------
* Description       : REDO.APAP.ACCOUNT.ACT is an L type template; this template is used to record
*                    the details of effective discount rate and amount for the sec trades
*-------------------------------------------------------------------------
* Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20-Jun-2013      Arundev KR            PACS00293038            Initial creation
* 12-Feb-2014     V.P.Ashokkumar         PACS00309822            Added new field to capture curr no
*---------------------------------------------------------------------------------
*---------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_Table

*-------------------------------------------------------------------------

  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '8'    ; ID.T = 'A'

*-----------------------------------------------------------------------------

  neighbour = ''

  fieldName = 'XX-ACCT.NO'
  fieldLength = '25'
  fieldType = 'ANY'
  GOSUB ADD.FIELDS

  fieldName = "ACCT.DATE.CURR" ;  fieldLength = "30" ; fieldType = "ANY"
  GOSUB ADD.FIELDS

  CALL Table.addReservedField('RESERVED.9')
  CALL Table.addReservedField('RESERVED.8')
  CALL Table.addReservedField('RESERVED.7')
  CALL Table.addReservedField('RESERVED.6')
  CALL Table.addReservedField('RESERVED.5')
  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')

  V = Table.currentFieldPosition

  RETURN

*-------------------------------------------------------------------------
ADD.FIELDS:
*-------------------------------------------------------------------------

  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  RETURN

*-----------------------------------------------------------------------------
END
