SUBROUTINE REDO.MULTI.TRANSACTION.DETAIL.FIELDS
*-----------------------------------------------------------------------------
*<doc>
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.MULTI.TRANSACTION.DETAIL.FIELDS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine is a .FIELDS routine for template REDO.MULTI.TRANSACTION.DETAIL
*
*</doc>
*-----------------------------------------------------------------------------
*Modification Details:
*=====================
*     Date              Who                 Reference                 Description
*    ------            ------              -------------             -------------
* 12th JULY 2010    Shiva Prasad Y      ODR-2009-10-0318 B.126      Initial Creation
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
    fieldName = 'ACCT.NUMBER'            ; fieldLength = '35'   ; fieldType = 'A'  ;  GOSUB ADD.FIELDS
    fieldName = 'TXN.DATE'               ; fieldLength = '35'   ; fieldType = 'D'   ;  GOSUB ADD.FIELDS
    fieldName = 'TXN.AMOUNT'             ; fieldLength = '35'   ; fieldType = 'A'   ;  GOSUB ADD.FIELDS
    fieldName = 'RECON.DATE'             ; fieldLength = '35'   ; fieldType = 'D'  ;  GOSUB ADD.FIELDS
    fieldName = 'RECON.REF'              ; fieldLength = '35'   ; fieldType = 'A'   ;  GOSUB ADD.FIELDS

    CALL Table.setAuditPosition ;* Poputale audit information

RETURN
*-----------------------------------------------------------------------------
***********
ADD.FIELDS:
***********
    CALL Table.addFieldDefinition(fieldName, fieldLength, fieldType, neighbour)   ;* Add a new field

RETURN
*----------------------------------------------------------------------------
END
