* @ValidationCode : MjoxNDQ4MjQzNTgxOkNwMTI1MjoxNjgxODI4MDA1ODMyOklUU1M6LTE6LTE6LTE2OjE6dHJ1ZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 19:56:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -16
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : true
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
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
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*11-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*11-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
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
