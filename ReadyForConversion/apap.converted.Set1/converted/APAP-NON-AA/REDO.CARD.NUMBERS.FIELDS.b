SUBROUTINE REDO.CARD.NUMBERS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.NUMBERS.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CARD.NUMBERS
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 JUL 2010    Mohammed Anies K       ODR-2010-03-0400         Initial Creation
* 9  Mar 2011    Balagurunathan B       ODR-2010-03-0400         Updating common variable V
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
    ID.N = '25'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'XX<CARD.NUMBER'  ; fieldLength = '35'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-STATUS'       ; fieldLength = '15'   ; fieldType = "A":@FM:"AVAILBLE_INUSE_DESTROY"  ;  GOSUB ADD.FIELDS
* Below Two fields are added as a part of C.15
    fieldName = 'XX-EMBOSS.TYPE'  ; fieldLength = '25'   ; fieldType = "A"  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-PERSONAL.TYPE'; fieldLength = '25'   ; fieldType = "A"  ;  GOSUB ADD.FIELDS
* Below fields added to defalt expiry date and type of card in Latam.card.order
    fieldName = 'XX-TYPE.OF.CARD' ; fieldLength = '25'   ; fieldType = "A"  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-CRD.REQ.ID' ; fieldLength = '25'   ; fieldType = "A"  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-EXPIRY.DATE' ; fieldLength = '10'   ; fieldType = "D"  ;  GOSUB ADD.FIELDS
    fieldName = 'XX>GEN.DATE' ; fieldLength = '10'   ; fieldType = "D"  ;  GOSUB ADD.FIELDS
*PACS00037281 end
    V = Table.currentFieldPosition
*PACS00037281 end
RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*----------------------------------------------------------------------------
END
