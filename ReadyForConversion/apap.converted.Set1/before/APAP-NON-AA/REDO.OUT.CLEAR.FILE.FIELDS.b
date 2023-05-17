*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-12</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.OUT.CLEAR.FILE.FIELDS
*-------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.OUT.CLEAR.FILE.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.OUT.CLEAR.FILE.FIELDS is an H type template
*</doc>
*-------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Descript
*   ------         ------               -------------            --------- -
* 24 Nov 2010     Sriraman.C            ODR-2010-09-0251         Initial Creation
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
  ID.N = '8'    ; ID.T = 'D'
*-----------------------------------------------------------------------------
  neighbour = ''

  fieldName = 'XX<CLEARING.OUT.ID'           ; fieldLength = '2' ; fieldType = ''; GOSUB ADD.FIELDS

  fieldName = 'XX>TFS.ID'  ; fieldlength = '20' ; fieldType = 'A'; GOSUB ADD.FIELDS

  RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  RETURN
*-----------------------------------------------------------------------------
END
