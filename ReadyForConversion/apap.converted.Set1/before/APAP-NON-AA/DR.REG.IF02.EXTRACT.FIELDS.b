*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE DR.REG.IF02.EXTRACT.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Americas
*Program   Name    : DR.REG.IF02.EXTRACT.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template DR.REG.IF02.EXTRACT
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference
*   ------         ------               -------------
* 2 May 2013                            Initial Creation
* 15-Sep-2014     V.P.Ashokkumar      PACS00305219 - Added closed account record.
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '6'    ; ID.T = '':FM:'SYSTEM'
*-----------------------------------------------------------------------------
  neighbour = ''

  fieldName = 'XX.LL.DESCRIPTION'     ; fieldLength = '35'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
  fieldName = 'EXTRACT.PATH'          ; fieldLength = '60'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
  fieldName = 'CUSTOMER.NUMBER'       ; fieldLength = '10'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
  fieldName = 'ID.CARD.NUMBER'        ; fieldLength = '10'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
  fieldName = 'COMMUNC.NUMBER'        ; fieldLength = '7.1'    ; fieldType = ''                       ;  GOSUB ADD.FIELDS
  fieldName = 'XX.LL.COMMENT'         ; fieldLength = '65'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
  fieldName = 'COMMUNC.YEAR'          ; fieldLength = '4.1'    ; fieldType = ''                       ;  GOSUB ADD.FIELDS
  fieldName = 'XX<IF.FIELD.NAME'         ; fieldLength = '15'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
  fieldName = 'XX-XX<IF.FIELD.VALUE'        ; fieldLength = '20'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS
  fieldName = 'XX>XX>IF.DISPLAY.VALUE'      ; fieldLength = '35'     ; fieldType = 'A'                      ;  GOSUB ADD.FIELDS

  CALL Table.addReservedField('RESERVED.2')
  CALL Table.addReservedField('RESERVED.1')

  CALL Table.addLocalReferenceField('XX.LOCAL.REF')

  CALL Table.addOverrideField

  CALL Table.setAuditPosition ;* Poputale audit information

  RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  RETURN
*-----------------------------------------------------------------------------
END
