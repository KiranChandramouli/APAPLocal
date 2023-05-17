*-----------------------------------------------------------------------------
* <Rating>-13</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.RENEWAL.FIELDS
*-----------------------------------------------------------------------------
*<doc>
******************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.RENEWAL.FIELDS
*-----------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CARD.GENERATION
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 22 Jul 2010    Mohammed Anies K      ODR-2010-03-0400        Initial Creation
* 27 MAY 2011    KAVITHA               PACS00063156            PACS00063156 FIX
*10 JUN 2011     KAVITHA               PACS00063138            PACS00063138 FIX
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_DataTypes
$INSERT I_Table

*** </region>
*-----------------------------------------------------------------------------
  CALL Table.defineId("@ID", T24_String)          ;* Define Table id
  ID.N = '35'    ; ID.T = 'A'
  ID.CHECKFILE = ''
*-----------------------------------------------------------------------------
  neighbour = ''

* PACS00063156 -S
*PACS00063138 -S
  fieldName = 'XX<PREV.CARD.NO'          ; fieldLength = '25'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
  fieldName = 'XX-NEXT.CARD.NO'          ; fieldLength = '25'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
  fieldName = 'XX-TYPE.OF.CARD'          ; fieldLength = '25'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
  fieldName = 'XX-EXPIRY.DATE'           ; fieldLength = '8'    ; fieldType = 'D'  ;  GOSUB ADD.FIELDS
  fieldName = 'XX-STATUS'                ; fieldLength = '10'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
  fieldName = 'XX-ISSUE.TYPE'            ; fieldLength = '25'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
  fieldName = 'XX>AUTO.RENEW'            ; fieldLength = '10'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS

*PACS00063156 -E
*PACS00063138 -E

  RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
  CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

  V = Table.currentFieldPosition

  RETURN
*-----------------------------------------------------------------------------
END
