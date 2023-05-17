SUBROUTINE REDO.CARD.REG.STOCK.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.REG.STOCK.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.CARD.REG.STOCK
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 17 SEP 2010    Swaminathan.S.R       ODR-2010-03-0400         Initial Creation
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
    ID.N = '20'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
    neighbour = ''
*    fieldName = 'SERIES.ID'             ; fieldLength = '30'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
*    fieldName = 'XX-SER.START.NO'       ; fieldLength = '20'   ; fieldType = ""   ;  GOSUB ADD.FIELDS
    fieldName = 'SERIES.BAL'            ; fieldLength = '20'   ; fieldType = ""   ;  GOSUB ADD.FIELDS

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
