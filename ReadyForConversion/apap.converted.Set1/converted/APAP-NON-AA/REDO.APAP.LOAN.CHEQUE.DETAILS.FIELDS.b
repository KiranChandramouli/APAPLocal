SUBROUTINE REDO.APAP.LOAN.CHEQUE.DETAILS.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.LOAN.CHEQUE.DETAILS.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.APAP.LOAN.CHEQUE.DETAILS
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 7th JUN 2010    Mohammed Anies K   ODR-2009-10-1678 B.10      Initial Creation
* ----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_DataTypes
*** </region>
*-----------------------------------------------------------------------------
    CALL Table.defineId("@ID", T24_String)          ;* Define Table id
    ID.N = '35'    ; ID.T = 'A'
*-----------------------------------------------------------------------------
    neighbour = ''
    fieldName = 'XX<TRANS.REF'           ; fieldLength = '35'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX<CHQ.NO'           ; fieldLength = '35'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-IN.TRANSIT.DAYS'  ; fieldLength = '35'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-TRANSIT.RELEASE'  ; fieldLength = '35'   ; fieldType = 'D'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-CHQ.RET.COUNT'    ; fieldLength = '35'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-CHQ.RET.DATE'     ; fieldLength = '35'   ; fieldType = 'D'  ;  GOSUB ADD.FIELDS
    fieldName = 'XX-XX-CHQ.RET.AMT'      ; fieldLength = '35'   ; fieldType = ''   ;  GOSUB ADD.FIELDS
    fieldName = 'XX>XX>CHQ.STATUS'       ; fieldLength = '10'   ; fieldType = "":@FM:"REATAINED_DROPPED"  ;  GOSUB ADD.FIELDS

RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*----------------------------------------------------------------------------
END
