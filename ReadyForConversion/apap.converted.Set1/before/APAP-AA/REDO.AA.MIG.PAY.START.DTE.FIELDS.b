*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.AA.MIG.PAY.START.DTE.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AA.MIG.PAY.START.DTE.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.AA.MIG.PAY.START.DTE
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date            Who                  Reference                Description
*     ------         ------               -------------             -------------
*    27/05/2015    Ashokkumar.V.P         PACS00460183               Initial Release
*    25/06/2015    Ashokkumar.V.P         PACS00466046               Added to check the Account details
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.F = '@ID'
  ID.N = '17.1'
  ID.T = "ARR"
*------------------------------------------------------------------------------
  fieldName = 'FIRST.PAY.DATE'
  fieldLength = '11'
  fieldType = 'D'; neighbour=''
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour) ;

  CALL Table.addReservedField('RESERVED.8')
  CALL Table.addReservedField('RESERVED.7')
  CALL Table.addReservedField('RESERVED.6')
  CALL Table.addReservedField('RESERVED.5')
  CALL Table.addReservedField('RESERVED.4')
  CALL Table.addReservedField('RESERVED.3')
  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')

  CALL Table.setAuditPosition ;* Poputale audit information
  RETURN
END
