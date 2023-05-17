SUBROUTINE REDO.CARD.NO.LOCK.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.NO.LOCK.FIELDS
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
    fieldName = 'XX-CARD.NUMBER'  ; fieldLength = '35'   ; fieldType = ''  ;  GOSUB ADD.FIELDS
    V = Table.currentFieldPosition

RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field
RETURN
*----------------------------------------------------------------------------
END
