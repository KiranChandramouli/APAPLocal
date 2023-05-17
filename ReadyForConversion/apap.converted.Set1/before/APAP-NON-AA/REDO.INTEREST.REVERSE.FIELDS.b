*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INTEREST.REVERSE.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.INTEREST.REVERSE.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.CLEARING.OUTWARD.FIELDS is an H type template
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            ----------
* 22 Sep 2010     Mudassir V            ODR-2010-09-0251         Initial Creation
* ------------------------------------------------------------------------
* <region name= Header>
* <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
* </region>
*-------------------------------------------------------------------------
*-------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '20'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
  neighbour = ''

  fieldName = 'ACCOUNT'             ; fieldLength = '10 '; fieldType = 'A'; GOSUB ADD.FIELDS
  fieldName = 'XX<DAY.NO'           ; fieldLength = '8'  ; fieldType = 'D'; GOSUB ADD.FIELDS
  fieldName = 'XX-AMOUNT.UTILISED'  ; fieldlength = '20' ; fieldType = 'A'; GOSUB ADD.FIELDS
  fieldName = 'XX>INT.ACCRUED'      ; fieldLength = '40' ; fieldType = 'A'; GOSUB ADD.FIELDS

  RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  RETURN
*-----------------------------------------------------------------------------
END
